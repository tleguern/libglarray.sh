#
# Copyright (c) 2015,2022 Tristan Le Guern <tleguern@bouledef.eu>
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

# XXX: Should be converted to native ZSH arrays, but will suffice for now.
if [ -n "${ZSH_VERSION:-}" ]; then
	setopt ksharrays
fi

#
# array_create: Create the array $1 with the values $@. Can be empty.
# Public
#
if [ -n "${BASH_VERSION:-}" ]; then
	array_create() {
		local _name="$1"; shift

		declare -ga "$_name"
		local _i=0
		local _j=0
		for _i; do
			declare -ga "$_name[$_j]=$_i"
			_j=$(( $_j + 1 ))
		done
		unset _i _j
	}
elif [ -n "${KSH_VERSION:-}" ]; then
	array_create() {
		local _name="$1"; shift

		set -A "$_name" -- $@
	}
elif [ -n "${YASH_VERSION:-}" ]; then
	array_create() {
		local _name="$1"; shift

		typeset -g "$_name"
		array "$_name" $@
	}
elif [ -n "${ZSH_VERSION:-}" ]; then
	array_create() {
		local _name="$1"; shift

		# Prevent zsh from merging a new array with an old one
		unset "$_name"
		typeset -ga "$_name"
		local _j=0
		for _i; do
			typeset -g "$_name[_j]"="$_i"
			_j=$(( _j + 1 ))
		done
		unset _i _j
	}
else
	array_create() {
		echo "unimplemented shell" >&2
	}
fi

#
# array_destroy: Destroy the array $1.
# Public
#
array_destroy() {
	local _name="$1"; shift

	unset "$_name"
}

#
# array_size: Print the size of array $1.
# Public
#
if [ -n "${YASH_VERSION:-}" ]; then
	array_size() {
		local _name="$1"; shift

		eval "echo \${$_name[#]}"
	}
else
	array_size() {
		local _name="$1"; shift

		eval "echo \${#$_name[*]}"
	}
fi

#
# array_del: Remove indice $2 from array $1.
# Public
#
if [ -n "${YASH_VERSION:-}" ]; then
	array_del() {
		local _name="$1"; shift
		local _pos="$1"; shift

		array -d "$_name" "$(( _pos + 1 ))"
	}
elif [ -n "${ZSH_VERSION:-}" ]; then
	array_del() {
		local _name="$1"; shift
		local _pos="$1"; shift

		eval "$_name[_pos]=()"
	}
else
	array_del() {
		local _name="$1"; shift
		local _pos="$1"; shift

		unset "$_name[_pos]"
	}
fi

#
# array_set: Assign the value $3 at indice $2 in array $1.
# Public
#
if [ -n "${YASH_VERSION:-}" ]; then
	array_set() {
		local _name="$1"; shift
		local _pos="$1"; shift
		local _val="$1"; shift

		#eval "$_name[$_pos]=$_val"
		array -s "$_name" "$(( _pos + 1 ))" "$_val"
	}
else
	array_set() {
		local _name="$1"; shift
		local _pos="$1"; shift
		local _val="$1"; shift

		eval "$_name[$_pos]=$_val"
	}
fi

#
# array_get: Print the element at indice $2 from array $1.
# Public
#
array_get() {
	local _name="$1"; shift
	local _pos="$1"; shift

	if [ -n "${YASH_VERSION:-}" ]; then
		eval "echo \${$_name[_pos + 1]}"
	else
		eval "echo \${$_name[_pos]}"
	fi
}

#
# array_get_all: Print all elements from the array $1.
# Internal
#
array_get_all() {
	local _name="$1"; shift

	if [ $(array_size "$_name") -gt 0 ]; then
		eval "echo \${$_name[@]}"
	fi
}

#
# array_pop: Print and remove the last element in array $1.
# Public
#
array_pop() {
	local _name="$1"; shift
	local _last=$(( $(array_size $_name) - 1))

	array_get "$_name" "$_last"
	array_del "$_name" "$_last"
}

#
# array_append: Add element $2 at the end of array $1.
# Public
#
if [ -n "${YASH_VERSION:-}" ]; then
	array_append() {
		local _name="$1"; shift
		local _val="$1"; shift
		local _end="$(array_size "$_name")"

		array -i "$_name" "$_end" "$_val"
		unset _end
	}

else
	array_append() {
		local _name="$1"; shift
		local _val="$1"; shift
		local _end="$(array_size "$_name")"

		array_set "$_name" "$_end" "$_val"
		unset _end
	}
fi

glarray() {
	local _action="$1"; shift
	local _name="$1"; shift

	if [[ $_action = "create" ]]; then
		array_create "$_name" $@
	elif [[ $_action = "destroy" ]]; then
		array_destroy "$_name"
	elif [[ $_action = "size" ]]; then
		array_size "$_name"
	elif [[ $_action = "pop" ]]; then
		array_pop "$_name"
	elif [[ $_action = "append" ]]; then
		array_append "$_name" "$1"
	elif [[ $_action = "del" ]]; then
		array_del "$_name" "$1"
	elif [[ $_action = "set" ]]; then
		array_set "$_name" "$1"
	elif [[ $_action = "get" ]] || [[ $_action = "print" ]]; then
		if [ $# -ne 0 ]; then
			array_get "$_name" "$1"
		else
			array_get_all "$_name"
		fi
	fi
}
