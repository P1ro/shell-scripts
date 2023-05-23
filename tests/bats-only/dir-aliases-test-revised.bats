#!/usr/bin/env bats


# Make executables ./tests/../ visible to PATH
PATH="/home/aveey/tom-project/shell-scripts/tests/batspp-only/../:$PATH"

<<<<<<< HEAD
# Enable aliases
shopt -s expand_aliases



@test "test-1" {
	testfolder="/tmp/batspp-132262/test-1"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'echo $PS1\n' "=========="
	test-1-actual 
	echo "=========" $'[PEXP\\[\\]ECT_PROMPT>' "========="
	test-1-expected 
	echo "============================"
	# ???: 'echo $PS1\n'=$(test-1-actual)
	# ???: '[PEXP\\[\\]ECT_PROMPT>'=$(test-1-expected)
	[ "$(test-1-actual)" == "$(test-1-expected)" ]
}

function test-1-actual () {
	# no-op in case content just a comment
	true

	echo $PS1

}

function test-1-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
[PEXP\[\]ECT_PROMPT>
END_EXPECTED
}


@test "test-3" {
	testfolder="/tmp/batspp-132262/test-3"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'unalias -a\n' "=========="
	test-3-actual 
	echo "=========" $"$ alias | wc -l\n$ for f in $(typeset -f | egrep '^\\w+'); do unset -f $f; done\n$ typeset -f | egrep '^\\w+' | wc -l\n0\n0" "========="
	test-3-expected 
	echo "============================"
	# ???: 'unalias -a\n'=$(test-3-actual)
	# ???: "$ alias | wc -l\n$ for f in $(typeset -f | egrep '^\\w+'); do unset -f $f; done\n$ typeset -f | egrep '^\\w+' | wc -l\n0\n0"=$(test-3-expected)
	[ "$(test-3-actual)" == "$(test-3-expected)" ]
}

function test-3-actual () {
	# no-op in case content just a comment
	true

	unalias -a

}

function test-3-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
$ alias | wc -l
$ for f in $(typeset -f | egrep '^\w+'); do unset -f $f; done
$ typeset -f | egrep '^\w+' | wc -l
0
0
END_EXPECTED
}


@test "test-4" {
	testfolder="/tmp/batspp-132262/test-4"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'alias testnum="sed -r "s/[0-9]/N/g"" \n' "=========="
	test-4-actual 
	echo "=========" $'$ alias testuser="sed -r "s/"$USER"+/userxf333/g""' "========="
	test-4-expected 
	echo "============================"
	# ???: 'alias testnum="sed -r "s/[0-9]/N/g"" \n'=$(test-4-actual)
	# ???: '$ alias testuser="sed -r "s/"$USER"+/userxf333/g""'=$(test-4-expected)
	[ "$(test-4-actual)" == "$(test-4-expected)" ]
}

function test-4-actual () {
	# no-op in case content just a comment
	true

	alias testnum="sed -r "s/[0-9]/N/g"" 

}

function test-4-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
$ alias testuser="sed -r "s/"$USER"+/userxf333/g""
END_EXPECTED
}


@test "test-5" {
	testfolder="/tmp/batspp-132262/test-5"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'mkdir -p tmp/test-dir-aliases\n' "=========="
	test-5-actual 
	echo "=========" $'' "========="
	test-5-expected 
	echo "============================"
	# ???: 'mkdir -p tmp/test-dir-aliases\n'=$(test-5-actual)
	# ???: ''=$(test-5-expected)
	[ "$(test-5-actual)" == "$(test-5-expected)" ]
}

function test-5-actual () {
	# no-op in case content just a comment
	true

	mkdir -p tmp/test-dir-aliases

}

function test-5-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED

END_EXPECTED
}


@test "test-6" {
	testfolder="/tmp/batspp-132262/test-6"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'TMP=/tmp/test-dir-aliases\n' "=========="
	test-6-actual 
	echo "=========" $'## NOTE: Source it directly from the ./tests directory.\n$ BIN_DIR=$PWD/..\n## You will need to run jupyter from that directory.\n## source $TEMP_BIN/_dir-aliases.bash\n$ alias | wc -l\n$ source _dir-aliases.bash\n2' "========="
	test-6-expected 
	echo "============================"
	# ???: 'TMP=/tmp/test-dir-aliases\n'=$(test-6-actual)
	# ???: '## NOTE: Source it directly from the ./tests directory.\n$ BIN_DIR=$PWD/..\n## You will need to run jupyter from that directory.\n## source $TEMP_BIN/_dir-aliases.bash\n$ alias | wc -l\n$ source _dir-aliases.bash\n2'=$(test-6-expected)
	[ "$(test-6-actual)" == "$(test-6-expected)" ]
}

