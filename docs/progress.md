# 📊 Geliştirme İlerleme Raporu (`progress.md`)

Bu belge, **ParsLinux Base (`pars-base`)** temel sistem katmanı meta paketinin gelişim sürecini, tamamlanan aşamalarını ve gelecek hedeflerini listeler.

---

## 🎯 Tamamlanan Aşamalar (Aşama 1: Çekirdek Sistem & Altyapı)

- [x] **Paket Mimarisi & Katman Tasarımı:**
  - [x] `pardus-desktops` (`pardus-common-desktop`) mimarisi incelendi.
  - [x] ParsLinux katmanlı meta paket modeli oluşturuldu (`pars-branding` -> `pars-base` -> `pars-desktop-*`).
  - [x] Masaüstünden bağımsız taban ihtiyaçları ayrıştırıldı.
- [x] **Debian Paket Yapılandırması (`debian/`):**
  - [x] `debian/control`: Bağımlılıklar (`Depends`), önerilenler (`Recommends`) ve PulseAudio çakışmaları (`Conflicts/Breaks`) tanımlandı.
  - [x] `debian/changelog`: 1.0.0 sürüm kaydı oluşturuldu.
  - [x] `debian/rules`: Standart `debhelper` ve `auto_install` kuralları yazıldı.
  - [x] `debian/postinst`: Font önbelleği yenileme ve PipeWire kullanıcı servislerini otomatik etkinleştirme tetikleyicisi eklendi.
  - [x] `debian/postrm`: Kaldırma sonrası temizlik yönergeleri eklendi.
- [x] **Modern Ses Mimarisi (PipeWire Entegrasyonu):**
  - [x] Düşük gecikmeli ve 48 kHz profesyonel ses ayarı (`99-pars-audio.conf`) hazırlandı.
  - [x] Ses takılmalarını önleyen gerçek zamanlı limit izinleri (`rtprio 95`) tanımlandı.
  - [x] Kullanıcı oturumu systemd preset tanımlaması (`99-pars-pipewire.preset`) eklendi.
- [x] **Yazı Tipleri & Türkçe Karakter Optimizasyonu:**
  - [x] Türkçe uyumlu font aileleri (Ubuntu, Noto Sans, DejaVu, Liberation) bağımlılıklara eklendi.
  - [x] Pürüzsüzleştirme ve alt-piksel RGB render yapılandırması (`99-pars-fonts.conf`) yazıldı.
- [x] **Yönetim ve Dağıtım Araçları:**
  - [x] `run.sh`: Ses, font ve temel servis sağlık denetim aracı yazıldı ve test edildi.
  - [x] `package.sh`: Hem `dpkg-buildpackage` hem bağımsız `ar`/`tar` fallback destekli `.deb` oluşturucu yazıldı ve test edildi.
  - [x] `install.sh` / `uninstall.sh`: Sisteme doğrudan kurulum ve kaldırma betikleri hazırlandı.
  - [x] `Makefile`: Kurulum ve temizleme hedefleri tanımlandı.
- [x] **Sürüm Kontrolü ve Yol Haritası:**
  - [x] Git deposu ilklendirildi ve ilk resmi commit atıldı.
  - [x] `PARSLINUX_FORK_PLANI.md` ana yol haritasında `pars-base` tamamlandı olarak işaretlendi.

---

## 🔮 Gelecek Hedefler (Aşama 2: Masaüstü & ISO Entegrasyonu)

- [ ] **`pars-desktop-gnome` Entegrasyonu:**
  - [ ] GNOME Shell, Greeter, Pars Ayarları ve mağazayı içeren üst katman meta paketinin `pars-base` üzerine oturtulması.
- [ ] **`pars-desktop-xfce` Entegrasyonu:**
  - [ ] Hafif sürüm masaüstü için XFCE tabanının `pars-base` ile birleştirilmesi.
- [ ] **Live-Build & Calamares Entegrasyonu:**
  - [ ] ParsLinux canlı ISO kalıbı basılırken `pars-base` paketinin `config/package-lists/` içerisine dahil edilmesi.
- [ ] **Resmi APT Deposu:**
  - [ ] `pars-base_1.0.0_all.deb` paketinin ParsLinux `reprepro` deposuna yüklenmesi ve imzalanması.
