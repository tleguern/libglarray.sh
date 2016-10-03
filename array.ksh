#
# Copyright (c) 2015 Tristan Le Guern <tleguern@bouledef.eu>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#

function array {
	local _action="get"
	local _array_name=""

	while getopts ":" opt;do
		case $opt in
			:) echo "$PROGNAME: option requires an argument -- $OPTARG";
			   usage; exit 1;;
			\?) echo "$PROGNAME: unkown option -- $OPTARG";
			  usage; exit 1;;
			*) usage; exit 1;;
		esac
	done
	shift $(( $OPTIND - 1 ))

	case $1 in
		init) _action="init"; shift;;
		size) _action="size"; shift;;
		pop) _action="pop"; shift;;
		push) _action="push"; shift;;
		get) _action="get"; shift;;
		sort) _action="sort"; shift;;
		*) echo "Unknown action" >&2; return ;;
	esac

	_array_name="$1"
	shift

	array_init() {
		local _name="$1"; shift
		set -A "$_name" -- $@
	}

	array_size() {
		eval "echo \${#$1[*]}"
	}

	array_pop() {
		local _last=$(( $(array_size $1) - 1))
		eval "echo \${$1[$_last]}"
		unset "$1"[$_last]
	}

	array_push() {
		local _last=$(array_size $1)
		eval "$1[$_last]=$2"
	}

	array_get() {
		eval "echo \${$1[@]}"
	}

	array_sleepsort() {
		while [ -n "$1" ]
		do
			{ sleep $1; echo "$1"; } &
			shift
		done
		wait
	}

	array_sort() {
		local _sorted="$(array_sleepsort $(array_get $1))"
		array_init $1 $_sorted
	}

	if [[ $_action = "init" ]]; then
		array_init "$_array_name" $@
	elif [[ $_action = "size" ]]; then
		array_size "$_array_name"
	elif [[ $_action = "pop" ]]; then
		array_pop "$_array_name"
	elif [[ $_action = "push" ]]; then
		array_push "$_array_name" "$1"
	elif [[ $_action = "get" ]]; then
		array_get "$_array_name"
	elif [[ $_action = "sort" ]]; then
		array_sort "$_array_name"
	fi
}

