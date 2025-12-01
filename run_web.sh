#!/bin/bash
# Run Flutter web on a fixed port to avoid redirect URI issues
# This ensures the app always runs on http://localhost:5000
cd "$(dirname "$0")"
flutter run -d chrome --web-hostname localhost --web-port 5000

