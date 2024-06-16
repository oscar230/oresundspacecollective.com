#!/bin/bash

# Base directory containing the HTML files
BASE_DIR="./src"

# Directories to store extracted components
HEADER_DIR="$BASE_DIR/headers"
FOOTER_DIR="$BASE_DIR/footers"
NAV_DIR="$BASE_DIR/navigation"

mkdir -p $HEADER_DIR
mkdir -p $FOOTER_DIR
mkdir -p $NAV_DIR

# Function to extract components from HTML files
extract_components() {
    local file=$1
    local relative_path=${file#$BASE_DIR/}
    local filename=$(basename "$relative_path" .htm)
    local dirname=$(dirname "$relative_path")

    mkdir -p "$HEADER_DIR/$dirname"
    mkdir -p "$FOOTER_DIR/$dirname"
    mkdir -p "$NAV_DIR/$dirname"

    # Extract header
    awk '/<header>/,/<\/header>/' "$file" > "$HEADER_DIR/$dirname/$filename-header.html"

    # Extract footer
    awk '/<footer>/,/<\/footer>/' "$file" > "$FOOTER_DIR/$dirname/$filename-footer.html"

    # Extract navigation
    awk '/<nav>/,/<\/nav>/' "$file" > "$NAV_DIR/$dirname/$filename-nav.html"
}

export -f extract_components

# Find and process all .htm files
find $BASE_DIR -type f -name "*.htm" -exec bash -c 'extract_components "$0"' {} \;
