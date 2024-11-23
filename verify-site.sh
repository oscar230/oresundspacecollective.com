#!/bin/bash

BASE_DIR=./osc

# Initialize an empty array to store error messages
errors=()

# Function to check if the file has the correct extension
check_extension() {
  for file in $(find "$BASE_DIR" -type f -name "*.markdown"); do
    errors+=("File '$file' should have a .md extension, .markdown extension is not allowed.")
  done
  for file in $(find "$BASE_DIR/_posts" -type f ! -name "*.md"); do
    errors+=("File '$file' should have a .md extension.")
  done
}

# Function to check if markdown files in _posts have the required front matter
check_front_matter() {
  for file in $(find "$BASE_DIR/_posts" -type f -name "*.md"); do
    # Check for layout: post
    if ! grep -q "^layout: post" "$file"; then
      errors+=("File '$file' is missing 'layout: post'.")
    fi
    
    # Check for a date
    if ! grep -q "^date: [0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}" "$file"; then
      errors+=("File '$file' is missing a valid date (YYYY-MM-DD).")
    fi

    # Check for a title
    if ! grep -q "^title:" "$file"; then
      errors+=("File '$file' is missing a 'title' field.")
    fi

    # Check for a category
    if ! grep -q "^category:" "$file"; then
      errors+=("File '$file' is missing a 'category' field.")
    fi
  done
}

# Function to check if the categories are valid
check_categories() {
  valid_categories=("news" "diary" "release")
  
  for file in $(find "$BASE_DIR/_posts" -type f -name "*.md"); do
    # Extract the category field and trim leading/trailing spaces
    category=$(grep "^category:" "$file" | sed 's/category:[[:space:]]*//')
    # Check category
    if [[ ! " ${valid_categories[@]} " =~ " ${category} " ]]; then
      errors+=("File '$file' has an invalid category '$category'. Allowed categories: ${valid_categories[*]}")
    fi
  done
}

# Function to check markdown formatting (using markdownlint or similar)
check_formatting() {
  for file in $(find "$BASE_DIR" -type f -name "*.md"); do
    # Using markdownlint to check file formatting
    lint_output=$(markdownlint "$file" 2>&1)
    if [ $? -ne 0 ]; then
      errors+=("File '$file' has markdownlint issues:\n$lint_output")
    fi
  done
}

# Check markdown links validity
check_links() {
  for file in $(find "$BASE_DIR" -type f -name "*.md"); do
    echo "Checking links in $file..."
    lint_output=$(markdown-link-check "$file" 2>&1)
    if [ $? -ne 0 ]; then
      errors+=("File '$file' contains invalid links:\n$lint_output")
    fi
  done
}

# Run all checks
check_extension
check_front_matter
check_categories
check_formatting
check_links

# If there are errors, print them and exit with a failure status
if [ ${#errors[@]} -ne 0 ]; then
  echo "The following errors were found:"
  for error in "${errors[@]}"; do
    echo "- $error"
  done
  exit 1
else
  echo "All checks passed successfully."
fi