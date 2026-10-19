#!/usr/bin/env bash
# ==============================================================================
# ParsLinux Base — Sistem Tabanı ve Ses/Font Sağlık Denetimi (run.sh)
# ==============================================================================
# Bu betik pars-base bileşenlerinin (PipeWire, fontlar, D-Bus, ağ) sistemdeki
# çalışma durumunu denetler ve renkli bir durum raporu sunar.
# ==============================================================================

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo -e "${CYAN}${BOLD}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║          🐆 ParsLinux Base — Sistem Taban Denetimi           ║"
echo "║      (PipeWire Ses, Yazı Tipleri ve Temel Servisler)         ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# 1. Pars Branding Katmanı
echo -e "${BOLD}[1/4] 🎨 Görsel Kimlik Katmanı (pars-branding):${NC}"
if [ -f "/usr/share/backgrounds/parslinux/pars-default.png" ] || [ -f "../pars-branding/data/backgrounds/pars-default.png" ]; then
    echo -e "  • Duvar Kağıtları   : ${GREEN}✓ Mevcut${NC}"
else
    echo -e "  • Duvar Kağıtları   : ${YELLOW}⚠️ Henüz sisteme kurulmamış${NC}"
fi

if [ -f "/usr/share/pixmaps/parslinux/parslinux-logo.svg" ] || [ -f "../pars-branding/data/pixmaps/parslinux-logo.svg" ]; then
    echo -e "  • Vektör Logo       : ${GREEN}✓ Mevcut${NC}"
else
    echo -e "  • Vektör Logo       : ${YELLOW}⚠️ Henüz sisteme kurulmamış${NC}"
fi

# 2. Modern Ses Sistemi (Pipewire & WirePlumber)
echo -e "\n${BOLD}[2/4] 🔊 Modern Ses Altyapısı (PipeWire):${NC}"
PW_RUNNING=false
WP_RUNNING=false

if pgrep -x "pipewire" >/dev/null; then
    PW_RUNNING=true
    PW_VER=$(pipewire --version 2>/dev/null | head -n 1 || echo "Aktif")
    echo -e "  • PipeWire Sunucusu : ${GREEN}✓ Çalışıyor${NC} (${CYAN}${PW_VER}${NC})"
else
    echo -e "  • PipeWire Sunucusu : ${YELLOW}⚠️ Çalışmıyor (Kurulum sonrası otomatik başlar)${NC}"
fi

if pgrep -x "wireplumber" >/dev/null; then
    WP_RUNNING=true
    echo -e "  • WirePlumber       : ${GREEN}✓ Oturum yöneticisi aktif${NC}"
else
    echo -e "  • WirePlumber       : ${YELLOW}⚠️ WirePlumber aktif değil${NC}"
fi

if command -v pactl &>/dev/null; then
    SERVER_NAME=$(pactl info 2>/dev/null | grep "Server Name" | cut -d: -f2- | xargs || true)
    if [[ "$SERVER_NAME" == *"PipeWire"* ]]; then
        echo -e "  • Pulse Uyumluluğu  : ${GREEN}✓ PulseAudio -> PipeWire köprüsü devrede${NC}"
    else
        echo -e "  • Ses Sunucusu      : ${CYAN}${SERVER_NAME:-Bilinmiyor}${NC}"
    fi
fi

if command -v wpctl &>/dev/null; then
    DEF_SINK=$(wpctl status 2>/dev/null | grep -A 2 "Audio" | grep "\*" | head -n 1 | sed 's/^[ \t]*//' || true)
    if [ -n "$DEF_SINK" ]; then
        echo -e "  • Varsayılan Çıkış  : ${CYAN}${DEF_SINK}${NC}"
    fi
fi

# 3. Yazı Tipleri ve Türkçe Karakter Desteği
echo -e "\n${BOLD}[3/4] 🔤 Yazı Tipleri ve Karakter Uyumluluğu:${NC}"
check_font() {
    local name="$1"
    local pattern="$2"
    if fc-list : family | grep -qi "$pattern"; then
        echo -e "  • $name : ${GREEN}✓ Yüklü${NC}"
    else
        echo -e "  • $name : ${YELLOW}⚠️ Bulunamadı (pars-base bağımlılıklarıyla kurulacak)${NC}"
    fi
}

check_font "Ubuntu Font Ailesi     " "Ubuntu"
check_font "Noto Sans (Evrensel)   " "Noto Sans"
check_font "DejaVu Sans            " "DejaVu Sans"
check_font "Font Awesome (Simgeler)" "FontAwesome"

echo -e "  • Türkçe Test Metni   : ${CYAN}Şemsi Paşa Pasajı'nda çamurda güvercinler ötüşür (IİıĞğÜüŞşÖöÇç)${NC}"

# 4. Donanım ve Temel Servisler
echo -e "\n${BOLD}[4/4] ⚙️ Temel Sistem Servisleri:${NC}"
check_service() {
    local label="$1"
    local proc="$2"
    if pgrep -x "$proc" >/dev/null; then
        echo -e "  • $label : ${GREEN}✓ Aktif${NC}"
    else
        echo -e "  • $label : ${YELLOW}⚠️ Pasif veya kurulu değil${NC}"
    fi
}

check_service "NetworkManager (Ağ)        " "NetworkManager"
check_service "Bluetooth (bluetoothd)     " "bluetoothd"
check_service "D-Bus (Sistem Mesajlaşma)  " "dbus-daemon"
check_service "GVfs (Dosya Sistemi Sürücü)" "gvfsd"

echo -e "\n${GREEN}${BOLD}══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}${BOLD}✓ pars-base denetim raporu tamamlandı!${NC}"
echo -e "${GREEN}${BOLD}══════════════════════════════════════════════════════════════${NC}\n"
