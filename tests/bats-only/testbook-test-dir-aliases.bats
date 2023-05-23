#!/usr/bin/env bats


# Make executables ./tests/../ visible to PATH
PATH="/home/aveey/tom-project/shell-scripts/tests/batspp-only/../:$PATH"

<<<<<<< HEAD
# Enable aliases
shopt -s expand_aliases



@test "test-1" {
	testfolder="/tmp/batspp-133057/test-1"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $"bind 'set enable-bracketed-paste off'\n" "=========="
	test-1-actual 
	echo "=========" $'' "========="
	test-1-expected 
	echo "============================"
	# ???: "bind 'set enable-bracketed-paste off'\n"=$(test-1-actual)
	# ???: ''=$(test-1-expected)
	[ "$(test-1-actual)" == "$(test-1-expected)" ]
}

function test-1-actual () {
	# no-op in case content just a comment
	true

	bind 'set enable-bracketed-paste off'

}

function test-1-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED

END_EXPECTED
}


@test "test-3" {
	testfolder="/tmp/batspp-133057/test-3"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'unalias -a\n' "=========="
	test-3-actual 
	echo "=========" $"$ for f in $(typeset -f | egrep '^\\w+'); do unset -f $f; done" "========="
	test-3-expected 
	echo "============================"
	# ???: 'unalias -a\n'=$(test-3-actual)
	# ???: "$ for f in $(typeset -f | egrep '^\\w+'); do unset -f $f; done"=$(test-3-expected)
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
$ for f in $(typeset -f | egrep '^\w+'); do unset -f $f; done
END_EXPECTED
}


@test "test-4" {
	testfolder="/tmp/batspp-133057/test-4"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'TEST_BIN=/home/$USER/tom-project/shell-scripts/tests\n' "=========="
	test-4-actual 
	echo "=========" $'$ TMP=/tmp/test-dir-aliases\n$ source $TEST_BIN/_dir-aliases.bash\n$ alias | wc -l\n8' "========="
	test-4-expected 
	echo "============================"
	# ???: 'TEST_BIN=/home/$USER/tom-project/shell-scripts/tests\n'=$(test-4-actual)
	# ???: '$ TMP=/tmp/test-dir-aliases\n$ source $TEST_BIN/_dir-aliases.bash\n$ alias | wc -l\n8'=$(test-4-expected)
	[ "$(test-4-actual)" == "$(test-4-expected)" ]
}

function test-4-actual () {
	# no-op in case content just a comment
	true

	TEST_BIN=/home/$USER/tom-project/shell-scripts/tests

}

function test-4-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
$ TMP=/tmp/test-dir-aliases
$ source $TEST_BIN/_dir-aliases.bash
$ alias | wc -l
8
END_EXPECTED
}


@test "test-5" {
	testfolder="/tmp/batspp-133057/test-5"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'alias | wc -l\n' "=========="
	test-5-actual 
	echo "=========" $'8' "========="
	test-5-expected 
	echo "============================"
	# ???: 'alias | wc -l\n'=$(test-5-actual)
	# ???: '8'=$(test-5-expected)
	[ "$(test-5-actual)" == "$(test-5-expected)" ]
}

function test-5-actual () {
	# no-op in case content just a comment
	true

	alias | wc -l

}

function test-5-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
8
END_EXPECTED
}


@test "test-6" {
	testfolder="/tmp/batspp-133057/test-6"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $"typeset -f | egrep '^\\w+' | wc -l\n" "=========="
	test-6-actual 
	echo "=========" $'2' "========="
	test-6-expected 
	echo "============================"
	# ???: "typeset -f | egrep '^\\w+' | wc -l\n"=$(test-6-actual)
	# ???: '2'=$(test-6-expected)
	[ "$(test-6-actual)" == "$(test-6-expected)" ]
}

function test-6-actual () {
	# no-op in case content just a comment
	true

	typeset -f | egrep '^\w+' | wc -l

}

function test-6-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
2
END_EXPECTED
}


