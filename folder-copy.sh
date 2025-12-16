#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <source_base> <destination_path> <folder_list.txt>"
    exit 1
fi

SOURCE_BASE="$1"
DESTINATION="$2"
FOLDER_LIST="$3"

# Validate source and folder list
if [ ! -d "$SOURCE_BASE" ]; then
    echo "Source directory does not exist: $SOURCE_BASE"
    exit 1
fi

if [ ! -f "$FOLDER_LIST" ]; then
    echo "Folder list file not found: $FOLDER_LIST"
    exit 1
fi

mkdir -p "$DESTINATION"

# Loop through each folder in the list
while IFS= read -r folder || [ -n "$folder" ]; do
    SRC="$SOURCE_BASE/$folder"
    DST_FOLDER="$DESTINATION/$folder"

    if [ ! -d "$SRC" ]; then
        echo "Skipping \"$folder\" – source folder not found."
        continue
    fi

    if [ -d "$DST_FOLDER" ]; then
        echo "Skipping \"$folder\" – already exists in destination."
        continue
    fi

    echo "Copying \"$folder\"..."
    rsync -a --no-perms --no-owner --no-group --no-times --omit-dir-times --inplace --progress "$SRC" "$DESTINATION/"
done < "$FOLDER_LIST"
