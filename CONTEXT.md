# Lane Standard Library

The standard library repository owns Lane source modules that provide standard
builtin wrappers, operation values, contextual offers, and later ordinary
library code.

## Language

**Stdlib.Builtins Module**:
The standard module containing primitive operation wrappers over Lane
intrinsics.
_Avoid_: compiler builtin table, host plugin API

**Standard Intrinsic Use**:
A standard-library call to a Lane intrinsic defined by the language and
implemented by the compiler/runtime boundary.
_Avoid_: host plugin API, arbitrary native call

**Contextual Operation Value**:
A standard-library value such as `Add[Int]` offered for contextual resolution.
_Avoid_: trait instance, open binding

**Stdlib.Ops Module**:
The standard module containing operation structs, operator targets, and default
contextual operation offers.
_Avoid_: magical operator namespace, source import system

**Stdlib.Io Module**:
The conventional standard module containing runtime effect shapes recognized by
run tooling when supplied explicitly by users.
_Avoid_: implicit prelude, pinned official artifact, compiler magic module

**Write Effect**:
The `Stdlib.Io` effect whose `println(String) -> Unit` operation is the initial
runtime output convention.
_Avoid_: generic console capability, unsafe builtin, terminal API

## Relationships

- `stdlib` is written in Lane source and checked by `lanec`.
- The language and intrinsic contract is specified by `spec`.
- `Stdlib.Builtins` supplies standard intrinsic wrappers.
- `Stdlib.Ops` imports `Stdlib.Builtins` and supplies standard operation values
  and offers.
- `Stdlib.Io` supplies conventional runtime effect shapes and is never injected
  implicitly by compiler or command tooling.
- `Stdlib.Io.Write.println(String) -> Unit` is the only initial runtime output
  convention.
- Downstream compilation consumes standard-library module interfaces; linking
  and execution consume the corresponding module objects.
