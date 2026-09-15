#!/usr/bin/env bash
set -euo pipefail
basic_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
lane_bin="$(command -v "${LANE_BIN:-lane}")"
lane_bin="$(cd -- "$(dirname -- "$lane_bin")" && pwd)/$(basename -- "$lane_bin")"
case_dir="$(mktemp -d)"
trap 'rm -rf -- "$case_dir"' EXIT
printf 'regular file\n' > "$case_dir/existing-file"
cd "$case_dir"
"$lane_bin" run "$basic_root/test/system/file_system_host.lane:main" --no-basic --lib-dir "$basic_root"
test -d "$case_dir/created-directory"
"$lane_bin" run "$basic_root/test/system/process_host.lane:main" --no-basic --lib-dir "$basic_root"

"$lane_bin" run "$basic_root/test/system/arithmetic_host.lane:valid" --no-basic --lib-dir "$basic_root"
for entry in divide_zero divide_overflow remainder_zero divide_i32_overflow; do
  if "$lane_bin" run "$basic_root/test/system/arithmetic_host.lane:$entry" --no-basic --lib-dir "$basic_root" > "$case_dir/fatal.log" 2>&1; then
    echo "expected arithmetic Panic from $entry" >&2
    exit 1
  else
    status=$?
  fi
  test "$status" -eq 1
  case "$(cat "$case_dir/fatal.log")" in
    *'error[E6013]: WebAssembly execution failed'*'unreachable'*) ;;
    *) cat "$case_dir/fatal.log" >&2; exit 1 ;;
  esac
done
echo "arithmetic host checks passed"
