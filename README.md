libglarray.sh
=============

This repository contains an interface to uniformly declare global arrays
in shell, glarray.sh, and an experimental Korn shell interface for easier
manipulation of arrays, array.ksh.

Compatibility
-------------

libglarray.sh supports the following shells:

- GNU Bourne-Again SHell - bash ;
- MirBSD Korn SHell - mksh;
- OpenBSD Korn SHell - oksh ;
- Public Domain Korn SHell - pdksh;
- The Z shell - zsh.

Other shells implementing the KSH arrays extension should be trivials
to support.

array.ksh
=========

This Korn shell script helps to handle arrays with an easier to use syntax. It currently implements the following functionalities :

- init: initialize the array with a list of value ;
- len: print the length of the array ;
- pop: print the last value of the array and remove it ;
- push: add a new value at the end of the array ;
- print: print the whole array ;
- sort: sort a numeric array (currently done with a sleep sort).

Exemple
-------

The Korn shell interface array.ksh should be installed as “array” in
your FPATH in order to be usable. Once done it is possible to start
playing with it this way :

    $ autoload array
    $ array init i 1 2 3 4
    $ [[ $(array len i) -eq $(echo ${#i[*]}) ]] && echo true
    true
    $ [[ $(array print i) = $(echo ${i[*]}) ]] && echo true
    true
    ...

