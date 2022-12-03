[![Actions Status](https://github.com/frithnanth/raku-Math-Libgsl-Combination/workflows/test/badge.svg)](https://github.com/frithnanth/raku-Math-Libgsl-Combination/actions)

NAME
====

Math::Libgsl::Combination - An interface to libgsl, the Gnu Scientific Library - Combinations.

SYNOPSIS
========

```raku
use Math::Libgsl::Combination;
```

DESCRIPTION
===========

Math::Libgsl::Combination is an interface to the combination functions of libgsl, the Gnu Scientific Library.

This package provides both the low-level interface to the C library (Raw) and a more comfortable interface layer for the Raku programmer.

### new(:$n!, :$k!)

### new($n!, $k!)

The constructor accepts two parameters: the total number of elements in the set and the number of elements chosen from the set; the parameters can be passed as Pair-s or as single values. The combination object is already initialized in lexicographically first combination, i.e. (0, 1, 2, …, $k − 1).

### init(:$start? = TOP)

This method initialize the combination object and returns **self**. The default is to initialize the object in lexicographically first combination, but by specifying the optional parameter **$start** as **BOTTOM** the initialization is performed in the lexicographically last combination, i.e. ($n − $k, $n − $k + 1, …, $n − 1). TOP and BOTTOM are declared as values of the Starting-point enum.

### copy($src! where * ~~ Math::Libgsl::Combination)

This method copies the combination **$src** into the current combination object and returns **self**.

### get(Int $elem! --> Int)

This method returns the combination value at position **$elem**.

### all(--> Seq)

This method returns a Seq of all the elements of the current combination.

### size(--> List)

This method returns the (n, k) parameters of the current combination object.

### is-valid(--> Bool)

This method checks whether the current combination is valid: the k elements should lie in the range 0 to $n − 1, with each value occurring once at most and in increasing order.

### next()

### prev()

These functions advance or step backwards the combination and return **self**, useful for method chaining.

### bnext(--> Bool)

### bprev(--> Bool)

These functions advance or step backwards the combination and return a Bool: **True** if successful or **False** if there's no more combination to produce.

### write(Str $filename! --> Int)

This method writes the combination data to a file.

### read(Str $filename! --> Int)

This method reads the combination data from a file. The combination must be of the same size of the one to be read.

### fprintf(Str $filename!, Str $format! --> Int)

This method writes the combination data to a file, using the format specifier.

### fscanf(Str $filename!)

This method reads the combination data from a file. The combination must be of the same size of the one to be read.

C Library Documentation
=======================

For more details on libgsl see [https://www.gnu.org/software/gsl/](https://www.gnu.org/software/gsl/). The excellent C Library manual is available here [https://www.gnu.org/software/gsl/doc/html/index.html](https://www.gnu.org/software/gsl/doc/html/index.html), or here [https://www.gnu.org/software/gsl/doc/latex/gsl-ref.pdf](https://www.gnu.org/software/gsl/doc/latex/gsl-ref.pdf) in PDF format.

Prerequisites
=============

This module requires the libgsl library to be installed. Please follow the instructions below based on your platform:

Debian Linux and Ubuntu 20.04+
------------------------------

    sudo apt install libgsl23 libgsl-dev libgslcblas0

That command will install libgslcblas0 as well, since it's used by the GSL.

Ubuntu 18.04
------------

libgsl23 and libgslcblas0 have a missing symbol on Ubuntu 18.04. I solved the issue installing the Debian Buster version of those three libraries:

  * [http://http.us.debian.org/debian/pool/main/g/gsl/libgslcblas0_2.5+dfsg-6_amd64.deb](http://http.us.debian.org/debian/pool/main/g/gsl/libgslcblas0_2.5+dfsg-6_amd64.deb)

  * [http://http.us.debian.org/debian/pool/main/g/gsl/libgsl23_2.5+dfsg-6_amd64.deb](http://http.us.debian.org/debian/pool/main/g/gsl/libgsl23_2.5+dfsg-6_amd64.deb)

  * [http://http.us.debian.org/debian/pool/main/g/gsl/libgsl-dev_2.5+dfsg-6_amd64.deb](http://http.us.debian.org/debian/pool/main/g/gsl/libgsl-dev_2.5+dfsg-6_amd64.deb)

Installation
============

To install it using zef (a module management tool):

    $ zef install Math::Libgsl::Combination

AUTHOR
======

Fernando Santagata <nando.santagata@gmail.com>

COPYRIGHT AND LICENSE
=====================

Copyright 2020 Fernando Santagata

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