@test "test-7-safe-symbolic-links" {
	testfolder="/tmp/batspp-133057/test-7-safe-symbolic-links"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'temp_dir=$TMP/test-$$\n' "=========="
	test-7-safe-symbolic-links-actual 
	echo "=========" $'$ mkdir -p "$temp_dir"\n# TODO: /bin/rm -rvf "$temp_dir"\n$ cd "$temp_dir"\n$ pwd\n/tmp/test-dir-aliases/test-4781' "========="
	test-7-safe-symbolic-links-expected 
	echo "============================"
	# ???: 'temp_dir=$TMP/test-$$\n'=$(test-7-safe-symbolic-links-actual)
	# ???: '$ mkdir -p "$temp_dir"\n# TODO: /bin/rm -rvf "$temp_dir"\n$ cd "$temp_dir"\n$ pwd\n/tmp/test-dir-aliases/test-4781'=$(test-7-safe-symbolic-links-expected)
	[ "$(test-7-safe-symbolic-links-actual)" == "$(test-7-safe-symbolic-links-expected)" ]
}

function test-7-safe-symbolic-links-actual () {
	# no-op in case content just a comment
	true

	temp_dir=$TMP/test-$$

}

function test-7-safe-symbolic-links-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
$ mkdir -p "$temp_dir"
# TODO: /bin/rm -rvf "$temp_dir"
$ cd "$temp_dir"
$ pwd
/tmp/test-dir-aliases/test-4781
END_EXPECTED
}


@test "test-8" {
	testfolder="/tmp/batspp-133057/test-8"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'alias testnum="sed -r "s/[0-9]/N/g"" \n' "=========="
	test-8-actual 
	echo "=========" $'$ alias testuser="sed -r "s/"$USER"+/userxf333/g""' "========="
	test-8-expected 
	echo "============================"
	# ???: 'alias testnum="sed -r "s/[0-9]/N/g"" \n'=$(test-8-actual)
	# ???: '$ alias testuser="sed -r "s/"$USER"+/userxf333/g""'=$(test-8-expected)
	[ "$(test-8-actual)" == "$(test-8-expected)" ]
}

function test-8-actual () {
	# no-op in case content just a comment
	true

	alias testnum="sed -r "s/[0-9]/N/g"" 

}

function test-8-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
$ alias testuser="sed -r "s/"$USER"+/userxf333/g""
END_EXPECTED
}


@test "test-9" {
	testfolder="/tmp/batspp-133057/test-9"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'echo $USER | testuser\n' "=========="
	test-9-actual 
	echo "=========" $'userxf333' "========="
	test-9-expected 
	echo "============================"
	# ???: 'echo $USER | testuser\n'=$(test-9-actual)
	# ???: 'userxf333'=$(test-9-expected)
	[ "$(test-9-actual)" == "$(test-9-expected)" ]
}

function test-9-actual () {
	# no-op in case content just a comment
	true

	echo $USER | testuser

}

function test-9-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
userxf333
END_EXPECTED
}


@test "test-10" {
	testfolder="/tmp/batspp-133057/test-10"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'touch file1\n' "=========="
	test-10-actual 
	echo "=========" $'$ ln-symbolic file1 link1\n# \'link1\' -> \'file1\'\n# The second case should should fail\n$ ln-symbolic file1 link1\n# => "ln: failed to create symbolic link \'link1\': File exists?"\n# Should only be four files total (along with . and ..)\n$ ls -R | wc -l\n# => 3\n\'link1\' -> \'file1\'\nln: failed to create symbolic link \'link1\': File exists\n3' "========="
	test-10-expected 
	echo "============================"
	# ???: 'touch file1\n'=$(test-10-actual)
	# ???: '$ ln-symbolic file1 link1\n# \'link1\' -> \'file1\'\n# The second case should should fail\n$ ln-symbolic file1 link1\n# => "ln: failed to create symbolic link \'link1\': File exists?"\n# Should only be four files total (along with . and ..)\n$ ls -R | wc -l\n# => 3\n\'link1\' -> \'file1\'\nln: failed to create symbolic link \'link1\': File exists\n3'=$(test-10-expected)
	[ "$(test-10-actual)" == "$(test-10-expected)" ]
}

