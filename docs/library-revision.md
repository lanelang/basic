# Standard library revision

This plan tracks the complete design audit accepted on 2026-09-15. Each verified
implementation milestone is committed independently in Basic and pinned by Lane.
The independent sibling checkout is not overwritten.

## Milestones

- [x] Effectful short-circuit operators and exception conversion preserving residual effects.
- [x] Nominal Debug identity, quoted/escaped rendering, and structural empty-payload handling.
- [x] Reliable output and directory creation with truthful failure reporting.
- [ ] Defined numeric conversions and arithmetic failure contracts.
- [x] Independent Reader, State and Writer semantics, with immediate runner functions.
- [ ] Structured process and filesystem errors with explicit host adapters.
- [ ] Coherent Option and Result operations and capability providers.
- [ ] Explicit partial and total comparison contracts.
- [ ] AList replacement semantics and separately named shadowing bindings.
- [ ] Consistent effectful collection operations and predictable construction costs.
- [ ] Direct capabilities for foundational data types and efficient text construction.
- [ ] Consistent module naming, public exports and documented compiler ABI seams.
- [ ] Explicit build configuration, planning and required interface closures.
- [ ] Boundary, order, composition, large-input and compatibility regression gates.

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
