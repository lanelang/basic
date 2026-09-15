# Lane Basic Library

Basic supplies Lane's operators, data types, effects, formatting and host
adapters. Most of it is ordinary Lane source. A small set of declarations is a
compiler ABI and must retain its canonical name and shape; see
[the ABI boundary](docs/compiler-abi.md).

Import `Basic.Prelude.*` for operators, primitive capability dictionaries and
common data types. Debug providers live in `Basic.Debug.*`; conversions live
on `Basic.Data.*`. Prelude includes primitive Debug dictionaries, while
generic collection dictionaries are selected explicitly. Custom derivation
machinery and its representation metadata are exposed by `Basic.Derive`.
Prelude retains ordinary derive providers without exporting Product, Sum or
metadata records.

- `Option` represents absence; `Result` preserves an error value. Lazy fallback
  and sequencing operations preserve callback effects.
- `PartialCompare` preserves unordered comparisons. `TotalCompare` is suitable
  for sorting; its equality can differ from `==`. Floating total order puts
  all NaNs last and treats signed zeros as equal.
- Integer addition, subtraction, multiplication and negation wrap. Integer
  division and remainder offer recoverable `checked_*` operations; operators
  carry `Panic`. Pure IEEE division is also available as `F32.divide/F64.divide`.
  Narrowing conversions are checked; intentional truncation uses `wrapping_*`.
- Strings are valid UTF-8. Positions count Unicode scalars, not grapheme
  clusters. Repeated scalar indexing is not a traversal API: use `foldl`.
  Bytes are arbitrary immutable data; their module exposes checked
  `make/get/set/slice` operations.
- List traversal is left to right except strict `foldr`, whose callbacks run
  right to left. `append` and `push_tail` cost linear time in the first list.
  Repeated construction should use `cons` and `reverse`. AList `set` replaces
  all prior bindings; `bind` explicitly adds a shadowing binding.
- Reader, State and Writer have distinct effects, even for the same payload
  type. All `run_*` handlers execute immediately.
- `try_println` returns output errors; `println` is explicitly fatal on failure.
  Process launch failures are separate from exit statuses. Captured output
  remains bytes. Filesystem errors retain operation, path and WASIp1 errno;
  directory creation is non-recursive.
- `Basic.Platform.Wasip1` and `Basic.Wasm.Abi` are low-level host bindings.
  Domain code should use the higher-level adapters.

`Basic.Build.Plan` validates a complete inspected source graph without effects.
`Basic.Build.build(project, configuration)` inspects, plans and executes it.
Configuration selects the compiler executable and project root; relative paths
are resolved from that root. The artifact directory's parent must exist.
Only the required transitive interfaces are passed to each compile command.
`Basic.Build.Inspection` decodes the compiler's versioned inspection projection,
not arbitrary JSON.

Run checks with the compiler paired with this revision:

```sh
LANE_BIN=/path/to/lane bash test.sh
LANE_BIN=/path/to/lane bash test-host.sh
PATH=/path/to/compiler/bin:$PATH lane run build.lane:build --no-basic --lib-dir .
lane exec basic.wasm:test
```

`test.sh` runs all groups with both JIT and interpreter execution, then checks
that a failing test exits unsuccessfully. `test-host.sh` exercises real filesystem,
process and arithmetic failure boundaries in a temporary directory.

The manifest uses `default_configuration()` (`lane` on PATH, root `.`).
Applications can supply their own configuration. The parent Lane repository
pins this Basic revision; updating an independent checkout is a separate action.
