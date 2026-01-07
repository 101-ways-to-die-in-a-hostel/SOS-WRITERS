#!/bin/bash
# ai-router.sh - Multi-AI provider router with automatic failover
# Usage: ./ai-router.sh --prompt "Your prompt" [--tier TIER] [--provider PROVIDER]
#
# Routes AI requests through multiple providers with automatic failover
# when rate limits or errors occur.
#
# Copyright (c) 2024-2026 Jonathan Mitchell Anderson
# See LEGAL/IP_CANON.md for terms.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CANON_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CONFIG_FILE="${CANON_ROOT}/config/ai-providers.yaml"

# Source audit logging
source "${CANON_ROOT}/ops/audit.sh" 2>/dev/null || true

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Defaults
PROMPT=""
SYSTEM_PROMPT=""
TIER="balanced"
PREFERRED_PROVIDER=""
MAX_RETRIES=3
RETRY_DELAY=1
TIMEOUT=120
JSON_OUTPUT=false
VERBOSE=false
STREAM=false

# Rate limit tracking (in-memory for this session)
declare -A PROVIDER_BLOCKED
declare -A PROVIDER_BLOCK_UNTIL

# Cost tracking
TOTAL_INPUT_TOKENS=0
TOTAL_OUTPUT_TOKENS=0
TOTAL_COST=0

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Route AI requests with automatic failover across 12 providers.

Options:
  --prompt TEXT        The prompt to send (required, or use --file)
  --file FILE          Read prompt from file
  --system TEXT        System prompt
  --tier TIER          Model tier: flagship, balanced, fast, reasoning, code (default: balanced)
  --provider NAME      Prefer specific provider (still fails over if needed)
  --model MODEL        Use specific model ID
  --max-retries N      Max retries per provider (default: 3)
  --timeout SECONDS    Request timeout (default: 120)
  --json               Output raw JSON response
  --verbose            Show detailed routing info
  --stream             Stream response (if supported)
  --dry-run            Show routing plan without executing
  --status             Show provider availability status
  --help               Show this help

Tiers:
  flagship   - Best quality (Claude Opus, GPT-4o, Gemini Pro)
  balanced   - Good quality/speed balance (Claude Sonnet, Gemini Flash)
  fast       - Fastest response (Claude Haiku, GPT-4o-mini, Qwen Turbo)
  reasoning  - Deep reasoning (o1, DeepSeek R1)
  code       - Code-optimized (Codestral, DeepSeek)

Examples:
  $(basename "$0") --prompt "Explain quantum computing" --tier flagship
  $(basename "$0") --prompt "Fix this code" --tier code --provider deepseek
  $(basename "$0") --file prompt.txt --tier reasoning --verbose
  $(basename "$0") --status

Environment Variables:
  ANTHROPIC_API_KEY, OPENAI_API_KEY, GOOGLE_API_KEY, DASHSCOPE_API_KEY,
  DEEPSEEK_API_KEY, MISTRAL_API_KEY, GROQ_API_KEY, TOGETHER_API_KEY,
  XAI_API_KEY, COHERE_API_KEY, PERPLEXITY_API_KEY, FIREWORKS_API_KEY

EOF
    exit 0
}

# Get tier fallback chain from config
get_tier_chain() {
    local tier="$1"

    case "$tier" in
        flagship)
            echo "anthropic:claude-opus-4-5-20251101 openai:gpt-4o google:gemini-1.5-pro alibaba:qwen-max mistral:mistral-large-latest xai:grok-2-latest cohere:command-r-plus"
            ;;
        balanced)
            echo "anthropic:claude-sonnet-4-20250514 google:gemini-1.5-flash alibaba:qwen-plus mistral:mistral-small-latest cohere:command-r openai:gpt-4o-mini"
            ;;
        fast)
            echo "anthropic:claude-3-5-haiku-20241022 openai:gpt-4o-mini google:gemini-2.0-flash alibaba:qwen-turbo groq:llama-3.1-8b-instant deepseek:deepseek-chat"
            ;;
        reasoning)
            echo "openai:o1 deepseek:deepseek-reasoner together:deepseek-ai/DeepSeek-R1 fireworks:accounts/fireworks/models/deepseek-r1 openai:o1-mini"
            ;;
        code)
            echo "mistral:codestral-latest deepseek:deepseek-chat anthropic:claude-sonnet-4-20250514 openai:gpt-4o"
            ;;
        *)
            echo "anthropic:claude-sonnet-4-20250514 openai:gpt-4o google:gemini-1.5-flash"
            ;;
    esac
}

