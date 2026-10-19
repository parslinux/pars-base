#!/usr/bin/env bash
# ==============================================================================
# ParsLinux Base — Debian / Bağımsız Paketleme Betiği (package.sh)
# ==============================================================================
# Bu betik pars-base için Debian (.deb) paketi oluşturur.
# Hem Debian/Ubuntu üzerinde (dpkg-buildpackage) hem de bağımsız sistemlerde
# otomatik ikili paketleme mekanizmasıyla çalışır.
# ==============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo -e "${CYAN}${BOLD}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║            📦 ParsLinux Base — Paketleme Aracı               ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

PKG_NAME="pars-base"
VERSION=$(head -n 1 debian/changelog | awk -F '[()]' '{print $2}')
ARCH="all"
OUTPUT_DIR="$SCRIPT_DIR/build"

mkdir -p "$OUTPUT_DIR"

echo -e "${BOLD}Paket Adı    :${NC} ${CYAN}$PKG_NAME${NC}"
echo -e "${BOLD}Sürüm        :${NC} ${CYAN}$VERSION${NC}"
echo -e "${BOLD}Mimari       :${NC} ${CYAN}$ARCH${NC}\n"

# Yöntem 1: Sistemde dpkg-buildpackage varsa
if command -v dpkg-buildpackage &>/dev/null; then
    echo -e "${BOLD}[1/2] dpkg-buildpackage ile paket inşa ediliyor...${NC}"
    dpkg-buildpackage -us -uc -b
    mv ../${PKG_NAME}_* "$OUTPUT_DIR/" 2>/dev/null || true
    echo -e "\n${GREEN}✓ Paket başarıyla oluşturuldu: $OUTPUT_DIR/${NC}"
    ls -lh "$OUTPUT_DIR/"*.deb 2>/dev/null || true
    exit 0
fi

# Yöntem 2: Bağımsız Yerel İkili .deb Oluşturucu
echo -e "${YELLOW}ℹ️  dpkg-buildpackage bulunamadı, yerel ikili .deb paketleme adımları çalıştırılıyor...${NC}"

STAGE_DIR="$OUTPUT_DIR/stage"
rm -rf "$STAGE_DIR"
mkdir -p "$STAGE_DIR/DEBIAN"

echo -e "${BOLD}[1/4] Makefile ile dosyalar paket köküne yükleniyor...${NC}"
make install DESTDIR="$STAGE_DIR"

echo -e "${BOLD}[2/4] DEBIAN kontrol dosyaları yerleştiriliyor...${NC}"

# debian/control dosyasından ikili kontrol dosyasını üret
cat << 'EOF' > "$STAGE_DIR/DEBIAN/control"
Package: pars-base
Version: 1.0.0
Section: metapackages
Priority: optional
Architecture: all
Maintainer: Pars Linux Developers <dev@parslinux.org>
Depends: pars-branding, dbus-user-session, dbus-x11, desktop-base, gvfs, gvfs-backends, gvfs-fuse, xdg-user-dirs, xdg-utils, pipewire, pipewire-audio, pipewire-alsa, pipewire-pulse, wireplumber, libspa-0.2-bluetooth, libspa-0.2-modules, fonts-ubuntu, fonts-noto-core, fonts-noto-color-emoji, fonts-dejavu-core, fonts-liberation2, xorg, xserver-xorg-input-all, xserver-xorg-video-all, network-manager, bluez, wireless-tools, wpasupplicant
Recommends: alsa-utils, btrfs-progs, command-not-found, curl, dnsutils, dosfstools, eject, f2fs-tools, fastfetch, fonts-font-awesome, fzf, iw, libcanberra-gtk3-module, lz4, net-tools, ntfs-3g, p7zip-full, printer-driver-all, pulseaudio-utils, tree, unzip, webp-pixbuf-loader, xfsprogs, zip
Breaks: pulseaudio, pulseaudio-module-bluetooth, pardus-common-desktop
Conflicts: pulseaudio, pulseaudio-module-bluetooth
Replaces: pulseaudio, pulseaudio-module-bluetooth, pardus-common-desktop
Description: Pars Linux Base Metapackage (Core system, Pipewire audio, fonts)
 This metapackage provides the core foundation of the Pars Linux operating
 system. It depends on essential system libraries, the modern Pipewire
 multimedia sound architecture, Turkish-compatible modern fonts, hardware
 abstraction layers, and the Pars visual branding package.
 .
 All desktop environments (pars-desktop-gnome, pars-desktop-xfce) depend
 directly on this base package.
EOF

cp debian/postinst "$STAGE_DIR/DEBIAN/postinst"
cp debian/postrm "$STAGE_DIR/DEBIAN/postrm"
chmod 755 "$STAGE_DIR/DEBIAN/postinst" "$STAGE_DIR/DEBIAN/postrm"

echo -e "${BOLD}[3/4] İzinler düzenleniyor...${NC}"
find "$STAGE_DIR" -type d -exec chmod 755 {} +

echo -e "${BOLD}[4/4] .deb arşivi paketleniyor...${NC}"
DEB_FILE="$OUTPUT_DIR/${PKG_NAME}_${VERSION}_${ARCH}.deb"

if command -v dpkg-deb &>/dev/null; then
    dpkg-deb --build "$STAGE_DIR" "$DEB_FILE"
else
    # dpkg-deb bile yoksa saf ar + tar ile standart .deb oluştur
    (
        cd "$STAGE_DIR"
        echo "2.0" > debian-binary
        tar -czf "$OUTPUT_DIR/control.tar.gz" -C DEBIAN .
        tar --exclude=./DEBIAN --exclude=./debian-binary -czf "$OUTPUT_DIR/data.tar.gz" .
        cd "$OUTPUT_DIR"
        ar rcs "$DEB_FILE" "$STAGE_DIR/debian-binary" control.tar.gz data.tar.gz
        rm -f "$OUTPUT_DIR/control.tar.gz" "$OUTPUT_DIR/data.tar.gz"
    )
fi

rm -rf "$STAGE_DIR"

echo -e "\n${GREEN}${BOLD}══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}${BOLD}🎉 Debian paketi başarıyla üretildi!${NC}"
echo -e "${GREEN}${BOLD}══════════════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}Paket Konumu:${NC} ${CYAN}$DEB_FILE${NC}"
ls -lh "$DEB_FILE"

echo -e "\n${BOLD}Kurulum için (Debian/Pars Linux):${NC}"
echo -e "  ${CYAN}sudo dpkg -i $DEB_FILE${NC}"
echo -e "  ${CYAN}sudo apt-get install -f${NC}\n"
