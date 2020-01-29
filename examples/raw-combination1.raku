#!/usr/bin/env raku

# See "GNU Scientific Library" manual Chapter 10 Combinations, Paragraph 10.7 Examples

use lib 'lib';
use NativeCall;
use Math::Libgsl::Constants;
use Math::Libgsl::Raw::Combination :ALL;

say "All subsets of {0,1,2,3} by size:";
for ^5 -> $i {
  my $c = gsl_combination_calloc(4, $i);
  repeat {
    say '{' ~ $c.data[^(gsl_combination_k($c))] ~ '}';
  }while gsl_combination_next($c) == GSL_SUCCESS;
  gsl_combination_free($c);
}
