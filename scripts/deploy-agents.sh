#!/bin/bash

# Deploy Sovereign Canon Agents to All Book Repos
# SOS for Writers - Agent Deployment Script

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOS_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATES_DIR="$SOS_DIR/templates"
BOOKS_DIR="/home/presidentanderson/Projects/orgs/101-ways-to-die-in-a-hostel/books"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     SOS for Writers - Agent Deployment                     ║"
echo "║     Deploying Sovereign Canon Agents to 103 Book Repos     ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Check directories exist
if [ ! -d "$TEMPLATES_DIR" ]; then
    echo "ERROR: Templates directory not found: $TEMPLATES_DIR"
    exit 1
fi

if [ ! -d "$BOOKS_DIR" ]; then
    echo "ERROR: Books directory not found: $BOOKS_DIR"
    exit 1
fi

# Count books
BOOK_COUNT=$(ls -d "$BOOKS_DIR"/book-* 2>/dev/null | wc -l)
echo "Found $BOOK_COUNT book repositories"
echo ""

# Deploy to each book
DEPLOYED=0
for book_dir in "$BOOKS_DIR"/book-*; do
    if [ -d "$book_dir" ]; then
        book_name=$(basename "$book_dir")
        echo "Deploying to: $book_name"

        # Create AGENTS directory
        mkdir -p "$book_dir/AGENTS"

        # Copy agent files
        cp "$TEMPLATES_DIR/AGENTS/WRITER_AGENT_INIT_CONTRACT.md" "$book_dir/AGENTS/"
        cp "$TEMPLATES_DIR/AGENTS/WRITER_AUTONOMOUS_INSTRUCTIONS.md" "$book_dir/AGENTS/"
        cp "$TEMPLATES_DIR/AGENTS/WRITER_AGENT_BRIEF.md" "$book_dir/AGENTS/"

        # Create LEGAL directory
        mkdir -p "$book_dir/LEGAL"
        cp "$TEMPLATES_DIR/LEGAL/IP_CANON.md" "$book_dir/LEGAL/"

        # Create REGISTERS directory (if not exists) and copy templates
        mkdir -p "$book_dir/REGISTERS"

        # Only copy PROGRESS.yaml if it doesn't exist (preserve existing progress)
        if [ ! -f "$book_dir/REGISTERS/PROGRESS.yaml" ]; then
            cp "$TEMPLATES_DIR/REGISTERS/PROGRESS.yaml" "$book_dir/REGISTERS/"
        fi

        if [ ! -f "$book_dir/REGISTERS/WORD_COUNT.yaml" ]; then
            cp "$TEMPLATES_DIR/REGISTERS/WORD_COUNT.yaml" "$book_dir/REGISTERS/"
        fi

        if [ ! -f "$book_dir/REGISTERS/CONTINUITY_LOG.yaml" ]; then
            cp "$TEMPLATES_DIR/REGISTERS/CONTINUITY_LOG.yaml" "$book_dir/REGISTERS/"
        fi

        DEPLOYED=$((DEPLOYED + 1))
    fi
done

echo ""
echo "════════════════════════════════════════════════════════════"
echo "Deployment Complete!"
echo "  Books updated: $DEPLOYED"
echo ""
echo "Files deployed to each repo:"
echo "  AGENTS/"
echo "    ├── WRITER_AGENT_INIT_CONTRACT.md"
echo "    ├── WRITER_AUTONOMOUS_INSTRUCTIONS.md"
echo "    └── WRITER_AGENT_BRIEF.md"
echo "  LEGAL/"
echo "    └── IP_CANON.md"
echo "  REGISTERS/"
echo "    ├── PROGRESS.yaml"
echo "    ├── WORD_COUNT.yaml"
echo "    └── CONTINUITY_LOG.yaml"
echo "════════════════════════════════════════════════════════════"
