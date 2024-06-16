#!/bin/bash

# Base directory containing the HTML files (relative to the current working directory)
BASE_DIR="./src"

# Directories to store extracted components
HEADER_DIR="$BASE_DIR/headers"
FOOTER_DIR="$BASE_DIR/footers"
NAV_DIR="$BASE_DIR/navigation"

# Create directories for storing components if they do not exist
mkdir -p "$HEADER_DIR"
mkdir -p "$FOOTER_DIR"
mkdir -p "$NAV_DIR"

# Function to extract components from HTML files
extract_components() {
    local file="$1"
    local relative_path="${file#$BASE_DIR/}"
    local filename
    filename=$(basename "$relative_path" .htm)
    local dirname
    dirname=$(dirname "$relative_path")

    # Ensure the target directories exist
    mkdir -p "$HEADER_DIR/$dirname"
    mkdir -p "$FOOTER_DIR/$dirname"
    mkdir -p "$NAV_DIR/$dirname"

    # Debugging information
    echo "Processing file: $file"

    # Extract header
    awk '/<header>/,/<\/header>/' "$file" > "$HEADER_DIR/$dirname/$filename-header.html"
    if [ $? -eq 0 ]; then
        if [ -s "$HEADER_DIR/$dirname/$filename-header.html" ]; then
            echo "Header extracted to: $HEADER_DIR/$dirname/$filename-header.html"
        else
            echo "Header not found in: $file"
        fi
    else
        echo "Failed to extract header from: $file"
    fi

    # Extract footer
    awk '/<footer>/,/<\/footer>/' "$file" > "$FOOTER_DIR/$dirname/$filename-footer.html"
    if [ $? -eq 0 ]; then
        if [ -s "$FOOTER_DIR/$dirname/$filename-footer.html" ]; then
            echo "Footer extracted to: $FOOTER_DIR/$dirname/$filename-footer.html"
        else
            echo "Footer not found in: $file"
        fi
    else
        echo "Failed to extract footer from: $file"
    fi

    # Extract navigation
    awk '/<nav>/,/<\/nav>/' "$file" > "$NAV_DIR/$dirname/$filename-nav.html"
    if [ $? -eq 0 ]; then
        if [ -s "$NAV_DIR/$dirname/$filename-nav.html" ]; then
            echo "Navigation extracted to: $NAV_DIR/$dirname/$filename-nav.html"
        else
            echo "Navigation not found in: $file"
        fi
    else
        echo "Failed to extract navigation from: $file"
    fi
}

export -f extract_components

# Find and process all .htm files
find "$BASE_DIR" -type f -name "*.htm" -exec bash -c 'extract_components "$0"' {} \;

echo "Extraction process completed."
