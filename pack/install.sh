#!/bin/bash
#
# SOS-WRITERS Pack Installer
# Installs the complete book production pipeline into a target repository
#
# Usage:
#   From SOS-WRITERS directory:
#     ./pack/install.sh /path/to/book-repo
#
#   From target repo:
#     curl -sSL https://raw.githubusercontent.com/.../install.sh | bash
#
# What gets installed:
#   - AGENTS/ directory (writer agent configs)
#   - FILM/ directory (trailer templates)
#   - website/ directory (landing page template)
#   - LEGAL/ directory (IP protection)
#   - REGISTERS/ directory (progress tracking)
#   - scripts/ directory (automation tools)

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Determine paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOS_WRITERS_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATES_DIR="$SOS_WRITERS_DIR/templates"
SCRIPTS_DIR="$SOS_WRITERS_DIR/scripts"
CONFIG_DIR="$SOS_WRITERS_DIR/config"

# Target directory (argument or current directory)
TARGET_DIR="${1:-$(pwd)}"

# Validate target
if [ ! -d "$TARGET_DIR" ]; then
    error "Target directory does not exist: $TARGET_DIR"
fi

# Check if it looks like a book repo
REPO_NAME=$(basename "$TARGET_DIR")
if [[ ! "$REPO_NAME" =~ ^book-[0-9]{3}- ]]; then
    warn "Target doesn't match book-XXX-* pattern: $REPO_NAME"
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Extract book info from directory name
BOOK_NUM=$(echo "$REPO_NAME" | grep -oP 'book-\K[0-9]{3}' || echo "000")
BOOK_SLUG=$(echo "$REPO_NAME" | sed 's/book-[0-9]*-//')
SUBTITLE=$(echo "$BOOK_SLUG" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║     SOS-WRITERS PACK INSTALLER                             ║"
echo "║     101 Ways to Die in a Hostel                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Target:   $TARGET_DIR"
echo "Book:     #$BOOK_NUM - $SUBTITLE"
echo ""

cd "$TARGET_DIR"

# ============================================================
# AGENTS Directory
# ============================================================
info "Installing AGENTS..."
mkdir -p AGENTS

# Copy agent templates
for file in "$TEMPLATES_DIR/AGENTS/"*.md; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        cp "$file" "AGENTS/$filename"
        # Customize placeholders
        sed -i "s/\[XXX\]/${BOOK_NUM}/g" "AGENTS/$filename" 2>/dev/null || true
        sed -i "s/\[TITLE\]/${SUBTITLE}/g" "AGENTS/$filename" 2>/dev/null || true
        sed -i "s/\[book-slug\]/${BOOK_SLUG}/g" "AGENTS/$filename" 2>/dev/null || true
    fi
done

# Copy CLAUDE.md to root if not exists
if [ ! -f "CLAUDE.md" ]; then
    cp "$TEMPLATES_DIR/CLAUDE.md" "CLAUDE.md"
    sed -i "s/\[XXX\]/${BOOK_NUM}/g" "CLAUDE.md" 2>/dev/null || true
    sed -i "s/\[TITLE\]/${SUBTITLE}/g" "CLAUDE.md" 2>/dev/null || true
fi

success "AGENTS installed"

# ============================================================
# CANON Directory (templates only if not exists)
# ============================================================
info "Installing CANON templates..."
mkdir -p CANON

for file in "$TEMPLATES_DIR/CANON/"*.md; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        # Only copy if doesn't exist (preserve existing canon)
        if [ ! -f "CANON/$filename" ]; then
            cp "$file" "CANON/$filename"
            sed -i "s/\[XXX\]/${BOOK_NUM}/g" "CANON/$filename" 2>/dev/null || true
            sed -i "s/\[TITLE\]/${SUBTITLE}/g" "CANON/$filename" 2>/dev/null || true
            sed -i "s/\[book-slug\]/${BOOK_SLUG}/g" "CANON/$filename" 2>/dev/null || true
        else
            warn "Skipping existing: CANON/$filename"
        fi
    fi
done

success "CANON installed"

# ============================================================
# OUTLINE Directory
# ============================================================
info "Installing OUTLINE templates..."
mkdir -p OUTLINE

if [ ! -f "OUTLINE/CHAPTER_PLAN.md" ]; then
    cp "$TEMPLATES_DIR/OUTLINE/CHAPTER_PLAN.md" "OUTLINE/"
    sed -i "s/\[XXX\]/${BOOK_NUM}/g" "OUTLINE/CHAPTER_PLAN.md" 2>/dev/null || true
fi

success "OUTLINE installed"

# ============================================================
# FILM Directory (Trailers)
# ============================================================
info "Installing FILM/trailers structure..."
mkdir -p FILM/trailers/{scripts,prompts/{runway,pika,sora,universal},assets/{reference-images,audio/{voiceover,music,sfx},branding},renders/{raw,edited,composited},output/thumbnails}

# Copy adaptation bible template
if [ ! -f "FILM/ADAPTATION_BIBLE.md" ]; then
    cp "$TEMPLATES_DIR/FILM/ADAPTATION_BIBLE.md" "FILM/"
    sed -i "s/\[XXX\]/${BOOK_NUM}/g" "FILM/ADAPTATION_BIBLE.md" 2>/dev/null || true
fi

# Copy trailer templates
cp "$TEMPLATES_DIR/FILM/trailers/TRAILER_STRUCTURE.md" "FILM/trailers/"
cp "$TEMPLATES_DIR/FILM/trailers/scripts/TRAILER_SCRIPT_TEMPLATE.md" \
   "FILM/trailers/scripts/101-ways_${BOOK_SLUG}_trailer-30s_script.md"
cp "$TEMPLATES_DIR/FILM/trailers/prompts/universal/shot-descriptions.yaml" \
   "FILM/trailers/prompts/universal/101-ways_${BOOK_SLUG}_shots.yaml"
cp "$TEMPLATES_DIR/FILM/trailers/prompts/runway/RUNWAY_PROMPT_TEMPLATE.md" \
   "FILM/trailers/prompts/runway/101-ways_${BOOK_SLUG}_runway-prompts.md"

# Customize trailer templates
for file in FILM/trailers/scripts/*.md FILM/trailers/prompts/**/*.md FILM/trailers/prompts/**/*.yaml; do
    if [ -f "$file" ]; then
        sed -i "s/\[XXX\]/${BOOK_NUM}/g" "$file" 2>/dev/null || true
        sed -i "s/\[TITLE\]/${SUBTITLE}/g" "$file" 2>/dev/null || true
        sed -i "s/\[book-slug\]/${BOOK_SLUG}/g" "$file" 2>/dev/null || true
        sed -i "s/\[death-mechanism\]/${SUBTITLE}/g" "$file" 2>/dev/null || true
    fi
done

# Create trailer brief
cat > "FILM/trailers/TRAILER_BRIEF.md" << EOF
# Trailer Brief: Book #${BOOK_NUM}

## Project: 101 Ways to Die in a Hostel - ${SUBTITLE}

### Overview
- **Book Number:** ${BOOK_NUM}
- **Death Type:** ${SUBTITLE}
- **Trailer Duration:** 30 seconds
- **Target Platforms:** YouTube, TikTok, Instagram Reels

### Status
- [ ] Script written
- [ ] Storyboard complete
- [ ] AI prompts generated
- [ ] Shots rendered
- [ ] Edit assembled
- [ ] Final approved

*Read CANON files for full book context before scripting.*
EOF

success "FILM/trailers installed"

# ============================================================
# Website Directory
# ============================================================
info "Installing website template..."
mkdir -p website/{styles,scripts,assets/{images/logos,video},data}

# Copy website template
cp "$TEMPLATES_DIR/WEBSITE/index.html" "website/"
cp "$TEMPLATES_DIR/WEBSITE/WEBSITE_STRUCTURE.md" "website/"

# Customize website
YEAR=$(date +%Y)
sed -i "s/{{BOOK_NUMBER}}/${BOOK_NUM}/g" "website/index.html"
sed -i "s/{{SUBTITLE}}/${SUBTITLE}/g" "website/index.html"
sed -i "s/{{SLUG}}/${BOOK_SLUG}/g" "website/index.html"
sed -i "s/{{YEAR}}/${YEAR}/g" "website/index.html"
sed -i "s/{{TAGLINE}}/Some hostels are a bargain. Others cost you your life./g" "website/index.html"
sed -i "s/{{DEATH_TYPE}}/${SUBTITLE}/g" "website/index.html"
sed -i "s/{{CTA_TEXT}}/Pre-Order Now/g" "website/index.html"
sed -i "s/{{PRICE_EBOOK}}/4.99/g" "website/index.html"
sed -i "s/{{PRICE_PAPERBACK}}/14.99/g" "website/index.html"
sed -i "s/{{PRICE_AUDIOBOOK}}/19.99/g" "website/index.html"

# Create book.json
cat > "website/data/book.json" << EOF
{
  "book_number": "${BOOK_NUM}",
  "title": "101 Ways to Die in a Hostel",
  "subtitle": "${SUBTITLE}",
  "slug": "${BOOK_SLUG}",
  "series": "101 Ways to Die in a Hostel",
  "author": {
    "name": "Jonathan ANDERSON",
    "bio": "",
    "website": ""
  },
  "tagline": "Some hostels are a bargain. Others cost you your life.",
  "synopsis": {
    "short": "",
    "long": ""
  },
  "death_type": "${SUBTITLE}",
  "release_date": "",
  "status": "draft",
  "prices": {
    "ebook": 4.99,
    "paperback": 14.99,
    "audiobook": 19.99
  },
  "purchase_links": {
    "amazon_kindle": "",
    "amazon_paperback": "",
    "apple_books": "",
    "google_play": "",
    "audible": "",
    "kobo": ""
  }
}
EOF

# Create vercel.json
cat > "website/vercel.json" << EOF
{
  "version": 2,
  "name": "101ways-${BOOK_SLUG}",
  "routes": [
    { "src": "/(.*)", "dest": "/index.html" }
  ]
}
EOF

success "website installed"

# ============================================================
# LEGAL Directory
# ============================================================
info "Installing LEGAL..."
mkdir -p LEGAL

if [ ! -f "LEGAL/IP_CANON.md" ]; then
    cp "$TEMPLATES_DIR/LEGAL/IP_CANON.md" "LEGAL/"
fi

success "LEGAL installed"

# ============================================================
# REGISTERS Directory
# ============================================================
info "Installing REGISTERS..."
mkdir -p REGISTERS

for file in "$TEMPLATES_DIR/REGISTERS/"*.yaml; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        # Only copy if doesn't exist (preserve existing progress)
        if [ ! -f "REGISTERS/$filename" ]; then
            cp "$file" "REGISTERS/$filename"
        else
            warn "Skipping existing: REGISTERS/$filename"
        fi
    fi
done

success "REGISTERS installed"

# ============================================================
# PUBLICATION Directory
# ============================================================
info "Installing PUBLICATION templates..."
mkdir -p PUBLICATION

for file in "$TEMPLATES_DIR/PUBLICATION/"*.md; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        if [ ! -f "PUBLICATION/$filename" ]; then
            cp "$file" "PUBLICATION/$filename"
            sed -i "s/\[XXX\]/${BOOK_NUM}/g" "PUBLICATION/$filename" 2>/dev/null || true
            sed -i "s/\[TITLE\]/${SUBTITLE}/g" "PUBLICATION/$filename" 2>/dev/null || true
        fi
    fi
done

success "PUBLICATION installed"

# ============================================================
# Chapters Directory Structure
# ============================================================
info "Creating chapters structure..."
mkdir -p chapters/{part-1-setup,part-2-escalation,part-3-crisis,part-4-climax,part-5-aftermath}

success "chapters structure created"

# ============================================================
# Other Directories
# ============================================================
mkdir -p drafts/{raw,revised,polished}
mkdir -p research
mkdir -p assets/{character-sketches,location-photos,mood-board}
mkdir -p output

# ============================================================
# Summary
# ============================================================
echo ""
echo "════════════════════════════════════════════════════════════"
echo -e "${GREEN}SOS-WRITERS Pack Installation Complete${NC}"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "Installed:"
echo "  ✓ AGENTS/          - Writer agent configurations"
echo "  ✓ CANON/           - Book identity templates"
echo "  ✓ OUTLINE/         - Chapter planning"
echo "  ✓ FILM/trailers/   - Video trailer production"
echo "  ✓ website/         - Landing page template"
echo "  ✓ LEGAL/           - IP protection"
echo "  ✓ REGISTERS/       - Progress tracking"
echo "  ✓ PUBLICATION/     - Publishing specs"
echo "  ✓ chapters/        - 5-part structure"
echo "  ✓ drafts/          - Work in progress"
echo ""
echo "Next Steps:"
echo "  1. Fill out CANON/ files with book details"
echo "  2. Complete OUTLINE/CHAPTER_PLAN.md"
echo "  3. Run autonomous writing agent"
echo "  4. Generate trailer assets"
echo "  5. Launch website"
echo ""
echo "Book: #$BOOK_NUM - $SUBTITLE"
echo "════════════════════════════════════════════════════════════"
