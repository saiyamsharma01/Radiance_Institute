#!/bin/bash
set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=========================================="
echo " Radiance Institute — Master Build Script"
echo "=========================================="

echo ""
echo ">>> [1/3] Compiling Cloud Functions (TypeScript)..."
cd "$ROOT_DIR/functions"
npm run build

echo ""
echo ">>> [2/3] Building Public Website (Next.js SSG)..."
cd "$ROOT_DIR/apps/public_website"
npm run build

echo ""
echo ">>> [3/3] Building Flutter Web Admin Dashboard..."
cd "$ROOT_DIR/apps/radiance_flutter"
flutter build web --release

echo ""
echo "=========================================="
echo " Master Build Completed Successfully!"
echo "=========================================="
