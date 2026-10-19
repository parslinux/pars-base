# ==============================================================================
# ParsLinux Base (pars-base) — Makefile
# ==============================================================================

DESTDIR ?=
PREFIX ?= /usr
SYSCONFDIR ?= /etc

all:
	@echo "pars-base: Derleme gerektiren ikili dosya yok (Meta paket)."

install:
	# PipeWire yapılandırma parçaları
	install -d $(DESTDIR)$(SYSCONFDIR)/pipewire/pipewire.conf.d
	install -m 644 etc/pipewire/pipewire.conf.d/99-pars-audio.conf \
		$(DESTDIR)$(SYSCONFDIR)/pipewire/pipewire.conf.d/99-pars-audio.conf

	# Gerçek zamanlı ses yetkileri (limits.d)
	install -d $(DESTDIR)$(SYSCONFDIR)/security/limits.d
	install -m 644 etc/security/limits.d/99-pars-audio.conf \
		$(DESTDIR)$(SYSCONFDIR)/security/limits.d/99-pars-audio.conf

	# Yazı tipi (Fontconfig) yapılandırması
	install -d $(DESTDIR)$(SYSCONFDIR)/fonts/conf.avail
	install -d $(DESTDIR)$(SYSCONFDIR)/fonts/conf.d
	install -m 644 etc/fonts/conf.avail/99-pars-fonts.conf \
		$(DESTDIR)$(SYSCONFDIR)/fonts/conf.avail/99-pars-fonts.conf
	ln -sf ../conf.avail/99-pars-fonts.conf \
		$(DESTDIR)$(SYSCONFDIR)/fonts/conf.d/99-pars-fonts.conf

	# Systemd kullanıcı önayarı (Pipewire & Wireplumber)
	install -d $(DESTDIR)$(PREFIX)/lib/systemd/user-preset
	install -m 644 etc/systemd/user-preset/99-pars-pipewire.preset \
		$(DESTDIR)$(PREFIX)/lib/systemd/user-preset/99-pars-pipewire.preset

uninstall:
	rm -f $(DESTDIR)$(SYSCONFDIR)/pipewire/pipewire.conf.d/99-pars-audio.conf
	rm -f $(DESTDIR)$(SYSCONFDIR)/security/limits.d/99-pars-audio.conf
	rm -f $(DESTDIR)$(SYSCONFDIR)/fonts/conf.d/99-pars-fonts.conf
	rm -f $(DESTDIR)$(SYSCONFDIR)/fonts/conf.avail/99-pars-fonts.conf
	rm -f $(DESTDIR)$(PREFIX)/lib/systemd/user-preset/99-pars-pipewire.preset

clean:
	rm -rf build debian/.debhelper debian/pars-base debian/files debian/*.substvars

.PHONY: all install uninstall clean
