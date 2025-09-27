#!/bin/bash
set -e

echo "🧪 Running Rust tests..."
cd rust_core
cargo test
cd ..

echo "🧪 Running Dart tests..."
cd dart_core
flutter test
cd ..

echo "✅ All tests passed!"