function test-6-actual () {
	# no-op in case content just a comment
	true

	TMP=/tmp/test-dir-aliases

}

function test-6-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
## NOTE: Source it directly from the ./tests directory.
$ BIN_DIR=$PWD/..
## You will need to run jupyter from that directory.
## source $TEMP_BIN/_dir-aliases.bash
$ alias | wc -l
$ source _dir-aliases.bash
2
END_EXPECTED
}


@test "test-7" {
	testfolder="/tmp/batspp-132262/test-7"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'alias | wc -l\n' "=========="
	test-7-actual 
	echo "=========" $'10' "========="
	test-7-expected 
	echo "============================"
	# ???: 'alias | wc -l\n'=$(test-7-actual)
	# ???: '10'=$(test-7-expected)
	[ "$(test-7-actual)" == "$(test-7-expected)" ]
}

function test-7-actual () {
	# no-op in case content just a comment
	true

	alias | wc -l

}

function test-7-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
10
END_EXPECTED
}


@test "test-8" {
	testfolder="/tmp/batspp-132262/test-8"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $"typeset -f | egrep '^\\w+' | wc -l\n" "=========="
	test-8-actual 
	echo "=========" $'2' "========="
	test-8-expected 
	echo "============================"
	# ???: "typeset -f | egrep '^\\w+' | wc -l\n"=$(test-8-actual)
	# ???: '2'=$(test-8-expected)
	[ "$(test-8-actual)" == "$(test-8-expected)" ]
}

function test-8-actual () {
	# no-op in case content just a comment
	true

	typeset -f | egrep '^\w+' | wc -l

}

function test-8-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
2
END_EXPECTED
}


@test "test-9" {
	testfolder="/tmp/batspp-132262/test-9"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'temp_dir=$TMP/test-7919\n' "=========="
	test-9-actual 
	echo "=========" $'$ mkdir -p "$temp_dir"\n# TODO: /bin/rm -rvf "$temp_dir"\n$ cd "$temp_dir"\n$ pwd\n/tmp/test-dir-aliases/test-7919' "========="
	test-9-expected 
	echo "============================"
	# ???: 'temp_dir=$TMP/test-7919\n'=$(test-9-actual)
	# ???: '$ mkdir -p "$temp_dir"\n# TODO: /bin/rm -rvf "$temp_dir"\n$ cd "$temp_dir"\n$ pwd\n/tmp/test-dir-aliases/test-7919'=$(test-9-expected)
	[ "$(test-9-actual)" == "$(test-9-expected)" ]
}

function test-9-actual () {
	# no-op in case content just a comment
	true

	temp_dir=$TMP/test-7919

}

function test-9-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
$ mkdir -p "$temp_dir"
# TODO: /bin/rm -rvf "$temp_dir"
$ cd "$temp_dir"
$ pwd
/tmp/test-dir-aliases/test-7919
END_EXPECTED
}


@test "test-10" {
	testfolder="/tmp/batspp-132262/test-10"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'/bin/rm -rvf /tmp/test-dir-aliases/test-7919/* >| /tmp/_cleanup-test-dir-aliases.log 2>&1\n' "=========="
	test-10-actual 
	echo "=========" $'' "========="
	test-10-expected 
	echo "============================"
	# ???: '/bin/rm -rvf /tmp/test-dir-aliases/test-7919/* >| /tmp/_cleanup-test-dir-aliases.log 2>&1\n'=$(test-10-actual)
	# ???: ''=$(test-10-expected)
	[ "$(test-10-actual)" == "$(test-10-expected)" ]
}

