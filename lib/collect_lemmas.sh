#!/usr/bin/env bash

INPUT_FILES="multiword_lemmas_j.csv multiword_lemmas_k.csv multiword_lemmas_l.csv multiword_lemmas_m.csv multiword_lemmas_n.csv multiword_lemmas_o.csv multiword_lemmas_p.csv multiword_lemmas_q.csv multiword_lemmas_r.csv multiword_lemmas_s.csv multiword_lemmas_t.csv multiword_lemmas_u.csv multiword_lemmas_v.csv multiword_lemmas_w.csv multiword_lemmas_xyz.csv multiword-lemmas.txt real_english_multiword_lemmas_xyz_expanded.csv real_english_multiword_lemmas_xyz.csv word-list.raw"

# collect_lemmas.sh
# Reads file names from $INPUT_FILES variable,
# appends all lines into ../lemmas.txt, and keeps lines uniquely sorted.

set -euo pipefail

TARGET_FILE="../lemmas.txt"


# Default fallback if INPUT_FILES is unset or empty
#: "${INPUT_FILES:=multiword_lemmas_j.csv multiword_lemmas_k.csv}"


# Create a temporary working file

TMP_FILE="$(mktemp)"
trap 'rm -f "$TMP_FILE"' EXIT

# Append existing lemmas from target file if present

if [[ -f "$TARGET_FILE" ]]; then
  cat "$TARGET_FILE" >> "$TMP_FILE"
fi

# Loop over the files listed in $INPUT_FILES
for file in $INPUT_FILES; do
  if [[ -f "$file" ]]; then
    cat "$file" >> "$TMP_FILE"
  else
    echo "Warning: File '$file' not found, skipping." >&2
  fi
done

# Ensure parent directory exists for target file
mkdir -p "$(dirname "$TARGET_FILE")"

# Remove blank lines and sort uniquely into target file
grep -v '^\s*$' "$TMP_FILE" | sort -u > "$TARGET_FILE"

echo "Updated and sorted $TARGET_FILE successfully."