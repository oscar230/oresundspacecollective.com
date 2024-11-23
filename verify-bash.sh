#!/bin/bash

SCRIPT_TO_TEST=$1

# Test the script for syntax errors
echo "Testing $SCRIPT_TO_TEST for syntax errors..."
bash -n "$SCRIPT_TO_TEST"
if [ $? -ne 0 ]; then
  echo "Syntax errors found in $SCRIPT_TO_TEST. Aborting."
  exit 1
else
  echo "$SCRIPT_TO_TEST passed syntax check."
fi

# If syntax check passes, run the script
echo "Running $SCRIPT_TO_TEST..."
bash "$SCRIPT_TO_TEST"
