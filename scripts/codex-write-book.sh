#!/bin/bash

# Codex Full Book Writer
# Writes all 50 chapters for a book autonomously
# Usage: ./codex-write-book.sh <book-number> [start-chapter]
# Example: ./codex-write-book.sh 077
# Example: ./codex-write-book.sh 077 15  (resume from chapter 15)

set -e

BOOK_NUM="${1:-077}"
START_CHAPTER="${2:-1}"
BOOKS_DIR="/home/presidentanderson/Projects/orgs/101-ways-to-die-in-a-hostel/books"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Find book directory
BOOK_DIR=$(find "$BOOKS_DIR" -maxdepth 1 -type d -name "book-${BOOK_NUM}-*" | head -1)

if [ -z "$BOOK_DIR" ]; then
    echo "ERROR: Book $BOOK_NUM not found"
    exit 1
fi

BOOK_SLUG=$(basename "$BOOK_DIR")

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     CODEX AUTONOMOUS BOOK WRITER                           ║"
echo "║     Writing: $BOOK_SLUG"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Starting from chapter: $START_CHAPTER"
echo "Target: 50 chapters, 250,000 words"
echo ""

# Write chapters
for CHAPTER in $(seq $START_CHAPTER 50); do
    CHAPTER_NUM=$(printf "%02d" $CHAPTER)

    echo "────────────────────────────────────────────────────────────"
    echo "Writing Chapter $CHAPTER_NUM / 50"
    echo "────────────────────────────────────────────────────────────"

    "$SCRIPT_DIR/codex-write-chapter.sh" "$BOOK_NUM" "$CHAPTER_NUM"

    echo ""
    echo "✓ Chapter $CHAPTER_NUM complete"
    echo ""

    # Brief pause between chapters (optional, for rate limiting)
    sleep 2
done

echo ""
echo "════════════════════════════════════════════════════════════"
echo "BOOK COMPLETE: $BOOK_SLUG"
echo "════════════════════════════════════════════════════════════"
