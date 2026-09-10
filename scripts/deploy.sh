#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
flutter pub get
flutter analyze
flutter test
flutter build web --release --no-web-resources-cdn
wrangler pages deploy build/web --project-name cityu-toolbox --branch main
