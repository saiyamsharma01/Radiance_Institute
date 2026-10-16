#!/bin/bash
set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=========================================="
echo " Radiance Institute — Master Test Suite"
echo "=========================================="

echo ""
echo ">>> [1/2] Running Cloud Functions Tests (TypeScript & Jest)..."
cd "$ROOT_DIR/functions"
npm test

echo ""
echo ">>> [2/2] Running Flutter Unit & Widget Tests..."
cd "$ROOT_DIR/apps/radiance_flutter"
flutter test

echo ""
echo "=========================================="
echo " All Master Test Suites Passed! (100% OK)"
echo "=========================================="
