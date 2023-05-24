#!/usr/bin/env python
#
# This script converts from Bash snippets to Python. This is not intended as a general purpose
# conversion utility, which is a major undertaking given the complexities of Bash syntax.
# Instead, this is intended to capture commonly used constructs, such as by Tom O'Hara
# during shell interactions. For such constructs, see header commments in following:
#    https://github.com/tomasohara/shell-scripts/blob/main/template.bash
# The code is adhoc, but that is appropriate given the nature of the task, namely
# conversion accounting for idiosyncratic conventions.
#
# There is optional support for doing the converion via OpenAI's Codex, which was trained on
# Github. See bash2python_diff.py for code that invokes both the regex approach
# and the Codex approach, showing the conversions in a side-by-side diff listing.
#
# Notes:
# - This just outputs the Python code, along with import for helper module and initialization.
#   The user might have to do some minor fixup's before the code will run properly.
# - Simple Bash statements get converted into shell invocation calls (a la os.system).
#     pushd ~/; cp -f .[a-z]* /tmp; popd     =>  run("pushd ~/; cp -f .[a-z]* /tmp; popd")
# - Simple variable assignments get translated directly, but complex runs are converted into echo command.
#     log="run-experiment.log";              =>  log = "run-experiment.log"
#     today=$(date '+%d%b%y')                =>  today = run("echo \"date '+%d%b%y'\"")
# - Simple loops get converted into Python loops, namely for-in and while:
#     for v in abc def: do echo $v; done     =>  for v in ["abc", "def"]: gh.run("echo {v}")
# - Unsupported or unrecognized constructs are flagged as runtime errors:
#     for (( i=0; i<10; i++ )); do  echo $i; done
#         =>
#     # not supported:  for (( i=0; i<10; i++ )); do  echo $i; done
#     raise NotImplementedError()
# - The result will likely need manual revision, a la Python 2 to 3 converion (2to3).
# - Global specifications for code linter(s):
#   # pylint: disable=eval-used
# - OpenAI API reference: https://platform.openai.com/docs/api-reference
# - Bash manual: https://www.gnu.org/software/bash/manual/bash.html
# - Devloped by Tana Alvarez and Tom O'Hara.
# - Regex cheatsheet:
#     (?:regex)               non-capturing group
#     (?<!regex)              negative lookbehind
#     (?!regex)               negative lookahead
#     *?  and  +?             non-greedy match
# - See https://www.rexegg.com/regex-quickstart.html for comprehensive cheatsheet.
#
# Tips:
# - **** Err on the side of special case code rather than general purpose. It is easier to
#   isolate problems when decomposed for special case handling=. In addition, one of the
#   updates clobbered special case conversion of for-in loops with support for list iteration.
# - *** Always add new test cases when making significant changes.
# - ** Avoid regular string searching or replacements (e.g., "done" in line => re.search('\bdone\b', line).
# - * Be liberal with variables (e.g., don't reuse same variable for different purpose and make name self explanatory)@.
#
# TODO1:
# - Add a bunch of more sanity checks (e.g., via debug.assertion).
# - Clean up var_replace, which is a veritable achilles heel. There should be a separate version that
#   converts partly converted bash code.
# TODO2:
# - Make sure pattern matching accounts for word boundaries (e.g., line.replace("FOR", ...) => re.sub(r"\bFOR\b", "...", line).
# - Also make sure strings excluded from matches (e.g., "# This for loop ..." =/=> "# This FOR loop").
# - Use bashlex and/or shlex for sanity checks on the regex parsing used here.
# TODO3:
# - Flag constructs not yet implemented:
#   -- C-style for loops (maybe use cursed-for module--more for extensing Python syntax).
#   -- Bash arrays and hashes
#

"""Bash snippet to Python conversion using heuristics for common constructs"""

# Standard modules
from collections import defaultdict
import json
import os
import re
import subprocess

# Installed modules
import click
import diskcache
import openai

# Local modules
import mezcla
from mezcla import debug
from mezcla import glue_helpers as gh
from mezcla.main import Main, BRIEF_USAGE, INDENT
from mezcla.my_regex import my_re
from mezcla import system
from mezcla.text_utils import version_to_number

# Version check
debug.assertion(version_to_number("1.3.4") <= version_to_number(mezcla.__version__))

# Constants
TL = debug.TL
CODEX_PREFIX = "# codex: "

# Environment constants
USER = system.getenv_text("USER", "unknown-user",
                          "User ID")
USE_MEZCLA = system.getenv_bool("USE_MEZCLA", (USER == "tomohara"),
                                "Whether to use mezcla support, such as for regex tracing")
INIT_FILE = system.getenv_value("INIT_FILE", None,
                                "File to source before running Bash command")
DISK_CACHE = system.getenv_value("DISK_CACHE", None,
                                 "Path to directory with disk cache")
OPENAI_API_KEY = system.getenv_value("OPENAI_API_KEY", None,
                                     "API key for OpenAI")
JUST_CODEX = system.getenv_bool("JUST_CODEX", False,
                                "Only do conversion via Codex")
USE_CODEX = system.getenv_bool("USE_CODEX", (OPENAI_API_KEY or JUST_CODEX),
                               "Whether to use codex support")
## TEMP: nuclear option to disable Codex
SKIP_CODEX = system.getenv_bool("SKIP_CODEX", (not USE_CODEX),
                                "Temporary hack to ensure codex not invoked")
INLINE_CODEX = system.getenv_bool("INLINE_CODEX", False,
                                "Add inline comments with Codex conversion")
INCLUDE_ORIGINAL = system.getenv_bool("INCLUDE_ORIGINAL", False,
                                      "Include original code as comment")
SKIP_HEADER = system.getenv_bool("SKIP_HEADER", False,
                                 "Omit header with imports and run definition")
INCLUDE_HEADER = (not SKIP_HEADER)
SKIP_COMMENTS = system.getenv_bool("SKIP_COMMENTS", False,
                                   "Omit comments from generated code")
STRIP_INPUT = system.getenv_bool("STRIP_INPUT", False,
                                 "Strip blank lines and comments from input code")
OUTPUT_BASENAME = system.getenv_value("OUTPUT_BASENAME", None,
                                      "Basename for optional output files such as Codex json responses")
EXPORT_RESPONSE = system.getenv_bool("EXPORT_RESPONSE", (OUTPUT_BASENAME is not None),
                                     "Export Codex reponses to JSON")
MODEL_NAME = system.getenv_text("MODEL_NAME", "text-davinci-002",
                                description="Name of OpenAI model/engine")
TEMPERATURE = system.getenv_float("TEMPERATURE", 0.6,
                                  description="Next token probability")
PARA_SPLIT = system.getenv_bool("PARA_SPLIT", False,
                                "Split code in Perl-style paragraph mode")

# Global settings
if USE_MEZCLA:
    re = my_re

## TEMP:
## NOTE: Eventually most pylint issues should be resolved (excepting nitpicking ones)
## pylint: disable=unneeded-not, line-too-long, fixme

PYTHON_HEADER = """# Output from bash2python.py
'''Python code from Bash snippet'''
import os
from mezcla.glue_helpers import run_via_bash
from mezcla import system

INIT_FILE = system.getenv_value("INIT_FILE", None,
                                "File to source before running Bash command")

def run(command, skip_print=False):
    '''Runs COMMAND and return output. Also, prints non-empty output unless SKIP_PRINT'''
    result = run_via_bash(command, init_file=INIT_FILE)
    if (not skip_print) and result:
       print(result)
    return result
"""


