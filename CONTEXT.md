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
The Basic module containing ordinary runtime-backed IO values such as
`println`.
_Avoid_: built-in Io effect type, compiler magic module

**Basic.Double Module**:
The Basic module containing user-facing `Double` constants and helpers over `f64` intrinsics.
_Avoid_: language literal namespace, implicit floating prelude, compiler-owned number library

**Double Contextual Operations**:
The Basic operation offers for `Double` arithmetic and comparison using IEEE floating-point equality and ordering.
_Avoid_: total floating-point order, decimal arithmetic, implicit numeric conversion

**println Binding**:
The `Basic.Io` extern binding with type `(String) -> Unit ! Io` and runtime
symbol `%println`.
_Avoid_: algebraic effect operation, compiler intrinsic, terminal API

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
- `Io` is a built-in effect type and is not declared by Basic.
- `Basic.Io.println` is an ordinary extern binding to `%println`.
- Downstream compilation consumes Basic module interfaces; linking and execution
  consume the corresponding module objects.
