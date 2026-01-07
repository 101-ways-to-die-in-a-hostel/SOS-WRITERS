#!/bin/bash

# AI Chapter Writer with Multi-Provider Failover
# Uses sovereign-canon ai-router for automatic failover across 12 AI providers
#
# Usage: ./ai-write-chapter.sh <book-number> <chapter-number> [--tier TIER]
# Example: ./ai-write-chapter.sh 077 01
# Example: ./ai-write-chapter.sh 077 01 --tier flagship
#
# Tiers: flagship (best), balanced (default), fast (cheapest)

set -e

BOOK_NUM="${1:-077}"
CHAPTER_NUM="${2:-01}"
shift 2 || true

# Parse optional arguments
TIER="balanced"
while [[ $# -gt 0 ]]; do
    case "$1" in
        --tier) TIER="$2"; shift 2 ;;
        *) shift ;;
    esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOS_WRITERS_DIR="$(dirname "$SCRIPT_DIR")"
BOOKS_DIR="/home/presidentanderson/Projects/orgs/101-ways-to-die-in-a-hostel/books"
AI_ROUTER="$SCRIPT_DIR/ai-router.sh"

# Find book directory
BOOK_DIR=$(find "$BOOKS_DIR" -maxdepth 1 -type d -name "book-${BOOK_NUM}-*" | head -1)

if [ -z "$BOOK_DIR" ]; then
    echo "ERROR: Book $BOOK_NUM not found"
    exit 1
fi

BOOK_SLUG=$(basename "$BOOK_DIR")