function test-10-actual () {
	# no-op in case content just a comment
	true

	touch file1

}

function test-10-expected () {
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


@test "test-11" {
	testfolder="/tmp/batspp-133057/test-11"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'# $ cat $TEST_BIN/_dir-aliases.bash\n' "=========="
	test-11-actual 
	echo "=========" $'' "========="
	test-11-expected 
	echo "============================"
	# ???: '# $ cat $TEST_BIN/_dir-aliases.bash\n'=$(test-11-actual)
	# ???: ''=$(test-11-expected)
	[ "$(test-11-actual)" == "$(test-11-expected)" ]
}

function test-11-actual () {
	# no-op in case content just a comment
	true


}

function test-11-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED

END_EXPECTED
}


@test "test-12" {
	testfolder="/tmp/batspp-133057/test-12"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'ls\n' "=========="
	test-12-actual 
	echo "=========" $'file1  link1' "========="
	test-12-expected 
	echo "============================"
	# ???: 'ls\n'=$(test-12-actual)
	# ???: 'file1  link1'=$(test-12-expected)
	[ "$(test-12-actual)" == "$(test-12-expected)" ]
}

function test-12-actual () {
	# no-op in case content just a comment
	true

	ls

}

function test-12-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
file1  link1
END_EXPECTED
}


@test "test-13" {
	testfolder="/tmp/batspp-133057/test-13"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'ls -l | testnum | testuser | awk \'!($6="")\'\n' "=========="
	test-13-actual 
	echo "=========" $'total N    \n-rw-rw-r-- N userxf333 userxf333 N  N NN:NN fileN\nlrwxrwxrwx N userxf333 userxf333 N  N NN:NN linkN -> fileN' "========="
	test-13-expected 
	echo "============================"
	# ???: 'ls -l | testnum | testuser | awk \'!($6="")\'\n'=$(test-13-actual)
	# ???: 'total N    \n-rw-rw-r-- N userxf333 userxf333 N  N NN:NN fileN\nlrwxrwxrwx N userxf333 userxf333 N  N NN:NN linkN -> fileN'=$(test-13-expected)
	[ "$(test-13-actual)" == "$(test-13-expected)" ]
}

function test-13-actual () {
	# no-op in case content just a comment
	true

	ls -l | testnum | testuser | awk '!($6="")'

}

function test-13-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
total N    
-rw-rw-r-- N userxf333 userxf333 N  N NN:NN fileN
lrwxrwxrwx N userxf333 userxf333 N  N NN:NN linkN -> fileN
END_EXPECTED
}


@test "test-14" {
	testfolder="/tmp/batspp-133057/test-14"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'bash $TEST_BIN/_dir-aliases.bash\n' "=========="
	test-14-actual 
	echo "=========" $'' "========="
	test-14-expected 
	echo "============================"
	# ???: 'bash $TEST_BIN/_dir-aliases.bash\n'=$(test-14-actual)
	# ???: ''=$(test-14-expected)
	[ "$(test-14-actual)" == "$(test-14-expected)" ]
}

function test-14-actual () {
	# no-op in case content just a comment
	true

	bash $TEST_BIN/_dir-aliases.bash

}

function test-14-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED

END_EXPECTED
}


@test "test-15" {
	testfolder="/tmp/batspp-133057/test-15"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'ln-symbolic /tmp temp-link\n' "=========="
	test-15-actual 
	echo "=========" $"temp-link' -> '/tmp" "========="
	test-15-expected 
	echo "============================"
	# ???: 'ln-symbolic /tmp temp-link\n'=$(test-15-actual)
	# ???: "temp-link' -> '/tmp"=$(test-15-expected)
	[ "$(test-15-actual)" == "$(test-15-expected)" ]
}

function test-15-actual () {
	# no-op in case content just a comment
	true

	ln-symbolic /tmp temp-link

}

