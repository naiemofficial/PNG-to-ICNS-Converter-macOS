#!/bin/bash
# Functions
update_basename_if_exists() {
  local basename="$1"
  local extension="icns"
  local original_basename="$basename"
  local count=1

  # Loop until a unique name is found
  while [ -e "${basename}.${extension}" ]; do
    basename="${original_basename} - $count"
    ((count++))
  done

  echo "$basename"
}

# Go to the Target Directory (create if it doesn't exist)
TARGET_DIR=~/Documents/Automator/"PNG to ICNS"
mkdir -p "$TARGET_DIR" && cd "$TARGET_DIR" 

# Read the input file path from stdin
# read INPUT_FILE
while IFS= read -r INPUT_FILE; do
    # Extract the basename (without extension) for use in folder and output file names
    BASENAME=$(basename "$INPUT_FILE" .png)
    ORIGINAL_BASENAME="$BASENAME"


    # Check if the input file (BASENAME.icns) exists then update BASENAME with the new name
    if [ -e "${BASENAME}.icns" ]; then
    BASENAME=$(update_basename_if_exists "$BASENAME")
    fi




    # Create a folder for the iconset
    ICONSET_FOLDER="${BASENAME}.iconset"
    mkdir "$ICONSET_FOLDER"

    # Resize the images and create the iconset
    sips -z 16 16     "$INPUT_FILE" --out "${ICONSET_FOLDER}/icon_16x16.png"
    sips -z 32 32     "$INPUT_FILE" --out "${ICONSET_FOLDER}/icon_16x16@2x.png"
    sips -z 32 32     "$INPUT_FILE" --out "${ICONSET_FOLDER}/icon_32x32.png"
    sips -z 64 64     "$INPUT_FILE" --out "${ICONSET_FOLDER}/icon_32x32@2x.png"
    sips -z 128 128   "$INPUT_FILE" --out "${ICONSET_FOLDER}/icon_128x128.png"
    sips -z 256 256   "$INPUT_FILE" --out "${ICONSET_FOLDER}/icon_128x128@2x.png"
    sips -z 256 256   "$INPUT_FILE" --out "${ICONSET_FOLDER}/icon_256x256.png"
    sips -z 512 512   "$INPUT_FILE" --out "${ICONSET_FOLDER}/icon_256x256@2x.png"
    sips -z 512 512   "$INPUT_FILE" --out "${ICONSET_FOLDER}/icon_512x512.png"

    # Copy the 512x512 image to create the @2x version
    cp "$INPUT_FILE"  "${ICONSET_FOLDER}/icon_512x512@2x.png"

    # Remove the original image
    rm -rf "${ORIGINAL_BASENAME}.png"

    # Create the .icns file
    iconutil -c icns "${ICONSET_FOLDER}"

    # Remove the temporary folder
    rm -R "${ICONSET_FOLDER}"
done 