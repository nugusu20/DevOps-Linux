#!/bin/bash
# Week 2 – Task 5: Print a column from a CSV file (defaults: file=data.csv, column=2)

file="${1:-data.csv}"
col="${2:-2}"

if [ ! -f "$file" ]; then
  echo "Error: '$file' not found." >&2
  exit 1
fi

awk -F, -v c="$col" 'NR>1 {print $c}' "$file"
