#!/usr/bin/env bash
# ==============================================================================
# ParsLinux Base — Sistem Kurulum Betiği (install.sh)
# ==============================================================================
# Bu betik ParsLinux temel yapılandırmalarını (PipeWire optimizasyonları,
# font ayarları ve servis presetlerini) sisteme kurar.
# ==============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${CYAN}${BOLD}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║          🐆 ParsLinux Base — Sistem Kurulum Sihirbazı        ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

if [ "$EUID" -ne 0 ]; then
    echo -e "${YELLOW}ℹ️  Sistem genelinde kurulum için root ayrıcalığı gerekiyor. Sudo isteniyor...${NC}"
    exec sudo bash "$0" "$@"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo -e "${BOLD}[1/3] Makefile ile yapılandırma dosyaları sisteme yükleniyor...${NC}"
make install DESTDIR=

echo -e "\n${BOLD}[2/3] Font önbelleği yenileniyor...${NC}"
if command -v fc-cache &>/dev/null; then
    fc-cache -s || true
    echo -e "${GREEN}✓ Font önbelleği güncellendi.${NC}"
fi

echo -e "\n${BOLD}[3/3] PipeWire ses servisleri etkinleştiriliyor...${NC}"
if command -v systemctl &>/dev/null; then
    systemctl --global enable pipewire.socket pipewire-pulse.socket wireplumber.service 2>/dev/null || true
    echo -e "${GREEN}✓ PipeWire kullanıcı servisleri global olarak etkinleştirildi.${NC}"
fi

echo -e "\n${GREEN}${BOLD}══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}${BOLD}✓ ParsLinux Base taban bileşenleri başarıyla kuruldu!${NC}"
echo -e "${GREEN}${BOLD}══════════════════════════════════════════════════════════════${NC}\n"
