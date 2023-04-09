var data = {lines:[
{"lineNum":"    1","line":"#!/usr/bin/env bats"},
{"lineNum":"    2","line":""},
{"lineNum":"    3","line":""},
{"lineNum":"    4","line":"# Make executables ./tests/../ visible to PATH"},
{"lineNum":"    5","line":"PATH=\"/home/aveey/tom-project/shell-scripts/tests/batspp-only/../:$PATH\"","class":"lineCov","hits":"17","order":"333","possible_hits":"0",},
{"lineNum":"    6","line":""},
{"lineNum":"    7","line":"# Source files"},
{"lineNum":"    8","line":"shopt -s expand_aliases","class":"lineCov","hits":"17","order":"349","possible_hits":"0",},
{"lineNum":"    9","line":""},
{"lineNum":"   10","line":""},
{"lineNum":"   11","line":"test_test0() { bats_test_begin \"test0\";"},
{"lineNum":"   12","line":"\ttest_folder=$(echo /tmp/test0-$$)","class":"lineCov","hits":"4","order":"440","possible_hits":"0",},
{"lineNum":"   13","line":"\tmkdir $test_folder && cd $test_folder","class":"lineCov","hits":"4","order":"441","possible_hits":"0",},
{"lineNum":"   14","line":""},
{"lineNum":"   15","line":"}"},
{"lineNum":"   16","line":""},
{"lineNum":"   17","line":""},
{"lineNum":"   18","line":"test_test1() { bats_test_begin \"test1\";"},
{"lineNum":"   19","line":"\ttest_folder=$(echo /tmp/test1-$$)","class":"lineCov","hits":"4","order":"480","possible_hits":"0",},
{"lineNum":"   20","line":"\tmkdir $test_folder && cd $test_folder","class":"lineCov","hits":"4","order":"481","possible_hits":"0",},
{"lineNum":"   21","line":""},
{"lineNum":"   22","line":"\tunalias -a","class":"lineCov","hits":"2","order":"482","possible_hits":"0",},
{"lineNum":"   23","line":"\talias | wc -l","class":"lineCov","hits":"4","order":"483","possible_hits":"0",},
{"lineNum":"   24","line":"\tfor f in $(typeset -f | egrep \'^\\w+\'); do unset -f $f; done","class":"lineCov","hits":"66","order":"484","possible_hits":"0",},
{"lineNum":"   25","line":"\tactual=$(test1-assert4-actual)","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"   26","line":"\texpected=$(test1-assert4-expected)","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"   27","line":"\techo \"========== actual ==========\"","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"   28","line":"\techo \"$actual\" | hexview.perl","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"   29","line":"\techo \"========= expected =========\"","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"   30","line":"\techo \"$expected\" | hexview.perl","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"   31","line":"\techo \"============================\"","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"   32","line":"\t[ \"$actual\" == \"$expected\" ]","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"   33","line":""},
{"lineNum":"   34","line":"}"},
{"lineNum":"   35","line":""},
{"lineNum":"   36","line":"function test1-assert4-actual () {"},
{"lineNum":"   37","line":"\ttypeset -f | egrep \'^\\w+\' | wc -l","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"   38","line":"}"},
{"lineNum":"   39","line":"function test1-assert4-expected () {"},
{"lineNum":"   40","line":"\techo -e \'00\'","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"   41","line":"}"},
{"lineNum":"   42","line":""},
{"lineNum":"   43","line":"test_test2() { bats_test_begin \"test2\";"},
{"lineNum":"   44","line":"\ttest_folder=$(echo /tmp/test2-$$)","class":"lineCov","hits":"4","order":"576","possible_hits":"0",},
{"lineNum":"   45","line":"\tmkdir $test_folder && cd $test_folder","class":"lineCov","hits":"4","order":"577","possible_hits":"0",},
{"lineNum":"   46","line":""},
{"lineNum":"   47","line":"\tBIN_DIR=$PWD/..","class":"lineCov","hits":"2","order":"578","possible_hits":"0",},
{"lineNum":"   48","line":"\tactual=$(test2-assert2-actual)","class":"lineCov","hits":"4","order":"579","possible_hits":"0",},
{"lineNum":"   49","line":"\texpected=$(test2-assert2-expected)","class":"lineCov","hits":"4","order":"581","possible_hits":"0",},
{"lineNum":"   50","line":"\techo \"========== actual ==========\"","class":"lineCov","hits":"2","order":"583","possible_hits":"0",},
{"lineNum":"   51","line":"\techo \"$actual\" | hexview.perl","class":"lineCov","hits":"4","order":"584","possible_hits":"0",},
{"lineNum":"   52","line":"\techo \"========= expected =========\"","class":"lineCov","hits":"2","order":"585","possible_hits":"0",},
{"lineNum":"   53","line":"\techo \"$expected\" | hexview.perl","class":"lineCov","hits":"4","order":"586","possible_hits":"0",},
{"lineNum":"   54","line":"\techo \"============================\"","class":"lineCov","hits":"2","order":"587","possible_hits":"0",},
{"lineNum":"   55","line":"\t[ \"$actual\" == \"$expected\" ]","class":"lineCov","hits":"2","order":"588","possible_hits":"0",},
{"lineNum":"   56","line":""},
{"lineNum":"   57","line":"}"},
{"lineNum":"   58","line":""},
{"lineNum":"   59","line":"function test2-assert2-actual () {"},
{"lineNum":"   60","line":"\talias | wc -l","class":"lineCov","hits":"4","order":"580","possible_hits":"0",},
{"lineNum":"   61","line":"}"},
{"lineNum":"   62","line":"function test2-assert2-expected () {"},
{"lineNum":"   63","line":"\techo -e \'0\'","class":"lineCov","hits":"2","order":"582","possible_hits":"0",},
{"lineNum":"   64","line":"}"},
{"lineNum":"   65","line":""},
{"lineNum":"   66","line":"test_test3() { bats_test_begin \"test3\";"},
{"lineNum":"   67","line":"\ttest_folder=$(echo /tmp/test3-$$)","class":"lineCov","hits":"4","order":"589","possible_hits":"0",},
{"lineNum":"   68","line":"\tmkdir $test_folder && cd $test_folder","class":"lineCov","hits":"4","order":"590","possible_hits":"0",},
{"lineNum":"   69","line":""},
{"lineNum":"   70","line":"\ttemp_dir=$TMP/test-6439","class":"lineCov","hits":"2","order":"591","possible_hits":"0",},
{"lineNum":"   71","line":"\tcd \"$temp_dir\"","class":"lineCov","hits":"4","order":"592","possible_hits":"0",},
{"lineNum":"   72","line":"}"},
{"lineNum":"   73","line":""},
{"lineNum":"   74","line":""},
{"lineNum":"   75","line":"test_test4() { bats_test_begin \"test4\";"},
{"lineNum":"   76","line":"\ttest_folder=$(echo /tmp/test4-$$)","class":"lineCov","hits":"4","order":"594","possible_hits":"0",},
{"lineNum":"   77","line":"\tmkdir $test_folder && cd $test_folder","class":"lineCov","hits":"4","order":"595","possible_hits":"0",},
{"lineNum":"   78","line":""},
{"lineNum":"   79","line":"\tactual=$(test4-assert1-actual)","class":"lineCov","hits":"4","order":"596","possible_hits":"0",},
{"lineNum":"   80","line":"\texpected=$(test4-assert1-expected)","class":"lineCov","hits":"4","order":"598","possible_hits":"0",},
{"lineNum":"   81","line":"\techo \"========== actual ==========\"","class":"lineCov","hits":"2","order":"600","possible_hits":"0",},
{"lineNum":"   82","line":"\techo \"$actual\" | hexview.perl","class":"lineCov","hits":"4","order":"601","possible_hits":"0",},
{"lineNum":"   83","line":"\techo \"========= expected =========\"","class":"lineCov","hits":"2","order":"602","possible_hits":"0",},
{"lineNum":"   84","line":"\techo \"$expected\" | hexview.perl","class":"lineCov","hits":"4","order":"603","possible_hits":"0",},
{"lineNum":"   85","line":"\techo \"============================\"","class":"lineCov","hits":"2","order":"604","possible_hits":"0",},
{"lineNum":"   86","line":"\t[ \"$actual\" == \"$expected\" ]","class":"lineCov","hits":"4","order":"605","possible_hits":"0",},
{"lineNum":"   87","line":""},
{"lineNum":"   88","line":"}"},
{"lineNum":"   89","line":""},
{"lineNum":"   90","line":"function test4-assert1-actual () {"},
{"lineNum":"   91","line":"\ttypeset -f | egrep \'^\\w+\' | wc -l","class":"lineCov","hits":"6","order":"597","possible_hits":"0",},
{"lineNum":"   92","line":"}"},
{"lineNum":"   93","line":"function test4-assert1-expected () {"},
{"lineNum":"   94","line":"\techo -e \'10\'","class":"lineCov","hits":"2","order":"599","possible_hits":"0",},
{"lineNum":"   95","line":"}"},
{"lineNum":"   96","line":""},
{"lineNum":"   97","line":"test_test5() { bats_test_begin \"test5\";"},
{"lineNum":"   98","line":"\ttest_folder=$(echo /tmp/test5-$$)","class":"lineCov","hits":"4","order":"606","possible_hits":"0",},
{"lineNum":"   99","line":"\tmkdir $test_folder && cd $test_folder","class":"lineCov","hits":"4","order":"607","possible_hits":"0",},
{"lineNum":"  100","line":""},
{"lineNum":"  101","line":"\talias testnum=\"sed -r \"s/[0-9]/N/g\"\"","class":"lineCov","hits":"2","order":"608","possible_hits":"0",},
{"lineNum":"  102","line":"\talias testuser=\"sed -r \"s/\"$USER\"+/userxf333/g\"\"","class":"lineCov","hits":"2","order":"609","possible_hits":"0",},
{"lineNum":"  103","line":"}"},
{"lineNum":"  104","line":""},
{"lineNum":"  105","line":""},
{"lineNum":"  106","line":"test_test6() { bats_test_begin \"test6\";"},
{"lineNum":"  107","line":"\ttest_folder=$(echo /tmp/test6-$$)","class":"lineCov","hits":"4","order":"610","possible_hits":"0",},
{"lineNum":"  108","line":"\tmkdir $test_folder && cd $test_folder","class":"lineCov","hits":"4","order":"611","possible_hits":"0",},
{"lineNum":"  109","line":""},
{"lineNum":"  110","line":"\tsource $BIN_DIR/tomohara-aliases.bash","class":"lineCov","hits":"2","order":"612","possible_hits":"0",},
{"lineNum":"  111","line":"}"},
{"lineNum":"  112","line":""},
{"lineNum":"  113","line":""},
{"lineNum":"  114","line":"test_test7() { bats_test_begin \"test7\";"},
{"lineNum":"  115","line":"\ttest_folder=$(echo /tmp/test7-$$)","class":"lineCov","hits":"4","order":"614","possible_hits":"0",},
{"lineNum":"  116","line":"\tmkdir $test_folder && cd $test_folder","class":"lineCov","hits":"4","order":"615","possible_hits":"0",},
{"lineNum":"  117","line":""},
{"lineNum":"  118","line":"\trm -rf ./*","class":"lineCov","hits":"2","order":"616","possible_hits":"0",},
{"lineNum":"  119","line":"\tprintf \"Hi Mom,\\nThis is the use of printf\\nI can use a backslash n to start a new line\\n1\\n2\\n3\" >> abc-test.txt","class":"lineCov","hits":"2","order":"617","possible_hits":"0",},
{"lineNum":"  120","line":"\tprintf \"This is another-test file\" >> test2.txt","class":"lineCov","hits":"2","order":"618","possible_hits":"0",},
{"lineNum":"  121","line":"\tprintf \"This is test-file 3\" >> test3.txt","class":"lineCov","hits":"2","order":"619","possible_hits":"0",},
{"lineNum":"  122","line":"\tprintf \"This is a test-file 4\" >> test4.txt","class":"lineCov","hits":"2","order":"620","possible_hits":"0",},
{"lineNum":"  123","line":"}"},
{"lineNum":"  124","line":""},
{"lineNum":"  125","line":""},
{"lineNum":"  126","line":"test_test8() { bats_test_begin \"test8\";"},
{"lineNum":"  127","line":"\ttest_folder=$(echo /tmp/test8-$$)","class":"lineCov","hits":"4","order":"621","possible_hits":"0",},
{"lineNum":"  128","line":"\tmkdir $test_folder && cd $test_folder","class":"lineCov","hits":"4","order":"622","possible_hits":"0",},
{"lineNum":"  129","line":""},
{"lineNum":"  130","line":"\tactual=$(test8-assert1-actual)","class":"lineCov","hits":"7","order":"623","possible_hits":"0",},
{"lineNum":"  131","line":"\texpected=$(test8-assert1-expected)","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  132","line":"\techo \"========== actual ==========\"","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  133","line":"\techo \"$actual\" | hexview.perl","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  134","line":"\techo \"========= expected =========\"","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  135","line":"\techo \"$expected\" | hexview.perl","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  136","line":"\techo \"============================\"","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  137","line":"\t[ \"$actual\" == \"$expected\" ]","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  138","line":""},
{"lineNum":"  139","line":"}"},
{"lineNum":"  140","line":""},
{"lineNum":"  141","line":"function test8-assert1-actual () {"},
{"lineNum":"  142","line":"\tls | count-it \'\\.([^\\.]+)$\'","class":"lineCov","hits":"6","order":"624","possible_hits":"0",},
{"lineNum":"  143","line":"}"},
{"lineNum":"  144","line":"function test8-assert1-expected () {"},
{"lineNum":"  145","line":"\techo -e \'txt\\t4\'","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  146","line":"}"},
{"lineNum":"  147","line":""},
{"lineNum":"  148","line":"test_test9() { bats_test_begin \"test9\";"},
{"lineNum":"  149","line":"\ttest_folder=$(echo /tmp/test9-$$)","class":"lineCov","hits":"4","order":"625","possible_hits":"0",},
{"lineNum":"  150","line":"\tmkdir $test_folder && cd $test_folder","class":"lineCov","hits":"4","order":"626","possible_hits":"0",},
{"lineNum":"  151","line":""},
{"lineNum":"  152","line":"\tactual=$(test9-assert1-actual)","class":"lineCov","hits":"7","order":"627","possible_hits":"0",},
{"lineNum":"  153","line":"\texpected=$(test9-assert1-expected)","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  154","line":"\techo \"========== actual ==========\"","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  155","line":"\techo \"$actual\" | hexview.perl","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  156","line":"\techo \"========= expected =========\"","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  157","line":"\techo \"$expected\" | hexview.perl","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  158","line":"\techo \"============================\"","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  159","line":"\t[ \"$actual\" == \"$expected\" ]","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  160","line":""},
{"lineNum":"  161","line":"}"},
{"lineNum":"  162","line":""},
{"lineNum":"  163","line":"function test9-assert1-actual () {"},
{"lineNum":"  164","line":"\tcat abc-test.txt | line-wc","class":"lineCov","hits":"6","order":"628","possible_hits":"0",},
{"lineNum":"  165","line":"}"},
{"lineNum":"  166","line":"function test9-assert1-expected () {"},
{"lineNum":"  167","line":"\techo -e \'2\\tHi Mom,6\\tThis is the use of printf11\\tI can use a backslash n to start a new line1\\t11\\t21\\t3\'","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  168","line":"}"},
{"lineNum":"  169","line":""},
{"lineNum":"  170","line":"test_test10() { bats_test_begin \"test10\";"},
{"lineNum":"  171","line":"\ttest_folder=$(echo /tmp/test10-$$)","class":"lineCov","hits":"4","order":"629","possible_hits":"0",},
{"lineNum":"  172","line":"\tmkdir $test_folder && cd $test_folder","class":"lineCov","hits":"4","order":"630","possible_hits":"0",},
{"lineNum":"  173","line":""},
{"lineNum":"  174","line":"\tactual=$(test10-assert1-actual)","class":"lineCov","hits":"7","order":"631","possible_hits":"0",},
{"lineNum":"  175","line":"\texpected=$(test10-assert1-expected)","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  176","line":"\techo \"========== actual ==========\"","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  177","line":"\techo \"$actual\" | hexview.perl","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  178","line":"\techo \"========= expected =========\"","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  179","line":"\techo \"$expected\" | hexview.perl","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  180","line":"\techo \"============================\"","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  181","line":"\t[ \"$actual\" == \"$expected\" ]","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  182","line":""},
{"lineNum":"  183","line":"}"},
{"lineNum":"  184","line":""},
{"lineNum":"  185","line":"function test10-assert1-actual () {"},
{"lineNum":"  186","line":"\tcat abc-test.txt | line-len","class":"lineCov","hits":"6","order":"632","possible_hits":"0",},
{"lineNum":"  187","line":"}"},
{"lineNum":"  188","line":"function test10-assert1-expected () {"},
{"lineNum":"  189","line":"\techo -e \'7\\tHi Mom,25\\tThis is the use of printf43\\tI can use a backslash n to start a new line1\\t11\\t20\\t3\'","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  190","line":"}"},
{"lineNum":"  191","line":""},
{"lineNum":"  192","line":"test_test11() { bats_test_begin \"test11\";"},
{"lineNum":"  193","line":"\ttest_folder=$(echo /tmp/test11-$$)","class":"lineCov","hits":"4","order":"633","possible_hits":"0",},
{"lineNum":"  194","line":"\tmkdir $test_folder && cd $test_folder","class":"lineCov","hits":"4","order":"634","possible_hits":"0",},
{"lineNum":"  195","line":""},
{"lineNum":"  196","line":"\tactual=$(test11-assert1-actual)","class":"lineCov","hits":"7","order":"635","possible_hits":"0",},
{"lineNum":"  197","line":"\texpected=$(test11-assert1-expected)","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  198","line":"\techo \"========== actual ==========\"","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  199","line":"\techo \"$actual\" | hexview.perl","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  200","line":"\techo \"========= expected =========\"","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  201","line":"\techo \"$expected\" | hexview.perl","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  202","line":"\techo \"============================\"","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  203","line":"\t[ \"$actual\" == \"$expected\" ]","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  204","line":""},
{"lineNum":"  205","line":"}"},
{"lineNum":"  206","line":""},
{"lineNum":"  207","line":"function test11-assert1-actual () {"},
{"lineNum":"  208","line":"\tcat abc-test.txt | para-len","class":"lineCov","hits":"6","order":"636","possible_hits":"0",},
{"lineNum":"  209","line":"}"},
{"lineNum":"  210","line":"function test11-assert1-expected () {"},
{"lineNum":"  211","line":"\techo -e \'82\\tHi Mom,This is the use of printfI can use a backslash n to start a new line123\'","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  212","line":"}"},
{"lineNum":"  213","line":""},
{"lineNum":"  214","line":"test_test12() { bats_test_begin \"test12\";"},
{"lineNum":"  215","line":"\ttest_folder=$(echo /tmp/test12-$$)","class":"lineCov","hits":"4","order":"637","possible_hits":"0",},
{"lineNum":"  216","line":"\tmkdir $test_folder && cd $test_folder","class":"lineCov","hits":"4","order":"638","possible_hits":"0",},
{"lineNum":"  217","line":""},
{"lineNum":"  218","line":"\tactual=$(test12-assert1-actual)","class":"lineCov","hits":"7","order":"639","possible_hits":"0",},
{"lineNum":"  219","line":"\texpected=$(test12-assert1-expected)","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  220","line":"\techo \"========== actual ==========\"","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  221","line":"\techo \"$actual\" | hexview.perl","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  222","line":"\techo \"========= expected =========\"","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  223","line":"\techo \"$expected\" | hexview.perl","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  224","line":"\techo \"============================\"","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  225","line":"\t[ \"$actual\" == \"$expected\" ]","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  226","line":""},
{"lineNum":"  227","line":"}"},
{"lineNum":"  228","line":""},
{"lineNum":"  229","line":"function test12-assert1-actual () {"},
{"lineNum":"  230","line":"\tcat abc-test.txt | line-word-len","class":"lineCov","hits":"6","order":"640","possible_hits":"0",},
{"lineNum":"  231","line":"}"},
{"lineNum":"  232","line":"function test12-assert1-expected () {"},
{"lineNum":"  233","line":"\techo -e \'2\\tHi Mom,6\\tThis is the use of printf11\\tI can use a backslash n to start a new line1\\t11\\t21\\t3\'","class":"lineNoCov","hits":"0","possible_hits":"0",},
{"lineNum":"  234","line":"}"},
{"lineNum":"  235","line":""},
{"lineNum":"  236","line":"test_test13() { bats_test_begin \"test13\";"},
{"lineNum":"  237","line":"\ttest_folder=$(echo /tmp/test13-$$)","class":"lineCov","hits":"4","order":"641","possible_hits":"0",},
{"lineNum":"  238","line":"\tmkdir $test_folder && cd $test_folder","class":"lineCov","hits":"4","order":"642","possible_hits":"0",},
{"lineNum":"  239","line":""},
{"lineNum":"  240","line":"}"},
{"lineNum":"  241","line":""},
{"lineNum":"  242","line":""},
{"lineNum":"  243","line":"test_test14() { bats_test_begin \"test14\";"},
{"lineNum":"  244","line":"\ttest_folder=$(echo /tmp/test14-$$)","class":"lineCov","hits":"4","order":"643","possible_hits":"0",},
{"lineNum":"  245","line":"\tmkdir $test_folder && cd $test_folder","class":"lineCov","hits":"4","order":"644","possible_hits":"0",},
{"lineNum":"  246","line":""},
{"lineNum":"  247","line":"\trm -rf ./* > /dev/null","class":"lineCov","hits":"2","order":"645","possible_hits":"0",},
{"lineNum":"  248","line":"\tactual=$(test14-assert2-actual)","class":"lineCov","hits":"4","order":"646","possible_hits":"0",},
{"lineNum":"  249","line":"\texpected=$(test14-assert2-expected)","class":"lineCov","hits":"4","order":"648","possible_hits":"0",},
{"lineNum":"  250","line":"\techo \"========== actual ==========\"","class":"lineCov","hits":"2","order":"650","possible_hits":"0",},
{"lineNum":"  251","line":"\techo \"$actual\" | hexview.perl","class":"lineCov","hits":"4","order":"651","possible_hits":"0",},
{"lineNum":"  252","line":"\techo \"========= expected =========\"","class":"lineCov","hits":"2","order":"652","possible_hits":"0",},
{"lineNum":"  253","line":"\techo \"$expected\" | hexview.perl","class":"lineCov","hits":"4","order":"653","possible_hits":"0",},
{"lineNum":"  254","line":"\techo \"============================\"","class":"lineCov","hits":"2","order":"654","possible_hits":"0",},
{"lineNum":"  255","line":"\t[ \"$actual\" == \"$expected\" ]","class":"lineCov","hits":"2","order":"655","possible_hits":"0",},
{"lineNum":"  256","line":""},
{"lineNum":"  257","line":"}"},
{"lineNum":"  258","line":""},
{"lineNum":"  259","line":"function test14-assert2-actual () {"},
{"lineNum":"  260","line":"\techo \"Done\"","class":"lineCov","hits":"2","order":"647","possible_hits":"0",},
{"lineNum":"  261","line":"}"},
{"lineNum":"  262","line":"function test14-assert2-expected () {"},
{"lineNum":"  263","line":"\techo -e \'Done\'","class":"lineCov","hits":"2","order":"649","possible_hits":"0",},
{"lineNum":"  264","line":"}"},
{"lineNum":"  265","line":""},
{"lineNum":"  266","line":"bats_test_function --tags \'\' test_test0","class":"lineCov","hits":"17","order":"350","possible_hits":"0",},
{"lineNum":"  267","line":"bats_test_function --tags \'\' test_test1","class":"lineCov","hits":"17","order":"351","possible_hits":"0",},
{"lineNum":"  268","line":"bats_test_function --tags \'\' test_test2","class":"lineCov","hits":"17","order":"352","possible_hits":"0",},
{"lineNum":"  269","line":"bats_test_function --tags \'\' test_test3","class":"lineCov","hits":"17","order":"353","possible_hits":"0",},
{"lineNum":"  270","line":"bats_test_function --tags \'\' test_test4","class":"lineCov","hits":"17","order":"354","possible_hits":"0",},
{"lineNum":"  271","line":"bats_test_function --tags \'\' test_test5","class":"lineCov","hits":"17","order":"355","possible_hits":"0",},
{"lineNum":"  272","line":"bats_test_function --tags \'\' test_test6","class":"lineCov","hits":"17","order":"356","possible_hits":"0",},
{"lineNum":"  273","line":"bats_test_function --tags \'\' test_test7","class":"lineCov","hits":"17","order":"357","possible_hits":"0",},
{"lineNum":"  274","line":"bats_test_function --tags \'\' test_test8","class":"lineCov","hits":"17","order":"358","possible_hits":"0",},
{"lineNum":"  275","line":"bats_test_function --tags \'\' test_test9","class":"lineCov","hits":"17","order":"359","possible_hits":"0",},
{"lineNum":"  276","line":"bats_test_function --tags \'\' test_test10","class":"lineCov","hits":"17","order":"360","possible_hits":"0",},
{"lineNum":"  277","line":"bats_test_function --tags \'\' test_test11","class":"lineCov","hits":"17","order":"361","possible_hits":"0",},
{"lineNum":"  278","line":"bats_test_function --tags \'\' test_test12","class":"lineCov","hits":"17","order":"362","possible_hits":"0",},
{"lineNum":"  279","line":"bats_test_function --tags \'\' test_test13","class":"lineCov","hits":"17","order":"363","possible_hits":"0",},
{"lineNum":"  280","line":"bats_test_function --tags \'\' test_test14","class":"lineCov","hits":"17","order":"364","possible_hits":"0",},
]};
var percent_low = 25;var percent_high = 75;
var header = { "command" : "bats", "date" : "2023-04-09 21:57:33", "instrumented" : 152, "covered" : 102,};
var merged_data = [];