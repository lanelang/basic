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
run_test_entry --no-jit
