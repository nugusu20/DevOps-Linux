# 📗 Week 2 – Shell Scripting Basics

In Week 2 we practiced creating and running simple Bash scripts.  
The goal is to build habits that are used daily in DevOps: printing messages, checking files, looping, searching logs, and parsing data.

---

## 📝 Task 1 – Hello DevOps
**Goal:** Write the most basic Bash script and run it.

### Script (`hello_devops.sh`)
```bash
#!/bin/bash
echo "Hello DevOps"
```

### Run
```bash
chmod +x hello_devops.sh
./hello_devops.sh
```

### Expected Output
```
Hello DevOps
```

---

## 📂 Task 2 – File & Directory Checker
**Goal:** Use conditions (`if/elif/else`) and file tests (`-f`, `-d`).

### Script (`file_checker.sh`)
```bash
#!/bin/bash
# Week 2 – Task 2: Checks if path is file/dir/not-exist
if [ -f "$1" ]; then
  echo "$1 is a file."
elif [ -d "$1" ]; then
  echo "$1 is a directory."
else
  echo "$1 does not exist."
fi
```

### Run (examples)
```bash
./file_checker.sh hello_devops.sh
./file_checker.sh /etc
./file_checker.sh not_exists.txt
```

### Expected Output
```
hello_devops.sh is a file.
/etc is a directory.
not_exists.txt does not exist.
```

---

## 📊 Task 3 – List Files with Sizes
**Goal:** Loop over files and print a **formatted table**.

### Script (`list_files_pretty.sh`)
```bash
#!/bin/bash
# Week 2 – Task 3 (Bonus): Pretty table of files and sizes (KB)

printf "%-30s %10s\n" "Filename" "Size(KB)"
printf "%-30s %10s\n" "------------------------------" "--------"

for file in *; do
  if [ -f "$file" ]; then
    size=$(du -k "$file" | cut -f1)
    printf "%-30s %10s\n" "$file" "$size"
  fi
done
```

### Run
```bash
chmod +x list_files_pretty.sh
./list_files_pretty.sh
```

### Example Output
```
Filename                         Size(KB)
------------------------------   --------
hello_devops.sh                         4
file_checker.sh                         4
list_files_pretty.sh                    4
```

---

## 🔎 Task 4 – Search for `ERROR` in Logs
**Goal:** Use `grep` to filter and count errors in logs.

### Sample log (`access.log`)
```
200 OK
404 ERROR: Not Found
500 ERROR: Server Error
ERROR: Unauthorized access
```

### Script (`error_checker.sh`)
```bash
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
```

### Run
```bash
chmod +x error_checker.sh
./error_checker.sh
```

### Expected Output
```
Lines containing ERROR:
404 ERROR: Not Found
500 ERROR: Server Error
ERROR: Unauthorized access

Number of lines with ERROR:
3

Total ERROR occurrences:
3
```

---

## 📑 Task 5 – AWK Column Extractor
**Goal:** Use `awk` to extract a specific CSV column.

### Data (`data.csv`)
```
id,name,score
1,Alice,88
2,Bob,92
3,Charlie,75
4,Dina,81
5,Ed,95
```

### Script (`awk_column_extractor.sh`)
```bash
#!/bin/bash
# Week 2 – Task 5: Extract CSV column (default col=2)
file="${1:-data.csv}"
col="${2:-2}"

if [ ! -f "$file" ]; then
  echo "Error: '$file' not found." >&2
  exit 1
fi

awk -F, -v c="$col" 'NR>1 {print $c}' "$file"
```

### Run
```bash
chmod +x awk_column_extractor.sh
./awk_column_extractor.sh data.csv 2
```

### Expected Output
```
Alice
Bob
Charlie
Dina
Ed
```

---

## ✅ Summary of Week 2
In this week we learned:
- How to create and run Bash scripts (`#!/bin/bash`, `chmod +x`).
- How to use conditions to check files and directories.
- How to loop through files and display results in a formatted table.
- How to filter and count errors in log files using `grep`.
- How to extract specific columns from CSV files using `awk`.