def get_bash_var_hash():
    """Return a lookup hash for checking whether Bash variable is defined
    Note: this includes environment variables as well as regular ones"""
    # Sample listing from Bash set command:
    #   ANACONDA_HOME=/
    #   BASH=/bin/bash
    #   ...
    #   zless ()
    #   {
    #       zcat "$@" | $PAGER
    #   }

    # Extract variables from set command output
    var_hash = defaultdict(bool)
    bash_variable_listing = gh.run_via_bash("set", init_file=INIT_FILE,
                                            trace_level=7)
    for line in bash_variable_listing.splitlines():
        if my_re.search(r"^([A-Za-z0-9_]+)=", line):
            var_hash[my_re.group(1)] = True

    # Run sanity checks
    if debug.detailed_debugging():
        env_vars = sorted(list(os.environ.keys()))
        bash_vars = sorted(list(var_hash.keys()))
        debug.trace_expr(5, bash_vars, max_len=4096)
        debug.trace_expr(5, env_vars, max_len=4096)
        debug.assertion(not system.difference(env_vars, bash_vars))
        debug.assertion(sorted(system.intersection(env_vars, bash_vars)) == env_vars)
    debug.trace(6, f"get_bash_var_hash() => {var_hash}")
    return var_hash


def embedded_in_quoted_string(subtext, text):
    """Whether SUBTEXT of TEXT in contained in a quote"""
    # ex: embedded_in_quoted_string("#", "echo '#-sign'")
    # ex: not embedded_in_quoted_string("#", 'let x++     # incr x w/ init')
    result = (my_re.search(fr"'[^']*{subtext}[^']*'", text) or
              my_re.search(rf'"[^"]*{subtext}[^"]*"', text))
    debug.trace(7, f"embedded_in_quoted_string{(subtext, text)} => {result}")
    return result


def safe_eval(expression):
    """Evaluates expression returning as a string
    Note: returns input as is if there is an error
    """
    result = expression
    try:
        result = eval(expression)       # pylint: disable=eval-used
    except:
        debug.trace_exception(7, f"safe_eval({expression}")
    return result

    
