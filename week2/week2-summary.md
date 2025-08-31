# Week 2 – Shell Scripting Basics

In Week 2 we practiced creating and running simple Bash scripts.  
The main goal was to understand how DevOps engineers automate daily tasks such as printing messages, checking files, listing directory contents, searching logs, and extracting columns from CSV files.  
Each task builds a foundation for real-world DevOps work.

---

## Task 1 – Hello DevOps
Goal: Learn how to write the most basic Bash script and make it executable.  

Script (hello_devops.sh):
#!/bin/bash
echo "Hello DevOps"

Run:
./hello_devops.sh

Expected Output:
Hello DevOps

---

## Task 2 – File & Directory Checker
Goal: Practice using conditions (if/else) and file tests (-f, -d).  

Script (file_checker.sh):
#!/bin/bash
if [ -f "$1" ]; then
  echo "$1 is a file."
elif [ -d "$1" ]; then
  echo "$1 is a directory."
else
  echo "$1 does not exist."
fi

Run Examples:
./file_checker.sh hello_devops.sh
./file_checker.sh /etc
./file_checker.sh not_exists.txt

Expected Output:
hello_devops.sh is a file.
/etc is a directory.
not_exists.txt does not exist.

---

## Task 3 – List Files with Sizes
Goal: Use loops and printf formatting to create a readable table of files and sizes.  

Script (list_files_pretty.sh):
#!/bin/bash
printf "%-30s %10s\n" "Filename" "Size(KB)"
printf "%-30s %10s\n" "------------------------------" "--------"

for file in *; do
  if [ -f "$file" ]; then
    size=$(du -k "$file" | cut -f1)
    printf "%-30s %10s\n" "$file" "$size"
  fi
done

Run:
./list_files_pretty.sh

Expected Output Example:
Filename                         Size(KB)
------------------------------   --------
hello_devops.sh                         4
file_checker.sh                         4
list_files_pretty.sh                    4

---

## Task 4 – Search for ERROR in Logs
Goal: Learn how to search and count errors in log files using grep.  

Log file (access.log example):
200 OK
404 ERROR: Not Found
500 ERROR: Server Error
ERROR: Unauthorized access

Script (error_checker.sh):
#!/bin/bash
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

Run:
./error_checker.sh

Expected Output:
Lines containing ERROR:
404 ERROR: Not Found
500 ERROR: Server Error
ERROR: Unauthorized access

Number of lines with ERROR:
3

Total ERROR occurrences:
3

---

## Task 5 – AWK Column Extractor
Goal: Use awk to extract specific columns from CSV files.  

Data file (data.csv):
id,name,score
1,Alice,88
2,Bob,92
3,Charlie,75
4,Dina,81
5,Ed,95

Script (awk_column_extractor.sh):
#!/bin/bash
file="${1:-data.csv}"
col="${2:-2}"

if [ ! -f "$file" ]; then
  echo "Error: '$file' not found."
  exit 1
fi

awk -F, -v c="$col" 'NR>1 {print $c}' "$file"

Run:
./awk_column_extractor.sh data.csv 2

Expected Output:
Alice
Bob
Charlie
Dina
Ed

---

## ✅ Summary of Week 2
In this week we learned:
- How to create and run Bash scripts (#/bin/bash, chmod +x).  
- How to use conditions to check files and directories.  
- How to loop through files and display results in a formatted table.  
- How to filter and count errors in log files using grep.  
- How to extract specific columns from CSV files using awk.  

These are essential building blocks for automation in DevOps.  
They will be reused later when working with GitHub Actions, Docker, Kubernetes, and other tools.

