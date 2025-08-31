#!/bin/bash

echo "Filename      Size(KB)"
echo "-----------------------"

for file in *; do
    if [ -f "$file" ]; then
        size=$(du -k "$file" | cut -f1)
        echo "$file        $size"
    fi
done