class Bash2Python:
    """Returns a Python-like file based on Bash input"""
    KEYWORD_MAP = {
        "function": "def",
        "true": "pass"}
    LOOP_CONTROL = ["break", "continue"]

    def __init__(self, bash, skip_comments=None, segment_prefix=None, segment_divider=None):
        """Class initializer: using BASH command with SHELL executable
        Note: Optionally SKIP_COMMENTS and changes SEGMENT_DIVIDER for command iteration (or newline)"""
        self.cmd = bash
        self.bash_var_hash = get_bash_var_hash()
        self.variables = []
        if skip_comments is None:
            skip_comments = SKIP_COMMENTS
        self.skip_comments = skip_comments
        if segment_divider is None:
            # note: PARA_SPLIT emulates input done by bash2python_diff.py
            segment_divider = ("\n\n" if PARA_SPLIT else "\n")
        self.segment_divider = segment_divider
        self.segment_prefix = segment_prefix
        self.cache = None
        self.codex_count = 0
        self.line_num = 0
        if DISK_CACHE:
            # notes:
            # - Uses JSON for serialization due to issues with pickling using tuples. See
            #      https://grantjenks.com/docs/diskcache/tutorial.html
            # - The cache itself is still stored via SQLite3.
            # - Changing disk type without regenerating cache can lead to subtle errors.
            self.cache = diskcache.Cache(DISK_CACHE,
                                         disk=diskcache.core.JSONDisk,
                                         disk_compress_level=0,       # no compression
                                         cull_limit=0,                # no automatic pruning
                                         )
            
        debug.trace_object(5, self, label=f"{self.__class__.__name__} instance")

    def contains_embedded_for(self, bash_snippet):
        """Simple method to get perl regex detection of embedded for loops"""
        debug.assertion(not system.file_exists(bash_snippet))
        bash_snippet = re.sub(r"#.*$", "", bash_snippet, flags=re.MULTILINE)  # Remove comments
        bash_snippet = re.sub(r"'([^'\\]*(?:\\.[^'\\]*)*)'", "", bash_snippet)  # Remove single-quoted strings
        bash_snippet = re.sub(r'"([^"\\]*(?:\\.[^"\\]*)*)"', "", bash_snippet)  # Remove double-quoted strings
        temp_file = gh.get_temp_file()
        system.write_file(temp_file, bash_snippet)
        command = f"echo '{bash_snippet}' | perl -0777 -ne 's/.*/\\L$&/; s/\\bdone\\b/D/g; print(\"Warning: embedded for: $&\n\") if (/\\bfor\\b[^D]*\\bfor\\b/m);'"
        process = subprocess.Popen(command, stdout=subprocess.PIPE, shell=True)
        output, _ = process.communicate()
        result = output.decode()
        debug.trace(6, f"contains_embedded_for({bash_snippet!r})\n\tself={self} => {result}")
        return result

    def map_keyword(self, line):
        """Perform conversion for single keyword statement"""
        in_line = line
        if my_re.search(r"^(\s*)(\w+)(.*)$", line):
            indent = my_re.group(1)
            keyword = my_re.group(2)
            remainder = my_re.group(3)
            line = indent + self.KEYWORD_MAP.get(keyword, keyword) + remainder
        debug.trace(5, f"map_keyword({in_line!r}) => {line!r}")
        return line

    def codex_convert(self, line):
        """Uses OpenAI Codex to translate Bash to Python"""
        result = self.codex_convert_aux(line)
        debug.trace(6, f"codex_convert({line!r}) => {result!r}")
        return result

    def codex_convert_aux(self, line):
        """Helper to codex_convert"""
        debug.trace(6, f"codex_convert_aux({line!r})")

        # Strip segment comments (see bash2python_diff.py)
        # ex: "#s# Segment 1\nfu=3\n" => "fu=3\n"
        comment = ""
        if self.segment_prefix:
            debug.assertion(self.segment_prefix.startswith("#"))
            while my_re.search(fr"^({self.segment_prefix}[^\n]*\n)+(.*)", line,
                               flags=my_re.DOTALL):
                comment += my_re.group(1)
                line = my_re.group(2)
                debug.trace_expr(6, comment, line)
            if my_re.search(fr"^({self.segment_prefix}[^\n]*\n)", line, flags=my_re.MULTILINE):
                debug.trace(5, f"FYI: Stripping residual segment comments in line: {my_re.group(1)!r}")
                line = my_re.sub(fr"^{self.segment_prefix}[^\n]*\n", "", line, flags=my_re.MULTILINE)
                debug.trace_expr(6, line)
        # note: normalize for sake of caching
        line = line.rstrip("\n") + "\n"
        
        # Note: Non-code uses both prefix and comment indicator (n.b., former stripped in format below)
        if SKIP_CODEX:
            return CODEX_PREFIX + "# internal warning (SKIP_CODEX set)"
        debug.assertion(USE_CODEX)
        if not USE_CODEX:
            return CODEX_PREFIX + "# internal error (USE_CODEX not set)"
        if not line.strip():
            return CODEX_PREFIX + "# blank line"

        # Make sure OpenAI key set
        # note: Apply for an API Key at https://beta.openai.com
        debug.assertion(OPENAI_API_KEY or DISK_CACHE)
        if (not (((OPENAI_API_KEY or "").strip()) or DISK_CACHE)):
            return CODEX_PREFIX + "# OPENAI_API_KEY not set"
        openai.api_key = OPENAI_API_KEY

        # Define the code generation prompt
        TARGET_LANG = system.getenv_text("TARGET_LANG", "Python",
                                         "Target language for Codex")
        prompt = f"Convert this Bash snippet to {TARGET_LANG}:\n{line}"
        debug.trace_expr(6, prompt)
        
        # Call the Codex API
        try:
            # Optionally check cache
            params = {
                "engine": MODEL_NAME,
                "prompt": prompt,
                "max_tokens": 3 * len(line.split()),
                "n": 1,
                "stop": None,
                "temperature": TEMPERATURE,
            }
            params_tuple = tuple(list(params.values()))
            response = None
            # Check if the response is already in the cache before calling the API
            if self.cache is not None:
                debug.trace(5, "Checking cached Codex result")
                response = self.cache.get(params_tuple)

            # Submit request to OpenAI
            if response is None:
                # If the response is not in the cache, make the API call and store the result in the cache
                debug.trace(5, "Submitting Codex request")
                response = openai.Completion.create(**params)
                self.cache[params_tuple] = response
            if EXPORT_RESPONSE:
                self.codex_count += 1
                json_filename = f"{OUTPUT_BASENAME}-codex-{self.codex_count}.json"
                response["prompt"] = prompt
                system.write_file(json_filename, json.dumps(response, default=str))
            debug.trace_expr(5, response, max_len=4096)

            # Extract text for first choice and convert into single-line comment
            comment += CODEX_PREFIX + response["choices"][0]["text"].replace("\n", "\n" + CODEX_PREFIX).rstrip()
        except openai.APIError:     # Catch OpenAI API errors
            system.print_exception_info("Error communicating with OpenAI API in codex_convert")
        except IOError:             # Catch file I/O errors
            system.print_exception_info("File I/O error in codex_convert")
        except:                     # Catch all other exceptions
            system.print_exception_info("Unexpected error in codex_convert")
        return comment

    def var_replace(self, line, other_vars=None, indent=None, is_loop=False,
                    converted_statement=False):
        """Replaces bash variables with python variables and also derive run call for LINE
        Notes:
        - Optional converts OTHER_VARS in line.
        - Use INDENT to overide the line space indentation.
        """
        # TODO1: return (was-converted, python, remainder), as with process_xyz functions

        def derive_indentation(line):
            """Derives indentation"""
            nonlocal indent
            if my_re.search(r"^(\s+)(.*)", line):
                if not indent:
                    indent = my_re.group(1)
                line = my_re.group(2)
                debug.trace(6, f"line2={line!r}")
            return line

        def handle_arithmetic_expansion(line):
            """Returns corrected arithmetic expansion"""
            # - ex: $(( x + y )) => f"{x + y}"
            while my_re.search(r"(.*)\$\(\( *(.*) *\)\)(.*)", line):
                debug.trace(4, "processing arithmetic expansion")
                (pre, expression, post) = my_re.groups()
                # Note: converts expression to f-string
                ## BAD:
                line = pre + 'f"{' + expression + '}"' + post
                ## TODO?: line = pre + safe_eval(expression) + post
            debug.trace(6, f"line3={line!r}")
            return line

        def replace_var_references(line):
            """Processes variables"""
            # Inicialize variables
            nonlocal bash_commands
            bash_commands = re.findall(r'\$\(.*\)', line)  # finds all bash commands
            nonlocal has_bash_var, has_default
            bash_vars_with_defaults = re.findall(r'\$\{\w+:-[^\}]+\}', line)
            bash_vars = re.findall(r'\$\w+', line)
            # TODO2: add $n => sys.argv[n]
            bash_commmon_special_vars = re.findall(r'\$[\?\@]', line)
            if other_vars:
                bash_vars += other_vars
            has_bash_var = False
            has_default = False

            # Iterate through the list of variables to convert Bash variable syntax to Python variable syntax
            for var in bash_vars + bash_vars_with_defaults + bash_commmon_special_vars:
                converted = False

                # If the variable is in the bash_vars_with_defaults list
                if var in bash_vars_with_defaults:
                    # Extract the variable name
                    var_name = re.search(r'\$\{(\w+):-[^\}]+\}', var).group(1)

                    # Extract the default value
                    var_default = re.search(r'\$\{\w+:-(.*)\}', var).group(1)

                    # If the variable name is uppercase (assumed to be an environment variable), replace it with Python os.getenv syntax
                    if my_re.search(r"^[A-Z0-9_]$", var_name):
                        replacement = f'os.getenv("{var_name}", "{var_default}")'
                    else:
                        # Replace the variable with Python syntax and a check for None
                        replacement = f"{{{var_name} if {var_name} is not None else '{var_default}'}}"

                    # Replace the Bash variable in the line with the Python-style variable
                    line = my_re.sub(fr"{var}\b", replacement, line)
                    has_bash_var = True
                    has_default = True
                elif var in bash_commmon_special_vars:
                    # If the variable is a commonly used special variable, replace it with a function run call
                    if is_loop:
                        line = line.replace(var, f"run(echo '{var}')")
                        debug.trace(4, f"Special case handling of Bash special variable {var}: line={line!r}")
                    converted = True
                elif (var[1:] in self.bash_var_hash) and (var not in self.variables):
                    # If the variable is a Bash-defined variable and not in self.variables, exclude it from the conversion
                    debug.trace(4, "Excluding Bash-defined variable {var}")
                else:
                    pass

                # If the variable wasn't converted yet
                if (not converted):
                    # If it's a loop, drop the $-prefix from the variable
                    if is_loop:
                        line = my_re.sub(fr"\${var[1:]}\b", var[1:], line)
                    else:
                        # Replace the Bash variable in the line with the Python-style variable
                        line = my_re.sub(fr"\${var[1:]}\b", "{" + var[1:] + "}", line)
                        has_bash_var = True

            # Trace output
            debug.trace(6, f"line4={line!r}")
            return line

        def process_conditions_and_loops(line):
            ## BAD: nonlocal is_loop

            # Early exit for loops
            if is_loop:
                if var_pos == 1:
                    line = f"{static}f{line}"
                if var_pos == 0:
                    line = f"f{line}{static}"
                debug.trace(5, f"[early exit 3a; process_conditions_and_loops] {var_replace_call} => ({line!r}, '')")
                return line, ""
            
            # TODO: add constraint to avoid over-generation
            ## BAD:
            ## debug.assertion(not embedded_in_quoted_string(";", line))
            ## line = line.replace(';', '')
            
            # Isolate comment
            inline_comment = ""
            if my_re.search(r"^([^#]+)(\s*#.*)", line):
                line, inline_comment = my_re.groups()
                debug.assertion(not embedded_in_quoted_string("#", line))
                debug.assertion("\n" not in inline_comment)
                line = line.strip()

            # Do special processing for single statement lines
            # TODO: strip extraneous semicolons (e.g., "ls;" => "ls")
            is_multiline_statement = ("\n" in line)
            if is_multiline_statement:
                system.print_stderr("Warning: unexpected multi-line statement in var_replace")
                debug.trace(5, f"[early exit 3b; process_conditions_and_loops] {var_replace_call} => ({line!r}, {inline_comment!r})")
                return line, inline_comment
            is_compound_statement = (my_re.search(r"\s*\S+\s*;\s*\S+\s*", line) and
                                     (not re.search(r"""^(['"])[^\1]*;\1$""", line)))
            if is_compound_statement:
                debug.assertion(not embedded_in_quoted_string(";", line))
                inline_comment += " # Warning: review conversion of compound statement"
            if not line.strip():
                debug.trace(6, f"line4.5={line!r}")
                pass
            ## TEST
            ## elif not has_bash_var:
            ##     debug.trace(6, f"line4.75={line!r}")
            ##     pass
            else:
                ## TEST
                ## # Make sure line has outer single quotes, with any internal ones quoted
                ## if "'" in line[1:-1]:
                ##     # note: Bash $'...' strings allows for escaped single quotes unlike '...'
                ##     # The regex (?<...) is for negative lookbehind
                ##     # OLD: line = re.sub(r"[^\\]'", r"\\\\'", line)
                ##     line = re.sub(r"(?<!\\)(')", r"\\\\\1", line)
                ## line = f"'{line!r}'"
                ##
                # Make sure line has outer single quotes, with any internal ones quoted
                if "'" in line:
                    # note: Bash $'...' strings allows for escaped single quotes unlike '...'
                    # The regex (?<...) is for negative lookbehind
                    # OLD: line = re.sub(r"[^\\]'", r"\\\\'", line)
                    line = re.sub(r"(?<!\\)(')", r"\\\\\1", line)
                    line = f'"{line}"'
                else:
                    line = f"'{line}'"
                debug.trace(6, f"line5={line!r}")
                debug.assertion(re.search(r"""^(['"]).*\1$""", line))
                #
                # Use f-strings if local Python variable to be resolved
                if has_bash_var:
                    line = "f" + line
                debug.assertion(re.search(r"""^f?(['"]).*\1$""", line))
            debug.trace(6, f"line5.5={line!r}")
            return line, inline_comment

        def derive_run_invocation(line):
            """Creates run() for necessary lines"""
            nonlocal has_assignment
            # Derive run invocation, with output omitted for variable assignments
            ## BAD: bash_commands = re.findall(r'\$\(.*\)', line)  # finds all bash commands
            nonlocal bash_commands
            has_assignment = (variable != "")
            comment = ""
            debug.trace(6, f"line5.55={line!r}")
            if (has_assignment and ("$" not in line)):
                debug.trace(6, f"line5.65={line!r}")
                # Remove outer quotes (e.g., '"my dog"' => "my dog" and '123' => 123)
                line = re.sub(r"^'(.*)'$", r"\1", line)
            elif not line.strip():
                debug.trace(6, f"line5.75={line!r}")
                pass
            elif bash_commands:
                debug.trace(6, f"line5.85={line!r}")
                # Note: uses echo command with $(...) unless line already uses one
                # TODO: handle arithmetic expansions (e.g., "echo $(( x + y ))
                if (not re.search(r"^f?'echo ", line)):
                    line = re.sub("'", "'echo ", line, count=1)
                if INLINE_CODEX:
                    comment = self.codex_convert(line)
                # note: avoids nested outer quotes (TODO: generalize)
                if ((line[0] == "'") and (line[-1] == "'")):
                    line = line[1:-1]
                line = f"run({line!r}, skip_print={has_assignment})"
                debug.trace(6, f"line5.89={line!r}")
            elif converted_statement:
                pass
            elif has_default:
                debug.trace(6, f"line5.9={line!r}")
                pass
            elif INLINE_CODEX:
                debug.trace(6, f"line5.95={line!r}")
                comment = self.codex_convert(line)
                line = f"run({line})"
            else:
                # Run shell over entire line
                line = f"run({line})"
            debug.trace_expr(3, line, comment)

            # Add variable assignment and indentation
            try:
                if var_pos == 1:
                    line = f"{static}{line}"
                if var_pos == 0:
                    line = f"{line}{static}"
            except:
                pass
            if indent:
                line = indent + line
            debug.trace(6, f"line6={line!r}")
            return line

        def special_case_fixups(line, inline_comment):
            # Special case fixup's
            # echo statement not converted
            # ex: 'echo "a + b  = " f"{a + b}"' => 'run(echo "a + b  = " f"{a + b}")'
            if my_re.search(r"^\s*echo .*", line):
                debug.trace(5, "Special case unconverted-echo fixup")
                ## if my_re.search(r'\bf".*"', line):
                ##     debug.trace(6, f"Resolving f-strings in line {line!r}")
                ##     line = eval(repr(line))
                ##     debug.trace_expr(6, line)
                line = my_re.sub(r'\bf"', '"', line)
                line = f"run(f{line!r})"

            # Convert from inner f-strings to a single outer one
            matches = re.findall(r'f"{(.*?)}"', line)
            if len(matches) >= 2:
                debug.trace(4, "Combining f-strings in {line!r}")
                contents = ' '.join(matches)
                line = re.sub(r'f"{.*?}"', '', line)
                line += f'f"{contents}"'

            # Restore comment
            if not self.skip_comments:
                line = (line + inline_comment)
            debug.trace(6, f"line7={line!r}")
            return line

        # Main function body for var_replace
        in_line = line
        if indent is None:
            indent = ""
        var_pos = ""
        variable = ""
        static = ""
        has_bash_var = ""
        has_default = ""
        has_assignment = ""
        var_replace_call = f"var_replace({in_line!r}, othvar={other_vars!r} ind={indent!r})"
        # TODO2: straighten out spaghetti references
        bash_commands = None
        
        # Check for assignment
        # TODO3: document what's going on!
        ## TODO: if is_loop:
        ## BAD: if "=" in line:
        if my_re.search(r"^\s*\w+=", line):
            line = line.replace("[", "").replace("]", "")
            ## *** Don't mix-n-match variable types with the same name: very confusing! ***
            # TODO: pre_assign, post_assign = line.split(" = ", maxsplit=1)
            if " = " in line:
                line = line.split(" = ")
            else:
                line = line.split("=")
            if "$" in line[0] and "$" in line[1]:
                line = " = ".join(line)
            elif "$" in line[0]:
                variable = line[0]
                static = " = " + line[1]
                var_pos = 0
            elif "$" in line[1]:
                variable = line[1]
                static = line[0] + " = "
                var_pos = 1
            elif not "$" in line[0] and not "$" in line[1]:
                result = " = ".join(line)
                converted = True
                debug.trace(5, f"[early exit 1] {var_replace_call} => ({converted}, {result!r}, '')")
                return (converted, result, "")
            if variable != "":
                # TODO2: add constraint to avoid clobbering entire line
                line = variable

        # Check for assignment within expression statement; ex: (( z = x + y ))
        if my_re.search(r"^\s+\(\(\s*(\w+)\s*=.*\)\)", line):
            variable = my_re.group(1)
        # HACK: check for Python assignment if already converted
        ## TODO:
        ## if converted_statement and my_re.search(r"^\s*(\w+)\s*=", line):
        ##     variable = my_re.group(1)
        if my_re.search(r"^\s*(\w+)\s*=", line):
            variable = my_re.group(1)
            converted_statement = True
        debug.trace_expr(5, static, var_pos, variable, converted_statement)
        debug.trace(6, f"line1={line!r}")

        line = derive_indentation(line)
        line = handle_arithmetic_expansion(line)
        line = replace_var_references(line)
        line, inline_comment = process_conditions_and_loops(line)
        if not is_loop:
            line = derive_run_invocation(line)
            line = special_case_fixups(line, inline_comment)
        else:
            debug.assertion(not inline_comment.strip())

        converted = True
        debug.trace(5, f"{var_replace_call} => ({converted}, {line!r}, '')\n\tself={self}")
        return (converted, line, "")

    def operators(self, line):
        """Returns line with operators converted to Python equivalents
        Note: Assumes the line contains a single test expression (in isolation).
        """
        # Dictionary with Bash operators and their Python equivalents
        # Split into binary and unary operators
        binary_operators = {
            # TODO2: drop space around '=' and '!=' (and use regex boundry matching)
            " = ": " == ",
            " != ": " != ",
            "-eq ": " == ",
            "-ne": " != ",
            "-gt": " > ",
            "-ge": " >= ",
            "-lt": " < ",
            "-le": " <= ",
            "&&": " and ",
            r"\|\|": " or ",  # NOTE: need to escape | for Python
        }

        unary_operators = {
            " ! ": " not ",
            "-z": " '' == ",
            "-n": " '' != ",
        }

        file_operators = {
            "-d": ("os.path.isdir({})"),
            "-f": ("os.path.isfile({})"),
            "-e": ("os.path.exists({})"),
            "-L": ("os.path.islink({})"),
            "-r": ("os.access({}, os.R_OK)"),
            "-w": ("os.access({}, os.W_OK)"),
            "-x": ("os.access({}, os.X_OK)"),
            "-s": ("os.path.getsize({}) > 0"),
        }

        in_line = line

        # Combine binary and unary operators
        operators = {**binary_operators, **unary_operators}

        # Iterate over operators and replace them with Python equivalents
        # TODO3: account for token boundaries (e.g., make sure [ or ] not in string)
        for bash_operator, python_equivalent in operators.items():
            ## OLD:
            line = re.sub(fr"(\S*) *{bash_operator} *(\S*)", fr"\1{python_equivalent}\2", line)
            ## BAD: line = re.sub(fr"(?<!\S) *{bash_operator} *(?!\S)", python_equivalent, line)
            ## NEW: line = re.sub(fr"(?<!\S) +{bash_operator.strip()} +(?!\S)", python_equivalent, line)

        # Likewise handle file operators
        quoted_string = r'(?:\"[^\"]+\")|(?:\'[^\']+\')'
        for bash_operator, python_template in file_operators.items():
            line = re.sub(r"([\[\(]\s*){bash_operator}\s+({quoted_string}|[^ \]]+)"
                          .format(bash_operator=bash_operator, quoted_string=quoted_string),
                          r"\1{}".format(python_template.format(r"(\2)")), line)

        # Replace Bash true/false statements with Python equivalent
        line = re.sub(r"\[ 1 \]", "True", line)
        line = re.sub(r"\[ 0 \]", "False", line)

        # Remove square brackets
        for bracket in [r"\[", r"\]", r"\[\[", r"\]\]"]:
            debug.assertion(not embedded_in_quoted_string(bracket, line),      \
                            f"test bracket '{bracket}' in quoted expression")
        line = my_re.sub(r"(^\s* \[) | (\] \s*$)", "", line, flags=my_re.VERBOSE)
        line = my_re.sub(r"(^\s* \[\[) | ( \]\]) \s*$", "", line, flags=my_re.VERBOSE)

        debug.trace(5, f"operators({in_line!r}) => (True, {line!r}, '')\n\tself={self}")
        ## BAD: return (was - converted, python, remainder)
        ## TEMP
        return (True, line, "")

    def process_keyword_statement(self, line):
        """Process simple built-in keyword statement (e.g., true to pass)
        Returns (was-converted, python, remainder): see process_compound)
        """
        debug.trace(6, f"in process_keyword_statement({line!r})")
        in_line = line
        converted = False
        line = self.map_keyword(line)
        if (line != in_line):
            converted = True
        debug.trace(7, f"process_keyword_statement({in_line!r}) => ({converted}, {line!r}, "")")
        return (converted, line, "")

    def process_simple(self, line):
        """Process simple statement conversion for LINE
        Returns (was-converted, python, remainder): see process_compound)
        """
        debug.trace(6, f"in process_simple({line!r})\n\tself={self}")
        in_line = line
        converted = False
        has_var_refs = False
        # Convert miscellenous commands
        # - break
        # TODO: continue (dont think this is needed)
        debug.trace(6, "checking miscellenous statements")
        if (line.strip() == "break"):
            debug.trace(4, "processing break")
            converted = True
        # - arithmetic expression
        #       (( expr ))
        # note: this is treated like a statement, unlike $((...) in var_replace
        elif my_re.search(r"^(\s*)\(\( (.*) \)\)\s*$", line):
            debug.trace(4, "processing arithmetic expression")
            indent = my_re.group(1)
            expression = my_re.group(2)
            line = (indent + expression)
            converted = True
        # Check for let with quoted expression (TODO: make sure operators converted)
        # ex:  let 'z=2*3'
        elif my_re.search(r"^\s*let\s+(([\'\"])(.*)\2)\s*(.*)$", line):
            debug.trace(4, "processing let expression")
            line = my_re.group(3)
            remainder = my_re.group(4) or ""
            debug.assertion(not remainder.strip())
            converted = True 
        # - variable assignments
        # - Tana-TODO: review (I added \blet\s+)
        # - ex: let v++
        elif re.search(r"\blet\s+(\S*)", line):
            debug.trace(4, "processing let")
            line = re.sub(r"\blet\s+(\S*)", r"\1", line)
            # HACK: convert postfix increment to += 1
            # TODO: handle more common variants (e.g., prefix)
            line = re.sub(r"\b(\w+)\+\+", r"\1 += 1", line)
            line = re.sub(r"\b(\w+)\-\-", r"\1 -= 1", line)
            converted = True
            has_var_refs = True
        # Fixup any variable references
        if converted and has_var_refs:
            ## TODO: line = self.var_replace(line)
            pass
        debug.trace(7, f"process_simple({in_line!r}) => ({converted}, {line!r}, "")")
        return converted, line, ""

    def process_compound(self, line, cmd_iter):
        """Process compound statement conversion for LINE
        Note: Use CMD_ITER to get addition input
        Returns tuple indicating: 1. whether line processed; 2. the converted text; and 3. any remaining text consumed from iterator
        """
        debug.trace(6, f"in process_compound({line!r}, {cmd_iter})")
        # Tana-TODO: document the general idea of the conversion
        # Declare loop and statements as a tuple
        # format: (START, MIDDLE, END)
        for_loop = ("for", " do ", "done")
        while_loop = ("while", "do", "done")
        if_loop = ("if", "then", "fi")
        elif_loop = ("elif", "then", "fi")
        else_loop = ("else", "", "fi")  # Else statements do not have a keyword so None
        loops = (elif_loop, for_loop, while_loop, if_loop, else_loop)
        dummy_loop = ("dummy-start", "dummy-middle", "dummy-end")
        debug.trace_values(8, loops, "loops")
        # note: (?:...) is for a non-capturing group: see www.rexegg.com/regex-quickstart.html
        start_keyword_regex = "(?:" + "|".join([l[0] for l in loops]) + ")"
        middle_keyword_regex = "(?:" + "|".join([l[1] for l in loops]) + ")"
        end_keyword_regex = "(?:" + "|".join([l[2] for l in loops]) + ")"
        body = ""
        loop_count = 0
        compound_stack = []             # OLD: loopy
        actual_loop = ()
        debug.trace(6, f"actual_loop0:{actual_loop}")
        converted = False
        # Tane-TODO: rename "loop" => "compound"
        loop_line = line
        indent = ""
        max_loop_count = 0
        loop_iterations = 0
        MAX_LOOP_ITERATIONS = 100
        saw_middle = False
        remainder = ""
        # Emulates a do while loop in python
        do_while = True
        while ((loop_count > 0) or do_while):
            debug.trace_expr(5, loop_line, loop_count, compound_stack, actual_loop, remainder)
            debug.trace_expr(6, body)
            # Stop upon end of compound command iteration (or some internal error)
            debug.assertion(loop_iterations < MAX_LOOP_ITERATIONS)
            if ((not loop_line) or (loop_iterations == MAX_LOOP_ITERATIONS)):
                debug.trace(6, f"Premature loop termination (iters={loop_iterations})")
                break
            loop_iterations += 1
            loop_line = loop_line.strip()
            do_while = False
            if loop_count > max_loop_count:
                max_loop_count = loop_count
            # Handle comments and blank lines
            if ((loop_line == "") or (my_re.search(r"^\s*#", loop_line))):
                debug.trace(5, f"Ignoring compound blank line or comment ({loop_line!r})")
                body += indent + "    " + loop_line + "\n"
                loop_line = ""
            # Flag case statement as unimplemented; ex: for (( c=0; c<5; c++ )); do  echo $c; done
            # Format:  case EXPR in PATTERN_a) STMT_a;; PATTERN_b) STMT_b;; ... esac
            elif my_re.search(r"^\s* case \s* \S* \s* in .*",
                              loop_line, flags=my_re.VERBOSE):
                raise NotImplementedError("case statement not supported")
            # Handle simple for-in loop
            elif my_re.search(r"^\s*for\s+(\w+)\s+in\s+([^;]+);\s+do\b(.*)$", loop_line):
                (loop_var, values_spec, remainder) = my_re.groups()
                debug.trace(5, f"Processing compound for-in: var={loop_var} values={values_spec}")
                loop_count += 1
                indent = "    " * (loop_count - 1)
                saw_middle = True
                compound_stack.append("for_loop")
                actual_loop = for_loop
                debug.trace(6, f"actual_loop1:{actual_loop}")
                quoted_values = ('["' + '", "'.join(values_spec.split()) + '"]')
                new_body = f"{indent}for {loop_var} in {quoted_values}:\n"
                body += new_body
                loop_line = ""
                debug.trace(5, f"Conversion of for-in clause; new body={new_body!r}")
            # Flag c-style for as unimplemented; ex: for (( c=0; c<5; c++ )); do  echo $c; done
            ## TODO: elif my_re.search(r"^\s* for \(\( \s*\S*\s*\; \s*\S+\s*\; \s*\S*\s* \)\)\s*\;",
            elif my_re.search(r"^\s* for \s* \(\( .* \)\)\s*\;",
                              loop_line, flags=my_re.VERBOSE):
                raise NotImplementedError("c-style for not supported")
            # General compound: warning this code is overly general, making it brittle!)
            elif my_re.search(
                ## OLD: fr"^(?!\*)\s*({loops[0][0]}|{loops[1][0]}|{loops[2][0]}|{loops[3][0]})\s+(\S.*)((?=;))",
                ## note: (?!...) is negative lokahead and (?=...) is positive lookahead
                ## TEST: fr"^(?!\*)\s*({loops[0][0]}|{loops[1][0]}|{loops[2][0]}|{loops[3][0]})\s+(\S.*)((?=\n))",
                fr"^(?!\*)\s*({start_keyword_regex})\s+([^;]+);\s*({middle_keyword_regex}|\n)(.*?)$",
                    loop_line + "\n", flags=my_re.DOTALL):
                (start_keyword, test_expression, middle_keyword, remainder) = my_re.groups()
                debug.trace(5, f"Processing compound start/continuation: start={start_keyword}; expr={test_expression} middle={middle_keyword!r}")
                saw_middle = (middle_keyword != "\n")
                if start_keyword != "elif":
                    loop_count += 1
                    indent = "    " * (loop_count - 1)
                compound_stack.append(start_keyword + "_loop")
                ## BAD: var = self.var_replace(test_expression, is_loop=True)
                (converted, var, test_remainder) = self.var_replace(test_expression, is_loop=True)
                debug.assertion(converted)
                debug.assertion(not test_remainder.strip())
                ## BAD: var = self.operators(var)
                (converted, var, oper_remainder) = self.operators(var)
                debug.assertion(converted)
                debug.assertion(not oper_remainder.strip())
                # TODO1: rework to avoid need for eval!
                actual_loop = (eval(compound_stack[-1]) if compound_stack else dummy_loop)
                debug.trace(6, f"actual_loop2:{actual_loop}")
                var = var.replace(";" + actual_loop[1], "").strip()
                new_body = f"{indent}{actual_loop[0]} {var}:\n"
                body += new_body
                loop_line = ""
                debug.trace(5, f"Conversion of {compound_stack[-1]} clause; new body={new_body!r}")
                # Sanity check for the above hairy code (Tana-TODO: document better)
                debug.assertion(len(loops) == 5)
                debug.assertion(loops[4][0] == "else")
            ##
            ## OLD
            ## elif loop_line == "else":
            ##     new_body = indent + loop_line.strip() + ":\n"
            ##     body += new_body
            ##     loop_line = ""
            ##     debug.trace(5, f"Processing compound else; new body={new_body!r}")
            ##     loop_count += 1
            ##
            elif my_re.search(r"^\s*else\b(.*)", loop_line):
                new_body = indent + loop_line.strip() + ":\n"
                body += new_body
                loop_line = ""
                remainder = my_re.group(1)
                debug.trace(5, f"Processing compound else; new body={new_body!r}")
            elif (actual_loop and my_re.search(fr"^\s*{actual_loop[2]}\b(.*)$", loop_line, flags=my_re.DOTALL)):
                debug.trace(5, f"Processing compound close {actual_loop[2]}")
                loop_line = ""
                remainder = my_re.group(1)
                loop_count -= 1
                compound_stack.pop()
                try:
                    actual_loop = (eval(compound_stack[-1]) if compound_stack else dummy_loop)
                    debug.trace(6, f"actual_loop3:{actual_loop}")
                except IndexError:
                    break
            else:
                debug.trace(7, "Processing compound misc.")
                if not actual_loop:
                    debug.trace(4, "Not a compound statement")
                    debug.assertion(loop_count == 0)
                    return (False, line, "")
                if my_re.search(fr"^\s*{actual_loop[1]}\b(.*)", loop_line):
                    debug.trace(5, f"Processing compound inner {actual_loop[1]}")
                    loop_line = my_re.group(1)
                    debug.assertion(not saw_middle)
                    saw_middle = True
                if loop_line == actual_loop[1].strip():
                    debug.trace(5, f"[alt] Processing compound inner {actual_loop[1]}")
                    loop_line = ""
                    debug.assertion(not saw_middle)
                    saw_middle = True
                if loop_line.strip() in self.LOOP_CONTROL:
                    debug.trace(5, "Processing compound loop control")
                    body += loop_line + "\n"
                    body += self.map_keyword(loop_line) + "\n"
                elif loop_line.strip():
                    debug.trace(5, "Processing compound body statement")
                    if (my_re.search(fr"^(.*?)(;|\n)\s*({end_keyword_regex}\b.*?)$", loop_line, flags=my_re.DOTALL)):
                        (loop_line, _sep, remainder) = my_re.groups()
                        debug.trace(5, f"Isolated compound end statement: remainder={remainder!r} loop_line={loop_line!r}")
                    # First tries to convert simple statements and then falls back to variable reference checks
                    (converted, loop_line, rem_line) = self.process_keyword_statement(loop_line)
                    if not converted:
                        (converted, loop_line, rem_line) = self.process_simple(loop_line)
                    debug.assertion(rem_line == "")
                    if converted:
                        body += indent + "    " + loop_line + "\n"
                    else:
                        debug.assertion(not my_re.search(fr"{start_keyword_regex}.*;.*{middle_keyword_regex}", loop_line))
                        ## BAD
                        ## body += "" + self.var_replace(loop_line.strip("\n"),
                        ##                               indent="    " * loop_count) + "\n"
                        (converted, new_loop_line, loop_remainder) = self.var_replace(loop_line.strip("\n"),
                                                                                      indent="    " * loop_count)
                        debug.assertion(converted)
                        debug.assertion(not loop_remainder.strip())
                        body += new_loop_line + "\n"
                else:
                    debug.trace(5, f"Warning: unexpected condition: blank loop line {loop_line!r}")
                converted = True
            # Use remaining text if any; otherwise get next line
            if (len(remainder) > 0):
                loop_line = remainder.strip()
                remainder = ""
            else:
                # note: line tracing mimics that of format()
                if loop_count > 0:
                    alt_bash_line = next(cmd_iter, None)
                    debug.trace_expr(5, alt_bash_line)
                    if INCLUDE_ORIGINAL and (alt_bash_line is not None):
                        self.line_num += 1
                        alt_bash_line_spec = alt_bash_line.replace("\n", "\\n")
                        body += f"{indent}# L{self.line_num}: {alt_bash_line_spec}\n"
                        self.line_num += (alt_bash_line.count("\n"))
                    loop_line = alt_bash_line
        debug.trace_expr(6, body)
        comment = ""
        if not self.skip_comments:
            comment = f"#b2py: Founded loop of order {max_loop_count}. Please be careful\n"
        body = comment + body
        debug.assertion(remainder == "")
        debug.trace(7, f"process_compound() => ({converted}, {body!r}, {loop_line!r})")
        return converted, body, loop_line

    def format(self, codex):                                   # TODO: format => convert_snippert
        """Convert self.cmd into python, returning text           # Tana-TODO: refine comments
        Note: Optionally does conversion via OpenAI CODEX"""  
        debug.trace(6, f"{self.__class__.__name__}.format({codex})")
        # Tom-Note: This will need to be restructured. I preserved original for sake of diff.
        # Split the code into segments (see bash2python_diff.py, which uses dashes instead of newlines.
        # TODO3: cleanup cmd as file vs as text support (n.b., error prone)
        python_commands = []
        self.line_num = 0
        debug.assertion(self.segment_divider.endswith("\n"))
        cmd_iter = (system.open_file(self.cmd) if system.file_exists(self.cmd)
                    # TODO1: use better command splitting (e.g., in case ';' embedding in string)
                    ## BAD: else iter(self.cmd.replace(";", "\n").splitlines(keepends=True)))
                    ## NOTE: semicolons needed for proper compound statement parsing
                    ## TEST: else iter(self.cmd.splitlines(keepends=True)))
                    else iter(self.cmd.split(sep=self.segment_divider)))
        if cmd_iter:
            for bash_line in cmd_iter:            # for each line in the script
                self.line_num += 1
                debug.trace_expr(5, bash_line)
                if INCLUDE_ORIGINAL:
                    bash_line_spec = bash_line.replace("\n", "\\n")
                    python_commands.append(f"# L{self.line_num}: {bash_line_spec}")
                    self.line_num += (bash_line.count("\n"))
                remainder = bash_line
                MAX_LOOP_ITERATIONS = 10
                loop_iterations = 0
                while ((remainder != "") or (loop_iterations == 0)):
                    loop_iterations += 1
                    if (loop_iterations == MAX_LOOP_ITERATIONS):
                        debug.trace(6, f"Premature loop termination (iters={loop_iterations})")
                        break
                    try:
                        remainder = self.convert_bash(remainder, cmd_iter, python_commands, codex)
                    except(NotImplementedError) as exc:
                        python_commands.append(f"Warning: {exc}")
                        debug.trace_exception(4, "format/convert unimplemented")
                    except:
                        system.print_exception_info("format/convert other")
        return "\n".join(python_commands)

    def convert_bash(self, bash_line, cmd_iter, python_commands, codex):
        """Convert bash LINE with additional input from CMD_ITER via CODEX
        Modifies PYTHON_COMMANDS in place and returns any unprocessed text
        """
        debug.trace(5, f"convert_bash({bash_line!r}, ..., {codex})\n\tself={self}")
        # Optionally filter non-code lines
        # Note: comments useful for Codex so included by default (i.e., not STRIP_INPUT)
        include = True
        rem_bash_line = ""
        # Strip comments and blank lines (n.b., doesn't show up in listing at all_
        if STRIP_INPUT:
            if not bash_line.strip():
                debug.trace(4, f"FYI: Ignoring blank line {self.line_num}: {bash_line!r}")
                include = False
            elif re.search(r"^\s*#", bash_line):
                debug.trace(4, f"FYI: Ignoring comment line {self.line_num}: {bash_line!r}")
                include = False
            else:
                pass
        # Add ignored text to return buffer
        if not include:
            debug.trace(5, f"Ignoring stripped input {bash_line!r}")
            python_commands.append(bash_line.strip("\n"))
        # Otherwise proceed with more filtering
        else:
            # Old sledgehammer approach to stripping comments
            comment = ""
            if (STRIP_INPUT and "#" in bash_line):
                # Tana-TODO: ignore #'s within strings
                debug.assertion(not embedded_in_quoted_string("#", bash_line))
                bash_line, comment = bash_line.split("#", maxsplit=1)
                debug.trace(4, f"FYI: Stripped comments from line {self.line_num}: {bash_line!r}")
            # Process with Codex; normally it should see the comments so best w/o STRIP_INPUT)
            if codex:
                python_line = self.codex_convert(bash_line)
                # note: removes comment indicator (TODO, rework so not produced when just using codex)
                python_line = my_re.sub(fr"^{CODEX_PREFIX}", "", python_line, flags=my_re.MULTILINE)
                python_commands.append(python_line)
            # Ignore comment (just up to first newline)
            elif (my_re.search(r"^(\s*#[^\n]*\n?)(.*)?$", bash_line, flags=my_re.DOTALL)):
                (comment, rem_bash_line) = my_re.groups()
                debug.trace(5, f"Ignoring comment {comment!r}")
                python_commands.append(comment)
            # Ignore blank line
            elif (my_re.search(r"^(\s*\n)(.*)?$", bash_line, flags=my_re.DOTALL)):
                # note: this matches an empty string
                (blank_line, rem_bash_line) = my_re.groups()
                debug.trace(5, f"Ignoring blank line {(blank_line or '')!r}")
                python_commands.append(blank_line or "")
            # Otherwise parse via regex approach
            else:
                (converted, python_line, rem_bash_line) = self.process_compound(bash_line, cmd_iter)
                if not converted:
                    # note: handles statements involving no variables
                    (converted, python_line, rem_bash_line) = self.process_keyword_statement(bash_line)
                if not converted:
                    (converted, python_line, rem_bash_line) = self.process_simple(bash_line)
                    ## TODO: python_line = self.var_replace(python_line, converted_statement=True)
                    (converted, python_line, rem_bash_line)  = self.var_replace(python_line)
                # Adhoc fixups
                if (comment and not self.skip_comments):
                    python_line += f" # {comment}"
                python_commands.append(python_line)
        if rem_bash_line is None:
            rem_bash_line = ""
        debug.trace(6, f"convert_bash() => {rem_bash_line!r}")
        return rem_bash_line
    
    def header(self):
        """Returns Python header to use for converted snippet code"""
        debug.trace(6, f"{self.__class__.__name__}.header()\n\tself={self}")
        return PYTHON_HEADER


