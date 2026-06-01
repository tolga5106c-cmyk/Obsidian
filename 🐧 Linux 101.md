---
title: "Linux 101 — Terminal ve Komut Satırı"
aliases: [Linux Giriş, Linux Introduction, Bash 101, Terminal 101]
tags: [linux, bash, terminal, cli, 101, gomulu-sistemler]
created: 2026-05-19
status: active
type: note
area: linux
---

# 🐧 Linux 101 — Terminal ve Komut Satırı

> [!ABSTRACT]+ TL;DR
> Linux terminalini sıfırdan kullanabilmek için bilmen gereken her şey: navigasyon (`pwd/ls/cd`), dosya işlemleri (`mkdir/cp/mv/rm`), izinler (`chmod`), metin filtreleme (`grep/sed/cut`), pipe & redirection (`|`, `>`, `<`), süreç yönetimi (`top/kill`) ve temel Bash scripting. Her bölümün sonunda öğrendiklerini kullanan **pratik mini örnekler** var.

> [!INFO]+ Nasıl çalışılır?
> - Sırayla oku; bölümler birikimli ilerliyor.
> - Bir terminal aç (WSL, Ubuntu VM, Raspberry Pi, macOS Terminal hepsi olur), her komutu **kendin yaz** — okumakla öğrenilmez.
> - Komutu yazmadan önce ne yapacağını tahmin et, sonra çalıştır, sonuçla karşılaştır.
> - Bağlantılı not: [[🚀 Gömülü Sistemler 101]] (Faz 1'in son maddesi bu nota gelir).

---

## 🎬 BÖLÜM 0: GİRİŞ — TERMİNAL, KABUK, KOMUT

- **Tamamlayıcı güç:** Terminal, GUI'nin (fareyle tıkladığın pencereli arayüz) düşmanı değildir; onu **güçlendiren** araçtır. Tek tıkla yapamayacağın 100'lerce iş, tek satırla biter.

- **Komut istemi (Prompt):** Sistem "Hazırım, komut yaz" der. Genelde şu formattadır: `user@bash:~$`. `$` (kullanıcı) veya `#` (root) ile biter.

- **Altın formül:** Her komut şu yapıdadır:
    ```
    komut [boşluk] -seçenek [boşluk] argüman
    ```
    Boşluklar **hayati**dir — `ls-l` değil, `ls -l`.

- **Kabuk (Shell) ve BASH:** Yazdığın komutları çekirdeğin (kernel) anlayacağı dile çeviren program "shell"dir. En yaygını **BASH** (Bourne Again SHell). Diğerleri: `zsh`, `fish`, `dash`, `ksh`.

- **Hayat kurtaran kısayollar:**
    - **Yukarı/Aşağı ok:** geçmiş komutları geri çağır.
    - **Tab:** otomatik tamamlama (dosya, komut, klasör adı).
    - **Ctrl+R:** geçmişte arama yap.
    - **Ctrl+L:** ekranı temizle (= `clear`).
    - **Ctrl+C:** çalışan komutu durdur.
    - **Ctrl+D:** terminali kapat (`exit` gibi).

> [!TIP] İlk hareket
> Hangi shell'i kullandığını öğrenmek için: `echo $SHELL`.

---

## 🧭 BÖLÜM 1: TEMEL NAVİGASYON

### `pwd` — Neredeyim?

"Print Working Directory" — bulunduğun konumu gösterir.

```bash
$ pwd
/home/tolga
```

### `ls` — Etrafta ne var?

"List" — bulunduğun (veya hedef gösterdiğin) klasördeki dosyaları listeler.

```bash
$ ls                    # basit liste
$ ls -l                 # uzun format (izin, sahip, boyut, tarih)
$ ls -la                # gizli dosyalar (.ile başlayan) dahil
$ ls -lh                # boyutu insan-okur format (KB, MB)
$ ls -lt                # tarihe göre sırala (yeni en üstte)
$ ls /etc               # başka bir klasörü listele
```

### Yollar (Paths) — Adres tarifi

| Tür | Başlangıç | Örnek |
|---|---|---|
| **Mutlak (Absolute)** | Kök dizinden (`/`) başlar | `/home/tolga/Documents` |
| **Göreceli (Relative)** | Bulunduğun yerden | `Documents/notes` |

### Navigasyon kısayolları

| İşaret | Anlamı |
|---|---|
| `/` | Kök dizin (sistemin en tepesi) |
| `~` | Ev (home) dizinin (`/home/tolga`) |
| `.` | Şu an içinde olduğun klasör |
| `..` | Bir üst klasör |
| `-` | Bir önceki bulunduğun klasör (`cd -` ile geri dön) |

### `cd` — Klasör değiştir

```bash
$ cd /etc                       # mutlak yol
$ cd Documents                  # göreceli
$ cd ..                         # bir üst klasör
$ cd ~                          # ev dizinine git
$ cd                            # tek başına yine ev
$ cd -                          # bir önceki klasöre dön
```

> [!TIP] **Tab tamamlama** — Komutun en güçlü tarafı
> `cd Doc` yazıp **Tab** tuşuna bas → `Documents/` olarak tamamlanır. Yarısı yetersiz kalırsa iki kez Tab → seçenekler listelenir.

### 📝 Öğrendiklerimiz — Pratik Örnekler

> [!EXAMPLE]+ Mini Senaryo
> Diyelim home'dasın, Downloads içine girip dosyaları boyutlarıyla görüp eve dönmek istiyorsun:
> ```bash
> $ pwd                    # /home/tolga
> $ cd Downloads
> $ ls -lh                 # boyut + uzun format
> $ cd ~                   # eve dön
> ```

| Komut | Ne yapar | Hızlı örnek |
|---|---|---|
| `pwd` | Mevcut konumu söyler | `pwd` |
| `ls` | Klasör içeriğini listeler | `ls -lh` |
| `cd` | Klasör değiştirir | `cd ~/Documents` |
| `/` `~` `.` `..` | Yol kısayolları | `cd ../..` (iki üst) |
| **Tab** | Otomatik tamamla | `cd Doc<Tab>` |

---

## 📂 BÖLÜM 2: DOSYALAR HAKKINDA DAHA FAZLASI

### "Her şey bir dosyadır"

Linux'ta **her şey** bir dosyadır:
- Metin dosyası → dosya
- Klasör → özel bir dosya (içinde başka dosyaların listesi)
- Klavye → dosya (sistem ondan okur)
- Ekran → dosya (sistem ona yazar)
- USB cihaz, ağ bağlantısı → dosya (`/dev/...` içinde)

Bu felsefe sayesinde Linux komutları küçük ve tutarlıdır — aynı komut hem dosya hem cihazla çalışır.

### Linux uzantısız bir sistemdir

Windows'ta `.exe` = program, `.txt` = metin. Linux'ta uzantı sadece **isim**dir, içeriği belirlemez. `myself.png` adlı bir dosyayı `myself.txt` olarak yeniden adlandırsan da Linux içine bakar ve "bu bir PNG resim" der.

İçeriği öğrenmek için: `file` komutu.

```bash
$ file myself.png
myself.png: PNG image data, 800 x 600, 8-bit/color RGB

$ file Documents
Documents: directory

$ mv myself.png myself.txt
$ file myself.txt
myself.txt: PNG image data, 800 x 600, 8-bit/color RGB    # hâlâ resim!
```

### Linux BÜYÜK/KÜÇÜK HARFE DUYARLI

`File.txt`, `file.txt`, `FILE.TXT` → **üç farklı dosya**. Windows'tan geçenler için en sık hata.

### İsimde boşluk — quotes ve escape

Klasör adı `Holiday Photos` ise `cd Holiday Photos` **çalışmaz** — terminal iki argüman görür. İki çözüm:

**1. Tırnak (quotes):**
```bash
$ cd 'Holiday Photos'
$ cd "Holiday Photos"
```

**2. Escape karakteri (`\`):**
```bash
$ cd Holiday\ Photos
```

Backslash, hemen sonrasındaki karakterin özel anlamını "nötralize eder".

> [!WARNING] En sık hatalar
> - Dosya adında boşluk olduğunu unutmak (tırnaksız yazmak).
> - `File.txt` ile `file.txt` arasındaki büyük-küçük harf farkını gözden kaçırmak.
> - Uzantıya bakıp dosya türü tahmin etmek — her zaman `file` ile teyit et.

### 📝 Öğrendiklerimiz — Pratik Örnekler

> [!EXAMPLE]+ Mini Senaryo
> İndirilenler klasöründe bir dosyanın türünü tespit et, gizli dosyaları da gör:
> ```bash
> $ cd ~/Downloads
> $ ls -a                          # gizli dosyalar dahil
> $ file mystery_file              # ne tür?
> mystery_file: PDF document, version 1.7
> ```

| Komut | Ne yapar | Hızlı örnek |
|---|---|---|
| `file <yol>` | Dosyanın gerçek türünü söyler | `file ~/Pictures/cat.png` |
| `ls -a` | Gizli dosyalar dahil listele | `ls -la ~` |
| Tırnak | Boşluklu isimler için | `cd "Holiday Photos"` |
| `\` (escape) | Özel karakteri nötrle | `cd Holiday\ Photos` |

---

## 📖 BÖLÜM 3: MANUAL PAGES (`man`)

Her komutun ne yaptığını ezberlemen gerekmez — sistem zaten manual sayfalarında saklıyor.

```bash
$ man ls                # ls komutunun tam dokümantasyonu
$ man -k network        # "network" kelimesi geçen tüm man sayfalarını ara
```

### Man sayfası içinde gezinme

| Tuş | İşlev |
|---|---|
| **Boşluk** veya **f** | Sonraki sayfa |
| **b** | Önceki sayfa |
| **↑/↓** | Satır satır kaydır |
| `/kelime` | İleri yönde ara |
| `?kelime` | Geri yönde ara |
| **n** | Sonraki eşleşme |
| **N** | Önceki eşleşme |
| **q** | Çık |
| **h** | Yardım |

### 📝 Öğrendiklerimiz — Pratik Örnekler

> [!EXAMPLE]+ Mini Senaryo
> "cp komutunun -i seçeneği ne yapıyordu acaba?" → ezberleme, sor:
> ```bash
> $ man cp
> /-i                  # / ile -i'yi ara
> # "prompt before overwrite" — üzerine yazmadan önce sor
> q                    # çık
> ```

> [!TIP] Hangi komut acaba?
> Bir işin komutunu bilmiyorsan, anahtar kelime ile ara:
> ```bash
> $ man -k "rename"
> $ man -k "compress"
> ```

| Komut | Ne yapar |
|---|---|
| `man <komut>` | Komutun dokümantasyonunu aç |
| `man -k <kelime>` | Açıklamalarda anahtar kelime ara |
| `/<kelime>` | Sayfa içi ileri ara |
| `n` / `q` | Sonraki eşleşme / çık |

> [!INFO] Önemli kavram
> **Ezberleme — `man` senin dostundur.** Hatırlamak yerine, hızlıca bakmayı öğren.

---

## 🛠️ BÖLÜM 4: DOSYA YÖNETİMİ

### `mkdir` — Klasör oluştur

```bash
$ mkdir projeler                          # tek klasör
$ mkdir -p projeler/2026/q4              # iç içe ara klasörler dahil
$ mkdir -v projeler                      # ne yaptığını söylesin (verbose)
$ mkdir -pv projeler/2026/{q1,q2,q3,q4}  # tek seferde 4 alt klasör
```

### `rmdir` — Boş klasör sil

```bash
$ rmdir projeler/2026/q4    # SADECE boş klasörü siler
```

> [!DANGER] **Linux'ta `Geri Al` (Undo) yoktur.**
> Komut satırından silinen dosya çöp kutusuna gitmez — **uçar gider**. `rm` ile silmeden önce iki kez düşün.

### `touch` — Boş dosya oluştur

```bash
$ touch notes.txt              # boş dosya
$ touch a.txt b.txt c.txt      # birden fazla
$ touch notes.txt              # zaten varsa: zaman damgasını günceller
```

### `cp` — Kopyala

```bash
cp [seçenek] <kaynak> <hedef>
```

```bash
$ cp notes.txt notes_backup.txt          # dosya kopyası
$ cp notes.txt ~/Documents/              # başka klasöre
$ cp -r projeler projeler_yedek          # -r: klasörü recursive kopyala
$ cp -v file.txt /backup/                # verbose: ne kopyaladığını söylesin
$ cp -i file.txt /backup/                # interactive: üstüne yazmadan önce sor
```

> [!WARNING] Klasör kopyalarken **`-r`** unutma
> `cp` varsayılan olarak sadece dosyaları kopyalar. Bir klasörü kopyalamak istiyorsan `-r` (recursive) zorunlu.

### `mv` — Taşı veya yeniden adlandır

```bash
mv [seçenek] <kaynak> <hedef>
```

```bash
$ mv notes.txt ~/Documents/              # taşı
$ mv notes.txt notlar.txt                # yeniden adlandır (aynı klasörde)
$ mv old_dir/ new_dir/                   # klasör için -r gerekmez!
$ mv *.jpg ~/Pictures/                   # joker karakterle topluca taşı
```

### `rm` — Sil

```bash
$ rm file.txt                # tek dosya
$ rm file1 file2 file3       # birden fazla
$ rm -r eski_klasor/         # klasör + içindekileri sil
$ rm -rf eski_klasor/        # zorla sil, soru sormadan (TEHLİKELİ)
$ rm -i file.txt             # silmeden önce onay iste (güvenli)
```

> [!DANGER] `rm -rf /` veya `rm -rf *`
> Sistemin tamamını silebilirsin. Asla, hiçbir koşulda, root iken `rm -rf` komutunu yolunu kontrol etmeden çalıştırma. **Production sunucularda `rm -i` alias'ı kullanmak iyi bir alışkanlık.**

### 📝 Öğrendiklerimiz — Pratik Örnekler

> [!EXAMPLE]+ Mini Senaryo 1 — Proje yedeği al
> ```bash
> $ mkdir -p ~/yedekler/$(date +%Y-%m-%d)
> $ cp -rv ~/projeler/site/ ~/yedekler/$(date +%Y-%m-%d)/
> $ ls ~/yedekler/
> 2026-05-19
> ```

> [!EXAMPLE]+ Mini Senaryo 2 — Klasör hiyerarşisi kur
> ```bash
> $ mkdir -p ~/blog/{drafts,published,images,scripts}
> $ touch ~/blog/drafts/2026-05-19-linux-101.md
> $ ls -R ~/blog
> ```

> [!EXAMPLE]+ Mini Senaryo 3 — Yeniden adlandır (mv ile)
> ```bash
> $ mv "Yeni Belge.docx" rapor_2026-q2.docx
> ```

| Komut | Ne yapar | Hızlı örnek |
|---|---|---|
| `mkdir` | Klasör oluştur | `mkdir -p a/b/c` |
| `rmdir` | Boş klasör sil | `rmdir bos_klasor` |
| `touch` | Boş dosya oluştur | `touch test.txt` |
| `cp` | Kopyala | `cp -r src/ dst/` |
| `mv` | Taşı / yeniden adlandır | `mv eski yeni` |
| `rm` | Sil | `rm -i dosya` (sorarak) |

> [!INFO] Önemli kavram
> **Geri alma yok.** Yıkıcı eylemlerde (silme, üstüne yazma) tedbirli ol. Önemli dosyalara dokunmadan önce `cp` ile yedek al.

---

## ✍️ BÖLÜM 5: METİN EDİTÖRÜ — VI

### Neden Vi?

Her Linux sisteminde **kesin** vardır — uzak bir sunucuya SSH ile bağlandığında `nano` olmayabilir ama `vi` (veya modern hâli `vim`) olur. En azından temel kullanımını bilmek hayat kurtarır.

### Açma

```bash
$ vi notes.txt           # varsa açar, yoksa yeni oluşturur
```

### İki temel mod

| Mod | Ne yapar | Nasıl girilir |
|---|---|---|
| **Normal (Edit) mod** | Komutlar (gezin, sil, kopyala) | `Esc` |
| **Insert mod** | Yazma | Normal'den `i` ile |

Açılış normal moddadır. Yazmaya başlamak için **`i`** bas. Yazma bitince **`Esc`** ile normal moda dön.

### Kaydetme ve çıkma (normal modda)

| Komut | İşlev |
|---|---|
| `:w` | Kaydet (kapatma) |
| `:q` | Çık (değişiklik yoksa) |
| `:wq` veya `ZZ` | Kaydet ve çık |
| `:q!` | Kaydetmeden zorla çık |
| `:w yeni.txt` | Farklı kaydet |

### Gezinme (normal modda)

| Tuş | Hareket |
|---|---|
| `h` `j` `k` `l` | Sol/aşağı/yukarı/sağ (ok tuşları da olur) |
| `w` / `b` | Bir kelime ileri / geri |
| `0` / `^` | Satır başı |
| `$` | Satır sonu |
| `gg` | Dosyanın en başı |
| `G` | Dosyanın en sonu |
| `5G` | 5. satıra git |
| `Ctrl+f` / `Ctrl+b` | Sayfa ileri / geri |

### Düzenleme (normal modda)

| Tuş | İşlev |
|---|---|
| `x` | Karakter sil |
| `dd` | Satırı sil |
| `5dd` | 5 satır sil |
| `yy` | Satırı kopyala (yank) |
| `p` | Yapıştır |
| `u` | Geri al (undo) |
| `Ctrl+r` | Geri al'ı geri al (redo) |
| `/kelime` | Ara |
| `n` / `N` | Sonraki / önceki eşleşme |
| `:s/eski/yeni/g` | Satırda tümünü değiştir |
| `:%s/eski/yeni/g` | Tüm dosyada değiştir |

### `cat` ve `less` — Dosyayı görüntüle

```bash
$ cat dosya.txt        # tüm içeriği ekrana dök (kısa dosyalar için)
$ less dosya.txt       # büyük dosyalar için (q ile çık, /ile ara)
```

### 📝 Öğrendiklerimiz — Pratik Örnekler

> [!EXAMPLE]+ Mini Senaryo — Bir config dosyasını düzenle
> ```bash
> $ vi config.ini
> # vi açıldı, normal mod
> i                           # insert moda gir
> # ... yaz ...
> Esc                         # tekrar normal mod
> :wq                         # kaydet ve çık
> ```

> [!EXAMPLE]+ Mini Senaryo — Bir dosyada arama-değiştirme
> ```bash
> $ vi notes.txt
> /TODO                       # TODO'ları ara
> n                           # sonraki
> :%s/TODO/DONE/g             # hepsini DONE yap
> :wq
> ```

| Komut | Ne yapar |
|---|---|
| `vi <dosya>` | Aç (yoksa oluştur) |
| `i` / `Esc` | Insert / Normal mod |
| `:wq` / `:q!` | Kaydet+çık / Kaydetmeden çık |
| `dd` `yy` `p` | Satır sil / kopyala / yapıştır |
| `/kelime` | İçinde ara |
| `cat` / `less` | Dosyayı görüntüle |

> [!TIP] vi'yi yenmek için
> Korkutucu görünür ama 5–10 dakika içinde temel akış oturur. Açılır açılmaz **`i`** → yaz → **`Esc`** → **`:wq`** dörtlüsünü ezberle. Gerisi bonus.

---

## 🃏 BÖLÜM 6: JOKER KARAKTERLER (WILDCARDS)

Bir desenle birden fazla dosyayı seçmenin yolu. `ls`, `cp`, `mv`, `rm`, `grep`... hepsi joker karakter anlar.

| Karakter | Ne eşler |
|---|---|
| `*` | **Sıfır veya daha fazla** karakter |
| `?` | **Tek** karakter |
| `[abc]` | Köşeli içindeki karakterlerden **biri** |
| `[a-z]` | a–z arası bir karakter |
| `[^abc]` | a, b, c **dışındaki** bir karakter |

### Pratik örnekler

```bash
$ ls *.txt              # tüm .txt dosyaları
$ ls b*                 # b ile başlayan
$ ls ?i*                # ikinci harfi i olan
$ ls *.???              # uzantısı tam 3 karakter olan
$ ls [sv]*              # s veya v ile başlayan
$ ls *[0-9]*            # adında rakam olan
$ ls [^a-k]*            # a-k aralığı dışındaki harfle başlayan
```

### Birden fazla işlemde kullanma

```bash
$ cp ~/Pictures/*.jpg ~/Backup/         # tüm jpg'leri kopyala
$ rm temp_*                              # temp_ ile başlayan tüm dosyaları sil
$ mv *.png *.jpg ~/Images/              # tüm png ve jpg'leri taşı
$ file /home/tolga/*                     # ev klasöründekilerin türlerini gör
```

### 📝 Öğrendiklerimiz — Pratik Örnekler

> [!EXAMPLE]+ Mini Senaryo 1 — Sadece resimleri başka klasöre taşı
> ```bash
> $ ls ~/Downloads
> photo1.jpg cv.pdf invoice.pdf logo.png notes.txt vacation.jpg
> $ mv ~/Downloads/*.{jpg,png} ~/Pictures/
> $ ls ~/Downloads
> cv.pdf invoice.pdf notes.txt
> ```

> [!EXAMPLE]+ Mini Senaryo 2 — Tarihli log dosyalarını topla
> ```bash
> $ ls /var/log/syslog*
> /var/log/syslog /var/log/syslog.1 /var/log/syslog.2.gz
> $ cp /var/log/syslog* ~/log_backup/
> ```

> [!EXAMPLE]+ Mini Senaryo 3 — Sadece tek harfli (geçici) dosyaları sil
> ```bash
> $ rm ?
> ```

| Sembol | Eşler | Örnek |
|---|---|---|
| `*` | 0+ karakter | `*.jpg` (tüm jpg) |
| `?` | Tam 1 karakter | `?.txt` (tek karakter + .txt) |
| `[abc]` | İçindekilerden biri | `[sv]*` (s veya v ile başlayan) |
| `[a-z]` | Aralık | `[0-9]*` (rakamla başlayan) |
| `[^...]` | Hariç | `[^a-z]*` (harf-dışı ile başlayan) |

---

## 🔐 BÖLÜM 7: İZİNLER (PERMISSIONS)

### Üç eylem, üç grup

Linux her dosya için 3 eylemi kontrol eder:

| Harf | Anlamı |
|---|---|
| `r` | **read** — okuma |
| `w` | **write** — yazma/değiştirme |
| `x` | **execute** — çalıştırma (klasörde: içine girme) |

Ve bu üç eylemi 3 farklı grup için ayarlar:

| Grup | Kim |
|---|---|
| **u** (user/owner) | Dosyanın sahibi |
| **g** (group) | Dosyanın grubu (birden fazla kullanıcı olabilir) |
| **o** (others) | Diğer herkes |
| **a** (all) | Hepsi (u+g+o) |

### İzinleri görme — `ls -l`

```bash
$ ls -l notes.txt
-rwxr-x--- 1 tolga staff 2.7K Jan 4 07:32 notes.txt
```

İlk 10 karakteri çözümleyelim:

| Karakter | Anlamı |
|---|---|
| `-` | Dosya türü (`-` = normal dosya, `d` = klasör, `l` = link) |
| `rwx` | **Owner** izinleri (read, write, execute) |
| `r-x` | **Group** izinleri (read, execute; write yok) |
| `---` | **Others** izinleri (hiçbiri) |

> [!INFO] Sıra hep aynı
> r → w → x. Eksik olan yerde `-` görürsün. Karıştırma.

### İzin değiştirme — `chmod`

İki yöntem: sembolik ve sayısal.

#### Sembolik yöntem

```
chmod [kim][+/-/=][izin] <dosya>
```

```bash
$ chmod g+x script.sh         # grup için execute ekle
$ chmod u-w file.txt          # owner'dan write çıkar
$ chmod o=r file.txt          # others sadece read
$ chmod a+x backup.sh         # herkese execute ver
$ chmod go-rwx secret.txt     # group ve others'tan tüm izinleri al
```

#### Sayısal (oktal) yöntem

Her izin bir sayıdır:

| İzin | Sayı |
|---|---|
| `r` | 4 |
| `w` | 2 |
| `x` | 1 |
| `-` | 0 |

Toplayarak 3 haneli sayı:

| Sayı | İzinler |
|---|---|
| `7` | rwx (4+2+1) |
| `6` | rw- (4+2) |
| `5` | r-x (4+1) |
| `4` | r-- |
| `0` | --- |

3 hane: **owner / group / others**.

```bash
$ chmod 755 script.sh         # rwxr-xr-x (script için klasik)
$ chmod 644 notes.txt         # rw-r--r-- (normal dosya için klasik)
$ chmod 700 ~/.ssh            # rwx------ (sadece sahip, gizli klasörler için)
$ chmod 600 ~/.ssh/id_rsa     # rw------- (SSH private key için ZORUNLU)
```

> [!TIP] Sık kullanılan klasikler
> - **755** — scriptler ve klasörler
> - **644** — düz dosyalar
> - **700** / **600** — kişisel/gizli içerik
> - **777** — herkes her şeyi yapabilir (genelde **kötü fikir**)

### Klasörlerde izinlerin anlamı farklı

| İzin | Dosyada | Klasörde |
|---|---|---|
| `r` | İçeriği okuyabilirsin | İçindekileri **listeleyebilirsin** (`ls`) |
| `w` | İçeriği değiştirebilirsin | İçinde dosya **oluşturabilir/silebilirsin** |
| `x` | Çalıştırabilirsin | İçine **girebilirsin** (`cd`) |

> [!EXAMPLE] Garip ama gerçek
> Bir klasörde sadece `x` (execute) verilirse: **içeri girebilirsin** ama `ls` çalışmaz. İçindeki dosyanın adını biliyorsan açabilirsin ama listeleyemezsin. Eski stil web server'lar için tipik (`public_html`).

### `chown` ve `chgrp` (bonus)

```bash
$ chown tolga file.txt              # sahibini değiştir
$ chown tolga:staff file.txt        # sahip ve grup
$ chgrp staff file.txt              # sadece grup
```

Bunlar genelde **root** yetkisi ister.

### 📝 Öğrendiklerimiz — Pratik Örnekler

> [!EXAMPLE]+ Mini Senaryo 1 — Script'i çalıştırılabilir yap
> ```bash
> $ ls -l backup.sh
> -rw-r--r-- 1 tolga staff 1.2K May 19 backup.sh
> $ chmod +x backup.sh                # u+g+o'ya execute ekle
> $ ./backup.sh                       # artık çalışıyor
> ```

> [!EXAMPLE]+ Mini Senaryo 2 — SSH anahtarını koru
> ```bash
> $ chmod 600 ~/.ssh/id_rsa
> $ ls -l ~/.ssh/id_rsa
> -rw------- 1 tolga staff 1.8K May 19 id_rsa
> # Aksi takdirde ssh "permissions too open" deyip reddeder.
> ```

> [!EXAMPLE]+ Mini Senaryo 3 — Bir klasörü herkesin **görmesini engelle** ama **içine girmesine izin ver**
> ```bash
> $ chmod 711 public_html        # rwx--x--x
> # Sahip her şey, others sadece içine girip içindeki ismi bildiği dosyayı açabilir.
> ```

| Komut | Ne yapar | Örnek |
|---|---|---|
| `ls -l` | İzinleri gör | `ls -l file.txt` |
| `chmod` | İzin değiştir | `chmod 755 script.sh` |
| `chown` | Sahibi değiştir | `chown tolga file` |
| `chgrp` | Grubu değiştir | `chgrp staff file` |

> [!INFO] Önemli kavram
> **Güvenlik = doğru izinler.** Yanlış izinler → ya kimse erişemez ya da herkes erişir. Her ikisi de istenmez.

---

## 🛡️ BÖLÜM 8: TEMEL GÜVENLİK

### Ev dizini izinleri

Ev klasörün (`~`) tipik olarak:
- **Owner (sen):** `rwx` — tam yetki
- **Group:** çoğu zaman `---` veya `r-x`
- **Others:** `---`

Çok-kullanıcılı bir sistemde başkasının dosyalarını okumak istemiyorsan ev klasörünü `chmod 700 ~` ile kilitle.

### Root kullanıcısı

Linux'ta sadece **iki kişi** bir dosyanın izinlerini değiştirebilir:

1. **Dosyanın sahibi**
2. **Root kullanıcısı** — süper kullanıcı, sistemi yöneten kişi, her şeyi yapabilir

Root'un parolası genelde bilinmez. Onun yerine `sudo` komutu kullanılır: "bu komutu root yetkisiyle çalıştır":

```bash
$ sudo apt update                # paket listesini güncelle (root yetkisi gerekir)
$ sudo chmod 644 /etc/hosts      # sistem dosyasına dokun
$ sudo -i                        # root shell'ine geç (dikkat!)
```

> [!DANGER] sudo neden tehlikeli?
> Root yetkisiyle yapılan hata, sistemin tamamını mahvedebilir. `sudo rm -rf /` çalıştırırsan dönüş yok. Komutu yazmadan **iki kez** oku.

### Hassas dosyalar — bilmen gerekenler

| Dosya | Ne içerir | İzin olması gereken |
|---|---|---|
| `~/.ssh/id_rsa` | SSH private key | `600` |
| `~/.ssh/authorized_keys` | Sana erişebilecek key'ler | `600` |
| `~/.bash_history` | Yazdığın komutların geçmişi | `600` |
| `/etc/shadow` | Şifre hash'leri | `000` (sadece root) |

### 📝 Öğrendiklerimiz — Pratik Örnekler

> [!EXAMPLE]+ Mini Senaryo — Yeni bir sunucuya bağlandın, ev klasörü güvenliğini sağla
> ```bash
> $ chmod 700 ~                            # ev klasörünü kilitle
> $ chmod 700 ~/.ssh                       # SSH klasörü
> $ chmod 600 ~/.ssh/authorized_keys       # anahtar dosyası
> ```

| Kavram | Anahtar nokta |
|---|---|
| **Ev dizini** | Senin alanın — başkasından koru |
| **root** | Süper kullanıcı, dikkatli kullan |
| **sudo** | Geçici root yetkisi |
| **Doğru izinler** | Güvenliğin temeli |

---

## 🔬 BÖLÜM 9: FİLTRELER

Veri akışını dönüştüren küçük, odaklanmış programlar. Pipe (`|`) ile birleştirildiklerinde çok güçlüler.

Tüm bu örneklerde aşağıdaki örnek dosyayı kullanacağız:

```text
# mysampledata.txt
Fred apples 20
Susy oranges 5
Mark watermellons 12
Robert pears 4
Terry oranges 9
Lisa peaches 7
Susy oranges 12
Mark grapes 39
Anne mangoes 7
Greg pineapples 3
Oliver rockmellons 2
Betty limes 14
```

### `head` — Baştan kaç satır

```bash
$ head mysampledata.txt           # ilk 10 satır (varsayılan)
$ head -4 mysampledata.txt        # ilk 4 satır
$ head -n 20 mysampledata.txt     # ilk 20 satır
```

### `tail` — Sondan kaç satır

```bash
$ tail mysampledata.txt           # son 10
$ tail -3 mysampledata.txt        # son 3
$ tail -f /var/log/syslog         # canlı izle (debug klasiği!)
```

> [!TIP] `tail -f` — Debug'ın en sevdiği komut
> Bir log dosyasını anlık izler. Yeni satır geldikçe ekrana basar. Sunucu sorunlarında saatlerce baktığın komuttur.

### `sort` — Sırala

```bash
$ sort mysampledata.txt           # alfabetik
$ sort -r mysampledata.txt        # ters
$ sort -n sayilar.txt             # sayısal sırala
$ sort -k 2 mysampledata.txt      # 2. kolona göre
$ sort -u mysampledata.txt        # benzersiz (uniq + sort)
```

### `nl` — Satır numarası ekle

```bash
$ nl mysampledata.txt
     1  Fred apples 20
     2  Susy oranges 5
     ...
$ nl -s ". " -w 10 mysampledata.txt    # 1. " özelleştir
```

### `wc` — Word count (satır, kelime, karakter)

```bash
$ wc mysampledata.txt
 12  36 195 mysampledata.txt        # satır kelime karakter
$ wc -l mysampledata.txt            # sadece satır
$ wc -w mysampledata.txt            # sadece kelime
$ wc -m mysampledata.txt            # karakter
```

### `cut` — Kolon ayır

```bash
$ cut -f 1 -d ' ' mysampledata.txt        # 1. kolon (boşlukla ayrı)
Fred
Susy
Mark
...

$ cut -f 1,3 -d ' ' mysampledata.txt      # 1. ve 3. kolon
Fred 20
Susy 5
...
```

- `-f` field (kolon) numarası
- `-d` delimiter (ayraç) — varsayılan TAB

> [!TIP] CSV dosyaları için
> CSV'de virgül ayraçtır: `cut -f 2 -d ',' data.csv`

### `sed` — Stream EDitor (bul-değiştir)

```bash
$ sed 's/oranges/bananas/g' mysampledata.txt
# Tüm "oranges" → "bananas"
```

Format: `s/aranan/değişen/g`
- `s` substitute
- `g` global (satırda hepsini, sadece ilkini değil)

```bash
$ sed 's/oranges/bananas/' file       # satırda sadece ilk eşleşme
$ sed 's/Mark//' file                 # Mark'ı sil (boş bırak)
$ sed -i 's/eski/yeni/g' file         # dosyayı yerinde değiştir (-i = in-place)
```

> [!WARNING] `sed -i` geri alınamaz
> Dosyayı doğrudan değiştirir. Önce yedek al: `cp file file.bak` veya `sed -i.bak ...`

### `uniq` — Tekrar satırları kaldır

```bash
$ uniq mysampledata.txt        # ardışık tekrarları siler
$ sort file | uniq             # her yerdeki tekrarları sil
$ sort file | uniq -c          # her satırın sayısı
```

> [!INFO] Önemli detay
> `uniq` sadece **ardışık** tekrarları siler. Önce `sort` çalıştır, sonra `uniq`.

### `tac` — `cat`'in tersi

```bash
$ tac mysampledata.txt
# son satırdan ilk satıra doğru yazdırır
```

### 📝 Öğrendiklerimiz — Pratik Örnekler

> [!EXAMPLE]+ Mini Senaryo 1 — En çok meyvesi olan ilk 3 kişi
> ```bash
> $ sort -k 3 -n -r mysampledata.txt | head -3
> Mark grapes 39
> Fred apples 20
> Betty limes 14
> ```

> [!EXAMPLE]+ Mini Senaryo 2 — Sadece isimleri al ve kaç farklı isim var say
> ```bash
> $ cut -f 1 -d ' ' mysampledata.txt | sort | uniq | wc -l
> 11
> ```

> [!EXAMPLE]+ Mini Senaryo 3 — "oranges"ı "narınciye" yap, yedek tut
> ```bash
> $ cp mysampledata.txt mysampledata.bak
> $ sed -i 's/oranges/narınciye/g' mysampledata.txt
> ```

| Komut | Ne yapar | Hızlı örnek |
|---|---|---|
| `head` / `tail` | İlk / son N satır | `tail -20 log.txt` |
| `sort` | Sırala | `sort -k 2 -n data` |
| `nl` | Satır numarası | `nl notes.md` |
| `wc` | Satır/kelime/karakter say | `wc -l *.txt` |
| `cut` | Kolon ayır | `cut -f 1 -d ',' csv` |
| `sed` | Bul-değiştir | `sed 's/foo/bar/g'` |
| `uniq` | Tekrarları sil | `sort \| uniq -c` |
| `tac` | Ters çevir | `tac log.txt` |

> [!INFO] Önemli kavram
> Filtreler küçük ama **birleştirilince** muazzam güçlüdür. Pipe (`|`) bölümünde bunu göreceksin.

---

## 🔍 BÖLÜM 10: GREP VE REGULAR EXPRESSIONS

### `grep` (ve `egrep`)

Belirli bir desenle eşleşen satırları bulur. **En sık kullanılan** Linux komutlarından biri.

```bash
grep [seçenek] <desen> <dosya>
```

```bash
$ grep "mellon" mysampledata.txt
Mark watermellons 12
Oliver rockmellons 2

$ grep -n "mellon" mysampledata.txt        # satır numarasıyla
3:Mark watermellons 12
11:Oliver rockmellons 2

$ grep -c "mellon" mysampledata.txt        # sadece sayı
2

$ grep -i "MELLON" mysampledata.txt        # büyük/küçük harf duyarsız
$ grep -v "oranges" mysampledata.txt       # eşleşMEyen satırlar
$ grep -r "TODO" projeler/                 # klasörde recursive ara
$ grep -l "TODO" *.md                      # sadece dosya isimleri
```

> [!INFO] `grep` vs `egrep`
> `egrep` = `grep -E` = extended regex. Modern regex (`+`, `?`, `|`, `()` vs.) ile çalışır. Pratikte ikisi de iyi; yeni komutlarda `grep -E` veya `egrep` tercih et.

### Regular Expressions — Temel yapı taşları

| Sembol | Anlamı |
|---|---|
| `.` | Herhangi tek karakter |
| `?` | Önceki karakter 0 veya 1 kez |
| `*` | Önceki karakter 0 veya daha fazla |
| `+` | Önceki karakter 1 veya daha fazla |
| `{n}` | Tam n kez |
| `{n,m}` | n ile m arası |
| `[abc]` | a, b veya c |
| `[^abc]` | a, b, c DEĞİL |
| `[a-z]` | aralık |
| `()` | gruplama |
| `\|` | VEYA |
| `^` | satır başı |
| `$` | satır sonu |

### Regex örnekleri

```bash
# Üst üste 2 sesli harf içeren satırlar
$ egrep '[aeiou]{2,}' mysampledata.txt
Robert pears 4
Lisa peaches 7
Anne mangoes 7
Greg pineapples 3

# 2 ile biten satırlar
$ egrep '2$' mysampledata.txt
Mark watermellons 12
Susy oranges 12
Oliver rockmellons 2

# Adı A–K ile başlayanlar
$ egrep '^[A-K]' mysampledata.txt
Fred apples 20
Anne mangoes 7
Greg pineapples 3
Betty limes 14

# "or", "is" veya "go" geçen satırlar
$ egrep 'or|is|go' mysampledata.txt

# E-posta formatı (basit)
$ egrep '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-z]{2,}' contacts.txt
```

> [!TIP] Regex'i derinlemesine öğren
> Veri bilimi, log analizi, kod arama, sed/awk, programlama dilleri — regex her yerde. Bir kez doğru öğrenirsen ömür boyu kullanırsın. [[Regex Pratiği]] notunu aç.

### 📝 Öğrendiklerimiz — Pratik Örnekler

> [!EXAMPLE]+ Mini Senaryo 1 — Bir log dosyasında hataları say
> ```bash
> $ grep -c "ERROR" /var/log/app.log
> 47
> $ grep "ERROR" /var/log/app.log | tail -10        # son 10 hata
> ```

> [!EXAMPLE]+ Mini Senaryo 2 — Bir Python projesinde TODO'ları bul
> ```bash
> $ grep -rn "TODO" --include="*.py" .
> ./src/auth.py:42:    # TODO: refresh token rotation
> ./src/db.py:108:    # TODO: connection pooling
> ```

> [!EXAMPLE]+ Mini Senaryo 3 — IP adresi formatında satırları bul
> ```bash
> $ egrep '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' access.log
> ```

| Komut | Ne yapar |
|---|---|
| `grep <desen> <dosya>` | Desenle eşleşen satırlar |
| `grep -n` | Satır numarası ile |
| `grep -i` | Büyük/küçük harf duyarsız |
| `grep -v` | Tersini bul (eşleşMEyen) |
| `grep -r` | Klasör içinde recursive ara |
| `grep -c` | Sadece sayı |
| `egrep` | Extended regex |

---

## 🔌 BÖLÜM 11: PIPE VE YÖNLENDİRME

### Üç akış (stream)

Her komutun üç bağlantısı vardır:

| Akış | Numara | Ne |
|---|---|---|
| **STDIN** | 0 | Standart girdi (programa giren veri) |
| **STDOUT** | 1 | Standart çıktı (programın yazdığı, varsayılan: terminal) |
| **STDERR** | 2 | Standart hata (hata mesajları, varsayılan: terminal) |

```
STDIN (0) →  [PROGRAM]  → STDOUT (1)
                       → STDERR (2)
```

### Yönlendirme (Redirection)

#### `>` — Çıktıyı dosyaya yaz (üstüne yazar)

```bash
$ ls > myoutput.txt           # ls çıktısını dosyaya kaydet
$ echo "Merhaba" > selam.txt  # dosyaya yaz
```

> [!WARNING] `>` mevcut dosyanın içeriğini **siler**, sonra yazar.

#### `>>` — Çıktıyı dosyaya ekle (sonuna)

```bash
$ date >> log.txt             # log'a tarih ekle (varolan içeriği bozmaz)
$ ls >> myoutput.txt          # mevcut dosyaya ekle
```

#### `<` — Dosyadan girdi al

```bash
$ wc -l < input.txt           # dosya wc'ye girdi olur
```

#### `2>` — Hataları yönlendir

```bash
$ ls /var/log /yokyer 2> errors.txt
# Normal çıktı ekrana, hatalar errors.txt'ye
```

#### `2>&1` — Hataları normal çıktıya bağla

```bash
$ ls /var/log /yokyer > all.txt 2>&1
# Hem normal hem hata aynı dosyaya
```

#### `&>` (modern kısayol)

```bash
$ ls /yokyer &> all.txt       # 2>&1 ile aynı, daha temiz
```

#### `/dev/null` — Çöp kutusu

```bash
$ ls > /dev/null              # çıktıyı sustur
$ noisy_command 2>/dev/null   # sadece hataları sustur
$ command &>/dev/null          # her şeyi sustur
```

### Pipe `|` — Bir programın çıktısını diğerine

Pipe Linux'un **en güçlü** özelliği. Sol taraftaki programın STDOUT'unu, sağdakinin STDIN'i yapar.

```bash
$ ls | head -3                       # ilk 3 dosya
$ cat log.txt | grep ERROR           # log'daki hatalar
$ cat log.txt | grep ERROR | wc -l   # kaç hata
```

### Birleştirme — Pipe'ın gücü

Tek tek küçük olan bu komutlar, birleşince muazzam.

```bash
# /etc içindeki en büyük 5 dosya
$ ls -lS /etc | head -6

# Belleği en çok tüketen 5 süreç
$ ps aux | sort -k 4 -n -r | head -5

# Bir log dosyasında benzersiz IP'leri saymak
$ cat access.log | cut -d ' ' -f 1 | sort | uniq -c | sort -n -r

# Bir klasörde her dosya türünden kaç adet var
$ ls | sed 's/.*\.//' | sort | uniq -c | sort -n -r

# Bash geçmişindeki en sık kullandığın 10 komut
$ history | awk '{print $2}' | sort | uniq -c | sort -n -r | head
```

### 📝 Öğrendiklerimiz — Pratik Örnekler

> [!EXAMPLE]+ Mini Senaryo 1 — Bir Python projesinde fonksiyon say
> ```bash
> $ grep -r "^def " --include="*.py" . | wc -l
> 73
> ```

> [!EXAMPLE]+ Mini Senaryo 2 — Bir log'da en sık görülen 5 hata mesajı
> ```bash
> $ grep ERROR app.log | cut -d ':' -f 4- | sort | uniq -c | sort -nr | head -5
>    142 Database connection timeout
>     87 Invalid token
>     31 Rate limit exceeded
>     12 File not found
>      7 Out of memory
> ```

> [!EXAMPLE]+ Mini Senaryo 3 — Sistem disk kullanımını e-posta için raporla
> ```bash
> $ df -h > /tmp/disk_report.txt
> $ echo "---" >> /tmp/disk_report.txt
> $ du -sh /home/* | sort -h >> /tmp/disk_report.txt
> ```

| Sembol | Ne yapar | Örnek |
|---|---|---|
| `>` | Çıktıyı dosyaya yaz (üstüne) | `ls > out.txt` |
| `>>` | Sonuna ekle | `date >> log.txt` |
| `<` | Dosyadan girdi | `wc -l < file` |
| `2>` | Hataları yönlendir | `cmd 2> err.txt` |
| `&>` | Hepsini yönlendir | `cmd &> all.txt` |
| `\|` | Pipe — sonraki programa ver | `ls \| grep .txt` |
| `/dev/null` | Çöp | `cmd > /dev/null` |

> [!INFO] Önemli kavram
> **Akışlar (streams).** Her program 3 akışla doğar: STDIN, STDOUT, STDERR. Bunları bilirsen, Linux'un %80'i avucunda.

---

## ⚙️ BÖLÜM 12: SÜREÇ YÖNETİMİ

### Linux çok-görevli (multitasking)

Aynı anda yüzlerce süreç koşar. Her birinin bir **PID** (Process ID) vardır.

### `top` ve `htop` — Canlı süreç listesi

```bash
$ top
```

Açıldığında:
- En üstte sistem özeti (CPU, RAM, swap, görev sayısı).
- Altında süreçler, CPU/RAM kullanımına göre sıralı.

| Tuş (top içinde) | İşlev |
|---|---|
| `q` | Çık |
| `k` | Süreç öldür (PID iste) |
| `M` | RAM'e göre sırala |
| `P` | CPU'ya göre sırala |
| `h` | Yardım |

`htop` daha renkli ve okunaklı — tercih edilebilir (ayrıca yüklemen gerekebilir).

### `ps` — Anlık süreç listesi (snapshot)

```bash
$ ps                       # sadece kendi terminalindeki
$ ps aux                   # sistemdeki HER süreç
$ ps aux | grep firefox    # belirli bir programı bul
$ ps -ef                   # BSD stili tam liste
```

`ps aux` çıktısı:

```
USER  PID  %CPU  %MEM  COMMAND
ryan  6978  8.8  23.5  /usr/lib64/firefox/firefox
```

PID = 6978 → süreci kontrol etmek için kullanırız.

### `kill` — Süreci öldür

```bash
$ kill 6978          # nazikçe iste (SIGTERM = sinyal 15)
$ kill -9 6978       # zorla öldür (SIGKILL = sinyal 9) — son çare
$ kill -l            # tüm sinyal listesi
```

> [!WARNING] `kill -9` neden son çare?
> SIGKILL sürecin kendini temizlemesine fırsat vermez. Veri kaybı olabilir. Önce `kill <PID>` dene; cevap vermezse `kill -9`.

### `pkill` ve `killall` — İsimle öldür

```bash
$ pkill firefox          # adı firefox geçen tüm süreçleri öldür
$ killall chrome         # tüm chrome'ları kapat
```

### Foreground ve Background

#### Background'a gönder (`&`)

```bash
$ sleep 60 &
[1] 21634             # iş numarası (job ID), PID
$                     # terminal hemen geri geldi
```

#### `jobs` — Arka plandaki işler

```bash
$ jobs
[1]+ Running    sleep 60 &
[2]- Stopped    vi notes.txt
```

#### `fg` ve `bg`

```bash
$ fg                  # en son işi öne getir
$ fg %1               # 1 numaralı işi öne getir
$ bg %2               # 2 numaralı işi arka planda devam ettir
```

#### Ctrl+Z — Çalışanı durdur ve arkaya at

```bash
$ vi notes.txt
# (Ctrl+Z basıldı, vi durdu, arka plana geçti)
$ jobs
[1]+ Stopped vi notes.txt
$ fg              # vi'ye geri dön
```

### Diğer faydalı komutlar

```bash
$ uptime              # sistem ne kadar zamandır açık
$ free -h             # RAM kullanımı
$ df -h               # disk kullanımı
$ du -sh ~/Downloads  # bir klasörün boyutu
$ uname -a            # kernel ve sistem bilgisi
$ whoami              # kim olarak girdim
$ id                  # detaylı kullanıcı/grup bilgisi
```

### 📝 Öğrendiklerimiz — Pratik Örnekler

> [!EXAMPLE]+ Mini Senaryo 1 — Donmuş Firefox'u kapat
> ```bash
> $ ps aux | grep firefox
> ryan 6978 8.8 23.5 ... firefox
> $ kill 6978                  # nazikçe
> $ ps aux | grep firefox      # hâlâ var mı?
> ryan 6978 ...
> $ kill -9 6978               # zorla
> ```

> [!EXAMPLE]+ Mini Senaryo 2 — Uzun süren bir backup script'i arka planda çalıştır
> ```bash
> $ ./backup.sh > backup.log 2>&1 &
> [1] 21000
> $ jobs                       # bak çalışıyor mu
> $ tail -f backup.log         # ilerlemeyi izle
> ```

> [!EXAMPLE]+ Mini Senaryo 3 — Sistem yükünü gör
> ```bash
> $ uptime
>  19:42:18 up 3 days, 5:12, 2 users, load average: 0.85, 0.62, 0.55
> $ free -h
>                total       used       free
> Mem:           7.7Gi      4.2Gi      1.1Gi
> ```

| Komut | Ne yapar |
|---|---|
| `top` / `htop` | Canlı süreç görüntüleyici |
| `ps aux` | Anlık süreç listesi |
| `kill <PID>` | Süreç öldür (nazikçe) |
| `kill -9 <PID>` | Zorla öldür |
| `pkill <ad>` | İsimle öldür |
| `jobs` | Arka plan işleri |
| `fg` / `bg` | Öne / arkaya getir |
| `Ctrl+Z` | Çalışanı durdur, arkaya at |
| `cmd &` | Arka planda başlat |

> [!INFO] Önemli kavram
> **Kontrol senin.** Hangi süreç var, ne tüketiyor, gerekirse öldürebilirsin. Bu komutlar olmadan sunucu yönetimi imkânsız.

---

## 📜 BÖLÜM 13: BASH SCRIPTING

Komut satırında yaptığın her şey, bir dosyaya yazılınca **script** olur. Tekrarlayan görevleri otomatikleştirmenin yolu.

### Basit bir script

```bash
#!/bin/bash
# Açıklama: Mevcut klasördeki dosyaları listeleyen örnek script
# Yazar: Tolga, 19/5/2026

echo "Mevcut klasördeki dosyalar:"
ls
```

Kaydet → `myscript.sh`. Çalıştırılabilir yap → `chmod +x myscript.sh`. Çalıştır:

```bash
$ ./myscript.sh
Mevcut klasördeki dosyalar:
barry.txt bob example.png firstfile foo1 video.mpeg
```

### Shebang (`#!`)

İlk satır **kritik**: hangi yorumlayıcının (interpreter) çalıştıracağını söyler.

```bash
#!/bin/bash         # bash ile çalıştır
#!/bin/sh           # POSIX sh
#!/usr/bin/env python3   # python3
#!/usr/bin/env node      # Node.js
```

`#!` ile başlamalı, **boşluk olmamalı**, ilk satırda olmalı.

> [!TIP] Yorumlayıcının yolunu bulmak
> ```bash
> $ which bash
> /bin/bash
> $ which python3
> /usr/bin/python3
> ```

### `./` neden gerekli?

Linux script'i çalıştırmak için PATH değişkenindeki klasörlere bakar. Bulunduğun klasör (`.`) PATH'te değilse Linux script'ini bulamaz.

`./myscript.sh` → "bulunduğum klasördeki myscript.sh'yi çalıştır" demek.

```bash
$ echo $PATH
/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
```

### Yorumlar (#)

```bash
#!/bin/bash
# Tüm satır yorum
echo "Merhaba" # satır sonu yorum
```

### Değişkenler

```bash
name="Tolga"          # = işaretinin yanında BOŞLUK OLMAZ
echo $name            # değer için $ ile başvur
echo "Merhaba $name"  # string içinde
echo 'Merhaba $name'  # tek tırnak → $ genişletilmez, harfiyen "Merhaba $name"
```

> [!WARNING] Bash formatı çok titiz
> `name = "Tolga"` (boşluklarla) **çalışmaz**. `name="Tolga"` yaz. Boşluklar = ayraç!

### Komut satırı argümanları

| Değişken | Anlamı |
|---|---|
| `$0` | Script'in kendi adı |
| `$1`, `$2`, ..., `$9` | 1., 2., ... argüman |
| `$#` | Toplam argüman sayısı |
| `$*` | Tüm argümanlar tek string olarak |
| `$@` | Tüm argümanlar ayrı ayrı |
| `$?` | Son komutun çıkış kodu (0 = başarı) |
| `$$` | Mevcut shell'in PID'i |

```bash
#!/bin/bash
echo "Script adı: $0"
echo "1. argüman: $1"
echo "Toplam: $# argüman"
echo "Hepsi: $*"
```

```bash
$ ./args.sh bob alice carol
Script adı: ./args.sh
1. argüman: bob
Toplam: 3 argüman
Hepsi: bob alice carol
```

### Back ticks ve `$(...)` — Komut çıktısını değişkene al

```bash
date_today=`date +%F`         # eski stil
date_today=$(date +%F)        # modern stil (tercih et)

echo "Bugün $date_today"
```

```bash
lines=$(wc -l < file.txt)
echo "Dosyada $lines satır var."
```

### `read` — Kullanıcıdan girdi al

```bash
#!/bin/bash
echo "Adın ne?"
read name
echo "Merhaba $name!"
```

### `if` koşulları

```bash
#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Kullanım: $0 <klasör_adı>"
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "Klasör bulunamadı: $1"
    exit 1
fi

echo "Klasör var: $1"
```

#### Sık kullanılan test ifadeleri

| Test | Ne | Örnek |
|---|---|---|
| `-d <yol>` | klasör mü | `[ -d ~/backups ]` |
| `-f <yol>` | dosya mı | `[ -f config.ini ]` |
| `-e <yol>` | var mı (her tür) | `[ -e $1 ]` |
| `-z <str>` | boş string mi | `[ -z "$name" ]` |
| `-n <str>` | boş değil mi | `[ -n "$name" ]` |
| `<str1> = <str2>` | string eşit | `[ "$a" = "yes" ]` |
| `<n1> -eq <n2>` | sayı eşit | `[ $# -eq 0 ]` |
| `-ne` `-lt` `-le` `-gt` `-ge` | sayı != < ≤ > ≥ | `[ $age -ge 18 ]` |
| `!` | NOT | `[ ! -d ~ ]` |

> [!WARNING] Köşeli parantezlerde boşluklar
> `[ ! -d $1 ]` → `[`, `!`, `-d`, `$1`, `]` arasındaki tüm boşluklar **şart**. `[!-d$1]` yazarsan çalışmaz.

### `for` döngüsü

```bash
#!/bin/bash
for file in *.txt; do
    echo "İşleniyor: $file"
    wc -l "$file"
done
```

```bash
for i in {1..5}; do
    echo "Sayım $i"
done
```

### `while` döngüsü

```bash
#!/bin/bash
count=1
while [ $count -le 5 ]; do
    echo "Sayım $count"
    count=$((count + 1))
done
```

### Tam örnek — Proje yedekleme script'i

```bash
#!/bin/bash
# Bir proje klasörünü tarihli yedek klasörüne kopyalar
# Kullanım: ./backup.sh <proje_adı>

if [ $# -ne 1 ]; then
    echo "Kullanım: $0 <proje_adı>"
    exit 1
fi

if [ ! -d ~/projeler/$1 ]; then
    echo "Hata: ~/projeler/$1 bulunamadı"
    exit 1
fi

date_today=$(date +%F)
backup_dir=~/yedekler/${1}_${date_today}

if [ -d "$backup_dir" ]; then
    echo "Bu proje bugün zaten yedeklenmiş."
    echo "Üstüne yazılsın mı? (e/h)"
    read answer
    if [ "$answer" != "e" ]; then
        exit 0
    fi
else
    mkdir -p "$backup_dir"
fi

cp -r ~/projeler/$1/* "$backup_dir/"
echo "✓ Yedek tamamlandı: $backup_dir"
```

Kullanım:

```bash
$ chmod +x backup.sh
$ ./backup.sh website
✓ Yedek tamamlandı: /home/tolga/yedekler/website_2026-05-19
```

### 📝 Öğrendiklerimiz — Pratik Örnekler

> [!EXAMPLE]+ Mini Senaryo 1 — Bir klasördeki .log dosyalarını sıkıştır
> ```bash
> #!/bin/bash
> for f in /var/log/*.log; do
>     gzip "$f"
>     echo "Sıkıştırıldı: $f"
> done
> ```

> [!EXAMPLE]+ Mini Senaryo 2 — Disk dolu mu kontrol et, uyar
> ```bash
> #!/bin/bash
> usage=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
> if [ $usage -gt 80 ]; then
>     echo "⚠️ Disk %$usage dolu!"
> else
>     echo "✓ Disk durumu iyi (%$usage)"
> fi
> ```

> [!EXAMPLE]+ Mini Senaryo 3 — Tüm .md dosyalarını tek bir PDF için hazırla
> ```bash
> #!/bin/bash
> output="combined.md"
> > "$output"           # dosyayı sıfırla
> for f in $(ls *.md | sort); do
>     echo "## $(basename $f .md)" >> "$output"
>     cat "$f" >> "$output"
>     echo "" >> "$output"
> done
> echo "Birleştirildi: $output"
> ```

| Yapı | Söz dizimi |
|---|---|
| Shebang | `#!/bin/bash` |
| Yorum | `# açıklama` |
| Değişken | `name="value"` → `$name` |
| Argümanlar | `$0` `$1` `$#` `$@` |
| Komut çıktısı | `var=$(komut)` |
| Girdi al | `read var` |
| Koşul | `if [ ... ]; then ... fi` |
| Döngü | `for x in ...; do ... done` |

> [!INFO] Önemli kavramlar
> - **Komut satırında ne yaparsan script'te aynı çalışır.** Önce terminalde dene, sonra script'e koy.
> - **Format hassas:** boşluklar, tırnaklar, noktalı virgüller önemli. Hata alırsan format kontrolüyle başla.

---

## 🎯 SONUÇ — TERMİNAL CHEAT SHEET

> [!SUCCESS]+ Bu noktaya geldin — artık ne biliyorsun?
> Sıfırdan başlayıp şunları öğrendin:
> 1. Terminalde gezinme (`pwd`, `ls`, `cd`)
> 2. Dosya yönetimi (`mkdir`, `cp`, `mv`, `rm`)
> 3. Metin editörü (`vi`)
> 4. Joker karakterler (`*`, `?`, `[]`)
> 5. İzinler (`chmod`)
> 6. Metin filtreleri (`head`, `tail`, `sort`, `cut`, `sed`, `uniq`)
> 7. Arama ve regex (`grep`, `egrep`)
> 8. Pipe ve yönlendirme (`|`, `>`, `<`)
> 9. Süreç yönetimi (`top`, `ps`, `kill`)
> 10. Bash scripting (değişkenler, koşullar, döngüler)

### En sık kullanılan 20 komut

| #   | Komut                 | Tek satır açıklama      |
| --- | --------------------- | ----------------------- |
| 1   | `ls -lh`              | Klasörü oku             |
| 2   | `cd <yol>`            | Klasör değiştir         |
| 3   | `pwd`                 | Neredeyim               |
| 4   | `mkdir -p a/b/c`      | İç içe klasör yarat     |
| 5   | `cp -r src/ dst/`     | Klasör kopyala          |
| 6   | `mv eski yeni`        | Taşı / yeniden adlandır |
| 7   | `rm -i dosya`         | Sorarak sil             |
| 8   | `cat dosya`           | Dosyayı yazdır          |
| 9   | `less dosya`          | Büyük dosyayı oku       |
| 10  | `grep -r "tex" .`     | Klasörde ara            |
| 11  | `find . -name "*.py"` | Dosya bul               |
| 12  | `chmod 755 script`    | Çalıştırılabilir yap    |
| 13  | `sudo komut`          | Root yetkisiyle         |
| 14  | `ps aux \| grep proc` | Süreci bul              |
| 15  | `kill -9 PID`         | Zorla öldür             |
| 16  | `top` / `htop`        | Canlı süreçler          |
| 17  | `df -h`               | Disk kullanımı          |
| 18  | `du -sh klasör`       | Klasör boyutu           |
| 19  | `tail -f log`         | Logu canlı izle         |
| 20  | `history`             | Komut geçmişi           |

### Şimdi sırada ne var?

- [[🚀 Gömülü Sistemler 101]] — Faz 1'in son adımı bu nottu. Devamı için yol haritasına bak.
- [[Bash Scripting Derinlemesine]] — fonksiyonlar, dizi, error handling, `set -e`, `trap`.
- [[Regex Pratiği]] — düzenli ifadeleri derinlemesine.
- [[SSH ve Uzak Sunucu Yönetimi]] — public key auth, port forwarding, tmux.
- [[Sistemd ve Servis Yazma]] — bir Bash script'ini sistem servisi yap.
- [[tmux ve Terminal Multiplexing]] — tek terminalde birden fazla pencere.
- [[Linux Dosya Sistemi Hiyerarşisi]] — `/etc`, `/var`, `/usr`, `/proc` ne demek.

---

## 📚 Pratik Egzersizler

Notu okudun, şimdi kasları çalıştır:

1. **Inbox temizlemesi:** `~/Downloads` klasöründeki tüm `.pdf` dosyalarını `~/Documents/PDFs/` klasörüne taşı, `.jpg/.png`'leri `~/Pictures/`'a, gerisini olduğu yerde bırak.
2. **Log analizi:** `/var/log/syslog` içinde "error" geçen tüm satırları say, en sık görülen 5'ini bul.
3. **Yedekleme:** Bir script yaz — argüman olarak verilen klasörü `~/yedekler/<isim>_<tarih>.tar.gz` olarak sıkıştırsın.
4. **Disk doluyor:** Ev klasörünün hangi alt klasörü en çok yer kaplıyor? Tek satır komutla bul.
5. **vi alıştırması:** `vi` ile bir markdown dosyası oluştur, başlık + 3 paragraf yaz, kaydet, çık, tekrar aç ve içindeki bir kelimeyi `:%s` ile değiştir.
6. **İzinler:** Bir script yaz, sadece sahibi çalıştırabilsin, grup ve diğerleri görmesin bile.
7. **Pipe zinciri:** `/etc` içindeki dosyaların uzantılarına göre kaç adet var, en çok olan 5 uzantıyı sırala.

---

%% Oluşturuldu: 2026-05-19 · Kaynak: LINUX INTRODUCTION PDF · Türkçeleştirildi ve örneklerle zenginleştirildi %%