function test-15-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
temp-link' -> '/tmp
END_EXPECTED
}


@test "test-16" {
	testfolder="/tmp/batspp-133057/test-16"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'ls -l | testnum | testuser | awk \'!($6="")\'\n' "=========="
	test-16-actual 
	echo "=========" $'total N    \n-rw-rw-r-- N userxf333 userxf333 N  N NN:NN fileN\nlrwxrwxrwx N userxf333 userxf333 N  N NN:NN linkN -> fileN\nlrwxrwxrwx N userxf333 userxf333 N  N NN:NN temp-link -> /tmp' "========="
	test-16-expected 
	echo "============================"
	# ???: 'ls -l | testnum | testuser | awk \'!($6="")\'\n'=$(test-16-actual)
	# ???: 'total N    \n-rw-rw-r-- N userxf333 userxf333 N  N NN:NN fileN\nlrwxrwxrwx N userxf333 userxf333 N  N NN:NN linkN -> fileN\nlrwxrwxrwx N userxf333 userxf333 N  N NN:NN temp-link -> /tmp'=$(test-16-expected)
	[ "$(test-16-actual)" == "$(test-16-expected)" ]
}

function test-16-actual () {
	# no-op in case content just a comment
	true

	ls -l | testnum | testuser | awk '!($6="")'

}

function test-16-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
total N    
-rw-rw-r-- N userxf333 userxf333 N  N NN:NN fileN
lrwxrwxrwx N userxf333 userxf333 N  N NN:NN linkN -> fileN
lrwxrwxrwx N userxf333 userxf333 N  N NN:NN temp-link -> /tmp
END_EXPECTED
}


@test "test-17" {
	testfolder="/tmp/batspp-133057/test-17"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'link-symbolic-safe --force ~/temp temp-link | testuser\n' "=========="
	test-17-actual 
	echo "=========" $"temp-link' -> '/home/userxf333/temp" "========="
	test-17-expected 
	echo "============================"
	# ???: 'link-symbolic-safe --force ~/temp temp-link | testuser\n'=$(test-17-actual)
	# ???: "temp-link' -> '/home/userxf333/temp"=$(test-17-expected)
	[ "$(test-17-actual)" == "$(test-17-expected)" ]
}

function test-17-actual () {
	# no-op in case content just a comment
	true

	link-symbolic-safe --force ~/temp temp-link | testuser

}

function test-17-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
temp-link' -> '/home/userxf333/temp
END_EXPECTED
}


@test "test-18" {
	testfolder="/tmp/batspp-133057/test-18"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'ls -l | testnum | testuser | awk \'!($6="")\'\n' "=========="
	test-18-actual 
	echo "=========" $'total N    \n-rw-rw-r-- N userxf333 userxf333 N  N NN:NN fileN\nlrwxrwxrwx N userxf333 userxf333 N  N NN:NN linkN -> fileN\nlrwxrwxrwx N userxf333 userxf333 NN  N NN:NN temp-link -> /home/userxf333/temp' "========="
	test-18-expected 
	echo "============================"
	# ???: 'ls -l | testnum | testuser | awk \'!($6="")\'\n'=$(test-18-actual)
	# ???: 'total N    \n-rw-rw-r-- N userxf333 userxf333 N  N NN:NN fileN\nlrwxrwxrwx N userxf333 userxf333 N  N NN:NN linkN -> fileN\nlrwxrwxrwx N userxf333 userxf333 NN  N NN:NN temp-link -> /home/userxf333/temp'=$(test-18-expected)
	[ "$(test-18-actual)" == "$(test-18-expected)" ]
}

function test-18-actual () {
	# no-op in case content just a comment
	true

	ls -l | testnum | testuser | awk '!($6="")'

}

function test-18-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
total N    
-rw-rw-r-- N userxf333 userxf333 N  N NN:NN fileN
lrwxrwxrwx N userxf333 userxf333 N  N NN:NN linkN -> fileN
lrwxrwxrwx N userxf333 userxf333 NN  N NN:NN temp-link -> /home/userxf333/temp
END_EXPECTED
}