# Check if provider has valid API key
has_api_key() {
    local provider="$1"

    case "$provider" in
        anthropic) [[ -n "${ANTHROPIC_API_KEY:-}" ]] ;;
        openai) [[ -n "${OPENAI_API_KEY:-}" ]] ;;
        google) [[ -n "${GOOGLE_API_KEY:-}" ]] ;;
        alibaba) [[ -n "${DASHSCOPE_API_KEY:-}" ]] ;;
        deepseek) [[ -n "${DEEPSEEK_API_KEY:-}" ]] ;;
        mistral) [[ -n "${MISTRAL_API_KEY:-}" ]] ;;
        groq) [[ -n "${GROQ_API_KEY:-}" ]] ;;
        together) [[ -n "${TOGETHER_API_KEY:-}" ]] ;;
        xai) [[ -n "${XAI_API_KEY:-}" ]] ;;
        cohere) [[ -n "${COHERE_API_KEY:-}" ]] ;;
        perplexity) [[ -n "${PERPLEXITY_API_KEY:-}" ]] ;;
        fireworks) [[ -n "${FIREWORKS_API_KEY:-}" ]] ;;
        *) return 1 ;;
    esac
}

# Check if provider is currently blocked (rate limited)
is_provider_blocked() {
    local provider="$1"
    local now
    now=$(date +%s)

    if [[ -n "${PROVIDER_BLOCK_UNTIL[$provider]:-}" ]]; then
        if [[ $now -lt ${PROVIDER_BLOCK_UNTIL[$provider]} ]]; then
            return 0  # Still blocked
        else
            unset PROVIDER_BLOCKED[$provider]
            unset PROVIDER_BLOCK_UNTIL[$provider]
        fi
    fi
    return 1  # Not blocked
}

# Block a provider temporarily
block_provider() {
    local provider="$1"
    local duration="${2:-60}"  # Default 60 seconds

    local until
    until=$(($(date +%s) + duration))
    PROVIDER_BLOCKED[$provider]=1
    PROVIDER_BLOCK_UNTIL[$provider]=$until

    if [[ "$VERBOSE" == "true" ]]; then
        echo -e "${YELLOW}[ROUTER] Blocked ${provider} for ${duration}s${NC}" >&2
    fi
}

# Make API call to Anthropic
call_anthropic() {
    local model="$1"
    local prompt="$2"
    local system="${3:-}"

    local messages
    messages=$(jq -n --arg content "$prompt" '[{"role": "user", "content": $content}]')

    local body
    if [[ -n "$system" ]]; then
        body=$(jq -n \
            --arg model "$model" \
            --argjson messages "$messages" \
            --arg system "$system" \
            '{model: $model, max_tokens: 4096, system: $system, messages: $messages}')
    else
        body=$(jq -n \
            --arg model "$model" \
            --argjson messages "$messages" \
            '{model: $model, max_tokens: 4096, messages: $messages}')
    fi

    curl -s --max-time "$TIMEOUT" \
        -H "x-api-key: ${ANTHROPIC_API_KEY}" \
        -H "anthropic-version: 2023-06-01" \
        -H "content-type: application/json" \
        -d "$body" \
        "https://api.anthropic.com/v1/messages"
}

# Make API call to OpenAI-compatible endpoints
call_openai_compatible() {
    local base_url="$1"
    local api_key="$2"
    local model="$3"
    local prompt="$4"
    local system="${5:-You are a helpful assistant.}"

    local body
    body=$(jq -n \
        --arg model "$model" \
        --arg system "$system" \
        --arg user "$prompt" \
        '{model: $model, messages: [{role: "system", content: $system}, {role: "user", content: $user}], max_tokens: 4096}')

    curl -s --max-time "$TIMEOUT" \
        -H "Authorization: Bearer ${api_key}" \
        -H "Content-Type: application/json" \
        -d "$body" \
        "${base_url}/chat/completions"
}

# Make API call to Google
call_google() {
    local model="$1"
    local prompt="$2"

    local body
    body=$(jq -n \
        --arg text "$prompt" \
        '{contents: [{parts: [{text: $text}]}]}')

    curl -s --max-time "$TIMEOUT" \
        -H "Content-Type: application/json" \
        -d "$body" \
        "https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${GOOGLE_API_KEY}"
}

# Make API call to Cohere
call_cohere() {
    local model="$1"
    local prompt="$2"

    local body
    body=$(jq -n \
        --arg model "$model" \
        --arg message "$prompt" \
        '{model: $model, message: $message}')

    curl -s --max-time "$TIMEOUT" \
        -H "Authorization: Bearer ${COHERE_API_KEY}" \
        -H "Content-Type: application/json" \
        -d "$body" \
        "https://api.cohere.ai/v1/chat"
}

