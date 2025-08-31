#!/bin/bash
# Week 2 – Task 3 (Bonus): Pretty table of files and sizes in KB

printf "%-30s %10s\n" "Filename" "Size(KB)"
printf "%-30s %10s\n" "------------------------------" "--------"

for file in *; do
  if [ -f "$file" ]; then
    size=$(du -k "$file" | cut -f1)
    printf "%-30s %10s\n" "$file" "$size"
  fi
done