@test "test-19" {
	testfolder="/tmp/batspp-133057/test-19"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $"alias ln-symbolic-force='ln-symbolic --force'\n" "=========="
	test-19-actual 
	echo "=========" $'' "========="
	test-19-expected 
	echo "============================"
	# ???: "alias ln-symbolic-force='ln-symbolic --force'\n"=$(test-19-actual)
	# ???: ''=$(test-19-expected)
	[ "$(test-19-actual)" == "$(test-19-expected)" ]
}

function test-19-actual () {
	# no-op in case content just a comment
	true

	alias ln-symbolic-force='ln-symbolic --force'

}

function test-19-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED

END_EXPECTED
}


@test "test-20" {
	testfolder="/tmp/batspp-133057/test-20"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'# $ ln-symbolic /tmp temp-link\n' "=========="
	test-20-actual 
	echo "=========" $"# | ln: failed to create symbolic link 'temp-link/tmp': File exists" "========="
	test-20-expected 
	echo "============================"
	# ???: '# $ ln-symbolic /tmp temp-link\n'=$(test-20-actual)
	# ???: "# | ln: failed to create symbolic link 'temp-link/tmp': File exists"=$(test-20-expected)
	[ "$(test-20-actual)" == "$(test-20-expected)" ]
}

function test-20-actual () {
	# no-op in case content just a comment
	true


}

function test-20-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
# | ln: failed to create symbolic link 'temp-link/tmp': File exists
END_EXPECTED
}


@test "test-21" {
	testfolder="/tmp/batspp-133057/test-21"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'# $ ln-symbolic-force /tmp temp-link\n' "=========="
	test-21-actual 
	echo "=========" $'# | ln: temp-link/tmp: cannot overwrite directory' "========="
	test-21-expected 
	echo "============================"
	# ???: '# $ ln-symbolic-force /tmp temp-link\n'=$(test-21-actual)
	# ???: '# | ln: temp-link/tmp: cannot overwrite directory'=$(test-21-expected)
	[ "$(test-21-actual)" == "$(test-21-expected)" ]
}

function test-21-actual () {
	# no-op in case content just a comment
	true


}

function test-21-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
# | ln: temp-link/tmp: cannot overwrite directory
END_EXPECTED
}


@test "test-22" {
	testfolder="/tmp/batspp-133057/test-22"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'ln-symbolic-force /tmp1 temp-link\n' "=========="
	test-22-actual 
	echo "=========" $"temp-link/tmp1' -> '/tmp1" "========="
	test-22-expected 
	echo "============================"
	# ???: 'ln-symbolic-force /tmp1 temp-link\n'=$(test-22-actual)
	# ???: "temp-link/tmp1' -> '/tmp1"=$(test-22-expected)
	[ "$(test-22-actual)" == "$(test-22-expected)" ]
}

function test-22-actual () {
	# no-op in case content just a comment
	true

	ln-symbolic-force /tmp1 temp-link

}

function test-22-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
temp-link/tmp1' -> '/tmp1
END_EXPECTED
}


@test "test-23" {
	testfolder="/tmp/batspp-133057/test-23"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'link-symbolic-safe --force ~/temp temp-link | testuser | testnum\n' "=========="
	test-23-actual 
	echo "=========" $"temp-link' -> '/home/userxfNNN/temp" "========="
	test-23-expected 
	echo "============================"
	# ???: 'link-symbolic-safe --force ~/temp temp-link | testuser | testnum\n'=$(test-23-actual)
	# ???: "temp-link' -> '/home/userxfNNN/temp"=$(test-23-expected)
	[ "$(test-23-actual)" == "$(test-23-expected)" ]
}

function test-23-actual () {
	# no-op in case content just a comment
	true

	link-symbolic-safe --force ~/temp temp-link | testuser | testnum

}

function test-23-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
temp-link' -> '/home/userxfNNN/temp
END_EXPECTED
}


