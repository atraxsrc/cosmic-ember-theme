#!/bin/bash
set -eo pipefail

# ─────────────────────────────────────────────
#  Ember palette (dark terminal)
#  pane:    #1B1E24   fg:      #D6D9E0   (terminal pane; window bg #15171C)
#  ember:   #E8713A   moss:    #8FB58A
#  amber:   #D9A441   brick:   #D85A5A
#  muted:   #7C8290   comment: #5A6070
# ─────────────────────────────────────────────

# Ember - using $'...' so escape bytes are stored at assignment time
# and work correctly with both echo -e and printf "%s"
CYAN=$'\033[38;2;214;217;224m'      # #D6D9E0  - section headers (text)
BLUE=$'\033[38;2;232;113;58m'     # #E8713A  - info / commands (ember)
PURPLE=$'\033[38;2;176;139;196m'   # #B08BC4  - highlights (heather)
GREEN=$'\033[38;2;143;181;138m'     # #8FB58A  - success (moss)
YELLOW=$'\033[38;2;217;164;65m'   # #D9A441  - warnings (amber)
ORANGE=$'\033[38;2;124;130;144m'   # #7C8290  - skipped (muted)
RED=$'\033[38;2;216;90;90m'      # #D85A5A  - errors (brick)
DIM=$'\033[38;2;90;96;112m'      # #5A6070  - comments / dim text
BOLD=$'\033[1m'
RESET=$'\033[0m'

# ── Helpers ────────────────────────────────────────────────────────────────────

print_header() {
    echo
    echo -e "${CYAN}${BOLD}┌─ $1 ${DIM}──────────────────────────────────────${RESET}"
}

print_success() { echo -e "  ${GREEN}✓ $1${RESET}"; }
print_info()    { echo -e "  ${BLUE}→ $1${RESET}"; }
print_warn()    { echo -e "  ${YELLOW}⚠ $1${RESET}"; }
print_skip()    { echo -e "  ${ORANGE}⊘ $1${RESET}"; }
print_error()   { echo -e "  ${RED}✗ $1${RESET}"; }
print_dim()     { echo -e "  ${DIM}$1${RESET}"; }

command_exists() { command -v "$1" >/dev/null 2>&1; }

# ── Config ─────────────────────────────────────────────────────────────────────

# Phased updates: Ubuntu staggers non-security updates so a bad one only hits a
# fraction of machines first. Setting this to "true" opts out of that - you pull
# every update immediately and become an early tester. Security updates are never
# phased, so they always install regardless of this setting.
#   true  = always pull phased updates now (early-adopter)
#   false = honor the rollout, install when it reaches you (safer default)
INCLUDE_PHASED=true

# Built once and passed to apt/nala. Empty when INCLUDE_PHASED=false.
PHASED_OPT=()
if [ "$INCLUDE_PHASED" = true ]; then
    PHASED_OPT=(-o APT::Get::Always-Include-Phased-Updates=true)
fi

# ── Update functions ───────────────────────────────────────────────────────────

update_system() {
    print_header "System Packages"

    if [ "$INCLUDE_PHASED" = true ]; then
        print_dim "Including phased updates (early-adopter mode)"
    fi

    if command_exists nala; then
        print_info "Package manager: nala"
        sudo nala update
        sudo nala upgrade --full -y "${PHASED_OPT[@]}"
#        sudo nala autoremove -y
        sudo nala clean
        print_success "Nala system update complete"

    elif command_exists apt; then
        print_info "Package manager: apt (nala not found)"
        sudo apt update
        sudo apt full-upgrade -y "${PHASED_OPT[@]}"
#        sudo apt autoremove -y
        sudo apt autoclean
        print_success "APT system update complete"

    else
        print_error "No supported package manager found - skipping"
        return 1
    fi
}

update_flatpak() {
    print_header "Flatpak"
    if ! command_exists flatpak; then
        print_skip "Flatpak not installed - skipping"
        return 0
    fi

    print_info "Running flatpak update..."
    if flatpak update -y; then
        print_success "Flatpak updates applied"
    else
        print_warn "Flatpak finished with some warnings"
    fi
}

update_snap() {
    print_header "Snap"

    if ! command_exists snap; then
        print_skip "Snap not installed - skipping"
        return 0
    fi

    print_info "Running snap refresh..."
    local output
    output=$(sudo snap refresh 2>&1) || true
    while IFS= read -r line; do
        echo -e "  ${DIM}${line}${RESET}"
    done <<< "$output"

    if echo "$output" | grep -q "All snaps up to date"; then
        print_success "All snaps are already up to date"
    else
        print_success "Snap updates applied"
    fi
}

