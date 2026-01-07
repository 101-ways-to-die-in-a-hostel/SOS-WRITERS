#!/bin/bash

# Codex Batch Book Writer
# Writes multiple books in sequence
# Usage: ./codex-batch-books.sh <start-book> <end-book>
# Example: ./codex-batch-books.sh 001 010  (writes books 1-10)

set -e

START_BOOK="${1:-001}"
END_BOOK="${2:-103}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

START_INT=$((10#$START_BOOK))
END_INT=$((10#$END_BOOK))

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     CODEX BATCH BOOK WRITER                                ║"
echo "║     101 Ways to Die in a Hostel                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Writing books $START_BOOK through $END_BOOK"
echo "Total books: $((END_INT - START_INT + 1))"
echo "Total words: $(((END_INT - START_INT + 1) * 250000))"
echo ""

COMPLETED=0
FAILED=0

for BOOK in $(seq $START_INT $END_INT); do
    BOOK_NUM=$(printf "%03d" $BOOK)

    echo ""
    echo "════════════════════════════════════════════════════════════"
    echo "STARTING BOOK $BOOK_NUM / $END_BOOK"
    echo "════════════════════════════════════════════════════════════"

    if "$SCRIPT_DIR/codex-write-book.sh" "$BOOK_NUM"; then
        COMPLETED=$((COMPLETED + 1))
        echo "✓ Book $BOOK_NUM complete"
    else
        FAILED=$((FAILED + 1))
        echo "✗ Book $BOOK_NUM failed"
    fi
done

echo ""
echo "════════════════════════════════════════════════════════════"
echo "BATCH COMPLETE"
echo "  Completed: $COMPLETED"
echo "  Failed: $FAILED"
echo "════════════════════════════════════════════════════════════"
