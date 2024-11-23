#!/bin/bash

BASE_DIR=./osc

# Function to check if the file has the correct extension
check_extension() {
  for file in $(find $BASE_DIR -type f -name "*.markdown"); do
    echo "Error: '$file' has the incorrect extension '.markdown'. It should be '.md'."
    exit 1
  done
}

# Function to check if markdown files in _posts have the required front matter
check_front_matter() {
  for file in $(find $BASE_DIR/_posts -type f -name "*.md"); do
    echo "Checking front matter for: $file"
    if ! grep -q "^layout: post" "$file"; then
      echo "Error: 'layout: post' is missing in the front matter of '$file'."
      exit 1
    fi
    if ! grep -q "^date:" "$file"; then
      echo "Error: 'date' is missing in the front matter of '$file'."
      exit 1
    fi
    if ! grep -q "^title:" "$file"; then
      echo "Error: 'title' is missing in the front matter of '$file'."
      exit 1
    fi
    if ! grep -q "^category:" "$file"; then
      echo "Error: 'category' is missing in the front matter of '$file'."
      exit 1
    fi
  done
}

# Function to check if the categories are valid
check_categories() {
  valid_categories=("news" "diary" "release")
  
  for file in $(find $BASE_DIR/_posts -type f -name "*.md"); do
    category=$(grep "^category:" "$file" | sed 's/category: //')
    
    if [[ ! " ${valid_categories[@]} " =~ " ${category} " ]]; then
      echo "Error: Invalid category '$category' in '$file'. Only 'news', 'diary', or 'release' are allowed."
      exit 1
    fi
  done
}

# Function to check markdown formatting (using markdownlint or similar)
check_formatting() {
  for file in $(find $BASE_DIR -type f -name "*.md"); do
    # Using markdownlint to check file formatting
    markdownlint "$file"
    if [ $? -ne 0 ]; then
      echo "Error: Formatting issue detected in '$file'. Please fix the markdown issues."
      exit 1
    fi
  done
}

# Run all checks
check_extension
check_front_matter
check_categories
check_formatting

echo "All checks passed successfully!"
