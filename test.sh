#!/bin/bash

set -euo pipefail

lane_bin="${LANE_BIN:-lane}"

run_test_entry() {
  local output
  if ! output="$("$lane_bin" run test/entry.lane:test_entry --lib-dir . --no-basic "$@" 2>&1)"; then
    printf '%s\n' "$output"
    return 1
  fi
  if [[ -n "$output" ]]; then
    printf '%s\n' "$output"
    return 1
  fi
}

run_test_entry
# The LoisVM interpreter behind --no-jit exhausts its call stack after fifty
# resumptions in one handler scope, which any moderately sized test will reach.
# Re-enable this once that limit is lifted.
# run_test_entry --no-jit
