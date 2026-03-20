#!/usr/bin/env bash
set -euo pipefail

# ── Colors & helpers ──────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

REPO="https://github.com/filiphric/trelloapp-workshop-app.git"
DEFAULT_DIR="trelloapp"

cleanup() {
  printf "\n${YELLOW}Setup cancelled.${RESET}\n"
  exit 1
}
trap cleanup INT TERM

info()    { printf "${BLUE}  ℹ${RESET}  %s\n" "$1"; }
success() { printf "${GREEN}  ✔${RESET}  %s\n" "$1"; }
error()   { printf "${RED}  ✖${RESET}  %s\n" "$1"; }
warn()    { printf "${YELLOW}  ⚠${RESET}  %s\n" "$1"; }

need_help() {
  printf "\n"
  printf "${YELLOW}${BOLD}  ── Can't install? ──────────────────────────────────────${RESET}\n"
  printf "\n"
  printf "  This often happens on work machines with restricted\n"
  printf "  permissions. Here's what you can do:\n"
  printf "\n"
  printf "  ${BOLD}1.${RESET} Ask your system administrator to install:\n"
  printf "     ${DIM}• git${RESET}\n"
  printf "     ${DIM}• Node.js v20 or later${RESET}\n"
  printf "     ${DIM}• npm (comes with Node.js)${RESET}\n"
  printf "\n"
  printf "  ${BOLD}2.${RESET} If your company uses a ${BOLD}VPN or proxy${RESET}, it may be\n"
  printf "     blocking downloads. Ask IT to allowlist:\n"
  printf "     ${DIM}• github.com${RESET}\n"
  printf "     ${DIM}• registry.npmjs.org${RESET}\n"
  printf "\n"
  printf "  ${BOLD}3.${RESET} Contact the ${BOLD}workshop instructor${RESET} — we'll help\n"
  printf "     you get set up before the session starts.\n"
  printf "\n"
}

spin() {
  local pid=$1 msg=$2
  local frames='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
  local i=0
  while kill -0 "$pid" 2>/dev/null; do
    printf "\r  ${CYAN}%s${RESET}  %s" "${frames:i++%${#frames}:1}" "$msg"
    sleep 0.08
  done
  wait "$pid"
  return $?
}

progress() {
  local pid=$1 msg=$2
  local width=30
  local filled=0
  local step=0
  while kill -0 "$pid" 2>/dev/null; do
    # Slow down as we approach 90%
    if [ "$filled" -lt $((width * 9 / 10)) ]; then
      filled=$((filled + 1))
    fi
    local empty=$((width - filled))
    local bar=""
    [ "$filled" -gt 0 ] && bar=$(printf "█%.0s" $(seq 1 "$filled"))
    local spaces=""
    [ "$empty" -gt 0 ] && spaces=$(printf "░%.0s" $(seq 1 "$empty"))
    local pct=$((filled * 100 / width))
    printf "\r  ${CYAN}%s${RESET} %s %3d%%" "${bar}${spaces}" "$msg" "$pct"
    step=$((step + 1))
    sleep 0.15
  done
  wait "$pid"
  local exit_code=$?
  # Fill to 100% on success
  if [ "$exit_code" -eq 0 ]; then
    local full_bar=$(printf "█%.0s" $(seq 1 "$width"))
    printf "\r  ${GREEN}%s${RESET} %s 100%%\n" "$full_bar" "$msg"
  fi
  return $exit_code
}

# ── Welcome banner ────────────────────────────────────────────────
printf "\n"
printf "${CYAN}${BOLD}  ┌────────────────────────────────┐${RESET}\n"
printf "${CYAN}${BOLD}  │                                │${RESET}\n"
printf "${CYAN}${BOLD}  │${RESET}${BOLD}   Trello App Workshop Setup    ${CYAN}${BOLD}│${RESET}\n"
printf "${CYAN}${BOLD}  │                                │${RESET}\n"
printf "${CYAN}${BOLD}  └────────────────────────────────┘${RESET}\n"
printf "\n"