function test-10-actual () {
	# no-op in case content just a comment
	true

	/bin/rm -rvf /tmp/test-dir-aliases/test-7919/* >| /tmp/_cleanup-test-dir-aliases.log 2>&1

}

function test-10-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED

END_EXPECTED
}


@test "test-11" {
	testfolder="/tmp/batspp-132262/test-11"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'touch file1\n' "=========="
	test-11-actual 
	echo "=========" $'$ ln-symbolic file1 link1\n# \'link1\' -> \'file1\'\n# The second case should should fail\n$ ln-symbolic file1 link1\n# => "ln: failed to create symbolic link \'link1\': File exists?"\n# Should only be four files total (along with . and ..)\n$ ls -R | wc -l\n# => 3\n\'link1\' -> \'file1\'\nln: failed to create symbolic link \'link1\': File exists\n3' "========="
	test-11-expected 
	echo "============================"
	# ???: 'touch file1\n'=$(test-11-actual)
	# ???: '$ ln-symbolic file1 link1\n# \'link1\' -> \'file1\'\n# The second case should should fail\n$ ln-symbolic file1 link1\n# => "ln: failed to create symbolic link \'link1\': File exists?"\n# Should only be four files total (along with . and ..)\n$ ls -R | wc -l\n# => 3\n\'link1\' -> \'file1\'\nln: failed to create symbolic link \'link1\': File exists\n3'=$(test-11-expected)
	[ "$(test-11-actual)" == "$(test-11-expected)" ]
}

function test-11-actual () {
	# no-op in case content just a comment
	true

	touch file1

}

function test-11-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
$ ln-symbolic file1 link1
# 'link1' -> 'file1'
# The second case should should fail
$ ln-symbolic file1 link1
# => "ln: failed to create symbolic link 'link1': File exists?"
# Should only be four files total (along with . and ..)
$ ls -R | wc -l
# => 3
'link1' -> 'file1'
ln: failed to create symbolic link 'link1': File exists
3
END_EXPECTED
}


@test "test-12" {
	testfolder="/tmp/batspp-132262/test-12"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'bash $BIN_DIR/tests/_dir-aliases.bash\n' "=========="
	test-12-actual 
	echo "=========" $'' "========="
	test-12-expected 
	echo "============================"
	# ???: 'bash $BIN_DIR/tests/_dir-aliases.bash\n'=$(test-12-actual)
	# ???: ''=$(test-12-expected)
	[ "$(test-12-actual)" == "$(test-12-expected)" ]
}

function test-12-actual () {
	# no-op in case content just a comment
	true

	bash $BIN_DIR/tests/_dir-aliases.bash

}

function test-12-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED

END_EXPECTED
}


@test "test-13" {
	testfolder="/tmp/batspp-132262/test-13"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'symlinks-proper\n' "=========="
	test-13-actual 
	echo "=========" $'bash: sublinks: command not found' "========="
	test-13-expected 
	echo "============================"
	# ???: 'symlinks-proper\n'=$(test-13-actual)
	# ???: 'bash: sublinks: command not found'=$(test-13-expected)
	[ "$(test-13-actual)" == "$(test-13-expected)" ]
}

function test-13-actual () {
	# no-op in case content just a comment
	true

	symlinks-proper

}

function test-13-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
bash: sublinks: command not found
END_EXPECTED
}


@test "test-14" {
	testfolder="/tmp/batspp-132262/test-14"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'ln-symbolic /tmp temp-link\n' "=========="
	test-14-actual 
	echo "=========" $"temp-link' -> '/tmp" "========="
	test-14-expected 
	echo "============================"
	# ???: 'ln-symbolic /tmp temp-link\n'=$(test-14-actual)
	# ???: "temp-link' -> '/tmp"=$(test-14-expected)
	[ "$(test-14-actual)" == "$(test-14-expected)" ]
}

function test-14-actual () {
	# no-op in case content just a comment
	true

	ln-symbolic /tmp temp-link

}

function test-14-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
temp-link' -> '/tmp
END_EXPECTED
}


@test "test-15" {
	testfolder="/tmp/batspp-132262/test-15"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'ls -l | cut --characters=12-46 --complement\n' "=========="
	test-15-actual 
	echo "=========" $'total 0\n-rw-rw-r-- \nlrwxrwxrwx -> file1\nlrwxrwxrwx ink -> /tmp' "========="
	test-15-expected 
	echo "============================"
	# ???: 'ls -l | cut --characters=12-46 --complement\n'=$(test-15-actual)
	# ???: 'total 0\n-rw-rw-r-- \nlrwxrwxrwx -> file1\nlrwxrwxrwx ink -> /tmp'=$(test-15-expected)
	[ "$(test-15-actual)" == "$(test-15-expected)" ]
}

function test-15-actual () {
	# no-op in case content just a comment
	true

	ls -l | cut --characters=12-46 --complement

}

function test-15-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
total 0
-rw-rw-r-- 
lrwxrwxrwx -> file1
lrwxrwxrwx ink -> /tmp
END_EXPECTED
}


@test "test-16" {
	testfolder="/tmp/batspp-132262/test-16"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $"alias ln-symbolic-force='ln-symbolic --force'\n" "=========="
	test-16-actual 
	echo "=========" $'' "========="
	test-16-expected 
	echo "============================"
	# ???: "alias ln-symbolic-force='ln-symbolic --force'\n"=$(test-16-actual)
	# ???: ''=$(test-16-expected)
	[ "$(test-16-actual)" == "$(test-16-expected)" ]
}

function test-16-actual () {
	# no-op in case content just a comment
	true

	alias ln-symbolic-force='ln-symbolic --force'

}

function test-16-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED

END_EXPECTED
}


@test "test-17" {
	testfolder="/tmp/batspp-132262/test-17"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'ln-symbolic /tmp temp-link\n' "=========="
	test-17-actual 
	echo "=========" $"# ln-symbolic-force SHOULD BYPASS THE CONDITION\n# ln: failed to create symbolic link 'temp-link': File exist\n$ ln-symbolic-force /tmp temp-link\n'temp-link/tmp' -> '/tmp'\n'temp-link/tmp' -> '/tmp'" "========="
	test-17-expected 
	echo "============================"
	# ???: 'ln-symbolic /tmp temp-link\n'=$(test-17-actual)
	# ???: "# ln-symbolic-force SHOULD BYPASS THE CONDITION\n# ln: failed to create symbolic link 'temp-link': File exist\n$ ln-symbolic-force /tmp temp-link\n'temp-link/tmp' -> '/tmp'\n'temp-link/tmp' -> '/tmp'"=$(test-17-expected)
	[ "$(test-17-actual)" == "$(test-17-expected)" ]
}

function test-17-actual () {
	# no-op in case content just a comment
	true

	ln-symbolic /tmp temp-link

}

function test-17-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
# ln-symbolic-force SHOULD BYPASS THE CONDITION
# ln: failed to create symbolic link 'temp-link': File exist
$ ln-symbolic-force /tmp temp-link
'temp-link/tmp' -> '/tmp'
'temp-link/tmp' -> '/tmp'
END_EXPECTED
}


@test "test-18" {
	testfolder="/tmp/batspp-132262/test-18"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'link-symbolic-safe /tmp/tmp temp-link-safe\n' "=========="
	test-18-actual 
	echo "=========" $"temp-link-safe' -> '/tmp/tmp" "========="
	test-18-expected 
	echo "============================"
	# ???: 'link-symbolic-safe /tmp/tmp temp-link-safe\n'=$(test-18-actual)
	# ???: "temp-link-safe' -> '/tmp/tmp"=$(test-18-expected)
	[ "$(test-18-actual)" == "$(test-18-expected)" ]
}

function test-18-actual () {
	# no-op in case content just a comment
	true

	link-symbolic-safe /tmp/tmp temp-link-safe

}

function test-18-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
temp-link-safe' -> '/tmp/tmp
END_EXPECTED
}


@test "test-19" {
	testfolder="/tmp/batspp-132262/test-19"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'link-symbolic-safe --force /tmp/tmp temp-link-safe\n' "=========="
	test-19-actual 
	echo "=========" $"temp-link-safe' -> '/tmp/tmp" "========="
	test-19-expected 
	echo "============================"
	# ???: 'link-symbolic-safe --force /tmp/tmp temp-link-safe\n'=$(test-19-actual)
	# ???: "temp-link-safe' -> '/tmp/tmp"=$(test-19-expected)
	[ "$(test-19-actual)" == "$(test-19-expected)" ]
}

function test-19-actual () {
	# no-op in case content just a comment
	true

	link-symbolic-safe --force /tmp/tmp temp-link-safe

}

function test-19-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
temp-link-safe' -> '/tmp/tmp
END_EXPECTED
}


@test "test-20" {
	testfolder="/tmp/batspp-132262/test-20"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'ls -l | cut --characters=12-46 --complement\n' "=========="
	test-20-actual 
	echo "=========" $'total 0\n-rw-rw-r-- \nlrwxrwxrwx -> file1\nlrwxrwxrwx ink -> /tmp\nlrwxrwxrwx ink-safe -> /tmp/tmp' "========="
	test-20-expected 
	echo "============================"
	# ???: 'ls -l | cut --characters=12-46 --complement\n'=$(test-20-actual)
	# ???: 'total 0\n-rw-rw-r-- \nlrwxrwxrwx -> file1\nlrwxrwxrwx ink -> /tmp\nlrwxrwxrwx ink-safe -> /tmp/tmp'=$(test-20-expected)
	[ "$(test-20-actual)" == "$(test-20-expected)" ]
}

function test-20-actual () {
	# no-op in case content just a comment
	true

	ls -l | cut --characters=12-46 --complement

}

function test-20-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
total 0
-rw-rw-r-- 
lrwxrwxrwx -> file1
lrwxrwxrwx ink -> /tmp
lrwxrwxrwx ink-safe -> /tmp/tmp
END_EXPECTED
}


@test "test-21" {
	testfolder="/tmp/batspp-132262/test-21"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'glob-links\n' "=========="
	test-21-actual 
	echo "=========" $'temp-link-safe\nlink1\ntemp-link' "========="
	test-21-expected 
	echo "============================"
	# ???: 'glob-links\n'=$(test-21-actual)
	# ???: 'temp-link-safe\nlink1\ntemp-link'=$(test-21-expected)
	[ "$(test-21-actual)" == "$(test-21-expected)" ]
}

function test-21-actual () {
	# no-op in case content just a comment
	true

	glob-links

}

function test-21-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
temp-link-safe
link1
temp-link
END_EXPECTED
}


@test "test-22" {
	testfolder="/tmp/batspp-132262/test-22"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'pwd\n' "=========="
	test-22-actual 
	echo "=========" $'$ mkdir test-7919-a test-7919-b\n$ glob-subdirs\n/tmp/test-dir-aliases/test-7919\ntest-7919-b\ntest-7919-a' "========="
	test-22-expected 
	echo "============================"
	# ???: 'pwd\n'=$(test-22-actual)
	# ???: '$ mkdir test-7919-a test-7919-b\n$ glob-subdirs\n/tmp/test-dir-aliases/test-7919\ntest-7919-b\ntest-7919-a'=$(test-22-expected)
	[ "$(test-22-actual)" == "$(test-22-expected)" ]
}

function test-22-actual () {
	# no-op in case content just a comment
	true

	pwd

}

function test-22-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
$ mkdir test-7919-a test-7919-b
$ glob-subdirs
/tmp/test-dir-aliases/test-7919
test-7919-b
test-7919-a
END_EXPECTED
=======
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
	actual=$(test1-assert4-actual)
	expected=$(test1-assert4-expected)
	echo "========== actual =========="
	echo "$actual" | hexview.perl
	echo "========= expected ========="
	echo "$expected" | hexview.perl
	echo "============================"
	[ "$actual" == "$expected" ]

}

function test1-assert4-actual () {
	typeset -f | egrep '^\w+' | wc -l
}
function test1-assert4-expected () {
	echo -e '00'
}

@test "test2" {
	test_folder=$(echo /tmp/test2-$$)
	mkdir $test_folder && cd $test_folder

	alias testnum="sed -r "s/[0-9]/N/g"" 
	alias testuser="sed -r "s/"$USER"+/userxf333/g""
}


@test "test3" {
	test_folder=$(echo /tmp/test3-$$)
	mkdir $test_folder && cd $test_folder

	mkdir -p tmp/test-dir-aliases
}


@test "test4" {
	test_folder=$(echo /tmp/test4-$$)
	mkdir $test_folder && cd $test_folder

	alias | wc -l
	actual=$(test4-assert2-actual)
	expected=$(test4-assert2-expected)
	echo "========== actual =========="
	echo "$actual" | hexview.perl
	echo "========= expected ========="
	echo "$expected" | hexview.perl
	echo "============================"
	[ "$actual" == "$expected" ]

}

function test4-assert2-actual () {
	source _dir-aliases.bash
}
function test4-assert2-expected () {
	echo -e '2'
}

@test "test5" {
	test_folder=$(echo /tmp/test5-$$)
	mkdir $test_folder && cd $test_folder

	actual=$(test5-assert1-actual)
	expected=$(test5-assert1-expected)
	echo "========== actual =========="
	echo "$actual" | hexview.perl
	echo "========= expected ========="
	echo "$expected" | hexview.perl
	echo "============================"
	[ "$actual" == "$expected" ]

}

function test5-assert1-actual () {
	alias | wc -l
}
function test5-assert1-expected () {
	echo -e '10'
}

@test "test6" {
	test_folder=$(echo /tmp/test6-$$)
	mkdir $test_folder && cd $test_folder

	actual=$(test6-assert1-actual)
	expected=$(test6-assert1-expected)
	echo "========== actual =========="
	echo "$actual" | hexview.perl
	echo "========= expected ========="
	echo "$expected" | hexview.perl
	echo "============================"
	[ "$actual" == "$expected" ]

}

function test6-assert1-actual () {
	typeset -f | egrep '^\w+' | wc -l
}
function test6-assert1-expected () {
	echo -e '2'
}

@test "test7" {
	test_folder=$(echo /tmp/test7-$$)
	mkdir $test_folder && cd $test_folder

	temp_dir=$TMP/test-7919
	cd "$temp_dir"
}


@test "test8" {
	test_folder=$(echo /tmp/test8-$$)
	mkdir $test_folder && cd $test_folder

	/bin/rm -rvf /tmp/test-dir-aliases/test-7919/* >| /tmp/_cleanup-test-dir-aliases.log 2>&1
}


@test "test9" {
	test_folder=$(echo /tmp/test9-$$)
	mkdir $test_folder && cd $test_folder

	touch file1
}


@test "test10" {
	test_folder=$(echo /tmp/test10-$$)
	mkdir $test_folder && cd $test_folder

	bash $BIN_DIR/tests/_dir-aliases.bash
}


@test "test11" {
	test_folder=$(echo /tmp/test11-$$)
	mkdir $test_folder && cd $test_folder

	actual=$(test11-assert1-actual)
	expected=$(test11-assert1-expected)
	echo "========== actual =========="
	echo "$actual" | hexview.perl
	echo "========= expected ========="
	echo "$expected" | hexview.perl
	echo "============================"
	[ "$actual" == "$expected" ]

}

function test11-assert1-actual () {
	symlinks-proper
}
function test11-assert1-expected () {
	echo -e 'bash: sublinks: command not found'
}

@test "test12" {
	test_folder=$(echo /tmp/test12-$$)
	mkdir $test_folder && cd $test_folder

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
	ls -l | cut --characters=12-46 --complement
}
function test13-assert1-expected () {
	echo -e 'total 0-rw-rw-r-- lrwxrwxrwx -> file1lrwxrwxrwx ink -> /tmp'
}

@test "test14" {
	test_folder=$(echo /tmp/test14-$$)
	mkdir $test_folder && cd $test_folder

	alias ln-symbolic-force='ln-symbolic --force'
}


@test "test15" {
	test_folder=$(echo /tmp/test15-$$)
	mkdir $test_folder && cd $test_folder

}


@test "test16" {
	test_folder=$(echo /tmp/test16-$$)
	mkdir $test_folder && cd $test_folder

}


@test "test17" {
	test_folder=$(echo /tmp/test17-$$)
	mkdir $test_folder && cd $test_folder

}


@test "test18" {
	test_folder=$(echo /tmp/test18-$$)
	mkdir $test_folder && cd $test_folder

	actual=$(test18-assert1-actual)
	expected=$(test18-assert1-expected)
	echo "========== actual =========="
	echo "$actual" | hexview.perl
	echo "========= expected ========="
	echo "$expected" | hexview.perl
	echo "============================"
	[ "$actual" == "$expected" ]

}

function test18-assert1-actual () {
	ls -l | cut --characters=12-46 --complement
}
function test18-assert1-expected () {
	echo -e 'total 0-rw-rw-r-- lrwxrwxrwx -> file1lrwxrwxrwx ink -> /tmplrwxrwxrwx ink-safe -> /tmp/tmp'
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
	glob-links
}
function test19-assert1-expected () {
	echo -e 'temp-link-safelink1temp-link'
}

@test "test20" {
	test_folder=$(echo /tmp/test20-$$)
	mkdir $test_folder && cd $test_folder

	pwd
	mkdir test-7919-a test-7919-b
>>>>>>> integration-testing-3fa2c13
}