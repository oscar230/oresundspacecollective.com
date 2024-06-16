#!/bin/bash

# Base directory containing the HTML files (relative to the current working directory)
BASE_DIR="./src"

# Directory to store Svelte components
COMPONENTS_DIR="./src/components"

# Create directories for storing components if they do not exist
mkdir -p "$COMPONENTS_DIR"

# Function to extract components from HTML files and create Svelte components
extract_svelte_components() {
    local file="$1"
    local relative_path="${file#$BASE_DIR/}"
    local filename
    filename=$(basename "$relative_path" .htm)

    # Debugging information
    echo "Processing file: $file"

    # Extract header and create Svelte component
    awk '/<header[^>]*>/,/<\/header>/' "$file" > "$COMPONENTS_DIR/Header.svelte"
    if [ $? -eq 0 ] && [ -s "$COMPONENTS_DIR/Header.svelte" ]; then
        echo "<script>
    export let title = 'Default Title';
</script>

<svelte:head>
    <title>{title}</title>
</svelte:head>
$(cat "$COMPONENTS_DIR/Header.svelte")" > "$COMPONENTS_DIR/Header.svelte"
        echo "Header component created: $COMPONENTS_DIR/Header.svelte"
    else
        echo "Header not found in: $file"
    fi

    # Extract footer and create Svelte component
    awk '/<footer[^>]*>/,/<\/footer>/' "$file" > "$COMPONENTS_DIR/Footer.svelte"
    if [ $? -eq 0 ] && [ -s "$COMPONENTS_DIR/Footer.svelte" ]; then
        echo "<script>
    export let footerText = 'Default Footer Text';
</script>

$(cat "$COMPONENTS_DIR/Footer.svelte")" > "$COMPONENTS_DIR/Footer.svelte"
        echo "Footer component created: $COMPONENTS_DIR/Footer.svelte"
    else
        echo "Footer not found in: $file"
    fi

    # Extract navigation and create Svelte component
    awk '/<nav[^>]*>/,/<\/nav>/' "$file" > "$COMPONENTS_DIR/Nav.svelte"
    if [ $? -eq 0 ] && [ -s "$COMPONENTS_DIR/Nav.svelte" ]; then
        echo "Navigation component created: $COMPONENTS_DIR/Nav.svelte"
    else
        echo "Navigation not found in: $file"
    fi
}

export -f extract_svelte_components

# Find and process all .htm files
find "$BASE_DIR" -type f -name "*.htm" -exec bash -c 'extract_svelte_components "$0"' {} \;

echo "Svelte component extraction process completed."
