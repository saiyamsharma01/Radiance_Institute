#!/bin/bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=========================================="
echo " Radiance Institute — Local Development"
echo "=========================================="
echo "To start services locally:"
echo ""
echo "1. Public Website (Next.js):"
echo "   cd $ROOT_DIR/apps/public_website && npm run dev"
echo ""
echo "2. Flutter Cross-Platform App (Chrome / Web Admin):"
echo "   cd $ROOT_DIR/apps/radiance_flutter && flutter run -d chrome"
echo ""
echo "3. Firebase Emulator Suite:"
echo "   cd $ROOT_DIR && firebase emulators:start --only auth,firestore,functions,storage"
echo ""
echo "=========================================="
