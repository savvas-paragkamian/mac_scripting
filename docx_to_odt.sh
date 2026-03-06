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

SOFFICE="/Applications/LibreOffice.app/Contents/MacOS/soffice"

if [ ! -x "$SOFFICE" ]; then
  echo "Error: LibreOffice soffice not found at:"
  echo "  $SOFFICE"
  echo "Adjust the SOFFICE path in this script."
  exit 1
fi

LOG_FILE="$ROOT_DIR/docx_to_odt_log.txt"
FAIL_FILE="$ROOT_DIR/docx_to_odt_failed.txt"

: > "$LOG_FILE"
: > "$FAIL_FILE"

echo "Starting DOCX -> ODT conversion in: $ROOT_DIR" | tee -a "$LOG_FILE"

find "$ROOT_DIR" -type f -iname '*.docx' -print0 |
while IFS= read -r -d '' file; do
  parent_dir="$(dirname "$file")"
  filename="$(basename "$file")"
  base_name="${filename%.*}"
  out_path="$parent_dir/$base_name.odt"

  if [ -f "$out_path" ]; then
    echo "Skipping (already exists): $file" | tee -a "$LOG_FILE"
    continue
  fi

  echo "Processing: $file" | tee -a "$LOG_FILE"

  if "$SOFFICE" --headless --convert-to odt --outdir "$parent_dir" "$file" >>"$LOG_FILE" 2>&1; then
    if [ -f "$out_path" ]; then
      echo "Converted: $file -> $out_path" | tee -a "$LOG_FILE"
    else
      echo "FAILED (no output produced): $file" | tee -a "$LOG_FILE" "$FAIL_FILE"
    fi
  else
    echo "FAILED: $file" | tee -a "$LOG_FILE" "$FAIL_FILE"
  fi
done

echo "Done."
echo "Log: $LOG_FILE"
echo "Failures: $FAIL_FILE"