@test "test-24" {
	testfolder="/tmp/batspp-133057/test-24"
	mkdir --parents "$testfolder"
	cd "$testfolder" || echo Warning: Unable to "cd $testfolder"

	echo "==========" $'ls -l | testnum | testuser | awk \'!($6="")\'\n' "=========="
	test-24-actual 
	echo "=========" $'total N    \n-rw-rw-r-- N userxf333 userxf333 N  N NN:NN fileN\nlrwxrwxrwx N userxf333 userxf333 N  N NN:NN linkN -> fileN\nlrwxrwxrwx N userxf333 userxf333 NN  N NN:NN temp-link -> /home/userxf333/temp' "========="
	test-24-expected 
	echo "============================"
	# ???: 'ls -l | testnum | testuser | awk \'!($6="")\'\n'=$(test-24-actual)
	# ???: 'total N    \n-rw-rw-r-- N userxf333 userxf333 N  N NN:NN fileN\nlrwxrwxrwx N userxf333 userxf333 N  N NN:NN linkN -> fileN\nlrwxrwxrwx N userxf333 userxf333 NN  N NN:NN temp-link -> /home/userxf333/temp'=$(test-24-expected)
	[ "$(test-24-actual)" == "$(test-24-expected)" ]
}

function test-24-actual () {
	# no-op in case content just a comment
	true

	ls -l | testnum | testuser | awk '!($6="")'

}