# ── Check: git ────────────────────────────────────────────────────
if ! command -v git &>/dev/null; then
  error "git is not installed"
  printf "\n"
  printf "  Install git:\n"
  case "$(uname -s)" in
    Darwin) printf "    ${DIM}brew install git${RESET}\n" ;;
    Linux)  printf "    ${DIM}sudo apt install git${RESET}  (Debian/Ubuntu)\n"
            printf "    ${DIM}sudo dnf install git${RESET}  (Fedora)\n" ;;
    *)      printf "    ${DIM}https://git-scm.com/downloads${RESET}\n" ;;
  esac
  need_help
  exit 1
fi
success "git found"

# ── Check: node ───────────────────────────────────────────────────
if ! command -v node &>/dev/null; then
  error "Node.js is not installed"
  printf "\n"
  printf "  Install Node.js using nvm (recommended):\n"
  printf "    ${DIM}curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash${RESET}\n"
  printf "    ${DIM}nvm install 20${RESET}\n"
  printf "\n"
  printf "  Or download directly from:\n"
  printf "    ${DIM}https://nodejs.org${RESET}\n"
  need_help
  exit 1
fi

# ── Check: node version >= 20 ────────────────────────────────────
NODE_VERSION=$(node -v | sed 's/v//' | cut -d. -f1)
if [ "$NODE_VERSION" -lt 20 ]; then
  error "Node.js v20+ is required (found v$(node -v | sed 's/v//'))"
  printf "\n"
  printf "  Upgrade Node.js:\n"
  if command -v nvm &>/dev/null; then
    printf "    ${DIM}nvm install 20${RESET}\n"
    printf "    ${DIM}nvm use 20${RESET}\n"
  else
    printf "    ${DIM}curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash${RESET}\n"
    printf "    ${DIM}nvm install 20${RESET}\n"
  fi
  need_help
  exit 1
fi
success "Node.js v$(node -v | sed 's/v//') found"

# ── Check: npm ────────────────────────────────────────────────────
if ! command -v npm &>/dev/null; then
  error "npm is not installed"
  printf "  npm usually comes with Node.js. Try reinstalling Node.js.\n"
  need_help
  exit 1
fi
success "npm v$(npm -v) found"

# ── Prompt for directory name ─────────────────────────────────────
printf "\n"
printf "  ${BOLD}Where should we set up the project?${RESET}\n"
printf "  ${DIM}(default: ${DEFAULT_DIR})${RESET} "
read -r DIR_NAME
DIR_NAME="${DIR_NAME:-$DEFAULT_DIR}"

# ── Handle existing directory ─────────────────────────────────────
if [ -d "$DIR_NAME" ]; then
  warn "Directory '${DIR_NAME}' already exists"
  printf "  ${BOLD}Overwrite it? (y/N)${RESET} "
  read -r OVERWRITE
  if [[ "$OVERWRITE" =~ ^[Yy]$ ]]; then
    rm -rf "$DIR_NAME"
  else
    printf "  ${BOLD}Enter a different name:${RESET} "
    read -r DIR_NAME
    if [ -z "$DIR_NAME" ]; then
      error "No directory name provided"
      exit 1
    fi
    if [ -d "$DIR_NAME" ]; then
      error "Directory '${DIR_NAME}' also exists. Please remove it and try again."
      exit 1
    fi
  fi
fi

# ── Download repository ──────────────────────────────────────────
printf "\n"
npx --yes degit "$REPO" "$DIR_NAME" &>/dev/null &
DEGIT_PID=$!
progress $DEGIT_PID "Downloading repository..."
if [ $? -ne 0 ]; then
  printf "\r"
  error "Failed to download repository"
  printf "  Check your internet connection and try again.\n"
  need_help
  exit 1
fi

# ── Install CLI dependencies ──────────────────────────────────────
cd "$DIR_NAME"
npm install --silent --prefix cli &>/dev/null &
CLI_PID=$!
spin $CLI_PID "Preparing setup wizard..."
if [ $? -ne 0 ]; then
  printf "\r"
  error "Failed to install setup dependencies"
  need_help
  exit 1
fi
printf "\r                                        \r"
success "Setup wizard ready"

# ── Hand off to Node.js CLI ──────────────────────────────────────
printf "\n"
node cli/index.mjs "$DIR_NAME" "$@"
