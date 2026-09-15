# Compiler and host boundaries

Basic is source code, but it is not wholly independent of the compiler.
The authoritative registry is Lane's
`modules/lanec/abi/contract.mbt`. The current canonical providers are:

| Declaration | Compiler purpose |
| --- | --- |
| `Basic.Data.List.List` | List syntax and canonical representation |
| `Basic.Data.Tuple.Tuple` | Tuple syntax and canonical representation |
| `Basic.Data.Void.Void` | Uninhabited results and fatal intrinsics |
| `Basic.Trait.Iso.Iso` | Derived representation conversion |
| `Basic.Trait.Derive.Deriver` | Structural capability derivation |
| `Basic.Trait.Derive.Product/Sum` | Derived product/sum representation |
| `Basic.Trait.Derive.TypeInfo/FieldInfo/VariantInfo` | Derivation metadata |
| `Basic.Wasm.Abi.WasmAddress` | Guest address accepted by Wasm extern calls |

The compiler validates names, kinds, field order and shapes. Changing these
requires a coordinated compiler change. Internal derived constructors are
compiler dependencies, not a reason to re-export metadata from every facade.

`Basic.Ops` supplies conventional operator names. Its dictionaries are ordinary
source types. `Basic.Builtins` binds a closed intrinsic table; raw primitives
have documented preconditions and are for implementation code. Checked data
modules validate those preconditions. `Io` and `Panic` are compiler effects;
Panic terminates the program and is not an algebraic exception to catch.

Strings and Bytes share the immutable byte-sequence representation. UTF-8
validation is mandatory before interpreting arbitrary external bytes as String.
Mutable ByteBuffer operations and WasmAddress are low-level: the caller must
supply valid ranges and preserve backing storage for the extern call. They do
not make an arbitrary guest pointer safe.

The process adapter uses `lane_runtime_v1` host imports. ProcessFailure system
codes are protocol statuses, not native operating-system errno values.
Filesystem codes are specifically WASIp1 errno values. Process output is fully
captured by this protocol; it is not a streaming process API.

Compiler inspection uses schema 1 and module artifact formats have their own
versions. The Basic gitlink in Lane is the compatibility pin; there is no
independent promise that arbitrary compiler and Basic revisions can be mixed.
