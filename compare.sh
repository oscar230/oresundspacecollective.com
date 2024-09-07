#!/bin/bash

# Directories to compare
DIR1="/path/to/directory1"
DIR2="/path/to/directory2"

# Find all files (recursively) in both directories, extract filenames without the path
files_in_dir1=$(find "$DIR1" -type f -exec basename {} \;)
files_in_dir2=$(find "$DIR2" -type f -exec basename {} \;)

echo "Files with the same name in both directories:"

# Compare file names
for file in $files_in_dir1; do
    if echo "$files_in_dir2" | grep -q "^$file$"; then
        echo "$file"
    fi
done
