# libglarray.sh

This repository contains an implementation of a portable wrapper around arrays manipulation in various shells.

## Compatibility

libglarray.sh supports the following shells:

* GNU Bourne-Again SHell - bash ;
* MirBSD Korn SHell - mksh ;
* OpenBSD Korn SHell - oksh ;
* Public Domain Korn SHell - pdksh ;
* Yet Another SHell - yash ;
* The Z shell - zsh.

## Functions

This library helps to handle arrays with an easier to use syntax.
It currently implements the following functionalities :

* create: initialize the array with a list of value ;
* destroy: destroy an array ;
* size: print the length of the array ;
* del: remove an element from an array ;
* set: assign a value to a particular indice ;
* get: print the element at a particular indice ;
* pop: print the last value of an array and remove it ;
* append: add a new value at the end of an array ;

## Exemple

    $ . ./array.sh
    $ glarray create A 1 2 3 4
    $ [ $(glarray size A) -eq 4 ]
    $ glarray append A 5
    $ glarray get A
    1 2 3 4 5