# -------------------------------------------------------------------------------

# Format optional usage notes
# Note: uses \b hack: see
#    https://stackoverflow.com/questions/42446923/python-click-help-formatting-newline
# TODO4: make notes section flush left (not indented two spaces)
usage_notes = ""
if "--verbose" in system.get_args():
    env_opts = system.formatted_environment_option_descriptions(sort=True, indent=INDENT)
    usage_notes += (
        "\b\n"
        "Notes:\n"
        "- It is best to integrate regular and Codex output\n"
        "- See bash2python_diff.py for way to compare regular vs codex output\n"
        f"- Available env. options:\n{INDENT}{env_opts}\n"
    )

@click.command(epilog=usage_notes)
# Tana-TODO: separate script option into separate ones (e.g., script-file and script-text arguments)
# For example, line-numbers option currently only works for former.
@click.option("--script", "-s", help="Script or snippet to convert")
@click.option("--output", "-o", help="Output file")
@click.option("--overview", help="List of what is working for now")
@click.option("--execute", is_flag=True, help="Try to run the code directly (probably brokes somewhere)")
@click.option("--line-numbers", is_flag=True, help="Add line numbers to the output")
@click.option("--codex", is_flag=True, help="Use OpenAI Codex to port all the code. It's SLOW")
@click.option("--stdin", "-i", is_flag=True, help="Get input from stdin")
@click.option("--verbose", is_flag=True, help="Verbose output")

