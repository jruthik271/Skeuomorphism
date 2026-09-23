#!/bin/bash
set -e

echo "=============================================="
echo " Starting Flutter Web Build on Vercel"
echo "=============================================="

# 1. Download Flutter SDK (shallow clone stable branch)
if [ ! -d "_flutter" ]; then
  echo "Cloning Flutter stable SDK..."
  git clone https://github.com/flutter/flutter.git --depth 1 -b stable _flutter
else
  echo "Flutter directory already exists."
fi

# 2. Add Flutter to PATH
export PATH="$PATH:$(pwd)/_flutter/bin"

# 3. Disable telemetry and verify installation
flutter config --no-analytics
flutter --version

# 4. Resolve Dart dependencies
echo "Resolving dependencies..."
flutter pub get

# 5. Build Flutter Web for production
echo "Compiling Flutter Web release bundle..."
flutter build web --release

echo "=============================================="
echo " Flutter Web build complete! Output in build/web"
echo "=============================================="