# ── Logo ───────────────────────────────────────────────────────────────────────

# COSMIC logo accent colors - global scope so $'...' escapes work correctly
TEAL=$'\033[38;2;214;217;224m'  # #D6D9E0  text (left half of the rule)
ORG=$'\033[38;2;232;113;58m'    # #E8713A  ember (right half of the rule)

# Banner rows, ANSI Shadow figlet font. All 46 columns wide; keep them that way
# or the gradient below will drift out of alignment with the letterforms.
LOGO_ROWS=(
    ' ██████╗ ██╗  ██╗██████╗ ███████╗██╗   ██╗ ██╗'
    '██╔═████╗╚██╗██╔╝██╔══██╗██╔════╝██║   ██║███║'
    '██║██╔██║ ╚███╔╝ ██║  ██║█████╗  ██║   ██║╚██║'
    '████╔╝██║ ██╔██╗ ██║  ██║██╔══╝  ╚██╗ ██╔╝ ██║'
    '╚██████╔╝██╔╝ ██╗██████╔╝███████╗ ╚████╔╝  ██║'
    ' ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚══════╝  ╚═══╝   ╚═╝'
)

# Per-column colours for the banner: text to ember, left to right. One entry per column, 46 total.
LOGO_GRAD=(
    "214;217;224" "214;215;220" "215;212;217" "215;210;213" "216;208;209" "216;205;206"
    "216;203;202" "217;201;198" "217;199;194" "218;196;191" "218;194;187" "218;192;183"
    "219;189;180" "219;187;176" "220;185;172" "220;182;169" "220;180;165" "221;178;161"
    "221;175;158" "222;173;154" "222;171;150" "222;168;147" "223;166;143" "223;164;139"
    "224;162;135" "224;159;132" "224;157;128" "225;155;124" "225;152;121" "226;150;117"
    "226;148;113" "226;145;110" "227;143;106" "227;141;102" "228;138;99" "228;136;95"
    "228;134;91" "229;131;88" "229;129;84" "230;127;80" "230;125;76" "230;122;73"
    "231;120;69" "231;118;65" "232;115;62" "232;113;58"
)

# Draw the banner one character at a time, colouring by column index so the
# gradient runs horizontally across the whole word. Every glyph gets the ramp,
# including the box-drawing bevel characters (╔ ═ ╗ ║ ╚ ╝) - colouring those
# separately puts stray marks inside the 0, the D bowl and the e, which reads
# as noise sitting on top of the letters rather than as depth.
print_logo() {
    # figlet rows are multibyte; force a UTF-8 locale so ${row:i:1} steps by
    # character instead of by byte. Local to this function only.
    local LC_ALL=C.UTF-8
    local row ch out i

    echo
    for row in "${LOGO_ROWS[@]}"; do
        out=""
        for (( i = 0; i < ${#row}; i++ )); do
            ch="${row:i:1}"
            if [ "$ch" = " " ]; then
                out+=" "
            else
                out+=$'\033[1;38;2;'"${LOGO_GRAD[i]}"$'m'"$ch"
            fi
        done
        printf '  %s%s\n' "$out" "$RESET"
    done

    echo
    printf "  ${TEAL}━━━━━━━━━━━━━━━━━━━━━━━${ORG}━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
    printf "  ${DIM}  Pop!_OS · COSMIC DE · System Update${RESET}\n"
    printf "  ${DIM}  %s${RESET}\n" "$(date '+%A %d %B %Y  %H:%M:%S')"
    echo
}

# ── Main ───────────────────────────────────────────────────────────────────────

main() {
    local start_time end_time duration

    print_logo

    start_time=$(date +%s)

    update_system || {
        print_error "System package update failed - continuing with remaining tasks"
    }

    update_flatpak
#    update_snap

    end_time=$(date +%s)
    duration=$((end_time - start_time))

    echo
    echo -e "${CYAN}${BOLD}└─ All done ${DIM}──────────────────────────────────${RESET}"
    printf "   ${GREEN}✓ Completed in ${BOLD}%dm %ds${RESET}\n" \
        $((duration / 60)) $((duration % 60))
    echo
}

main
