. ../glarray.sh

test_description="glarray test suite"
. /usr/local/share/sharness/sharness.sh

test_expect_success "init empty array" '
	glarray E
	[ ${#E[@]} -eq 0 ]
'

test_expect_success "init array with one item" '
	glarray O 1
	[ ${#O[@]} -eq 1 ]
	[ "${O[@]}" = "1" ]
	[ "${O[0]}" = "1" ]
'

test_expect_success "init array with two items" '
	glarray T 1 2
	[ ${#T[@]} -eq 2 ]
	[ "${T[@]}" = "1 2" ]
	[ "${T[0]}" = "1" ]
	[ "${T[1]}" = "2" ]
'

test_done
