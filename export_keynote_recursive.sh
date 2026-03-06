#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 /path/to/root/folder"
  exit 1
fi

ROOT_DIR="$1"

if [ ! -d "$ROOT_DIR" ]; then
  echo "Error: not a directory: $ROOT_DIR"
  exit 1
fi

find "$ROOT_DIR" -type f -name '*.key' -print0 |
while IFS= read -r -d '' file; do
  parent_dir="$(dirname "$file")"
  filename="$(basename "$file")"
  base_name="${filename%.key}"

  pptx_path="$parent_dir/$base_name.pptx"
  pdf_path="$parent_dir/$base_name.pdf"

  if [ -f "$pptx_path" ] && [ -f "$pdf_path" ]; then
    echo "Skipping: $file"
    continue
  fi

  /usr/bin/osascript \
    -e 'on run argv' \
    -e 'set inFile to item 1 of argv' \
    -e 'set outPPTX to item 2 of argv' \
    -e 'set outPDF to item 3 of argv' \
    -e 'tell application "Keynote"' \
    -e 'activate' \
    -e 'open POSIX file inFile' \
    -e 'set theDoc to front document' \
    -e 'export theDoc to POSIX file outPPTX as Microsoft PowerPoint' \
    -e 'export theDoc to POSIX file outPDF as PDF' \
    -e 'close theDoc saving no' \
    -e 'end tell' \
    -e 'end run' \
    "$file" "$pptx_path" "$pdf_path"

  echo "Exported: $file"
done

echo "Done."


