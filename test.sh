#!/bin/bash

set -euo pipefail

lane_bin="${LANE_BIN:-lane}"
lane_path="$(command -v "$lane_bin")"
lane_dir="$(cd -- "$(dirname -- "$lane_path")" && pwd)"
lane_bin="$lane_dir/$(basename -- "$lane_path")"
export PATH="$lane_dir:$PATH"

run_test_entry() {
  "$lane_bin" run test/entry.lane:test_entry --lib-dir . --no-basic "$@"
}

run_test_entry
run_test_entry --no-jit

set +e
"$lane_bin" run test/failing_entry.lane:test_entry --lib-dir . --no-basic >/dev/null
failing_test_status=$?
set -e

if [[ "$failing_test_status" -ne 1 ]]; then
  echo "expected the failing test entry to exit with status 1, got $failing_test_status" >&2
  exit 1
fi
