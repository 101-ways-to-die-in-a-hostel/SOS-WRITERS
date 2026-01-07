#!/bin/bash

# Generate Video Trailer Assets for a Book
# Creates all scaffolding for trailer production
#
# Usage: ./generate-trailer.sh <book-number>
# Example: ./generate-trailer.sh 001

set -e

BOOK_NUM="${1:-001}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOS_WRITERS_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATES_DIR="$SOS_WRITERS_DIR/templates"
BOOKS_DIR="/home/presidentanderson/Projects/orgs/101-ways-to-die-in-a-hostel/books"

# Find book directory
BOOK_DIR=$(find "$BOOKS_DIR" -maxdepth 1 -type d -name "book-${BOOK_NUM}-*" | head -1)

if [ -z "$BOOK_DIR" ]; then
    echo "ERROR: Book $BOOK_NUM not found"
    exit 1
fi

BOOK_SLUG=$(basename "$BOOK_DIR" | sed 's/book-[0-9]*-//')
BOOK_FULL_SLUG=$(basename "$BOOK_DIR")

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     TRAILER ASSET GENERATOR                                ║"
echo "║     101 Ways to Die in a Hostel                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Book: $BOOK_FULL_SLUG"
echo "Slug: $BOOK_SLUG"
echo ""

# Create trailer directory structure
TRAILER_DIR="$BOOK_DIR/FILM/trailers"
mkdir -p "$TRAILER_DIR"/{scripts,prompts/{runway,pika,sora,universal},assets/{reference-images,audio/{voiceover,music,sfx},branding},renders/{raw,edited,composited},output/thumbnails}

echo "Created directory structure:"
echo "  $TRAILER_DIR/"
echo "  ├── scripts/"
echo "  ├── prompts/{runway,pika,sora,universal}/"
echo "  ├── assets/{reference-images,audio,branding}/"
echo "  ├── renders/{raw,edited,composited}/"
echo "  └── output/thumbnails/"
echo ""

# Copy and customize templates
echo "Generating templates..."

# Trailer brief
cat > "$TRAILER_DIR/TRAILER_BRIEF.md" << EOF
# Trailer Brief: Book #${BOOK_NUM}

## Project: 101 Ways to Die in a Hostel - ${BOOK_SLUG}

### Overview
- **Book Number:** ${BOOK_NUM}
- **Death Type:** ${BOOK_SLUG//-/ }
- **Trailer Duration:** 30 seconds
- **Target Platforms:** YouTube, TikTok, Instagram Reels

### Goals
1. Hook viewers in first 3 seconds
2. Establish dread without spoiling the death
3. Drive pre-orders/purchases

### Key Visuals
- [ ] Hostel exterior (establish location)
- [ ] Victim introduction (relatable protagonist)
- [ ] Warning signs (foreshadowing)
- [ ] Death tease (maximum tension, no gore)

### Key Audio
- [ ] Atmospheric soundscape
- [ ] Voice-over option
- [ ] Music: dark ambient/horror

### Deliverables
- [ ] 30s trailer (16:9 horizontal)
- [ ] 30s trailer (9:16 vertical)
- [ ] 15s teaser cut
- [ ] Thumbnail set

### Timeline
- Script: [ ]
- Storyboard: [ ]
- AI Generation: [ ]
- Edit: [ ]
- Final: [ ]

---

*Read CANON files for full book context before scripting.*
EOF

# Copy script template
cp "$TEMPLATES_DIR/FILM/trailers/scripts/TRAILER_SCRIPT_TEMPLATE.md" \
   "$TRAILER_DIR/scripts/101-ways_${BOOK_SLUG}_trailer-30s_script.md"

# Customize script template
sed -i "s/\[XXX\]/${BOOK_NUM}/g" "$TRAILER_DIR/scripts/101-ways_${BOOK_SLUG}_trailer-30s_script.md"
sed -i "s/\[TITLE\]/${BOOK_SLUG//-/ }/g" "$TRAILER_DIR/scripts/101-ways_${BOOK_SLUG}_trailer-30s_script.md"
sed -i "s/\[book-slug\]/${BOOK_SLUG}/g" "$TRAILER_DIR/scripts/101-ways_${BOOK_SLUG}_trailer-30s_script.md"

# Copy universal shot descriptions
cp "$TEMPLATES_DIR/FILM/trailers/prompts/universal/shot-descriptions.yaml" \
   "$TRAILER_DIR/prompts/universal/101-ways_${BOOK_SLUG}_shots.yaml"

# Customize shot descriptions
sed -i "s/\[XXX\]/${BOOK_NUM}/g" "$TRAILER_DIR/prompts/universal/101-ways_${BOOK_SLUG}_shots.yaml"
sed -i "s/\[TITLE\]/${BOOK_SLUG//-/ }/g" "$TRAILER_DIR/prompts/universal/101-ways_${BOOK_SLUG}_shots.yaml"
sed -i "s/\[book-slug\]/${BOOK_SLUG}/g" "$TRAILER_DIR/prompts/universal/101-ways_${BOOK_SLUG}_shots.yaml"
sed -i "s/\[death-mechanism\]/${BOOK_SLUG//-/ }/g" "$TRAILER_DIR/prompts/universal/101-ways_${BOOK_SLUG}_shots.yaml"

# Copy Runway prompts template
cp "$TEMPLATES_DIR/FILM/trailers/prompts/runway/RUNWAY_PROMPT_TEMPLATE.md" \
   "$TRAILER_DIR/prompts/runway/101-ways_${BOOK_SLUG}_runway-prompts.md"

sed -i "s/\[XXX\]/${BOOK_NUM}/g" "$TRAILER_DIR/prompts/runway/101-ways_${BOOK_SLUG}_runway-prompts.md"
sed -i "s/\[TITLE\]/${BOOK_SLUG//-/ }/g" "$TRAILER_DIR/prompts/runway/101-ways_${BOOK_SLUG}_runway-prompts.md"

echo ""
echo "Generated files:"
echo "  - TRAILER_BRIEF.md"
echo "  - scripts/101-ways_${BOOK_SLUG}_trailer-30s_script.md"
echo "  - prompts/universal/101-ways_${BOOK_SLUG}_shots.yaml"
echo "  - prompts/runway/101-ways_${BOOK_SLUG}_runway-prompts.md"
echo ""

# Extract info from CANON files if they exist
if [ -f "$BOOK_DIR/CANON/BOOK_IDENTITY.md" ]; then
    echo "Found CANON/BOOK_IDENTITY.md - extracting metadata..."
    # Could parse and inject into templates here
fi

if [ -f "$BOOK_DIR/CANON/VICTIM_PROFILE.md" ]; then
    echo "Found CANON/VICTIM_PROFILE.md - victim info available"
fi

if [ -f "$BOOK_DIR/CANON/DEATH_SCENARIO.md" ]; then
    echo "Found CANON/DEATH_SCENARIO.md - death details available"
fi

if [ -f "$BOOK_DIR/CANON/LOCATION.md" ]; then
    echo "Found CANON/LOCATION.md - location info available"
fi

echo ""
echo "════════════════════════════════════════════════════════════"
echo "Trailer scaffolding complete for: $BOOK_FULL_SLUG"
echo ""
echo "Next steps:"
echo "  1. Review TRAILER_BRIEF.md"
echo "  2. Read CANON files for book context"
echo "  3. Customize the script template"
echo "  4. Generate AI prompts for each platform"
echo "  5. Run AI video generation"
echo "  6. Assemble and edit"
echo "════════════════════════════════════════════════════════════"
