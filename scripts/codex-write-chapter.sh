#!/bin/bash

# Codex Chapter Writer
# Usage: ./codex-write-chapter.sh <book-number> <chapter-number>
# Example: ./codex-write-chapter.sh 077 01

set -e

BOOK_NUM="${1:-077}"
CHAPTER_NUM="${2:-01}"
BOOKS_DIR="/home/presidentanderson/Projects/orgs/101-ways-to-die-in-a-hostel/books"

# Find book directory
BOOK_DIR=$(find "$BOOKS_DIR" -maxdepth 1 -type d -name "book-${BOOK_NUM}-*" | head -1)

if [ -z "$BOOK_DIR" ]; then
    echo "ERROR: Book $BOOK_NUM not found"
    exit 1
fi

BOOK_SLUG=$(basename "$BOOK_DIR")
echo "Writing Chapter $CHAPTER_NUM for: $BOOK_SLUG"

# Determine part based on chapter number
CHAPTER_INT=$((10#$CHAPTER_NUM))
if [ $CHAPTER_INT -le 10 ]; then
    PART="part-1-setup"
elif [ $CHAPTER_INT -le 20 ]; then
    PART="part-2-escalation"
elif [ $CHAPTER_INT -le 30 ]; then
    PART="part-3-crisis"
elif [ $CHAPTER_INT -le 40 ]; then
    PART="part-4-climax"
else
    PART="part-5-aftermath"
fi

CHAPTER_FILE="chapters/$PART/chapter-${CHAPTER_NUM}.md"

# Build the Codex prompt
PROMPT="You are an autonomous book writer for '101 Ways to Die in a Hostel' horror series.

TASK: Write Chapter $CHAPTER_NUM for book $BOOK_SLUG

INSTRUCTIONS:
1. Read CANON/BOOK_IDENTITY.md for book concept
2. Read CANON/VICTIM_PROFILE.md for character details
3. Read CANON/DEATH_SCENARIO.md for death mechanics and foreshadowing
4. Read CANON/LOCATION.md for setting and sensory details
5. Read OUTLINE/CHAPTER_PLAN.md for chapter objectives
6. If previous chapters exist, read them for continuity
7. Write the complete chapter (4,000-6,000 words) to $CHAPTER_FILE
8. Update REGISTERS/PROGRESS.yaml marking chapter $CHAPTER_NUM as complete
9. Update REGISTERS/WORD_COUNT.yaml with the word count

STYLE: Literary horror with dark humor. Victim POV. Immersive sensory details. Build dread through accumulation.

STRUCTURE:
- Opening hook (grab reader immediately)
- Scene development (2-3 scenes advancing plot)
- Closing beat (cliffhanger or dread)

Write the complete chapter now."

# Change to book directory and run Codex
cd "$BOOK_DIR"

echo "Launching Codex..."
echo "Book: $BOOK_SLUG"
echo "Chapter: $CHAPTER_NUM"
echo "Output: $CHAPTER_FILE"
echo ""

codex exec --sandbox workspace-write --skip-git-repo-check "$PROMPT"

echo ""
echo "Chapter $CHAPTER_NUM complete."
