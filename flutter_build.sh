#!/bin/bash

# Get today's date in YYYYMMDD format
today=$(date +%Y%m%d)
read -p "Enter build number for today: " build
read -p "Enter the build name : " build_name
version="${today}$(printf "%02d" $build)"

echo "Build version: $build_name $version"

fvm flutter build appbundle --release --flavor "regression" \
  --build-number "$version" --build-name "$build_name" \
  --dart-define="version=$build_name" \
  --obfuscate --split-debug-info=build/flutter_mapping
