#!/usr/bin/env bash
set -euo pipefail

usage() {
cat <<'USAGE'
Usage:
./remote_log_analyzer.sh user@host
 <remote_log_dir> <keywords_csv> [--help]

Examples:
./remote_log_analyzer.sh ubuntu@35.180.39.60 /var/log "ERROR,WARNING,CRITICAL"
./remote_log_analyzer.sh student@10.0.0.5 /var/log/app "ERROR,WARNING"

Params:
user@host
 SSH target (e.g., ubuntu@1.2.3.4)
<remote_log_dir> Remote directory with logs
<keywords_csv> Comma-separated keywords (e.g., ERROR,WARNING)

Notes:

Auth uses SSH key already configured (ssh config or -i option when needed).

Next steps will: copy logs (scp/rsync), extract ZIP/TAR, analyze counts,
and generate: remote_report.txt + remote_report.csv
USAGE
}

#--help or not enough args

# --help or not enough args
if [[ "${1:-}" == "--help" || "${1:-}" == "-h" || "$#" -lt 3 ]]; then
  usage
  exit 0
fi

TARGET="$1"
REMOTE_DIR="$2"
KEYWORDS_CSV="$3"

IFS=',' read -r -a KEYWORDS <<< "$KEYWORDS_CSV"

START_TS=$(date +%s.%N)

WORK_DIR="$(pwd)"
LOGS_LOCAL_DIR="$WORK_DIR/logs_remote"
REPORTS_DIR="$WORK_DIR/reports"
TXT_REPORT="$REPORTS_DIR/remote_report.txt"
CSV_REPORT="$REPORTS_DIR/remote_report.csv"

mkdir -p "$LOGS_LOCAL_DIR" "$REPORTS_DIR"

pull_logs() {
echo "[INFO] Pulling logs from $TARGET:$REMOTE_DIR ..."
local ts
ts="$(date +%Y%m%d_%H%M%S)"
RUN_DIR="$LOGS_LOCAL_DIR/$ts"
mkdir -p "$RUN_DIR"

if ! scp -q -i ~/.ssh/week3-key.pem "$TARGET:$REMOTE_DIR/"{syslog,auth.log,kern.log,dpkg.log} "$RUN_DIR/" 2>/dev/null; then
  echo "[ERROR] No logs copied. Check remote path/permissions."
  exit 1
fi

echo "[OK] Logs copied to $RUN_DIR"
}

extract_archives() {
  echo "[INFO] Checking for archives in $RUN_DIR ..."

  shopt -s nullglob
  for archive in "$RUN_DIR"/*.zip "$RUN_DIR"/*.tar "$RUN_DIR"/*.tar.gz; do
    case "$archive" in
      *.zip)
        echo "[INFO] Extracting $archive ..."
        unzip -o -d "$RUN_DIR" "$archive" >/dev/null 2>&1
        ;;
      *.tar)
        echo "[INFO] Extracting $archive ..."
        tar -xf "$archive" -C "$RUN_DIR"
        ;;
      *.tar.gz)
        echo "[INFO] Extracting $archive ..."
        tar -xzf "$archive" -C "$RUN_DIR"
        ;;
    esac
  done
  echo "[OK] Archive extraction step complete."
}
pull_logs
extract_archives
analyze_keywords() {
  echo "[INFO] Starting keyword analysis ..."
  : > "$TXT_REPORT"   # איפוס תוכן
  : > "$CSV_REPORT"

  echo "Remote Server: $TARGET" >> "$TXT_REPORT"
  echo "Analyzed Directory: $REMOTE_DIR" >> "$TXT_REPORT"
  echo "" >> "$TXT_REPORT"

  printf "File Name,Keyword,Count\n" >> "$CSV_REPORT"

  for logfile in "$RUN_DIR"/*; do
    [[ -f "$logfile" ]] || continue
    fname=$(basename "$logfile")
    for kw in "${KEYWORDS[@]}"; do
      count=$(grep -c "$kw" "$logfile" || true)
      echo "| $fname | $kw | $count |" >> "$TXT_REPORT"
      printf "%s,%s,%s\n" "$fname" "$kw" "$count" >> "$CSV_REPORT"
    done
  done

  echo "[OK] Analysis complete. Reports ready:"
  echo " - $TXT_REPORT"
  echo " - $CSV_REPORT"
}
extract_archives
analyze_keywords() {
  echo "[INFO] Starting keyword analysis ..."
  : > "$TXT_REPORT"
  : > "$CSV_REPORT"

  {
    echo "Remote Server: $TARGET"
    echo "Analyzed Directory: $REMOTE_DIR"
    echo
    echo "| File Name | Keyword | Count |"
    echo "|-----------|---------|-------|"
  } >> "$TXT_REPORT"

  printf "File Name,Keyword,Count\n" >> "$CSV_REPORT"

  shopt -s nullglob
  for logfile in "$RUN_DIR"/*; do
    [[ -f "$logfile" ]] || continue
    fname=$(basename "$logfile")

    # בוחר כלי קריאה מתאים: zgrep לקבצי .gz, אחרת grep רגיל
    if [[ "$fname" == *.gz ]]; then
      reader=(zgrep -E -i)
    else
      reader=(grep -E -i)
    fi

    for kw in "${KEYWORDS[@]}"; do
      # ספירה לא תלויה רישיות + גבול מילה (לא יתפוס חלקי מילים)
      pattern="\\b${kw}\\b"
      count=$("${reader[@]}" -c "$pattern" "$logfile" 2>/dev/null || true)

      echo "| $fname | $kw | $count |" >> "$TXT_REPORT"
    printf "%s,%s,%s\n" "$fname" "$kw" "$count" >> "$CSV_REPORT"
  done
done

echo "[OK] Analysis complete. Reports ready:"
echo " - $TXT_REPORT"
echo " - $CSV_REPORT"
}

# ---- Execution ----
echo "[OK] Params parsed:"
echo "  TARGET         = $TARGET"
echo "  REMOTE_DIR     = $REMOTE_DIR"
echo "  KEYWORDS       = ${KEYWORDS[*]}"
echo "  LOGS_LOCAL_DIR = $LOGS_LOCAL_DIR"
echo "  REPORTS_DIR    = $REPORTS_DIR"
echo

pull_logs
extract_archives
analyze_keywords

END_TS=$(date +%s.%N)
DURATION=$(awk -v s="$START_TS" -v e="$END_TS" 'BEGIN {printf "%.2f", (e - s)}')
echo "Total Execution Time: ${DURATION} seconds"


