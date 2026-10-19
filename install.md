# 📦 ParsLinux Base (`pars-base`) — Kurulum ve Kullanım Kılavuzu (`install.md`)

Bu belge, **ParsLinux Base** meta paketinin sisteme nasıl kurulacağını, nasıl `.deb` paketi haline getirileceğini ve sistem testlerinin nasıl yapılacağını açıklar.

---

## 📋 Önkoşullar & Bağımlılıklar

`pars-base`, Debian/Ubuntu tabanlı sistemlerde çalışacak şekilde tasarlanmıştır.

### Zorunlu Temel Bileşenler:
* **Görsel Taban:** `pars-branding`
* **Ses Sunucusu:** `pipewire`, `pipewire-audio`, `pipewire-alsa`, `pipewire-pulse`, `wireplumber`
* **Yazı Tipleri:** `fonts-ubuntu`, `fonts-noto-core`, `fonts-dejavu-core`, `fonts-liberation2`
* **Ağ ve Donanım:** `network-manager`, `bluez`, `wireless-tools`, `wpasupplicant`, `xorg`, `gvfs`

---

## 🚀 1. Yöntem: Doğrudan Betik ile Kurulum (Geliştirme Ortamı)

Kaynak kod dizininde bulunan `install.sh` betiği, tüm yapılandırmaları doğrudan `/etc` ve `/usr` dizinlerine kurar:

```bash
cd /home/can/Masaüstü/proje/mcsm/masaüstü/inceleme_düzenleme/pars-base
sudo ./install.sh
```

### Betiğin Yaptığı İşlemler:
1. `etc/pipewire/pipewire.conf.d/99-pars-audio.conf` -> `/etc/pipewire/pipewire.conf.d/`
2. `etc/security/limits.d/99-pars-audio.conf` -> `/etc/security/limits.d/`
3. `etc/fonts/conf.avail/99-pars-fonts.conf` -> `/etc/fonts/conf.avail/` ve `/etc/fonts/conf.d/`
4. `etc/systemd/user-preset/99-pars-pipewire.preset` -> `/usr/lib/systemd/user-preset/`
5. `fc-cache -s` komutu ile yazı tipi önbelleğini yeniler.
6. PipeWire kullanıcı servislerini (`pipewire.socket`, `wireplumber.service`) global olarak etkinleştirir.

---

## 📦 2. Yöntem: Debian (.deb) Paketi Üretme ve Kurma

Paketi resmi dağıtım formatında inşa etmek için:

```bash
./package.sh
```

Oluşan paketi sisteme kurmak için:

```bash
sudo dpkg -i build/pars-base_1.0.0_all.deb
sudo apt-get install -f
```

> **Not:** `package.sh` sistemi akıllıdır. Eğer sisteminizde `dpkg-buildpackage` yoksa (örneğin Arch/CachyOS üzerinde geliştirme yapıyorsanız), yerel ikili paketleme mekanizmasıyla tam uyumlu bir `.deb` dosyası üretir.

---

## 🔍 3. Sağlık Denetimi & Doğrulama

Kurulumdan sonra veya geliştirme aşamasında sistem tabanını doğrulamak için:

```bash
./run.sh
```

Bu araç şunları denetler:
* `pars-branding` logolarının ve duvar kağıtlarının varlığı,
* PipeWire ve WirePlumber ses sunucusu servislerinin aktifliği,
* Ubuntu ve Noto Sans yazı tiplerinin varlığı ve Türkçe karakter testi,
* NetworkManager, Bluetooth ve D-Bus temel servislerinin çalışma durumu.

---

## 🗑️ Sistemden Kaldırma

Paket veya betikle yapılan kurulumları sistemden tamamen temizlemek için:

```bash
# Betik ile kaldırma:
sudo ./uninstall.sh

# Veya Debian paket yöneticisi ile:
sudo apt remove --purge pars-base
```

---

## 🛠️ Sık Karşılaşılan Sorunlar & Çözümler

### 1. Ses Çıkışı Alamıyorum / PipeWire Başlamadı
PipeWire kullanıcı oturumu seviyesinde çalışır. Oturumu yeniden başlatın veya terminalde:
```bash
systemctl --user restart pipewire pipewire-pulse wireplumber
pactl info  # "Server Name: PulseAudio (on PipeWire ...)" görmelisiniz
```

### 2. Türkçe Karakterler veya Fontlar Düzgün Görünmüyor
Font önbelleğini zorla tazelemek için:
```bash
sudo fc-cache -fv
```