# Extract response text from different API formats
extract_response() {
    local provider="$1"
    local response="$2"

    case "$provider" in
        anthropic)
            echo "$response" | jq -r '.content[0].text // empty' 2>/dev/null
            ;;
        google)
            echo "$response" | jq -r '.candidates[0].content.parts[0].text // empty' 2>/dev/null
            ;;
        cohere)
            echo "$response" | jq -r '.text // empty' 2>/dev/null
            ;;
        *)
            # OpenAI-compatible format
            echo "$response" | jq -r '.choices[0].message.content // empty' 2>/dev/null
            ;;
    esac
}

# Check if response indicates rate limit
is_rate_limited() {
    local response="$1"

    # Check HTTP status in response
    if echo "$response" | grep -qiE '"error".*"rate_limit|429|"overloaded"|"capacity"'; then
        return 0
    fi
    return 1
}

# Check if response is an error
is_error_response() {
    local response="$1"

    if echo "$response" | jq -e '.error' > /dev/null 2>&1; then
        return 0
    fi
    return 1
}

# Route request to a specific provider
route_to_provider() {
    local provider="$1"
    local model="$2"
    local prompt="$3"
    local system="${4:-}"

    if [[ "$VERBOSE" == "true" ]]; then
        echo -e "${CYAN}[ROUTER] Trying ${provider}:${model}${NC}" >&2
    fi

    local response=""

    case "$provider" in
        anthropic)
            response=$(call_anthropic "$model" "$prompt" "$system")
            ;;
        openai)
            response=$(call_openai_compatible "https://api.openai.com/v1" "$OPENAI_API_KEY" "$model" "$prompt" "$system")
            ;;
        google)
            response=$(call_google "$model" "$prompt")
            ;;
        alibaba)
            response=$(call_openai_compatible "https://dashscope.aliyuncs.com/compatible-mode/v1" "$DASHSCOPE_API_KEY" "$model" "$prompt" "$system")
            ;;
        deepseek)
            response=$(call_openai_compatible "https://api.deepseek.com/v1" "$DEEPSEEK_API_KEY" "$model" "$prompt" "$system")
            ;;
        mistral)
            response=$(call_openai_compatible "https://api.mistral.ai/v1" "$MISTRAL_API_KEY" "$model" "$prompt" "$system")
            ;;
        groq)
            response=$(call_openai_compatible "https://api.groq.com/openai/v1" "$GROQ_API_KEY" "$model" "$prompt" "$system")
            ;;
        together)
            response=$(call_openai_compatible "https://api.together.xyz/v1" "$TOGETHER_API_KEY" "$model" "$prompt" "$system")
            ;;
        xai)
            response=$(call_openai_compatible "https://api.x.ai/v1" "$XAI_API_KEY" "$model" "$prompt" "$system")
            ;;
        cohere)
            response=$(call_cohere "$model" "$prompt")
            ;;
        perplexity)
            response=$(call_openai_compatible "https://api.perplexity.ai" "$PERPLEXITY_API_KEY" "$model" "$prompt" "$system")
            ;;
        fireworks)
            response=$(call_openai_compatible "https://api.fireworks.ai/inference/v1" "$FIREWORKS_API_KEY" "$model" "$prompt" "$system")
            ;;
        *)
            echo -e "${RED}Unknown provider: ${provider}${NC}" >&2
            return 1
            ;;
    esac

    # Check for rate limit
    if is_rate_limited "$response"; then
        if [[ "$VERBOSE" == "true" ]]; then
            echo -e "${YELLOW}[ROUTER] Rate limited by ${provider}${NC}" >&2
        fi
        block_provider "$provider" 60
        return 2  # Rate limited - try next
    fi

    # Check for other errors
    if is_error_response "$response"; then
        local error_msg
        error_msg=$(echo "$response" | jq -r '.error.message // .error // "Unknown error"' 2>/dev/null)
        if [[ "$VERBOSE" == "true" ]]; then
            echo -e "${RED}[ROUTER] Error from ${provider}: ${error_msg}${NC}" >&2
        fi
        return 1
    fi

    # Extract and return response
    local text
    text=$(extract_response "$provider" "$response")

    if [[ -n "$text" ]]; then
        if [[ "$JSON_OUTPUT" == "true" ]]; then
            echo "$response"
        else
            echo "$text"
        fi

        # Log success
        if declare -f audit_log &>/dev/null; then
            audit_log "ai-request" "${provider}:${model}" "success" "tier=${TIER}"
        fi

        return 0
    fi

    return 1
}

