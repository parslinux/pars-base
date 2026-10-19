# 🐆 Pars Linux Base (`pars-base`) — Claude & Geliştirici Kılavuzu

Bu belge, **Pars Linux** işletim sisteminin temel sistem omurgası olan `pars-base` paketinin mimarisini, dosya düzenini ve geliştirme yönergelerini içerir.

---

## 🎯 Proje Misyonu & Mimari

`pars-base`, Pars Linux'un tüm masaüstü ortamlarının (`pars-desktop-gnome`, `pars-desktop-xfce`) ve kullanıcı profillerinin (`pars-gaming`, `pars-dev`, `pars-creator`) altında çalışan **taban meta paketi (Core Base Layer)**dir.

### Temel Sorumluluk Alanları:
1. **Görsel Kimlik Katmanı:** `pars-branding` paketini taban gereksinim olarak bağlar.
2. **Modern Ses Altyapısı (PipeWire):** Eski PulseAudio yerine düşük gecikmeli, profesyonel PipeWire + WirePlumber mimarisini sisteme entegre eder ve optimize eder.
3. **Yazı Tipleri & Karakter Seti:** Türkçe karakterleri kusursuz render eden font paketlerini ve Fontconfig yapılandırmalarını (`99-pars-fonts.conf`) sağlar.
4. **Donanım & Ağ Tabanı:** Xorg, NetworkManager, Bluetooth ve GVfs sanal dosya sistemi altyapısını hazır tutar.

---

## 📂 Dizin ve Dosya Yapısı

```
pars-base/
├── debian/                     # Debian paket kontrol ve kurulum betikleri
│   ├── changelog               # Sürüm geçmişi (1.0.0)
│   ├── control                 # Bağımlılıklar, Breaks/Conflicts ve meta paket tanımı
│   ├── postinst                # Kurulum sonrası font cache ve PipeWire servis tetikleyici
│   ├── postrm                  # Kaldırma sonrası temizlik betiği
│   └── rules                   # debhelper kuralları
├── etc/                        # Sisteme yerleştirilecek optimize yapılandırmalar
│   ├── fonts/conf.avail/       # 99-pars-fonts.conf (Subpixel RGB, hintslight, antialias)
│   ├── pipewire/pipewire.conf.d/ # 99-pars-audio.conf (48kHz, düşük gecikmeli buffer ayarı)
│   ├── security/limits.d/      # 99-pars-audio.conf (Gerçek zamanlı rtprio 95 izinleri)
│   └── systemd/user-preset/    # 99-pars-pipewire.preset (Pipewire kullanıcı servis önayarı)
├── Makefile                    # Dosyaları sisteme veya paket evresine yerleştiren kurallar
├── install.sh                  # Doğrudan sisteme kurma sihirbazı (root yetkisiyle)
├── uninstall.sh                # Sistemden kaldırma ve temizleme aracı
├── package.sh                  # Debian .deb paketi derleme/arşivleme aracı
├── run.sh                      # Ses, font ve temel servis sağlık denetim aracı
├── progress.md                 # Gelişim süreci ve tamamlanan adımlar
├── install.md                  # Ayrıntılı kurulum, test ve bağımlılık kılavuzu
├── claude.md                   # AI ve geliştirici mimari rehberi
└── .claudeignore               # Yapay zeka ve araçlar için hariç tutma kuralları
```

---

## 🛠️ Temel Geliştirici Komutları

| Komut | Açıklama |
| :--- | :--- |
| `./run.sh` | Sistemdeki PipeWire, yazı tipleri, D-Bus ve ağ servislerinin durumunu denetler. |
| `./package.sh` | Bağımsız olarak `build/pars-base_1.0.0_all.deb` paketini oluşturur. |
| `sudo ./install.sh` | Yapılandırma dosyalarını çalışan sisteme yükler ve önbellekleri tazeler. |
| `sudo ./uninstall.sh` | Yapılandırma dosyalarını sistemden kaldırır. |
| `make clean` | Geçici derleme ve paketleme artıklarını temizler. |

---

## ⚠️ Geliştirme Kuralları & Dikkat Edilecekler
- **Bağımlılık Ayrımı:** `pars-base` içerisine masaüstüne özgü GUI uygulamaları (örneğin `gnome-shell` veya `gimp`) **eklenmemelidir**. Onlar `pars-desktop-*` katmanının sorumluluğundadır.
- **PulseAudio Çakışması:** PipeWire tam ikame edildiği için `debian/control` içinde `pulseaudio` ve `pulseaudio-module-bluetooth` kesinlikle `Conflicts/Breaks` olarak tutulmalıdır.
- **Türkçe Karakter Standartları:** Fontconfig dosyalarında Sans, Serif ve Monospace ailelerinde Türkçe glif desteği yüksek fontlar (Ubuntu, Noto) öncelikli olmalıdır.
