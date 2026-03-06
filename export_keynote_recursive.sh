#!/usr/bin/env bash
set -u

if [ $# -ne 1 ]; then
  echo "Usage: $0 /path/to/root/folder"
  exit 1
fi

ROOT_DIR="$1"

if [ ! -d "$ROOT_DIR" ]; then
  echo "Error: not a directory: $ROOT_DIR"
  exit 1
fi

LOG_FILE="$ROOT_DIR/export_keynote_log.txt"
FAIL_FILE="$ROOT_DIR/export_keynote_failed.txt"

: > "$LOG_FILE"
: > "$FAIL_FILE"

echo "Starting Keynote export in: $ROOT_DIR" | tee -a "$LOG_FILE"

find "$ROOT_DIR" \( -type f -o -type d \) -name '*.key' -print0 |
while IFS= read -r -d '' file; do
  parent_dir="$(dirname "$file")"
  filename="$(basename "$file")"
  base_name="${filename%.key}"

  pptx_path="$parent_dir/$base_name.pptx"
  pdf_path="$parent_dir/$base_name.pdf"

  if [ -f "$pptx_path" ] && [ -f "$pdf_path" ]; then
    echo "Skipping: $file" | tee -a "$LOG_FILE"
    continue
  fi

  echo "Processing: $file" | tee -a "$LOG_FILE"

  if /usr/bin/osascript \
    -e 'on run argv' \
    -e 'set inFile to item 1 of argv' \
    -e 'set outPPTX to item 2 of argv' \
    -e 'set outPDF to item 3 of argv' \
    -e 'tell application "Keynote"' \
    -e 'activate' \
    -e 'open POSIX file inFile' \
    -e 'delay 2' \
    -e 'set theDoc to front document' \
    -e 'export theDoc to POSIX file outPPTX as Microsoft PowerPoint' \
    -e 'delay 1' \
    -e 'export theDoc to POSIX file outPDF as PDF' \
    -e 'close theDoc saving no' \
    -e 'end tell' \
    -e 'end run' \
    "$file" "$pptx_path" "$pdf_path" >>"$LOG_FILE" 2>&1
  then
    echo "Exported: $file" | tee -a "$LOG_FILE"
  else
    echo "FAILED: $file" | tee -a "$LOG_FILE" "$FAIL_FILE"
    continue
  fi
done

echo "Done."
echo "Log: $LOG_FILE"
echo "Failures: $FAIL_FILE"