def main(script, output, overview, execute, line_numbers, codex, stdin, verbose):
    """Entry point"""
    debug.trace_current_context(level=TL.QUITE_DETAILED)
    if overview:
        print("""Working:
            -If, elif, else, and while.
            -Variable Assignments, all of them. 
            -Piping to file. (Uses bash for it)
            -All kind of calls to system. 
            -Printing (still using run(echo) for it)
            -AI sugestions using OpenAI GPT-3 Codex (requires API key)
            -Bash defaults
Not working yet: 
            -For loops")
            -Writing on / reading files
            -Bash functions
            -Any kind of subprocess
            -C-style loops """)
    debug.trace(3,
                f"main{(script, output, overview, execute, line_numbers, codex, stdin, verbose)}: script={system.real_path(__file__)}")
    bash_snippet = script

    # Convert filename script to text
    if bash_snippet and system.file_exists(bash_snippet):
        bash_snippet = system.read_file(bash_snippet)
    
    # Optionally get script from standard input (stdin)
    if stdin:
        debug.assertion(not bash_snippet)
        dummy_main_app = Main([], description=__doc__, skip_input=False, manual_input=True)
        debug.assertion(dummy_main_app.parsed_args)
        bash_snippet = dummy_main_app.read_entire_input()
    #
    if not bash_snippet:
        print("No script or snippet specified. Use --help for usage or --script to specify a script")

        # Show synopsis of options (TODO4: figure out how to do within maldito click)
        if BRIEF_USAGE:
            prog = __file__
            options = gh.run(fr"{prog} --help 2>&1 | extract_matches.perl '(\-\-.*)  '")
            options = re.sub(r"(.*?)\s+$", r"[\1]", options, flags=re.MULTILINE)
            options = options.replace("\n", " ")
            prog = gh.basename(prog)
            print(f"usage: {prog} {options}")
        return

    # HACK: override global flag
    global USE_CODEX
    if codex and not USE_CODEX:
        USE_CODEX = codex

    # If just converting via Codex, show the result and stop.
    if JUST_CODEX:
        b2p = Bash2Python(bash_snippet, None)
        result = b2p.format(True)
        print(my_re.sub(fr"^{CODEX_PREFIX}", "", result, flags=my_re.MULTILINE))
        return

    # Optionally add line numbers
    # Tana-TODO: put this above (before script => bash_snippet support);
    if line_numbers:
        debug.assertion(system.file_exists(script))
        temp_script = gh.get_temp_file(gh.basename(script) + ".b2py.numbered")
        with open(script, encoding='UTF-8', mode='r') as infile, \
                open(temp_script, encoding='UTF-8', mode='w') as outfile:
            # Loop through each line in the input file
            for i, line in enumerate(infile):
                # Write the modified line to the output file
                if line.startswith("#"):
                    outfile.write(line)
                elif line == "\n":
                    outfile.write(line)
                else:
                    outfile.write(f"{line}#b2py #Line {i}" + "\n")
        bash_snippet = temp_script

    # Convert and print snippet
    debug.trace_expr(6, bash_snippet)
    b2p = Bash2Python(bash_snippet, "bash -c")
    if output:
        ## BAD: with open(output, "rw") as out_file:
        ## NOTE: easier to use helper like system.write_file (or system.write_lines)
        with open(output, encoding="UTF-8", mode="w") as out_file:
            out_file.write(b2p.header())
            out_file.write(b2p.format(codex))
    if execute:
        cmd = b2p.format(codex)
        print(f"# {cmd}")
        # TODO; print(gh.run("python " + write_temp_file(cmd)))
        print(safe_eval(str(cmd)))
    else:
        ## OLD:
        ## if INCLUDE_HEADER:
        ##    print(b2p.header())
        print(b2p.format(codex))
        print(b2p.contains_embedded_for(bash_snippet))


# -------------------------------------------------------------------------------
if __name__ == '__main__':
    # pylint: disable=no-value-for-parameter
    main()
