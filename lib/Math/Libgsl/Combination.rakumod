use v6.c;

unit class Math::Libgsl::Combination:ver<0.1.1>:auth<zef:FRITH>;

use Math::Libgsl::Raw::Combination :ALL;
use Math::Libgsl::Exception;
use Math::Libgsl::Constants;
use NativeCall;

has gsl_combination $.c;

enum Starting-point is export <TOP BOTTOM>;

multi method new(Int $n!, Int $k!) { self.bless(:$n, :$k) }
multi method new(Int :$n!, Int :$k) { self.bless(:$n, :$k) }

submethod BUILD(:$n!, :$k) { $!c = gsl_combination_calloc($n, $k) }

submethod DESTROY { gsl_combination_free($!c) }

method init(:$start? = TOP) {
  given $start {
    when TOP { gsl_combination_init_first($!c) }
    when BOTTOM { gsl_combination_init_last($!c) }
    default { X::Libgsl.new(errno => GSL_FAILURE, error => "Invalid starting point").throw }
  }
  self
}

method copy($src! where * ~~ Math::Libgsl::Combination) { gsl_combination_memcpy($!c, $src.c); self }

method get(Int $elem! --> Int)
{
  fail X::Libgsl.new: errno => GSL_EINVAL, error => 'Index out of range' if $elem > $!c.k - 1;
  gsl_combination_get($!c, $elem)
}

method size(--> List) { gsl_combination_n($!c), gsl_combination_k($!c) }

method is-valid(--> Bool) { gsl_combination_valid($!c) == GSL_SUCCESS ?? True !! False }

method all(--> Seq) { $!c.data[^gsl_combination_k($!c)] }

method next
{
  my $ret = gsl_combination_next($!c);
  X::Libgsl.new(errno => $ret, error => "Can't get next combination").throw if $ret ≠ GSL_SUCCESS;
  self
}

method prev
{
  my $ret = gsl_combination_prev($!c);
  X::Libgsl.new(errno => $ret, error => "Can't get previous combination").throw if $ret ≠ GSL_SUCCESS;
  self
}

method bnext(--> Bool) { gsl_combination_next($!c) == GSL_SUCCESS ?? True !! False }

method bprev(--> Bool) { gsl_combination_prev($!c) == GSL_SUCCESS ?? True !! False }

method write(Str $filename! --> Int)
{
  my $ret = mgsl_combination_fwrite($filename, $!c);
  fail X::Libgsl.new: errno => $ret, error => "Can't write to file" if $ret ≠ GSL_SUCCESS;
  $ret;
}

method read(Str $filename! --> Int)
{
  my $ret = mgsl_combination_fread($filename, $!c);
  fail X::Libgsl.new: errno => $ret, error => "Can't read from file" if $ret ≠ GSL_SUCCESS;
  $ret;
}

method fprintf(Str $filename!, Str $format! --> Int)
{
  my $ret = mgsl_combination_fprintf($filename, $!c, $format);
  fail X::Libgsl.new: errno => $ret, error => "Can't fprintf to file" if $ret ≠ GSL_SUCCESS;
  $ret;
}

method fscanf(Str $filename! --> Int)
{
  my $ret = mgsl_combination_fscanf($filename, $!c);
  fail X::Libgsl.new: errno => $ret, error => "Can't fscanf from file" if $ret ≠ GSL_SUCCESS;
  $ret;
}

=begin pod

=head1 NAME

Math::Libgsl::Combination - An interface to libgsl, the Gnu Scientific Library - Combinations.

=head1 SYNOPSIS

=begin code :lang<raku>

use Math::Libgsl::Combination;

=end code

=head1 DESCRIPTION

Math::Libgsl::Combination is an interface to the combination functions of libgsl, the Gnu Scientific Library.

This package provides both the low-level interface to the C library (Raw) and a more comfortable interface layer for the Raku programmer.

=head3 new(:$n!, :$k!)
=head3 new($n!, $k!)

The constructor accepts two parameters: the total number of elements in the set and the number of elements chosen from the set; the parameters can be passed as Pair-s or as single values.
The combination object is already initialized in lexicographically first combination, i.e. (0, 1, 2, …, $k − 1).

All the following methods I<throw> on error if they return B<self>, otherwise they I<fail> on error.

=head3 init(:$start? = TOP)

This method initialize the combination object and returns B<self>.
The default is to initialize the object in lexicographically first combination, but by specifying the optional parameter B<$start> as B<BOTTOM> the initialization is performed in the lexicographically last combination, i.e. ($n − $k, $n − $k + 1, …, $n − 1).
TOP and BOTTOM are declared as values of the Starting-point enum.

=head3 copy($src! where * ~~ Math::Libgsl::Combination)

This method copies the combination B<$src> into the current combination object and returns B<self>.

=head3 get(Int $elem! --> Int)

This method returns the combination value at position B<$elem>.

=head3 all(--> Seq)

This method returns a Seq of all the elements of the current combination.

=head3 size(--> List)

This method returns the (n, k) parameters of the current combination object.

=head3 is-valid(--> Bool)

This method checks whether the current combination is valid: the k elements should lie in the range 0 to $n − 1, with
each value occurring once at most and in increasing order.

=head3 next()
=head3 prev()

These functions advance or step backwards the combination and return B<self>, useful for method chaining.

=head3 bnext(--> Bool)
=head3 bprev(--> Bool)

These functions advance or step backwards the combination and return a Bool: B<True> if successful or B<False> if there's no more combination to produce.

=head3 write(Str $filename! --> Int)

This method writes the combination data to a file.

=head3 read(Str $filename! --> Int)

This method reads the combination data from a file.
The combination must be of the same size of the one to be read.

=head3 fprintf(Str $filename!, Str $format! --> Int)

This method writes the combination data to a file, using the format specifier.

=head3 fscanf(Str $filename!)

This method reads the combination data from a file.
The combination must be of the same size of the one to be read.

=head1 C Library Documentation

For more details on libgsl see L<https://www.gnu.org/software/gsl/>.
The excellent C Library manual is available here L<https://www.gnu.org/software/gsl/doc/html/index.html>, or here L<https://www.gnu.org/software/gsl/doc/latex/gsl-ref.pdf> in PDF format.

=head1 Prerequisites

This module requires the libgsl library to be installed. Please follow the instructions below based on your platform:

=head2 Debian Linux and Ubuntu 20.04+

=begin code
sudo apt install libgsl23 libgsl-dev libgslcblas0
=end code

That command will install libgslcblas0 as well, since it's used by the GSL.

=head2 Ubuntu 18.04

libgsl23 and libgslcblas0 have a missing symbol on Ubuntu 18.04.
I solved the issue installing the Debian Buster version of those three libraries:

=item L<http://http.us.debian.org/debian/pool/main/g/gsl/libgslcblas0_2.5+dfsg-6_amd64.deb>
=item L<http://http.us.debian.org/debian/pool/main/g/gsl/libgsl23_2.5+dfsg-6_amd64.deb>
=item L<http://http.us.debian.org/debian/pool/main/g/gsl/libgsl-dev_2.5+dfsg-6_amd64.deb>

=head1 Installation

To install it using zef (a module management tool):

=begin code
$ zef install Math::Libgsl::Combination
=end code

=head1 AUTHOR

Fernando Santagata <nando.santagata@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2020 Fernando Santagata

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
