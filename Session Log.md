# Session Log

> **NOT:** Bu dosya her yeni Claude Code session'ında **üzerine ekleme** yapılarak güncellenir. Yeni dosya yaratılmaz, bu dosyanın sonuna eklenir.

---

## Session 1 — 2026-05-31 | Embedded Systems Roadmap

### Yapılanlar

**Obsidian sorunu tespit edildi:**
- Obsidian (snap v1.12.7) açılmıyordu
- Neden: `kernel.apparmor_restrict_unprivileged_userns=1` — AppArmor, Electron tabanlı Obsidian'ın user namespace oluşturmasını engelliyor
- Çözüm henüz uygulanmadı. Seçenekler:
  - `sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0` (sistem geneli)
  - `DISPLAY=:0 snap run obsidian --no-sandbox` (geçici)

**Embedded Systems öğrenme yolu belirlendi:**
- Mevcut durum: Teorik temel var, STM32 var, blink yapıldı
- Hedef: C → Embedded C++ → STM32 register seviyesi → RTOS
- Oluşturulan notlar: `Embedded Öğrenme Planı.md`

**Kaynaklar kararlaştırıldı:**
- C temeli: Beej's Guide to C Programming (ücretsiz, online)
- Embedded C + STM32: FastBit Embedded Brain Academy — Kiran Nayak (Udemy, ~$10-15)
- Embedded C++: "A Tour of C++" — Stroustrup + CppCon konuşmaları
- STM32 derinleşme: "Mastering STM32" — Carmine Noviello, ControllersTech/Phil's Lab YouTube
- Sertifika almaya gerek yok — portfolyo ve GitHub projeleri daha değerli

**STM32CubeIDE 2.1.1 Ubuntu'ya kuruldu:**
- Kurulum dizini: `/opt/st/stm32cubeide_2.1.1/`
- ST-Link udev kuralları aktif: `/etc/udev/rules.d/49-stlinkv*.rules`
- Terminal kısayolu: `sudo ln -s /opt/st/stm32cubeide_2.1.1/stm32cubeide /usr/local/bin/stm32cubeide`
- Kurulum notu: `STM32CubeIDE Ubuntu Kurulum.md`

**STM32CubeMX ayrıca kurulacak:**
- CubeIDE 2.1.1'de CubeMX artık ayrı kurulması gerekiyor (eski versiyonlarda entegreydi)
- ST sitesinden Generic Linux seçeneği ile indirilecek — session sonu itibarıyla indirme devam ediyordu

### Açık Kalan İşler
- [ ] Obsidian AppArmor sorunu çözülecek
- [ ] STM32CubeMX kurulumu tamamlanacak
- [ ] C modüllerine başlanacak (Beej's Guide + Kiran Nayak kursu)
