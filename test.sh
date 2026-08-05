#!/bin/bash

set -euo pipefail

lane_bin="${LANE_BIN:-lane}"

run_test_entry() {
  "$lane_bin" run test/entry.lane:test_entry --lib-dir . --no-basic "$@"
}

run_test_entry
# run_test_entry --no-jit