function test-24-expected () {
	# no-op in case content just a comment
	true

	cat <<END_EXPECTED
total N    
-rw-rw-r-- N userxf333 userxf333 N  N NN:NN fileN
lrwxrwxrwx N userxf333 userxf333 N  N NN:NN linkN -> fileN
lrwxrwxrwx N userxf333 userxf333 NN  N NN:NN temp-link -> /home/userxf333/temp
END_EXPECTED
=======
# Source files
shopt -s expand_aliases


@test "test0" {
	test_folder=$(echo /tmp/test0-$$)
	mkdir $test_folder && cd $test_folder

	bind 'set enable-bracketed-paste off'
}


@test "test1" {
	test_folder=$(echo /tmp/test1-$$)
	mkdir $test_folder && cd $test_folder

	unalias -a
	for f in $(typeset -f | egrep '^\w+'); do unset -f $f; done
}


@test "test2" {
	test_folder=$(echo /tmp/test2-$$)
	mkdir $test_folder && cd $test_folder

	TEST_BIN=/home/$USER/tom-project/shell-scripts/tests
	TMP=/tmp/test-dir-aliases
	source $TEST_BIN/_dir-aliases.bash
	actual=$(test2-assert4-actual)
	expected=$(test2-assert4-expected)
	echo "========== actual =========="
	echo "$actual" | hexview.perl
	echo "========= expected ========="
	echo "$expected" | hexview.perl
	echo "============================"
	[ "$actual" == "$expected" ]

}

function test2-assert4-actual () {
	alias | wc -l
}
function test2-assert4-expected () {
	echo -e '8'
}

@test "test3" {
	test_folder=$(echo /tmp/test3-$$)
	mkdir $test_folder && cd $test_folder

	actual=$(test3-assert1-actual)
	expected=$(test3-assert1-expected)
	echo "========== actual =========="
	echo "$actual" | hexview.perl
	echo "========= expected ========="
	echo "$expected" | hexview.perl
	echo "============================"
	[ "$actual" == "$expected" ]

}

function test3-assert1-actual () {
	alias | wc -l
}
function test3-assert1-expected () {
	echo -e '8'
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
	echo -e '2'
}

@test "test5" {
	test_folder=$(echo /tmp/test5-$$)
	mkdir $test_folder && cd $test_folder

	temp_dir=$TMP/test-$$
	cd "$temp_dir"
}


@test "test6" {
	test_folder=$(echo /tmp/test6-$$)
	mkdir $test_folder && cd $test_folder

	alias testnum="sed -r "s/[0-9]/N/g"" 
	alias testuser="sed -r "s/"$USER"+/userxf333/g""
}


@test "test7" {
	test_folder=$(echo /tmp/test7-$$)
	mkdir $test_folder && cd $test_folder

	actual=$(test7-assert1-actual)
	expected=$(test7-assert1-expected)
	echo "========== actual =========="
	echo "$actual" | hexview.perl
	echo "========= expected ========="
	echo "$expected" | hexview.perl
	echo "============================"
	[ "$actual" == "$expected" ]

}

function test7-assert1-actual () {
	echo $USER | testuser
}
function test7-assert1-expected () {
	echo -e 'userxf333'
}

@test "test8" {
	test_folder=$(echo /tmp/test8-$$)
	mkdir $test_folder && cd $test_folder

	touch file1
}


@test "test9" {
	test_folder=$(echo /tmp/test9-$$)
	mkdir $test_folder && cd $test_folder

	actual=$(test9-assert1-actual)
	expected=$(test9-assert1-expected)
	echo "========== actual =========="
	echo "$actual" | hexview.perl
	echo "========= expected ========="
	echo "$expected" | hexview.perl
	echo "============================"
	[ "$actual" == "$expected" ]

}

function test9-assert1-actual () {
	ls
}
function test9-assert1-expected () {
	echo -e 'file1  link1'
}

@test "test10" {
	test_folder=$(echo /tmp/test10-$$)
	mkdir $test_folder && cd $test_folder

	actual=$(test10-assert1-actual)
	expected=$(test10-assert1-expected)
	echo "========== actual =========="
	echo "$actual" | hexview.perl
	echo "========= expected ========="
	echo "$expected" | hexview.perl
	echo "============================"
	[ "$actual" == "$expected" ]

}

function test10-assert1-actual () {
	ls -l | testnum | testuser | awk '!($6="")'
}
function test10-assert1-expected () {
	echo -e 'total N    -rw-rw-r-- N userxf333 userxf333 N  N NN:NN fileNlrwxrwxrwx N userxf333 userxf333 N  N NN:NN linkN -> fileN'
}

@test "test11" {
	test_folder=$(echo /tmp/test11-$$)
	mkdir $test_folder && cd $test_folder

	bash $TEST_BIN/_dir-aliases.bash
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
	ls -l | testnum | testuser | awk '!($6="")'
}
function test13-assert1-expected () {
	echo -e 'total N    -rw-rw-r-- N userxf333 userxf333 N  N NN:NN fileNlrwxrwxrwx N userxf333 userxf333 N  N NN:NN linkN -> fileNlrwxrwxrwx N userxf333 userxf333 N  N NN:NN temp-link -> /tmp'
}

@test "test14" {
	test_folder=$(echo /tmp/test14-$$)
	mkdir $test_folder && cd $test_folder

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
	ls -l | testnum | testuser | awk '!($6="")'
}
function test15-assert1-expected () {
	echo -e 'total N    -rw-rw-r-- N userxf333 userxf333 N  N NN:NN fileNlrwxrwxrwx N userxf333 userxf333 N  N NN:NN linkN -> fileNlrwxrwxrwx N userxf333 userxf333 NN  N NN:NN temp-link -> /home/userxf333/temp'
}

@test "test16" {
	test_folder=$(echo /tmp/test16-$$)
	mkdir $test_folder && cd $test_folder

	alias ln-symbolic-force='ln-symbolic --force'
}


@test "test17" {
	test_folder=$(echo /tmp/test17-$$)
	mkdir $test_folder && cd $test_folder

}


@test "test18" {
	test_folder=$(echo /tmp/test18-$$)
	mkdir $test_folder && cd $test_folder

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
	ls -l | testnum | testuser | awk '!($6="")'
}
function test19-assert1-expected () {
	echo -e 'total N    -rw-rw-r-- N userxf333 userxf333 N  N NN:NN fileNlrwxrwxrwx N userxf333 userxf333 N  N NN:NN linkN -> fileNlrwxrwxrwx N userxf333 userxf333 NN  N NN:NN temp-link -> /home/userxf333/temp'
>>>>>>> integration-testing-3fa2c13
}