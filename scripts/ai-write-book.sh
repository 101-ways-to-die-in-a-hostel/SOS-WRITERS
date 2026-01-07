#!/bin/bash

# AI Full Book Writer with Multi-Provider Failover
# Writes all 50 chapters for a book autonomously using ai-router
#
# Usage: ./ai-write-book.sh <book-number> [options]
# Example: ./ai-write-book.sh 077
# Example: ./ai-write-book.sh 077 --start 15 --tier flagship
#
# Options:
#   --start N     Start from chapter N (resume)
#   --end N       Stop at chapter N
#   --tier TIER   AI tier: flagship, balanced (default), fast

set -e

BOOK_NUM="${1:-077}"
shift || true

# Defaults
START_CHAPTER=1
END_CHAPTER=50
TIER="balanced"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --start) START_CHAPTER="$2"; shift 2 ;;
        --end) END_CHAPTER="$2"; shift 2 ;;
        --tier) TIER="$2"; shift 2 ;;
        *) shift ;;
    esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BOOKS_DIR="/home/presidentanderson/Projects/orgs/101-ways-to-die-in-a-hostel/books"
LOG_DIR="$SCRIPT_DIR/logs"

mkdir -p "$LOG_DIR"

# Find book directory
BOOK_DIR=$(find "$BOOKS_DIR" -maxdepth 1 -type d -name "book-${BOOK_NUM}-*" | head -1)

if [ -z "$BOOK_DIR" ]; then
    echo "ERROR: Book $BOOK_NUM not found"
    exit 1
fi

BOOK_SLUG=$(basename "$BOOK_DIR")
LOG_FILE="$LOG_DIR/${BOOK_SLUG}.log"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     AI AUTONOMOUS BOOK WRITER                              ║"
echo "║     Multi-Provider Failover (12 AI Providers)              ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Book:     $BOOK_SLUG"
echo "Chapters: $START_CHAPTER to $END_CHAPTER"
echo "Tier:     $TIER"
echo "Log:      $LOG_FILE"
echo ""
echo "Target: $((END_CHAPTER - START_CHAPTER + 1)) chapters"
echo "Est. words: $(((END_CHAPTER - START_CHAPTER + 1) * 5000))"
echo ""

# Log start
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting book: $BOOK_SLUG" >> "$LOG_FILE"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Chapters: $START_CHAPTER-$END_CHAPTER, Tier: $TIER" >> "$LOG_FILE"

COMPLETED=0
FAILED=0
TOTAL_WORDS=0
START_TIME=$(date +%s)

# Write chapters sequentially
for CHAPTER in $(seq $START_CHAPTER $END_CHAPTER); do
    CHAPTER_NUM=$(printf "%02d" $CHAPTER)

    echo "────────────────────────────────────────────────────────────"
    echo "[$(date '+%H:%M:%S')] Chapter $CHAPTER_NUM / $END_CHAPTER"
    echo "────────────────────────────────────────────────────────────"

    if "$SCRIPT_DIR/ai-write-chapter.sh" "$BOOK_NUM" "$CHAPTER_NUM" --tier "$TIER" 2>&1 | tee -a "$LOG_FILE"; then
        COMPLETED=$((COMPLETED + 1))

        # Get word count from the chapter file
        CHAPTER_FILE=$(find "$BOOK_DIR/chapters" -name "chapter-${CHAPTER_NUM}.md" 2>/dev/null | head -1)
        if [ -f "$CHAPTER_FILE" ]; then
            WC=$(wc -w < "$CHAPTER_FILE")
            TOTAL_WORDS=$((TOTAL_WORDS + WC))
        fi

        echo ""
        echo "[$(date '+%H:%M:%S')] Chapter $CHAPTER_NUM complete ($WC words)"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Chapter $CHAPTER_NUM: $WC words" >> "$LOG_FILE"
    else
        FAILED=$((FAILED + 1))
        echo ""
        echo "[$(date '+%H:%M:%S')] Chapter $CHAPTER_NUM FAILED"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Chapter $CHAPTER_NUM: FAILED" >> "$LOG_FILE"
    fi

    echo ""

    # Brief pause between chapters to respect rate limits
    sleep 5
done

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))
DURATION_MIN=$((DURATION / 60))

echo ""
echo "════════════════════════════════════════════════════════════"
echo "BOOK COMPLETE: $BOOK_SLUG"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "Results:"
echo "  Completed: $COMPLETED chapters"
echo "  Failed:    $FAILED chapters"
echo "  Words:     $TOTAL_WORDS"
echo "  Duration:  ${DURATION_MIN}m ${DURATION}s"
echo ""
echo "Log: $LOG_FILE"
echo ""

# Final log entry
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Complete: $COMPLETED/$((END_CHAPTER - START_CHAPTER + 1)) chapters, $TOTAL_WORDS words, ${DURATION}s" >> "$LOG_FILE"

# Update book progress register
if [ -f "$BOOK_DIR/REGISTERS/PROGRESS.yaml" ]; then
    echo "" >> "$BOOK_DIR/REGISTERS/PROGRESS.yaml"
    echo "# Auto-generated summary" >> "$BOOK_DIR/REGISTERS/PROGRESS.yaml"
    echo "total_chapters_complete: $COMPLETED" >> "$BOOK_DIR/REGISTERS/PROGRESS.yaml"
    echo "total_words: $TOTAL_WORDS" >> "$BOOK_DIR/REGISTERS/PROGRESS.yaml"
    echo "last_updated: $(date -Iseconds)" >> "$BOOK_DIR/REGISTERS/PROGRESS.yaml"
fi

exit $FAILED
