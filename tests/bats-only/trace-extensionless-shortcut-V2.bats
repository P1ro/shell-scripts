#!/usr/bin/env bats


# Make executables ./tests/../ visible to PATH
PATH="/home/aveey/tom-project/shell-scripts/tests/batspp-only/../:$PATH"

# Source files
shopt -s expand_aliases


@test "test0" {
	test_folder=$(echo /tmp/test0-$$)
	mkdir $test_folder && cd $test_folder

}


@test "test1" {
	test_folder=$(echo /tmp/test1-$$)
	mkdir $test_folder && cd $test_folder

	unalias -a
	alias | wc -l
	for f in $(typeset -f | egrep '^\w+'); do unset -f $f; done
	TMP=/tmp/test-extensionless
	actual=$(test1-assert5-actual)
	expected=$(test1-assert5-expected)
	echo "========== actual =========="
	echo "$actual" | hexview.perl
	echo "========= expected ========="
	echo "$expected" | hexview.perl
	echo "============================"
	[ "$actual" == "$expected" ]

}

function test1-assert5-actual () {
	BIN_DIR=$PWD/..
}
function test1-assert5-expected () {
	echo -e '00'
}

@test "test2" {
	test_folder=$(echo /tmp/test2-$$)
	mkdir $test_folder && cd $test_folder

	actual=$(test2-assert1-actual)
	expected=$(test2-assert1-expected)
	echo "========== actual =========="
	echo "$actual" | hexview.perl
	echo "========= expected ========="
	echo "$expected" | hexview.perl
	echo "============================"
	[ "$actual" == "$expected" ]

}

function test2-assert1-actual () {
	alias | wc -l
}
function test2-assert1-expected () {
	echo -e '0'
}

@test "test3" {
	test_folder=$(echo /tmp/test3-$$)
	mkdir $test_folder && cd $test_folder

	temp_dir=$TMP/test-3570
	mkdir -p "$temp_dir"
	cd "$temp_dir"
}


@test "test4" {
	test_folder=$(echo /tmp/test4-$$)
	mkdir $test_folder && cd $test_folder

	actual=$(test4-assert1-actual)
	expected=$(test4-assert1-expected)
	echo "========== actual =========="
	echo "$actual" | hexview.perl
	echo "========= expected ========="
	echo "$expected" | hexview.perl
	echo "============================"
	[ "$actual" == "$expected" ]

}

function test4-assert1-actual () {
	typeset -f | egrep '^\w+' | wc -l
}
function test4-assert1-expected () {
	echo -e '10'
}

@test "test5" {
	test_folder=$(echo /tmp/test5-$$)
	mkdir $test_folder && cd $test_folder

	alias perl-=""
	GREP='grep'
	alias move='mv'
	alias convert-termstrings='perl- convert_termstrings.perl'
	alias do-rcsdiff='do_rcsdiff.sh'
	alias dobackup='dobackup.sh'
	alias kill-em='kill_em.sh'
	alias kill-it='kill-em --pattern'
}


