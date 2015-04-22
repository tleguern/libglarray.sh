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

glarray() {
	local LIBNAME="libglarray.sh"
	local LIBVERSION="1.0"

	_glarrayksh() {
		local _glarray_name="$1"
		shift
		set -A $_glarray_name -- $@
	}

	_glarraybash() {
		local _glarray_name="$1"
		shift
		declare -ga $_glarray_name
		local _glarray_i=0
		local _glarray_j=0
		for _glarray_i; do
			declare -ga "$_glarray_name[$_glarray_j]=$_glarray_i"
			_glarray_j=$(( $_glarray_j + 1 ))
		done
	}

	_glarrayzsh() {
		local _glarray_name="$1"
		shift
		typeset -ga $_glarray_name
		local _glarray_i=0
		local _glarray_j=0
		for _glarray_i; do
			typeset -g "$_glarray_name[$_glarray_j]"="$_glarray_i"
			_glarray_j=$(( $_glarray_j + 1 ))
		done
	}

	_glarray_init() {
		set +u
		if [ -n "$BASH_VERSION" ]; then
			_glarray=_glarraybash
		elif [ -n "$KSH_VERSION" ]; then
			_glarray=_glarrayksh
		elif [ -n "$ZSH_VERSION" ]; then
			setopt ksharrays
			_glarray=_glarrayzsh
		else
			echo "Error: unsuported shell :(" >&2
			exit 1
		fi
		set -u
	}

	if [ -z ${_glarray:-} ]; then
		_glarray_init
	fi
	$_glarray $@
}

