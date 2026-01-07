#!/bin/bash

# AI Book Pipeline Orchestrator
# Autonomous multi-book production with parallel AI processing
#
# Usage: ./ai-pipeline.sh [command] [options]
#
# Commands:
#   start       Start the pipeline
#   status      Show current status
#   resume      Resume from last checkpoint
#   stop        Stop all running jobs
#
# Examples:
#   ./ai-pipeline.sh start --books 001-103 --concurrency 5
#   ./ai-pipeline.sh start --books 001,005,010 --tier flagship
#   ./ai-pipeline.sh status
#   ./ai-pipeline.sh resume

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOS_WRITERS_DIR="$(dirname "$SCRIPT_DIR")"
BOOKS_DIR="/home/presidentanderson/Projects/orgs/101-ways-to-die-in-a-hostel/books"
LOG_DIR="$SCRIPT_DIR/logs"
STATE_DIR="$SCRIPT_DIR/.pipeline"
PID_FILE="$STATE_DIR/pipeline.pid"
STATE_FILE="$STATE_DIR/state.yaml"

mkdir -p "$LOG_DIR" "$STATE_DIR"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

usage() {
    cat <<EOF
AI Book Pipeline Orchestrator
Multi-provider AI book production with automatic failover

Usage: $(basename "$0") <command> [options]

Commands:
  start       Start the pipeline
  status      Show current pipeline status
  resume      Resume from last checkpoint
  stop        Stop all running jobs
  providers   Show available AI providers and status

Start Options:
  --books RANGE       Book range: "001-103" or "001,005,010,020"
  --concurrency N     Parallel book sessions (default: 5)
  --tier TIER         AI tier: flagship, balanced, fast (default: balanced)
  --chapters RANGE    Chapter range per book: "1-50" (default: all)
  --dry-run           Show what would run without executing

Examples:
  $(basename "$0") start --books 001-010 --concurrency 3
  $(basename "$0") start --books 077 --tier flagship
  $(basename "$0") start --books 001-103 --concurrency 10 --tier fast
  $(basename "$0") resume
  $(basename "$0") status

Environment Variables Required:
  At least one of: ANTHROPIC_API_KEY, OPENAI_API_KEY, GOOGLE_API_KEY,
  DEEPSEEK_API_KEY, MISTRAL_API_KEY, GROQ_API_KEY, etc.

EOF
    exit 0
}

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Parse book range into array
parse_books() {
    local input="$1"
    local books=()

    if [[ "$input" == *"-"* ]]; then
        # Range format: 001-010
        IFS='-' read -r start end <<< "$input"
        for i in $(seq $((10#$start)) $((10#$end))); do
            books+=($(printf "%03d" $i))
        done
    elif [[ "$input" == *","* ]]; then
        # List format: 001,005,010
        IFS=',' read -ra books <<< "$input"
    else
        # Single book
        books+=("$input")
    fi

    echo "${books[@]}"
}

# Check AI provider availability
check_providers() {
    local available=0

    echo ""
    echo "AI Provider Status:"
    echo "───────────────────────────────────────────────────────────"

    for provider in ANTHROPIC OPENAI GOOGLE DEEPSEEK MISTRAL GROQ TOGETHER XAI COHERE PERPLEXITY FIREWORKS DASHSCOPE; do
        key_var="${provider}_API_KEY"
        if [ -n "${!key_var}" ]; then
            echo -e "  ${GREEN}✓${NC} $provider"
            available=$((available + 1))
        else
            echo -e "  ${RED}✗${NC} $provider (no API key)"
        fi
    done

    echo "───────────────────────────────────────────────────────────"
    echo "Available providers: $available / 12"
    echo ""

    if [ $available -eq 0 ]; then
        error "No AI providers configured. Set at least one API key."
        exit 1
    fi

    return $available
}

# Show pipeline status
show_status() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║     AI PIPELINE STATUS                                     ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo ""

    # Check if pipeline is running
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if ps -p "$PID" > /dev/null 2>&1; then
            success "Pipeline RUNNING (PID: $PID)"
        else
            warn "Pipeline STOPPED (stale PID file)"
            rm -f "$PID_FILE"
        fi
    else
        info "Pipeline NOT RUNNING"
    fi

    echo ""

    # Show state if exists
    if [ -f "$STATE_FILE" ]; then
        echo "Last State:"
        echo "───────────────────────────────────────────────────────────"
        cat "$STATE_FILE"
        echo "───────────────────────────────────────────────────────────"
    fi

    echo ""

    # Count books by status
    local total=0
    local complete=0
    local in_progress=0
    local pending=0

    for book_dir in "$BOOKS_DIR"/book-*; do
        if [ -d "$book_dir" ]; then
            total=$((total + 1))

            # Check progress
            progress_file="$book_dir/REGISTERS/PROGRESS.yaml"
            if [ -f "$progress_file" ]; then
                if grep -q "total_chapters_complete: 50" "$progress_file" 2>/dev/null; then
                    complete=$((complete + 1))
                elif grep -q "chapter_" "$progress_file" 2>/dev/null; then
                    in_progress=$((in_progress + 1))
                else
                    pending=$((pending + 1))
                fi
            else
                pending=$((pending + 1))
            fi
        fi
    done

    echo "Book Status:"
    echo "  Total:       $total"
    echo -e "  ${GREEN}Complete:${NC}    $complete"
    echo -e "  ${YELLOW}In Progress:${NC} $in_progress"
    echo -e "  ${BLUE}Pending:${NC}     $pending"
    echo ""

    # Show recent logs
    echo "Recent Activity:"
    echo "───────────────────────────────────────────────────────────"
    if ls "$LOG_DIR"/*.log 1> /dev/null 2>&1; then
        tail -n 10 "$LOG_DIR"/*.log 2>/dev/null | tail -20
    else
        echo "  No logs yet"
    fi
    echo "───────────────────────────────────────────────────────────"
}

# Start pipeline
start_pipeline() {
    local books_input="$1"
    local concurrency="$2"
    local tier="$3"
    local dry_run="$4"

    # Parse books
    local books=($(parse_books "$books_input"))
    local book_count=${#books[@]}

    echo ""
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║     AI BOOK PIPELINE                                       ║"
    echo "║     101 Ways to Die in a Hostel                            ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo ""
    echo "Configuration:"
    echo "  Books:        ${books[0]} to ${books[-1]} ($book_count total)"
    echo "  Concurrency:  $concurrency parallel sessions"
    echo "  Tier:         $tier"
    echo "  Est. Words:   $((book_count * 250000)) (~$((book_count * 250000 / 1000000))M)"
    echo ""

    check_providers

    if [ "$dry_run" == "true" ]; then
        warn "DRY RUN - Would process:"
        for book in "${books[@]}"; do
            echo "  Book $book"
        done
        exit 0
    fi

    # Save state
    cat > "$STATE_FILE" <<EOF
started: $(date -Iseconds)
books: "${books_input}"
concurrency: $concurrency
tier: $tier
total_books: $book_count
EOF

    # Create job list
    JOB_FILE=$(mktemp)
    for book in "${books[@]}"; do
        echo "$book" >> "$JOB_FILE"
    done

    # Export for parallel jobs
    write_single_book() {
        local book_num=$1
        local tier=$2
        local log_file="$LOG_DIR/book-${book_num}.log"

        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting Book $book_num" >> "$log_file"

        if "$SCRIPT_DIR/ai-write-book.sh" "$book_num" --tier "$tier" >> "$log_file" 2>&1; then
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] Book $book_num COMPLETE" >> "$log_file"
            return 0
        else
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] Book $book_num FAILED" >> "$log_file"
            return 1
        fi
    }

    export -f write_single_book
    export SCRIPT_DIR LOG_DIR

    # Save PID
    echo $$ > "$PID_FILE"

    info "Starting pipeline with $concurrency parallel jobs..."
    echo ""

    # Run with GNU parallel if available
    if command -v parallel &> /dev/null; then
        cat "$JOB_FILE" | parallel \
            -j "$concurrency" \
            --delay 5 \
            --progress \
            --joblog "$LOG_DIR/parallel.log" \
            write_single_book {} "$tier"
    else
        warn "GNU parallel not found. Using sequential processing."
        warn "Install with: sudo apt install parallel"

        for book in "${books[@]}"; do
            write_single_book "$book" "$tier"
        done
    fi

    rm -f "$JOB_FILE" "$PID_FILE"

    # Update state
    echo "completed: $(date -Iseconds)" >> "$STATE_FILE"

    echo ""
    success "Pipeline complete!"
    show_status
}

# Stop pipeline
stop_pipeline() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if ps -p "$PID" > /dev/null 2>&1; then
            info "Stopping pipeline (PID: $PID)..."
            kill -TERM "$PID" 2>/dev/null || true

            # Kill any child processes
            pkill -P "$PID" 2>/dev/null || true

            rm -f "$PID_FILE"
            success "Pipeline stopped"
        else
            warn "Pipeline not running (stale PID)"
            rm -f "$PID_FILE"
        fi
    else
        info "Pipeline not running"
    fi
}

# Main
main() {
    local command="${1:-help}"
    shift || true

    # Defaults
    local books="001-103"
    local concurrency=5
    local tier="balanced"
    local dry_run="false"

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --books) books="$2"; shift 2 ;;
            --concurrency) concurrency="$2"; shift 2 ;;
            --tier) tier="$2"; shift 2 ;;
            --dry-run) dry_run="true"; shift ;;
            --help|-h) usage ;;
            *) shift ;;
        esac
    done

    case "$command" in
        start)
            start_pipeline "$books" "$concurrency" "$tier" "$dry_run"
            ;;
        status)
            show_status
            ;;
        resume)
            if [ -f "$STATE_FILE" ]; then
                # Read state and resume
                source <(grep -E "^(books|concurrency|tier):" "$STATE_FILE" | sed 's/: /=/')
                start_pipeline "$books" "$concurrency" "$tier" "false"
            else
                error "No previous state found. Use 'start' instead."
                exit 1
            fi
            ;;
        stop)
            stop_pipeline
            ;;
        providers)
            check_providers
            ;;
        help|--help|-h)
            usage
            ;;
        *)
            error "Unknown command: $command"
            usage
            ;;
    esac
}

main "$@"
