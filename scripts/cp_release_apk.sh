#!/bin/sh

CURRENT_DIR=`pwd -P`
OUTPUT_NAME="release_$1-$2.apk"
INPUT_DIR="$CURRENT_DIR/build/app/outputs/flutter-apk/app-release.apk"
OUTPUT_DIR="$CURRENT_DIR/release_apk/$OUTPUT_NAME"
echo "copy $INPUT_DIR to $OUTPUT_DIR"
cp $INPUT_DIR $OUTPUT_DIR
