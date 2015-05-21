#!/bin/ksh

#
# Copyright (c) 2015 Tristan Le Guern <tleguern@bouledef.eu>
#
# This file is in the public domain.
#

autoload array

echo "Initialize the array 'i' with the values 3, 7, 1 and 2:"
array init i 3 7 1 2
array print i

echo "The length of array 'i' is:"
array len i

echo "Remove the last member, '2'. The length of array 'i' is now:"
array pop i
array len i

echo "Add the number '6' at the end of array 'i':"
array push i 6
array print i

echo "Sort the numbers in array 'i'"
array sort i
array print i
