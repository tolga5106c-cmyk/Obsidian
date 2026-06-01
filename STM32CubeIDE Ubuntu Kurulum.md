# STM32CubeIDE Ubuntu Kurulum Rehberi

Versiyon: 2.1.1 | Test edildi: Ubuntu (Kernel 7.0.0-15)

---

## 1. İndirme

ST'nin sitesi indirme için **hesap gerektiriyor**. Giriş yapmadan indirilen dosya 110 byte'lık bir hata XML'i oluyor — gerçek dosya değil.

1. `st.com`'da hesap aç (ücretsiz) ve giriş yap
2. STM32CubeIDE indirme sayfasına git
3. OS olarak **Debian Linux** seç, versiyonu seç
4. İndir — dosya adı şuna benzer:
   `st-stm32cubeide_2.1.1_XXXXX_amd64.deb_bundle.sh.zip`
5. İndirme ~805 MB, **tamamen bitene kadar dosyaya dokunma**

> Zip içinden `.deb_bundle.sh` çıkar. Bu, bir `.deb` paketini içinde barındıran Makeself self-extracting shell script'tir. Normal zip gibi açılmaz, direkt çalıştırılır.

---

## 2. Kurulum

```bash
# Çalıştırma izni ver
chmod +x st-stm32cubeide_*_amd64.deb_bundle.sh

# Kur (sudo + gerçek terminal gerekli)
sudo ./st-stm32cubeide_*_amd64.deb_bundle.sh -- --quiet
```

Kurulum `/opt/st/stm32cubeide_2.1.1/` dizinine yapılır.

---

## 3. ST-Link Udev Kuralları

ST-Link debugger'ın Linux'ta sudo olmadan çalışması için udev kuralları gerekiyor.

```bash
# Kuralları sistem dizinine kopyala
sudo cp /opt/st/stm32cubeide_2.1.1/plugins/com.st.stm32cube.ide.mcu.externaltools.stlink-gdb-server.linux64_*/tools/bin/49-stlinkv*.rules /etc/udev/rules.d/

# Kuralları yeniden yükle
sudo udevadm control --reload-rules
sudo udevadm trigger
```

> `udevadm trigger` çalışırken çok sayıda "Permission denied" hatası çıkıyor — bu normal, sanal cihazlar için oluyor. ST-Link kuralları yine de aktif olur.

Kurulduğunu doğrula:
```bash
ls /etc/udev/rules.d/ | grep stlink
# Çıktıda 49-stlinkv2.rules, 49-stlinkv2-1.rules, 49-stlinkv3.rules görünmeli
```

---

## 4. Terminal Kısayolu (Opsiyonel)

Kurulum sonrası `stm32cubeide` komutu PATH'te olmadığı için direkt çalışmıyor. Symlink ile ekle:

```bash
sudo ln -s /opt/st/stm32cubeide_2.1.1/stm32cubeide /usr/local/bin/stm32cubeide
```

Artık her yerden `stm32cubeide` yazarak açılır.

---

## 5. Çalıştırma

```bash
# Tam yol ile
/opt/st/stm32cubeide_2.1.1/stm32cubeide

# Symlink kurulduysa
stm32cubeide
```

---

## Kurulum Özeti

| Adım | Konum |
|---|---|
| IDE kurulum dizini | `/opt/st/stm32cubeide_2.1.1/` |
| Çalıştırılabilir dosya | `/opt/st/stm32cubeide_2.1.1/stm32cubeide` |
| ST-Link udev kuralları | `/etc/udev/rules.d/49-stlinkv*.rules` |
| Terminal kısayolu | `/usr/local/bin/stm32cubeide` |

---

## Sık Karşılaşılan Sorunlar

**İndirilen dosya 110 byte:**
ST hesabına giriş yapılmamış. Giriş yap, tekrar indir.

**`sudo: A terminal is required to authenticate`:**
Sudo komutunu gerçek bir terminal penceresinden çalıştır.

**`stm32cubeide: command not found`:**
Symlink kurulmamış. Adım 4'ü uygula veya tam yolu kullan.

**ST-Link tanınmıyor:**
Udev kuralları kurulmamış veya kurallar yüklenmemiş. Adım 3'ü tekrar uygula, ardından USB'yi çıkarıp tekrar tak.
