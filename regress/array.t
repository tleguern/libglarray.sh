. ../array.sh

test_description="new array test suite"
if [ -f /usr/share/sharness/sharness.sh ]; then
	. /usr/share/sharness/sharness.sh
elif [ -f /usr/local/share/sharness/sharness.sh ]; then
	. /usr/local/share/sharness/sharness.sh
else
	echo "Sharness is not installed or not discovered."
	exit 1
fi

test_expect_success "init empty array" '
	glarray create E
	[ $(glarray size E) -eq 0 ]
	[ "$(glarray get E)" = "" ]
'

test_expect_success "init array with one item" '
	glarray create O 1
	[ $(glarray size O) -eq 1 ]
	[ "$(glarray get O)" = "1" ]
	[ "$(glarray get O 0)" = "1" ]
'

test_expect_success "init array with three items" '
	glarray create T 0 1 2
	[ $(glarray size T) -eq 3 ]
	[ "$(glarray get T)" = "0 1 2" ]
	[ "$(glarray get T 0)" = "0" ]
	[ "$(glarray get T 1)" = "1" ]
	[ "$(glarray get T 2)" = "2" ]
'

test_expect_success "Remove elements from the middle of an array" '
	glarray create A a b c d e
	[ $(glarray size A) -eq 5 ]
	glarray del A 2
	[ $(glarray size A) -eq 4 ]
	[ "$(glarray get A)" = "a b d e" ]
'

test_expect_success "Remove elements from the end of an array using pop" '
	glarray create A a b c d e
	[ $(glarray size A) -eq 5 ]
	glarray pop A
	[ $(glarray size A) -eq 4 ]
	[ "$(glarray get A)" = "a b c d" ]
	glarray pop A
	[ $(glarray size A) -eq 3 ]
	[ "$(glarray get A)" = "a b c" ]
	glarray pop A
	[ $(glarray size A) -eq 2 ]
	[ "$(glarray get A)" = "a b" ]
	glarray pop A
	[ $(glarray size A) -eq 1 ]
	[ "$(glarray get A)" = "a" ]
	glarray pop A
	[ $(glarray size A) -eq 0 ]
	[ "$(glarray get A)" = "" ]
'

test_expect_success "Add elements at the end of an array using append" '
	glarray create A
	[ $(glarray size A) -eq 0 ]
	glarray append A a
	[ $(glarray size A) -eq 1 ]
	[ "$(glarray get A)" = "a" ]
	glarray append A b
	[ $(glarray size A) -eq 2 ]
	[ "$(glarray get A)" = "a b" ]
	glarray append A c
	[ $(glarray size A) -eq 3 ]
	[ "$(glarray get A)" = "a b c" ]
	glarray append A d
	[ $(glarray size A) -eq 4 ]
	[ "$(glarray get A)" = "a b c d" ]
	glarray append A e
	[ $(glarray size A) -eq 5 ]
	[ "$(glarray get A)" = "a b c d e" ]
'

test_expect_success "Modify arbitrary elements of an array" '
	glarray create A a b c d e
	[ $(glarray size A) -eq 5 ]
	glarray set A 2 f
	[ $(glarray size A) -eq 5 ]
	[ "$(glarray get A 2)" = "f" ]
	[ "$(glarray get A)" = "a b f d e" ]
'

test_expect_success "Modify the last element of an array" '
	glarray create E
	[ $(glarray size E) -eq 0 ]
	glarray set E 0 foo
	[ $(glarray size E) -eq 1 ]
	[ "$(glarray get E)" = "foo" ]
'

test_done
