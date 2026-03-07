#!/bin/bash
set -e

# Install Flutter
git clone https://github.com/flutter/flutter.git --depth 1 -b stable /opt/flutter
export PATH="/opt/flutter/bin:$PATH"

# Build
flutter pub get
flutter build web --release