# Determine part based on chapter number
CHAPTER_INT=$((10#$CHAPTER_NUM))
if [ $CHAPTER_INT -le 10 ]; then
    PART="part-1-setup"
    PART_NAME="Setup & Introduction"
elif [ $CHAPTER_INT -le 20 ]; then
    PART="part-2-escalation"
    PART_NAME="Escalation"
elif [ $CHAPTER_INT -le 30 ]; then
    PART="part-3-crisis"
    PART_NAME="Crisis Point"
elif [ $CHAPTER_INT -le 40 ]; then
    PART="part-4-climax"
    PART_NAME="Climax"
else
    PART="part-5-aftermath"
    PART_NAME="Aftermath & Resolution"
fi

CHAPTER_DIR="$BOOK_DIR/chapters/$PART"
CHAPTER_FILE="$CHAPTER_DIR/chapter-${CHAPTER_NUM}.md"

# Ensure chapter directory exists
mkdir -p "$CHAPTER_DIR"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     AI CHAPTER WRITER (Multi-Provider Failover)            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Book:     $BOOK_SLUG"
echo "Chapter:  $CHAPTER_NUM ($PART_NAME)"
echo "Tier:     $TIER"
echo "Output:   $CHAPTER_FILE"
echo ""

# Read canon files for context
CONTEXT=""

if [ -f "$BOOK_DIR/CANON/BOOK_IDENTITY.md" ]; then
    CONTEXT+="## BOOK IDENTITY\n$(cat "$BOOK_DIR/CANON/BOOK_IDENTITY.md")\n\n"
fi

if [ -f "$BOOK_DIR/CANON/VICTIM_PROFILE.md" ]; then
    CONTEXT+="## VICTIM PROFILE\n$(cat "$BOOK_DIR/CANON/VICTIM_PROFILE.md")\n\n"
fi

if [ -f "$BOOK_DIR/CANON/DEATH_SCENARIO.md" ]; then
    CONTEXT+="## DEATH SCENARIO\n$(cat "$BOOK_DIR/CANON/DEATH_SCENARIO.md")\n\n"
fi

if [ -f "$BOOK_DIR/CANON/LOCATION.md" ]; then
    CONTEXT+="## LOCATION\n$(cat "$BOOK_DIR/CANON/LOCATION.md")\n\n"
fi

if [ -f "$BOOK_DIR/OUTLINE/CHAPTER_PLAN.md" ]; then
    CONTEXT+="## CHAPTER PLAN\n$(cat "$BOOK_DIR/OUTLINE/CHAPTER_PLAN.md")\n\n"
fi

# Read previous chapter for continuity (if exists)
PREV_CHAPTER=$((CHAPTER_INT - 1))
if [ $PREV_CHAPTER -ge 1 ]; then
    PREV_NUM=$(printf "%02d" $PREV_CHAPTER)
    # Find previous chapter file
    PREV_FILE=$(find "$BOOK_DIR/chapters" -name "chapter-${PREV_NUM}.md" 2>/dev/null | head -1)
    if [ -f "$PREV_FILE" ]; then
        # Include last 2000 chars of previous chapter for continuity
        CONTEXT+="## PREVIOUS CHAPTER (ending)\n...\n$(tail -c 2000 "$PREV_FILE")\n\n"
    fi
fi

# Build the prompt
SYSTEM_PROMPT="You are an autonomous horror novelist writing for the '101 Ways to Die in a Hostel' series.

STYLE GUIDELINES:
- Literary horror with dark humor undertones
- First-person or close third-person POV from the victim's perspective
- Immersive sensory details (sounds, smells, textures, temperature)
- Build dread through accumulation of small wrongnesses
- Each chapter should have an opening hook, 2-3 scenes, and a closing beat
- Target 4,000-6,000 words per chapter
- Include foreshadowing of the death scenario
- Balance tension with moments of false security

STRUCTURE:
- Opening hook (grab reader in first paragraph)
- Scene development (advance plot, deepen character, build atmosphere)
- Closing beat (cliffhanger, revelation, or moment of dread)

OUTPUT FORMAT:
Write the complete chapter in Markdown format with:
- Chapter title as H1
- Scene breaks with '---'
- No meta-commentary or notes"

USER_PROMPT="Write Chapter $CHAPTER_NUM for book: $BOOK_SLUG

This is Part $((CHAPTER_INT / 10 + 1)): $PART_NAME

$CONTEXT

---

Write the complete Chapter $CHAPTER_NUM now (4,000-6,000 words).
Begin with '# Chapter $CHAPTER_NUM' and write the full chapter."

# Create temp file for prompt
PROMPT_FILE=$(mktemp)
echo -e "$USER_PROMPT" > "$PROMPT_FILE"

echo "Sending to AI router (tier: $TIER)..."
echo ""

# Call AI router with failover
RESPONSE=$("$AI_ROUTER" \
    --file "$PROMPT_FILE" \
    --system "$SYSTEM_PROMPT" \
    --tier "$TIER" \
    --timeout 300 \
    2>&1)

# Clean up
rm -f "$PROMPT_FILE"

# Check if response contains chapter content
if echo "$RESPONSE" | grep -q "^# Chapter"; then
    # Write the chapter
    echo "$RESPONSE" > "$CHAPTER_FILE"

    # Calculate word count
    WORD_COUNT=$(wc -w < "$CHAPTER_FILE")

    echo ""
    echo "════════════════════════════════════════════════════════════"
    echo "Chapter $CHAPTER_NUM COMPLETE"
    echo "  Words: $WORD_COUNT"
    echo "  File:  $CHAPTER_FILE"
    echo "════════════════════════════════════════════════════════════"

    # Update progress register
    if [ -f "$BOOK_DIR/REGISTERS/PROGRESS.yaml" ]; then
        # Update chapter status
        sed -i "s/chapter_${CHAPTER_NUM}: pending/chapter_${CHAPTER_NUM}: complete/" "$BOOK_DIR/REGISTERS/PROGRESS.yaml" 2>/dev/null || true
    fi

    # Update word count register
    if [ -f "$BOOK_DIR/REGISTERS/WORD_COUNT.yaml" ]; then
        echo "chapter_${CHAPTER_NUM}: $WORD_COUNT" >> "$BOOK_DIR/REGISTERS/WORD_COUNT.yaml"
    fi

else
    echo "ERROR: AI response did not contain valid chapter content"
    echo "Response preview:"
    echo "$RESPONSE" | head -20
    exit 1
fi
