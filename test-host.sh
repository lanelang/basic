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
