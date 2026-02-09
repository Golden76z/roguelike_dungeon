#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "=== Roguelike Dungeon – Setup ==="

if ! command -v flutter >/dev/null 2>&1; then
  echo "ERROR: Flutter is not installed or not on PATH."
  echo "Please install Flutter and ensure 'flutter' is available, then re-run this script."
  exit 1
fi

echo "-> Flutter version:"
flutter --version

echo
echo "-> Running flutter pub get..."
flutter pub get

echo
echo "-> Running static analysis (flutter analyze)..."
flutter analyze || {
  echo
  echo "WARN: flutter analyze reported issues. You can still run the app, but it's recommended to fix them."
}

echo
echo "-> (Optional) Running tests..."
if flutter test; then
  echo "Tests passed."
else
  echo "WARN: Some tests failed (or there are no tests yet)."
fi

echo
echo "Setup complete."
echo "You can now run the game with:"
echo "  cd \"$PROJECT_ROOT\" && flutter run"

