#!/bin/bash

# Codex Parallel Book Writer
# Writes multiple books simultaneously
# Usage: ./codex-parallel-books.sh <start-book> <end-book> [concurrency]
# Example: ./codex-parallel-books.sh 001 103 30

set -e

START_BOOK="${1:-001}"
END_BOOK="${2:-103}"
CONCURRENCY="${3:-10}"  # Default 10, can go up to 30+

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BOOKS_DIR="/home/presidentanderson/Projects/orgs/101-ways-to-die-in-a-hostel/books"
LOG_DIR="$SCRIPT_DIR/logs"

mkdir -p "$LOG_DIR"

START_INT=$((10#$START_BOOK))
END_INT=$((10#$END_BOOK))

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     CODEX PARALLEL BOOK WRITER                             ║"
echo "║     101 Ways to Die in a Hostel                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Books: $START_BOOK to $END_BOOK"
echo "Concurrency: $CONCURRENCY parallel sessions"
echo "Total books: $((END_INT - START_INT + 1))"
echo "Total words: $(((END_INT - START_INT + 1) * 250000)) (~25M+)"
echo ""
echo "Logs: $LOG_DIR/"
echo ""

# Create job list
JOB_FILE=$(mktemp)
for BOOK in $(seq $START_INT $END_INT); do
    BOOK_NUM=$(printf "%03d" $BOOK)
    echo "$BOOK_NUM" >> "$JOB_FILE"
done

# Function to write a single book
write_book() {
    local BOOK_NUM=$1
    local LOG_FILE="$LOG_DIR/book-${BOOK_NUM}.log"

    echo "[$(date '+%H:%M:%S')] Starting Book $BOOK_NUM" | tee -a "$LOG_FILE"

    if "$SCRIPT_DIR/codex-write-book.sh" "$BOOK_NUM" >> "$LOG_FILE" 2>&1; then
        echo "[$(date '+%H:%M:%S')] ✓ Book $BOOK_NUM COMPLETE" | tee -a "$LOG_FILE"
        return 0
    else
        echo "[$(date '+%H:%M:%S')] ✗ Book $BOOK_NUM FAILED" | tee -a "$LOG_FILE"
        return 1
    fi
}

export -f write_book
export SCRIPT_DIR LOG_DIR

# Check if GNU parallel is available
if command -v parallel &> /dev/null; then
    echo "Using GNU parallel with $CONCURRENCY jobs..."
    echo "Adding 2-second delay between job starts to avoid rate limits..."
    echo ""

    cat "$JOB_FILE" | parallel -j "$CONCURRENCY" --delay 2 --progress write_book {}

else
    echo "GNU parallel not found. Using xargs..."
    echo "Install with: sudo apt install parallel"
    echo ""

    cat "$JOB_FILE" | xargs -P "$CONCURRENCY" -I {} bash -c 'write_book "$@"' _ {}
fi

rm "$JOB_FILE"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "PARALLEL BATCH COMPLETE"
echo "Check logs in: $LOG_DIR/"
echo "════════════════════════════════════════════════════════════"
