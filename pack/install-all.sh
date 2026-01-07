#!/bin/bash
#
# SOS-WRITERS Batch Installer
# Installs the production pipeline to ALL book repos in the organization
#
# Usage:
#   ./pack/install-all.sh [options]
#
# Options:
#   --books RANGE     Book range: "001-103" or "001,005,010" (default: all)
#   --dry-run         Show what would be installed without installing
#   --force           Overwrite existing files (default: skip existing)
#   --parallel N      Install N repos in parallel (default: 1)

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOS_WRITERS_DIR="$(dirname "$SCRIPT_DIR")"
BOOKS_DIR="/home/presidentanderson/Projects/orgs/101-ways-to-die-in-a-hostel/books"
INSTALLER="$SCRIPT_DIR/install.sh"

# Defaults
BOOK_RANGE="all"
DRY_RUN=false
FORCE=false
PARALLEL=1

usage() {
    cat <<EOF
SOS-WRITERS Batch Installer
Install the production pipeline to multiple book repositories

Usage: $(basename "$0") [options]

Options:
  --books RANGE     Book range to install:
                    "all" - All books (default)
                    "001-010" - Range of books
                    "001,005,010" - Specific books
  --dry-run         Show what would be installed
  --force           Overwrite existing files
  --parallel N      Install N repos in parallel (default: 1)
  --help            Show this help

Examples:
  $(basename "$0")                          # Install to all books
  $(basename "$0") --books 001-010          # Install to books 1-10
  $(basename "$0") --books 001,050,100      # Install to specific books
  $(basename "$0") --dry-run                # Preview installation
  $(basename "$0") --parallel 10            # Install 10 at a time

EOF
    exit 0
}

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Parse book range into array of directories
get_book_dirs() {
    local range="$1"
    local dirs=()

    if [ "$range" == "all" ]; then
        # All book directories
        for dir in "$BOOKS_DIR"/book-*; do
            if [ -d "$dir" ]; then
                dirs+=("$dir")
            fi
        done
    elif [[ "$range" == *"-"* ]]; then
        # Range format: 001-010
        IFS='-' read -r start end <<< "$range"
        for i in $(seq $((10#$start)) $((10#$end))); do
            num=$(printf "%03d" $i)
            dir=$(find "$BOOKS_DIR" -maxdepth 1 -type d -name "book-${num}-*" 2>/dev/null | head -1)
            if [ -d "$dir" ]; then
                dirs+=("$dir")
            fi
        done
    elif [[ "$range" == *","* ]]; then
        # List format: 001,005,010
        IFS=',' read -ra nums <<< "$range"
        for num in "${nums[@]}"; do
            num=$(printf "%03d" $((10#$num)))
            dir=$(find "$BOOKS_DIR" -maxdepth 1 -type d -name "book-${num}-*" 2>/dev/null | head -1)
            if [ -d "$dir" ]; then
                dirs+=("$dir")
            fi
        done
    else
        # Single book
        num=$(printf "%03d" $((10#$range)))
        dir=$(find "$BOOKS_DIR" -maxdepth 1 -type d -name "book-${num}-*" 2>/dev/null | head -1)
        if [ -d "$dir" ]; then
            dirs+=("$dir")
        fi
    fi

    echo "${dirs[@]}"
}

# Install to a single repo
install_single() {
    local dir="$1"
    local name=$(basename "$dir")

    if [ "$DRY_RUN" == "true" ]; then
        echo "  [DRY-RUN] Would install to: $name"
        return 0
    fi

    echo -e "${CYAN}Installing:${NC} $name"

    if "$INSTALLER" "$dir" > /dev/null 2>&1; then
        success "$name"
        return 0
    else
        error "$name - FAILED"
        return 1
    fi
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --books)
            BOOK_RANGE="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --force)
            FORCE=true
            shift
            ;;
        --parallel)
            PARALLEL="$2"
            shift 2
            ;;
        --help|-h)
            usage
            ;;
        *)
            shift
            ;;
    esac
done

# Check installer exists
if [ ! -f "$INSTALLER" ]; then
    error "Installer not found: $INSTALLER"
    exit 1
fi

# Make installer executable
chmod +x "$INSTALLER"

# Get target directories
DIRS=($(get_book_dirs "$BOOK_RANGE"))
TOTAL=${#DIRS[@]}

if [ $TOTAL -eq 0 ]; then
    error "No book directories found for range: $BOOK_RANGE"
    exit 1
fi

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║     SOS-WRITERS BATCH INSTALLER                            ║"
echo "║     101 Ways to Die in a Hostel                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Books Directory: $BOOKS_DIR"
echo "Target Range:    $BOOK_RANGE"
echo "Total Repos:     $TOTAL"
echo "Parallel:        $PARALLEL"
echo "Dry Run:         $DRY_RUN"
echo ""

if [ "$DRY_RUN" == "true" ]; then
    warn "DRY RUN MODE - No changes will be made"
    echo ""
fi

# Confirm
if [ "$DRY_RUN" != "true" ]; then
    read -p "Install SOS-WRITERS pack to $TOTAL repositories? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi
fi

echo ""
info "Starting installation..."
echo ""

# Track results
INSTALLED=0
FAILED=0
START_TIME=$(date +%s)

# Export for parallel
export -f install_single
export INSTALLER DRY_RUN

if [ "$PARALLEL" -gt 1 ] && command -v parallel &> /dev/null; then
    # Use GNU parallel
    printf '%s\n' "${DIRS[@]}" | parallel -j "$PARALLEL" install_single {}
    # Can't easily track success/fail with parallel, so estimate
    INSTALLED=$TOTAL
else
    # Sequential installation
    for dir in "${DIRS[@]}"; do
        if install_single "$dir"; then
            INSTALLED=$((INSTALLED + 1))
        else
            FAILED=$((FAILED + 1))
        fi
    done
fi

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo ""
echo "════════════════════════════════════════════════════════════"
echo -e "${GREEN}Batch Installation Complete${NC}"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "Results:"
echo "  Total:     $TOTAL"
echo "  Installed: $INSTALLED"
echo "  Failed:    $FAILED"
echo "  Duration:  ${DURATION}s"
echo ""

if [ "$DRY_RUN" == "true" ]; then
    echo "This was a dry run. Run without --dry-run to install."
fi
