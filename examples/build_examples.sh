#!/bin/sh

# Find every V file in the examples directory and build it

# Exit on error
set -e

# Find all V files in the examples directory
files=$(find . -name "*.v")

# Make a directory to store the built files
mkdir -p bin

# Build each file
for file in $files; do
    echo "Building $file"
    v -prod -gc none -skip-unused -o bin/$(basename $file .v) $file
done
