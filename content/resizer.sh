#!/bin/bash

# Check if a folder was passed as an argument, if not, use the current directory
if [ -n "$1" ]; then
    SOURCE_FOLDER="$1"
else
    SOURCE_FOLDER="$(pwd)"
fi

# Define the target width (for resizing). Adjust this value as needed.
TARGET_WIDTH=1920

# Create a folder for the converted files
CONVERTED_FOLDER="$SOURCE_FOLDER/converted"
mkdir -p "$CONVERTED_FOLDER"

# Process each image in the folder
for file in "$SOURCE_FOLDER"/*; do
    if [[ -f "$file" ]]; then
        # Get the file extension
        EXTENSION="${file##*.}"
        
        # For PNG files, compress using pngquant
        if [[ "$EXTENSION" == "png" ]]; then
            # Compress the PNG file using pngquant and save to the converted folder
            pngquant --quality=70 --output "$CONVERTED_FOLDER/$(basename "$file")" "$file"
        
        # For JPG files, just resize and compress with ImageMagick (using "magick")
        elif [[ "$EXTENSION" == "jpg" || "$EXTENSION" == "jpeg" ]]; then
            magick "$file" -resize "$TARGET_WIDTH" -quality 85 "$CONVERTED_FOLDER/$(basename "$file")"
        fi
    fi
done

echo "Compression and conversion completed. Check the 'converted' folder."