@test "test6" {
	test_folder=$(echo /tmp/test6-$$)
	mkdir $test_folder && cd $test_folder

	rm -rf ./*
	printf "TOP\nTHIS IS A TEST\nBOTTOM" > test.txt
	ls
	dobackup test.txt
	linebr
	actual=$(test6-assert6-actual)
	expected=$(test6-assert6-expected)
	echo "========== actual =========="
	echo "$actual" | hexview.perl
	echo "========= expected ========="
	echo "$expected" | hexview.perl
	echo "============================"
	[ "$actual" == "$expected" ]

}

function test6-assert6-actual () {
	ls
}
function test6-assert6-expected () {
	echo -e "test.txtBacking up 'test.txt' to './backup/test.txt'--------------------------------------------------------------------------------backup\ttest.txt"
}

@test "test7" {
	test_folder=$(echo /tmp/test7-$$)
	mkdir $test_folder && cd $test_folder

	function ps-mine- { ps-mine "$@" | filter-dirnames; }
	alias ps_mine='ps-mine'
	alias ps-mine-all='ps-mine --all'
}


@test "test8" {
	test_folder=$(echo /tmp/test8-$$)
	mkdir $test_folder && cd $test_folder

	alias rename-files='perl- rename_files.perl'
	alias rename_files='rename-files'
	alias testwn='perl- testwn.perl'
	alias perlgrep='perl- perlgrep.perl'
	alias foreach='perl- foreach.perl'
	alias rename-spaces='rename-files -q -global " " "_"'
	alias rename-special-punct='rename-files -q -global -regex "[&\!\*?\(\)]" ""'
	alias rename-quotes='rename-files -q -global "'"'"'" ""' 
}


@test "test9" {
	test_folder=$(echo /tmp/test9-$$)
	mkdir $test_folder && cd $test_folder

	rename-files
}


@test "test10" {
	test_folder=$(echo /tmp/test10-$$)
	mkdir $test_folder && cd $test_folder

	do-rcsdiff
}


@test "test11" {
	test_folder=$(echo /tmp/test11-$$)
	mkdir $test_folder && cd $test_folder

	uname -r > versionR.txt
	uname -a > versionA.txta
	uname -v > versionV.txt
	uname -i > versionI.txt
	uname > "version none.txt"
	uname -ra > "version?.txt"
	ps -aux > processlist.txt
	cp ./versionR.txt ./versionR-1.txt
	actual=$(test11-assert9-actual)
	expected=$(test11-assert9-expected)
	echo "========== actual =========="
	echo "$actual" | hexview.perl
	echo "========= expected ========="
	echo "$expected" | hexview.perl
	echo "============================"
	[ "$actual" == "$expected" ]

}

function test11-assert9-actual () {
	ls
}
function test11-assert9-expected () {
	echo -e "backup\t\t   versionA.txta       versionR-1.txt   versionV.txtprocesslist.txt   versionI.txt        versionR.txttest.txt\t  'version none.txt'  'version?.txt'"
}

@test "test12" {
	test_folder=$(echo /tmp/test12-$$)
	mkdir $test_folder && cd $test_folder

	actual=$(test12-assert1-actual)
	expected=$(test12-assert1-expected)
	echo "========== actual =========="
	echo "$actual" | hexview.perl
	echo "========= expected ========="
	echo "$expected" | hexview.perl
	echo "============================"
	[ "$actual" == "$expected" ]

}

function test12-assert1-actual () {
	rename-files -q test.txt harry.txt
}
function test12-assert1-expected () {
	echo -e 'renaming "test.txt" to "harry.txt"'
}

@test "test13" {
	test_folder=$(echo /tmp/test13-$$)
	mkdir $test_folder && cd $test_folder

	actual=$(test13-assert1-actual)
	expected=$(test13-assert1-expected)
	echo "========== actual =========="
	echo "$actual" | hexview.perl
	echo "========= expected ========="
	echo "$expected" | hexview.perl
	echo "============================"
	[ "$actual" == "$expected" ]

}

function test13-assert1-actual () {
	perlgrep "bash" ./processlist.txt
}
function test13-assert1-expected () {
	echo -e 'aveey       2415  0.0  0.0  17612  2020 pts/0    Ss   17:40   0:00 bashaveey       2440  0.0  0.1  17612  4936 pts/1    Ss+  17:40   0:00 bashaveey       4508  0.0  1.6 691220 57836 ?        Ssl  17:50   0:03 /usr/bin/python3 -m bash_kernel -f /home/aveey/.local/share/jupyter/runtime/kernel-c9deb3b8-c656-45df-a2c2-d9f85ff318ab.jsonaveey       4519  0.0  0.1  17480  4904 pts/3    Ss+  17:50   0:00 /usr/bin/bash --rcfile /usr/lib/python3/dist-packages/pexpect/bashrc.shaveey       5078  0.0  0.1  17668  5048 pts/4    Ss   17:54   0:00 bashaveey       8448  0.0  0.1  17668  5376 pts/5    Ss+  18:21   0:00 bashaveey      11222  0.0  1.7 691220 60556 ?        Ssl  21:10   0:01 /usr/bin/python3 -m bash_kernel -f /home/aveey/.local/share/jupyter/runtime/kernel-2576ed23-01a7-4571-b5e4-0db404e9a80a.jsonaveey      11233  0.0  0.1  17540  5236 pts/6    Ss+  21:10   0:00 /usr/bin/bash --rcfile /usr/lib/python3/dist-packages/pexpect/bashrc.shaveey      13076  0.0  1.7 691220 60580 ?        Ssl  21:16   0:01 /usr/bin/python3 -m bash_kernel -f /home/aveey/.local/share/jupyter/runtime/kernel-438a7192-237e-490e-8ab2-2658035cc4dd.jsonaveey      13087  0.0  0.1  17540  5408 pts/7    Ss+  21:16   0:00 /usr/bin/bash --rcfile /usr/lib/python3/dist-packages/pexpect/bashrc.shaveey      13405  0.0  0.1  17668  5808 pts/8    Ss   21:20   0:00 bashaveey      22993  0.0  0.1  17664  5916 pts/9    Ss   21:55   0:00 bashaveey      25810 22.0  1.7 691228 60764 ?        Ssl  22:02   0:01 /usr/bin/python3 -m bash_kernel -f /home/aveey/.local/share/jupyter/runtime/kernel-7d6eccc1-4db7-4f69-b592-329e0b2bcb25.jsonaveey      25821  2.2  0.1  17540  5452 pts/2    Ss   22:03   0:00 /usr/bin/bash --rcfile /usr/lib/python3/dist-packages/pexpect/bashrc.sh'
}

@test "test14" {
	test_folder=$(echo /tmp/test14-$$)
	mkdir $test_folder && cd $test_folder

	foreach "echo $f" *.txt
}


@test "test15" {
	test_folder=$(echo /tmp/test15-$$)
	mkdir $test_folder && cd $test_folder

	actual=$(test15-assert1-actual)
	expected=$(test15-assert1-expected)
	echo "========== actual =========="
	echo "$actual" | hexview.perl
	echo "========= expected ========="
	echo "$expected" | hexview.perl
	echo "============================"
	[ "$actual" == "$expected" ]

}

function test15-assert1-actual () {
	rename-spaces
}
function test15-assert1-expected () {
	echo -e 'renaming "version none.txt" to "version_none.txt"'
}

@test "test16" {
	test_folder=$(echo /tmp/test16-$$)
	mkdir $test_folder && cd $test_folder

	actual=$(test16-assert1-actual)
	expected=$(test16-assert1-expected)
	echo "========== actual =========="
	echo "$actual" | hexview.perl
	echo "========= expected ========="
	echo "$expected" | hexview.perl
	echo "============================"
	[ "$actual" == "$expected" ]

}

function test16-assert1-actual () {
	rename-special-punct
}
function test16-assert1-expected () {
	echo -e 'renaming "version?.txt" to "version.txt"'
}

@test "test17" {
	test_folder=$(echo /tmp/test17-$$)
	mkdir $test_folder && cd $test_folder

	ps -l > "process(L).md"
	ps -u > "process(U).md"
	ps -x > "process(X).md"
	ps -al > 'process'all'.md'
}


@test "test18" {
	test_folder=$(echo /tmp/test18-$$)
	mkdir $test_folder && cd $test_folder

	alias move-duplicates='mkdir -p duplicates; move *\([0-9]\).* duplicates 2>&1 | $GREP -iv cannot.stat.*..No.such'
	alias rename-parens='rename-files -global -regex "[\(\)]" "" *[\(\)]*'
	alias rename-etc='rename-spaces; rename-quotes; rename-special-punct; move-duplicates'
}


@test "test19" {
	test_folder=$(echo /tmp/test19-$$)
	mkdir $test_folder && cd $test_folder

	actual=$(test19-assert1-actual)
	expected=$(test19-assert1-expected)
	echo "========== actual =========="
	echo "$actual" | hexview.perl
	echo "========= expected ========="
	echo "$expected" | hexview.perl
	echo "============================"
	[ "$actual" == "$expected" ]

}

function test19-assert1-actual () {
	rename-parens -v
}
function test19-assert1-expected () {
	echo -e 'renaming "process(L).md" to "processL.md"renaming "process(U).md" to "processU.md"renaming "process(X).md" to "processX.md"'
}

@test "test20" {
	test_folder=$(echo /tmp/test20-$$)
	mkdir $test_folder && cd $test_folder

	actual=$(test20-assert1-actual)
	expected=$(test20-assert1-expected)
	echo "========== actual =========="
	echo "$actual" | hexview.perl
	echo "========= expected ========="
	echo "$expected" | hexview.perl
	echo "============================"
	[ "$actual" == "$expected" ]

}

function test20-assert1-actual () {
	rename-quotes -v
}
function test20-assert1-expected () {
	echo -e 'WARNING: Ignoring -quick mode as files specified'
}

@test "test21" {
	test_folder=$(echo /tmp/test21-$$)
	mkdir $test_folder && cd $test_folder

	actual=$(test21-assert1-actual)
	expected=$(test21-assert1-expected)
	echo "========== actual =========="
	echo "$actual" | hexview.perl
	echo "========= expected ========="
	echo "$expected" | hexview.perl
	echo "============================"
	[ "$actual" == "$expected" ]

}

function test21-assert1-actual () {
	ls
}
function test21-assert1-expected () {
	echo -e 'backup\t       processlist.txt\tprocessX.md    version_none.txt  version.txtharry.txt      processL.md\tversionA.txta  versionR-1.txt\t versionV.txtprocessall.md  processU.md\tversionI.txt   versionR.txt'
}

@test "test22" {
	test_folder=$(echo /tmp/test22-$$)
	mkdir $test_folder && cd $test_folder

	function move-versioned-files {
	alias perl-grep='perl $BIN_DIR/perlgrep.perl'
	alias dir-rw='dir -rw'
	alias move='mv'
	local ext_pattern='$1'
	if [ '$ext_pattern' = '' ]; then ext_pattern='{list,log,txt}'; fi
	local dir='$2'
	if [ '$dir' = '' ]; then dir='versioned-files'; fi
	mkdir -p '$dir';
	local D='[-.]'
	local file_list='$TEMP/_move-versioned-files-$$.list'
	eval_middle='$(eval dir-rw *$D$ext_pattern[0-9]*  *$D*[0-9]*$D$ext_pattern  *$D$ext_pattern$D*[0-9][0-9]*   *$D*[0-9][0-9]*$D$ext_pattern  2>&1 | perl-grep -v "No such file" | perl -pe "s/(\S+\s+){6}\S+//;" | sort -u)'
	move '$eval_middle' '$dir'
	}
	alias move-log-files='move-versioned-files "{log,debug}" "log-files"'
	alias move-output-files='move-versioned-files "{csv,html,json,list,out,output,png,report,tsv,xml}" "output-files"'
	alias move-adhoc-files='move-log-files; move-output-files'
}


@test "test23" {
	test_folder=$(echo /tmp/test23-$$)
	mkdir $test_folder && cd $test_folder

	man sudo > sudo_manual.out
	man ansifilter > fakelog.log
	ps -aux > process_all.html
}


@test "test24" {
	test_folder=$(echo /tmp/test24-$$)
	mkdir $test_folder && cd $test_folder

	function get-free-filename() {
	local base="$1"
	local sep="$2"
	local L=1
	local filename="$base"
	while [ -e "$filename" ]; do
	let L++
	filename="$base$sep$L"
	done;
	echo "$filename"
	}
	function rename-with-file-date() {
	local f new_f
	local move_command="move"
	if [ "$1" = "--copy" ]; then
	move_command='command cp --interactive --verbose --preserve'
	shift
	fi
	for f in "$@"; do
	if [ -e "$f" ]; then
	new_f=$(get-free-filename "$f".$(date --reference="$f" '+%d%b%y') ".")
	eval "$move_command" "$f" "$new_f";
	fi
	done;
	}
	function copy-with-file-date { rename-with-file-date --copy "$@"; }
}


@test "test25" {
	test_folder=$(echo /tmp/test25-$$)
	mkdir $test_folder && cd $test_folder

}


@test "test26" {
	test_folder=$(echo /tmp/test26-$$)
	mkdir $test_folder && cd $test_folder

	alias bigrams='perl -sw $BIN_DIR/count_bigrams.perl -N=2'
	alias unigrams='perl -sw $BIN_DIR/count_bigrams.perl -N=1'
	alias word-count=unigrams
}


@test "test27" {
	test_folder=$(echo /tmp/test27-$$)
	mkdir $test_folder && cd $test_folder

	actual=$(test27-assert1-actual)
	expected=$(test27-assert1-expected)
	echo "========== actual =========="
	echo "$actual" | hexview.perl
	echo "========= expected ========="
	echo "$expected" | hexview.perl
	echo "============================"
	[ "$actual" == "$expected" ]

}

function test27-assert1-actual () {
	word-count ./versionV.txt
}
function test27-assert1-expected () {
	echo -e 'utc\t1n/a\t126\t1aug\t113:26:29\t1fri\t1#54-ubuntu\t1smp\t1'
}

@test "test28" {
	test_folder=$(echo /tmp/test28-$$)
	mkdir $test_folder && cd $test_folder

	actual=$(test28-assert1-actual)
	expected=$(test28-assert1-expected)
	echo "========== actual =========="
	echo "$actual" | hexview.perl
	echo "========= expected ========="
	echo "$expected" | hexview.perl
	echo "============================"
	[ "$actual" == "$expected" ]

}

function test28-assert1-actual () {
	bigrams ./version.txt
}
function test28-assert1-expected () {
	echo -e 'x86_64:x86_64\t2utc:2022\t1n/a:n/a\t1n/a:linux\t1fri:aug\t1#54-ubuntu:smp\t126:13:26:29\t1smp:fri\t113:26:29:utc\t1aug:26\t1linux:ins-15-3573-umate\t12022:x86_64\t15.15.0-48-generic:#54-ubuntu\t1ins-15-3573-umate:5.15.0-48-generic\t1'
}

@test "test29" {
	test_folder=$(echo /tmp/test29-$$)
	mkdir $test_folder && cd $test_folder

	lynx-dump-stdout () { lynx -width=512 -dump "$@"; }
	lynx-dump () { 
	local in_file="$1"
	shift 1
	local base=$(basename "$file" .html)
	if [[ ("$out_file" = "" ) && (! "$1" =~ -*) ]]; then
	local out_file="$1"
	fi
	if [ "$out_file" = "" ]; then out_file="$base.txt"; fi
	lynx-dump-stdout "$@" "$file" > "$out_file" 2> "$out_file.log"
	if [ -s "$out_file.log" ]; then
	cat "$out_file.log"
	delete-force "$out_file.log"
	fi
	}
	if [ "$BAREBONES_HOST" = "1" ]; then export lynx_width=0; fi
	alias lynx-html='lynx -force_html'
}


@test "test30" {
	test_folder=$(echo /tmp/test30-$$)
	mkdir $test_folder && cd $test_folder

}


@test "test31" {
	test_folder=$(echo /tmp/test31-$$)
	mkdir $test_folder && cd $test_folder

	function setenv () { export $1="$2"; }
	alias unsetenv='unset'
	alias unexport='unset'
}


@test "test32" {
	test_folder=$(echo /tmp/test32-$$)
	mkdir $test_folder && cd $test_folder

	setenv MY_USERNAME aveey-temp
	actual=$(test32-assert2-actual)
	expected=$(test32-assert2-expected)
	echo "========== actual =========="
	echo "$actual" | hexview.perl
	echo "========= expected ========="
	echo "$expected" | hexview.perl
	echo "============================"
	[ "$actual" == "$expected" ]

}

function test32-assert2-actual () {
	echo $MY_USERNAME
}
function test32-assert2-expected () {
	echo -e 'aveey-temp'
}

@test "test33" {
	test_folder=$(echo /tmp/test33-$$)
	mkdir $test_folder && cd $test_folder

	unexport MY_USERNAME
	echo $MY_USERNAME
}


@test "test34" {
	test_folder=$(echo /tmp/test34-$$)
	mkdir $test_folder && cd $test_folder

	actual=$(test34-assert1-actual)
	expected=$(test34-assert1-expected)
	echo "========== actual =========="
	echo "$actual" | hexview.perl
	echo "========= expected ========="
	echo "$expected" | hexview.perl
	echo "============================"
	[ "$actual" == "$expected" ]

}

function test34-assert1-actual () {
	echo "END"
}
function test34-assert1-expected () {
	echo -e 'END'
}