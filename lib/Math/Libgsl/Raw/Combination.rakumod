use v6;

unit module Math::Libgsl::Raw::Combination:ver<0.1.0>:auth<zef:FRITH>;

use NativeCall;

constant GSLHELPER = %?RESOURCES<libraries/gslhelper>.absolute;

sub LIB {
  run('/sbin/ldconfig', '-p', :chomp, :out).out.slurp(:close).split("\n").grep(/^ \s+ libgsl\.so\. \d+ /).sort.head.comb(/\S+/).head;
}

class gsl_combination is repr('CStruct') is export {
  has size_t          $.n;
  has size_t          $.k;
  has CArray[size_t]  $.data;
}

# Combination allocation
sub gsl_combination_alloc(size_t $n, size_t $k --> gsl_combination) is native(&LIB) is export(:combmem) { * }
sub gsl_combination_calloc(size_t $n, size_t $k --> gsl_combination) is native(&LIB) is export(:combmem) { * }
sub gsl_combination_init_first(gsl_combination $c) is native(&LIB) is export(:combmem) { * }
sub gsl_combination_init_last(gsl_combination $c) is native(&LIB) is export(:combmem) { * }
sub gsl_combination_free(gsl_combination $c) is native(&LIB) is export(:combmem) { * }
sub gsl_combination_memcpy(gsl_combination $dest, gsl_combination $src --> int32) is native(&LIB) is export(:combmem) { * }
# Accessing combination elements
sub gsl_combination_get(gsl_combination $c, size_t $i --> size_t) is native(&LIB) is export(:combacc) { * }
# Combination properties
sub gsl_combination_n(gsl_combination $c --> size_t) is native(&LIB) is export(:combprop) { * }
sub gsl_combination_k(gsl_combination $c --> size_t) is native(&LIB) is export(:combprop) { * }
sub gsl_combination_data(gsl_combination $c --> Pointer) is native(&LIB) is export(:combprop) { * }
sub gsl_combination_valid(gsl_combination $c --> int32) is native(&LIB) is export(:combprop) { * }
# Combination functions
sub gsl_combination_next(gsl_combination $c --> int32) is native(&LIB) is export(:combfunc) { * }
sub gsl_combination_prev(gsl_combination $c --> int32) is native(&LIB) is export(:combfunc) { * }
# Reading and writing combinations
sub mgsl_combination_fwrite(Str $filename, gsl_combination $p --> int32) is native(GSLHELPER) is export(:combio) { * }
sub mgsl_combination_fread(Str $filename, gsl_combination $p --> int32) is native(GSLHELPER) is export(:combio) { * }
sub mgsl_combination_fprintf(Str $filename, gsl_combination $p, Str $format --> int32) is native(GSLHELPER) is export(:combio) { * }
sub mgsl_combination_fscanf(Str $filename, gsl_combination $p --> int32) is native(GSLHELPER) is export(:combio) { * }