# Main routing logic with failover
route_request() {
    local prompt="$1"
    local system="${2:-}"

    local chain
    chain=$(get_tier_chain "$TIER")

    # If preferred provider specified, put it first
    if [[ -n "$PREFERRED_PROVIDER" ]]; then
        local preferred_models=""
        for entry in $chain; do
            if [[ "$entry" == "${PREFERRED_PROVIDER}:"* ]]; then
                preferred_models="$entry $preferred_models"
            fi
        done
        chain="$preferred_models $chain"
    fi

    if [[ "$VERBOSE" == "true" ]]; then
        echo -e "${BLUE}[ROUTER] Tier: ${TIER}${NC}" >&2
        echo -e "${BLUE}[ROUTER] Chain: ${chain}${NC}" >&2
    fi

    local attempts=0
    local max_total_attempts=$((MAX_RETRIES * 12))  # Don't loop forever

    for entry in $chain; do
        if [[ $attempts -ge $max_total_attempts ]]; then
            break
        fi

        local provider="${entry%%:*}"
        local model="${entry#*:}"

        # Skip if no API key
        if ! has_api_key "$provider"; then
            if [[ "$VERBOSE" == "true" ]]; then
                echo -e "${YELLOW}[ROUTER] Skipping ${provider} - no API key${NC}" >&2
            fi
            continue
        fi

        # Skip if blocked
        if is_provider_blocked "$provider"; then
            if [[ "$VERBOSE" == "true" ]]; then
                echo -e "${YELLOW}[ROUTER] Skipping ${provider} - rate limited${NC}" >&2
            fi
            continue
        fi

        # Try this provider
        local retry=0
        while [[ $retry -lt $MAX_RETRIES ]]; do
            ((attempts++))

            if route_to_provider "$provider" "$model" "$prompt" "$system"; then
                return 0
            fi

            local exit_code=$?
            if [[ $exit_code -eq 2 ]]; then
                # Rate limited - move to next provider immediately
                break
            fi

            ((retry++))
            if [[ $retry -lt $MAX_RETRIES ]]; then
                sleep "$RETRY_DELAY"
            fi
        done
    done

    echo -e "${RED}[ROUTER] All providers exhausted${NC}" >&2

    if declare -f audit_log &>/dev/null; then
        audit_log "ai-request" "all-providers" "failed" "tier=${TIER},attempts=${attempts}"
    fi

    return 1
}

# Show provider status
show_status() {
    echo -e "${BLUE}=== AI Provider Status ===${NC}"
    echo ""

    local providers="anthropic openai google alibaba deepseek mistral groq together xai cohere perplexity fireworks"

    printf "%-15s %-12s %-10s\n" "Provider" "API Key" "Status"
    printf "%-15s %-12s %-10s\n" "--------" "-------" "------"

    for provider in $providers; do
        local key_status="${RED}Missing${NC}"
        local block_status="${GREEN}Available${NC}"

        if has_api_key "$provider"; then
            key_status="${GREEN}Set${NC}"
        fi

        if is_provider_blocked "$provider"; then
            block_status="${YELLOW}Blocked${NC}"
        fi

        printf "%-15s " "$provider"
        echo -e "$key_status\t$block_status"
    done

    echo ""
    echo "Tier chains:"
    for tier in flagship balanced fast reasoning code; do
        echo -e "  ${CYAN}${tier}:${NC} $(get_tier_chain "$tier" | tr ' ' '→' | head -c 80)..."
    done
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --prompt) PROMPT="$2"; shift 2 ;;
        --file) PROMPT=$(cat "$2"); shift 2 ;;
        --system) SYSTEM_PROMPT="$2"; shift 2 ;;
        --tier) TIER="$2"; shift 2 ;;
        --provider) PREFERRED_PROVIDER="$2"; shift 2 ;;
        --model) PREFERRED_MODEL="$2"; shift 2 ;;
        --max-retries) MAX_RETRIES="$2"; shift 2 ;;
        --timeout) TIMEOUT="$2"; shift 2 ;;
        --json) JSON_OUTPUT=true; shift ;;
        --verbose) VERBOSE=true; shift ;;
        --stream) STREAM=true; shift ;;
        --dry-run)
            echo "Routing plan for tier: $TIER"
            get_tier_chain "${TIER:-balanced}"
            exit 0
            ;;
        --status) show_status; exit 0 ;;
        --help|-h) usage ;;
        *) echo "Unknown option: $1"; usage ;;
    esac
done

# Validate
if [[ -z "$PROMPT" ]]; then
    echo -e "${RED}Error: --prompt or --file required${NC}"
    usage
fi

# Route the request
route_request "$PROMPT" "$SYSTEM_PROMPT"
