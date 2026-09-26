#!/usr/bin/env bash
# Build the release Web version locally and serve it at http://localhost:8080.
# Output of every step is also written to build/preview.log.
set -uo pipefail
cd "$(dirname "$0")/.."
mkdir -p build
LOG=build/preview.log
: > "$LOG"

step() {
  echo "==> $*" | tee -a "$LOG"
  "$@" 2>&1 | tee -a "$LOG"
  local status=${PIPESTATUS[0]}
  echo "<== exit $status: $*" | tee -a "$LOG"
  return "$status"
}

step flutter pub get || exit 1
step flutter analyze
step flutter test
step flutter build web --release --no-web-resources-cdn || { echo "构建失败，日志见 $LOG"; exit 1; }
step python3 scripts/prepare_web.py || exit 1

echo "预览地址：http://localhost:8080 （按 Ctrl+C 结束）" | tee -a "$LOG"
cd build/web && exec python3 -m http.server 8080
