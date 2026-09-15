# Standard library revision

This plan tracks the complete design audit accepted on 2026-09-15. Each verified
implementation milestone is committed independently in Basic and pinned by Lane.
The independent sibling checkout is not overwritten.

## Milestones

- [x] Effectful short-circuit operators and exception conversion preserving residual effects.
- [x] Nominal Debug identity, quoted/escaped rendering, and structural empty-payload handling.
- [x] Reliable output and directory creation with truthful failure reporting.
- [x] Defined numeric conversions and arithmetic failure contracts.
- [x] Independent Reader, State and Writer semantics, with immediate runner functions.
- [x] Structured process and filesystem errors with explicit host adapters.
- [x] Coherent Option and Result operations and capability providers.
- [x] Explicit partial and total comparison contracts.
- [x] AList replacement semantics and separately named shadowing bindings.
- [x] Consistent effectful collection operations and predictable construction costs.
- [x] Direct capabilities for foundational data types and efficient text construction.
- [x] Consistent module naming, public exports and documented compiler ABI seams.
- [x] Explicit build configuration, planning and required interface closures.
- [x] Boundary, order, composition, large-input and compatibility regression gates.

## Validation

Basic is Lane source, not a MoonBit module. Use a pinned Lane compiler to format,
check and execute the Basic suite. Compiler changes use `moon test --target native`,
`moon info` and `moon fmt`. Validate actual emitted Wasm and example fixtures when
changing contracts consumed by compiled programs. Never overwrite the independent
Basic checkout's existing changes.

### Effect composition

`And` and `Or` preserve the deferred operand effect. `to_option` preserves
residual effects; `to_result` also retains the exception value. The Basic suite
passes 19 test groups, including effectful and skipped Boolean operands and
exception conversion with an independent assertion effect.

### Debug identity and rendering

Debug is a nominal dictionary producing structural Documents. Primitive
formatters use `from_formatter`; String and Char render escaped delimiters.
The derivation terminator is `Document.empty`, distinct from `text("")`.
Regression tests cover ordinary conversion coexistence, empty enum payloads,
escaping and custom empty renderers. All 19 Basic test groups pass.

### Output and directory correctness

`try_println`/`write_all` return structured errors. `println` is explicitly fatal
on write failure and carries Panic. Short writes retry, zero progress terminates
with an error, and empty output does not invoke the adapter. Directory creation
is non-recursive and verifies the type of existing paths. All 20 Basic groups
and the isolated filesystem host regression passed.

### Independent effects and immediate handlers

Reader.ask, State.get/put and Writer.tell have distinct operation identities.
All run_* handlers execute immediately; composition uses ordinary explicit
closures. WriterResult uses `value` consistently with StateResult. All 21 Basic
groups pass, including same-type environment, state and log composition and
fresh state on a subsequent run. The isolated filesystem host test also passes.

### Option and Result

Both types provide lazy recovery and effect-preserving sequencing. Result now
provides Mappable, Applicative and FlatMappable dictionaries. Application is
fail-fast with the value error taking priority. All 22 Basic groups pass.

### Association lists

set replaces all bindings for a key, puts the replacement first, and preserves
the relative order of other keys. bind is constant-time shadowing without an
Equal requirement. Duplicate binding, cardinality and deletion tests pass.

### Collection traversal

filter and find preserve callback effects. Construction, append, zip, folds and
flat_map use tail-recursive accumulation; reverse and reverse_append make costs
explicit. get returns Option; elem([], 0) reports the upper bound. Tests cover
effect order, early exit, 10,000-element maps/folds and 20,000-element append.

### Foundational capabilities and text

List, Option, Result and Tuple equality compares fields directly. Each has a
direct Debug provider; List renders bracketed elements. Document rendering uses
tail-recursive traversal and balanced fragment merging, with O(bytes * log
fragments) copying rather than quadratic prefix copying. String quoting uses
the same path. Skewed 10,000-fragment documents and quotes pass.

### Partial and total comparison

PartialCompare retains IEEE relational behavior; partial_compare returns None
for unordered pairs. TotalCompare returns a three-way Ordering. Numeric total
providers place all NaNs in one final equivalence class and identify signed
zeros. Both floating widths have NaN, infinity and signed-zero regressions.

### Numeric boundaries

Integer checked_div/rem return ArithmeticError; generic operators terminate
with Panic for invalid integer inputs. Floating divide remains available as a
pure named operation (generic / conservatively carries Panic). Float-to-I64,
Byte and I32 narrowing are checked; intentional truncation uses wrapping_from_i64.
Wrapping negation includes the minimum integer. Boundary and nonfinite tests pass.

### Host errors

Process execution returns Result: launch/protocol failure is separate from
ExitStatus, including nonzero exits. Output stays binary. Filesystem errors
retain operation, path and WASIp1 code. Adapters preserve these types. Build
validates UTF-8 before treating process output as text. Mock regressions and
real regular-file, directory, nonzero-exit, binary-output and missing-executable
checks all pass. Host protocol status is not mislabeled as native errno.

### Build planning and execution

Configuration explicitly selects the compiler and project root. Pure planning
rejects missing, duplicate and cyclic dependencies before creating directories
or compiling. Each step records only its transitive interface closure. Tests
cover an unrelated module, dependency order and configuration forwarding. The
real manifest compiled, linked and executed all 23 Basic groups. This exposed
and fixed a compiler slot-allocation bug on fatal paths; 1936 native tests pass.

### Public modules and ABI

Debug providers now live under Basic.Debug; numeric conversions live on data
modules. Applicative, Mappable and FlatMappable module names are explicit. Bytes
and Bool use module-relative operation names. Prelude hides derivation metadata,
and the empty Ref placeholder is removed. README and compiler-abi.md document
the canonical and raw-host seams. This also exposed and fixed hidden derive
constructor registration; all 1937 native tests pass.

### Text fragments and Writer

String.join and Writer log collection use balanced merging. Writer records
messages in order and reassociates only the pure monoid operation. A 1,000-message
String log and separator/empty-fragment regressions pass with all 23 groups.


### Final regression gates

The complete 24-group suite passes with both JIT and interpreter execution,
including effectful Loop predicates, break/continue, checked narrowing, direct
Result/Tuple capabilities, 10,000-element traversal and deep Document rendering.
Writer now returns each message to an outer driver before resuming its one-shot
continuation; a 1,000-message log uses bounded handler stack space. Same-payload
Reader/State/Writer composition and message order remain covered.

The manifest compiles and links the complete library, and the resulting
basic.wasm passes all 24 groups on both execution engines. Real host tests cover
filesystem, process and fatal integer arithmetic behavior. The test runner also
checks that an assertion failure exits unsuccessfully. The parent repository's
227-case example fixture and Explore smoke gate verify consumer compatibility.

Deep-input interpreter checks exposed two further compiler defects: recursive
reference destruction and missed tail calls through simplified return joins.
The compiler now drains destruction with an intrusive worklist and recognizes
those tail calls before ARC cleanup. Together with the fatal-path slot and hidden
derive-constructor fixes above, all 1,939 native compiler tests pass.
