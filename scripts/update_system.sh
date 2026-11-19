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

# Packages whose removal can leave an encrypted Pop!_OS install unbootable
# (no LUKS prompt, no initramfs, no bootloader). If an upgrade wants to remove
# any of these, the system upgrade is aborted instead of auto-confirmed.
CRITICAL_PKGS='^(systemd|systemd-cryptsetup|systemd-boot|systemd-boot-efi|cryptsetup|cryptsetup-bin|libcryptsetup12|dracut|dracut-core|lvm2|kernelstub|linux-generic|linux-image-generic)(:amd64)?$'

# Simulate the upgrade and look at what it would remove.
#   0 = nothing removed      -> safe to run with -y
#   1 = removals, none critical -> run interactively so you can review them
#   2 = critical removal, or simulation failed -> abort
# nala and apt-get share the same package state, so apt-get's simulation is a
# close preview of what nala will do.
check_removals() {
    local sim removals pkg

    if ! sim=$(apt-get -s dist-upgrade "${PHASED_OPT[@]}" 2>&1); then
        print_error "Upgrade simulation failed:"
        while IFS= read -r pkg; do print_dim "  $pkg"; done <<< "$sim"
        return 2
    fi

    removals=$(awk '/^Remv /{print $2}' <<< "$sim")
    if [ -z "$removals" ]; then
        print_dim "No packages will be removed"
        return 0
    fi

    print_warn "This upgrade wants to remove:"
    while IFS= read -r pkg; do print_dim "  $pkg"; done <<< "$removals"

    if grep -qE "$CRITICAL_PKGS" <<< "$removals"; then
        print_error "A boot-critical package would be removed - not upgrading"
        print_dim "Investigate with: apt-get -s dist-upgrade | grep ^Remv"
        return 2
    fi
    return 1
}

update_system() {
    print_header "System Packages"

    if [ "$INCLUDE_PHASED" = true ]; then
        print_dim "Including phased updates (early-adopter mode)"
    fi

    # This function is called as `update_system || ...`, which switches off
    # `set -e` inside it - so every step checks its own exit status.
    local pm rc=0
    local yes_opt=(-y)

    if command_exists nala; then
        pm=nala
    elif command_exists apt-get; then
        pm=apt-get
    else
        print_error "No supported package manager found - skipping"
        return 1
    fi
    print_info "Package manager: $pm"

    sudo "$pm" update || { print_error "$pm update failed"; return 1; }

    check_removals || rc=$?
    case $rc in
        0) ;;
        1) print_warn "Removals found - confirm the upgrade yourself"
           yes_opt=() ;;
        *) return 1 ;;
    esac

    if [ "$pm" = nala ]; then
        # The package lists were just refreshed above, so skip nala's own
        # refresh when this nala version supports --no-update.
        local nala_opt=()
        if nala upgrade --help 2>/dev/null | grep -q -- '--no-update'; then
            nala_opt=(--no-update)
        fi
        sudo nala upgrade --full "${nala_opt[@]}" "${yes_opt[@]}" "${PHASED_OPT[@]}" \
            || { print_error "nala upgrade failed"; return 1; }
#        sudo nala autoremove -y
        sudo nala clean || print_warn "nala clean failed"
    else
        sudo apt-get dist-upgrade "${yes_opt[@]}" "${PHASED_OPT[@]}" \
            || { print_error "apt-get dist-upgrade failed"; return 1; }
#        sudo apt-get autoremove -y
        sudo apt-get autoclean || print_warn "apt-get autoclean failed"
    fi

    print_success "System update complete"
}

# After any upgrade, confirm the files systemd-boot will actually load can
# still boot this machine: both initramfs images on the ESP must contain
# systemd-cryptsetup (or there's no LUKS prompt), and both kernels on the ESP
# must have their modules installed (or nothing loads after root is mounted).
# Checks that don't apply to this machine (no kernelstub, no LUKS, no dracut)
# are skipped instead of reported as failures.
verify_boot() {
    print_header "Boot Check"

    if ! command_exists kernelstub; then
        print_skip "kernelstub not installed (not a Pop!_OS boot layout) - skipping"
        return 0
    fi

    local root_uuid esp img count kern ver ok=true check_initrd=true

    root_uuid=$(findmnt -no UUID /) || root_uuid=""
    esp="/boot/efi/EFI/Pop_OS-${root_uuid}"

    if [ -z "$root_uuid" ] || ! sudo test -d "$esp"; then
        print_error "Kernelstub folder not found on the ESP: $esp"
        print_dim "Is /boot/efi mounted? Check with: findmnt /boot/efi"
        return 1
    fi

    # Only an encrypted install needs systemd-cryptsetup in the initramfs, and
    # only dracut images can be listed with lsinitrd.
    if ! sudo grep -qvE '^[[:space:]]*(#|$)' /etc/crypttab 2>/dev/null; then
        print_skip "No LUKS volumes in /etc/crypttab - skipping initramfs check"
        check_initrd=false
    elif ! command_exists lsinitrd; then
        print_skip "lsinitrd not found (initramfs not built by dracut) - skipping initramfs check"
        check_initrd=false
    fi

    if [ "$check_initrd" = true ]; then
        for img in initrd.img initrd.img-previous; do
            if ! sudo test -f "$esp/$img"; then
                print_skip "$img not present"
                continue
            fi
            count=$(sudo lsinitrd "$esp/$img" 2>/dev/null | grep -c systemd-cryptsetup || true)
            if [ "${count:-0}" -gt 0 ]; then
                print_success "$img can unlock LUKS"
            else
                print_error "$img has no systemd-cryptsetup"
                ok=false
            fi
        done
    fi

    if ! command_exists file; then
        print_skip "file not installed - skipping kernel module check"
    else
        for kern in vmlinuz.efi vmlinuz-previous.efi; do
            if ! sudo test -f "$esp/$kern"; then
                print_skip "$kern not present"
                continue
            fi
            ver=$(sudo file -b "$esp/$kern" | sed -n 's/.*version \([^ ,]*\).*/\1/p')
            if [ -n "$ver" ] && [ -d "/lib/modules/$ver" ]; then
                print_success "$kern → $ver (modules installed)"
            else
                print_error "$kern → ${ver:-unknown version}: no matching /lib/modules"
                ok=false
            fi
        done
    fi

    [ "$ok" = true ]
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
    local start_time end_time duration boot_ok=true

    print_logo

    start_time=$(date +%s)

    update_system || {
        print_error "System package update failed - continuing with remaining tasks"
    }

    # Always run, even after a failed upgrade: a half-finished upgrade is
    # exactly when the boot files are most likely to be broken.
    verify_boot || boot_ok=false

    update_flatpak
#    update_snap

    end_time=$(date +%s)
    duration=$((end_time - start_time))

    echo
    echo -e "${CYAN}${BOLD}└─ All done ${DIM}──────────────────────────────────${RESET}"
    printf "   ${GREEN}✓ Completed in ${BOLD}%dm %ds${RESET}\n" \
        $((duration / 60)) $((duration % 60))
    if [ "$boot_ok" = false ]; then
        echo
        print_error "${BOLD}Boot check failed - do NOT reboot until it's fixed"
    fi
    echo
}

main
