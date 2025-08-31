#!/bin/bash
# Week 2 – Task 2: Checks if path is file/dir/not-exist

if [ -f "$1" ]; then
    echo "$1 is a file."
elif [ -d "$1" ]; then
    echo "$1 is a directory."
else
    echo "$1 does not exist."
fi
