#!/usr/bin/env bash
# ==============================================================================
# ParsLinux Base — Sistemden Kaldırma Betiği (uninstall.sh)
# ==============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${YELLOW}${BOLD}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║          🗑️ ParsLinux Base — Sistemden Kaldırma               ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

if [ "$EUID" -ne 0 ]; then
    echo -e "${YELLOW}ℹ️  Sistemden kaldırma için root ayrıcalığı gerekiyor. Sudo isteniyor...${NC}"
    exec sudo bash "$0" "$@"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo -e "${BOLD}[1/2] Makefile ile yapılandırma dosyaları kaldırılıyor...${NC}"
make uninstall DESTDIR=

echo -e "\n${BOLD}[2/2] Font önbelleği yenileniyor...${NC}"
if command -v fc-cache &>/dev/null; then
    fc-cache -s || true
fi

echo -e "\n${GREEN}${BOLD}✓ ParsLinux Base taban bileşenleri sistemden temizlendi.${NC}\n"
