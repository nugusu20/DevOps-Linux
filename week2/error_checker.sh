#!/bin/bash
# Week 2 – Task 4: Find & count ERROR entries in a log

if [ ! -f "access.log" ]; then
    echo "access.log not found!"
    exit 1
fi

echo "Lines containing ERROR:"
grep ERROR access.log

echo ""
echo "Number of lines with ERROR:"
grep -c ERROR access.log

echo ""
echo "Total ERROR occurrences:"
grep -o ERROR access.log | wc -l
