# Lane Basic Library

This directory contains Lane's ordinary Basic library. It defines no compiler-recognized declarations: primitive operations enter through the closed `Basic.Builtins` intrinsic table, while numeric traits, Unicode scalar algorithms, UTF-8 validation, immutable byte-sequence operations, contextual offers, effects, and structural derivation are implemented in Lane source.

`Basic.Data.I64`, `Basic.Data.I32`, `Basic.Data.F64`, and `Basic.Data.F32` supply numeric trait offers, special floating-point values, and explicit width conversions. `Basic.Data.Char` supplies checked Unicode scalar construction, ordering, and UTF-8 encoding. `Basic.Data.String` treats positions as Unicode scalar indices and provides byte length, scalar count, scalar lookup and slicing, effect-polymorphic folding, exact concatenation, UTF-8 encode/decode, and Equal, Compare, Semigroup, and Monoid offers. `Basic.Data.Bytes` remains arbitrary immutable bytes with checked construction, lookup, update, slicing, concatenation, equality, and UTF-8 validation.

Run the integration suite with `./test.sh`. Set `LANE_BIN=/path/to/lane` when testing against a compiler build that is not installed on `PATH`.
