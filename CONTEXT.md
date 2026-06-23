# Lane Standard Library

The standard library repository owns Lane source modules that provide standard
builtin wrappers, operation values, contextual offers, and later ordinary
library code.

## Language

**Builtins Module**:
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

**Ops Module**:
The standard module containing operation structs, operator targets, and default
contextual operation offers.
_Avoid_: magical operator namespace, source import system

## Relationships

- `stdlib` is written in Lane source and checked by `lanec`.
- The language and intrinsic contract is specified by `spec`.
- `Builtins` supplies standard intrinsic wrappers.
- `Ops` imports `Builtins` and supplies standard operation values and offers.
- Downstream compilation consumes standard-library module interfaces; linking
  and execution consume the corresponding module objects.
