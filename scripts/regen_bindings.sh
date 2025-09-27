#!/bin/bash
set -e

echo "🦀 Building Rust and regenerating C header..."
cd rust_core
cargo build
cd ..

echo "🎯 Regenerating Dart FFI bindings..."
cd dart_core
dart run ffigen --config ffigen.yaml
cd ..

echo "✅ Done! Bindings regenerated."
echo ""
echo "Next steps:"
echo "  cd example && flutter run"