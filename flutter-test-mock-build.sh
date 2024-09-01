#!/bin/bash
echo "Cleaning the Flutter project..."
flutter clean
echo "Getting Flutter packages..."
flutter pub get
echo "Flutter clean and pub get completed!"
flutter pub run build_runner build
echo "Flutter mock data generated!"
flutter test
echo "Test completed!"
