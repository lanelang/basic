#!/bin/bash

set -euo pipefail

lane_bin="${LANE_BIN:-lane}"

run_test_entry() {
  local output
  local expected_test_count=11
  if ! output="$("$lane_bin" run test/entry.lane:test_entry --lib-dir . --no-basic "$@" 2>&1)"; then
    printf '%s\n' "$output"
    return 1
  fi
  local ok_count=0
  local summary_seen=0
  while IFS= read -r line; do
    if [[ "$summary_seen" -ne 0 ]]; then
      printf '%s\n' "$output"
      return 1
    fi
    if [[ "$line" == "ok" ]]; then
      ((ok_count += 1))
    elif [[ "$ok_count" -eq "$expected_test_count" && "$line" == "Tests passed: ${expected_test_count}, failed: 0" ]]; then
      ((summary_seen = 1))
    else
      printf '%s\n' "$output"
      return 1
    fi
  done <<< "$output"
  if [[ "$summary_seen" -eq 0 ]]; then
    printf '%s\n' "$output"
    return 1
  fi
}

run_test_entry
# The interpreter is intentionally excluded from this library gate because it
# is substantially slower; Lane's compiler suite covers it separately.
# run_test_entry --no-jit
