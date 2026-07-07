# Lane Basic Library

The Basic library repository owns explicitly supplied Lane source modules that
provide basic builtin wrappers, operation values, contextual offers, and later
ordinary library code.

## Language

**Basic.Builtins Module**:
The Basic module containing primitive operation wrappers over Lane intrinsics.
_Avoid_: compiler builtin table, host plugin API

**Basic Intrinsic Use**:
A Basic library call to a Lane intrinsic defined by the language and
implemented by the compiler/runtime boundary.
_Avoid_: host plugin API, arbitrary native call

**Contextual Operation Value**:
A Basic library value such as `Add[Int]` offered for contextual resolution.
_Avoid_: trait instance, open binding

**Basic.Ops Module**:
The Basic module containing operation structs, operator targets, and default
contextual operation offers.
_Avoid_: magical operator namespace, source import system

**Basic.Io Module**:
The conventional Basic module containing runtime effect shapes recognized by run
tooling when supplied explicitly by users.
_Avoid_: implicit prelude, pinned official artifact, compiler magic module

**Basic.Double Module**:
The Basic module containing user-facing `Double` constants and helpers over `f64` intrinsics.
_Avoid_: language literal namespace, implicit floating prelude, compiler-owned number library

**Double Contextual Operations**:
The Basic operation offers for `Double` arithmetic and comparison using IEEE floating-point equality and ordering.
_Avoid_: total floating-point order, decimal arithmetic, implicit numeric conversion

**Write Effect**:
The `Basic.Io` effect whose `println(String) -> Unit` operation is the initial
runtime output convention.
_Avoid_: generic console capability, unsafe builtin, terminal API

## Relationships

- `basic` is written in Lane source and checked by `lanec`.
- The language and intrinsic contract is specified by `spec`.
- `Basic.Builtins` supplies standard intrinsic wrappers.
- `Basic.Ops` imports `Basic.Builtins` and supplies standard operation values
  and offers.
- `Basic.Double` supplies explicit `Double` constants such as infinity and NaN;
  these are ordinary library values, not language literals.
- `Basic.Ops` supplies `Double` arithmetic and comparison offers; comparison is
  IEEE floating-point comparison, not a total order.
- `Basic.Io` supplies conventional runtime effect shapes and is never injected
  implicitly by compiler or command tooling.
- `Basic.Io.Write.println(String) -> Unit` is the only initial runtime output
  convention.
- Downstream compilation consumes Basic module interfaces; linking and execution
  consume the corresponding module objects.
