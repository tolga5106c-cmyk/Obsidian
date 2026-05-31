---
title: C Dili — Sıfırdan Derinlemesine
aliases:
  - C for Embedded
  - C Temeli
tags:
  - c
  - embedded
  - gomulu-sistemler
  - faz1
created: 2026-05-16
updated: 2026-05-31
status: active
type: note
area: gomulu-sistemler
---

# 🧠 C Dili — Sıfırdan Derinlemesine

> [!ABSTRACT]+ TL;DR
> Gömülü için C, "bellek-merkezli C"dir. Bu not, pointer/bellek/bit ustalığını **proje kurarak** kazandıran 12 modülük bir eylem planıdır. Her modül bir mini projeyle biter. Son modül, doğrudan [[🚀 Gömülü Sistemler 101]] notundaki UART CLI desenine (ring buffer + komut parser) köprü kurar.

> [!INFO] Felsefe — neden böyle çalışıyoruz?
> - **Önce PC, sonra donanım:** C'yi PC'de (WSL / Linux / online derleyici) öğreniyoruz. Derle-çalıştır-gör döngüsü saniyeler sürer; F407'de aynı şey dakikalar alır. Pointer öğrenirken bu hız altın değerinde. Temeli attıktan sonra aynı bilgiyi F407'ye taşıyacağız.
> - **Proje-odaklı:** Her kavram bir mini projede kanıtlanır. "Anladım" yetmez, "çalıştırdım" gerekir.
> - **Gömülü gözüyle:** Her modülde *"bu F407'de ne işime yarayacak?"* notu var. Hiçbir konu havada kalmıyor.

> [!TIP] Ortam kurulumu (Modül 0'dan önce)
> - **Windows'ta:** WSL2 + Ubuntu kur → `sudo apt install build-essential gdb`
> - **Derleme komutu (her projede):** `gcc -Wall -Wextra -g dosya.c -o program && ./program`
> - `-Wall -Wextra` uyarıları açar — gömülüde bir uyarıyı görmezden gelmek bir bug'dır. Bunları her zaman aç.

---

## 🗺️ İlerleme Tablosu

| #   | Modül                                       | Mini Proje                 | Durum |
| --- | ------------------------------------------- | -------------------------- | ----- |
| 0   | Toolchain & ilk program                     | Build döngüsü kur          | ⬜     |
| 1   | Tipler, `sizeof`, sabit-genişlik tamsayılar | Byte/tip kâşifi            | ⬜     |
| 2   | Kontrol akışı & fonksiyonlar                | Mini hesap makinesi        | ⬜     |
| 3   | **Bitwise işlemler**                        | Register simülatörü        | ⬜     |
| 4   | Diziler & string'ler                        | Log parser                 | ⬜     |
| 5   | **Pointer'lar**                             | Sıfırdan `strlen`/`strcpy` | ⬜     |
| 6   | Struct, union, enum & padding               | Sensör paketi modeli       | ⬜     |
| 7   | Dinamik bellek (`malloc`/`free`)            | Dinamik dizi               | ⬜     |
| 8   | Linked list & veri yapıları                 | Tek yönlü liste            | ⬜     |
| 9   | `static` / `extern` / `const` / `volatile`  | State machine              | ⬜     |
| 10  | Preprocessor, makrolar, çok dosyalı proje   | Modüler proje + Makefile   | ⬜     |
| 11  | 🏁 **Bitirme:** Ring buffer + komut parser  | Mini gömülü CLI            | ⬜     |

> İlerledikçe `⬜` → `✅` yap. Bu tablo senin gerçek ilerleme barın.

---

## 🟦 MODÜL 0 — Toolchain ve İlk Program

**Konu:** Derleyici nedir, `gcc` nasıl çalışır, kaynak kod → `.o` → çalıştırılabilir dosya yolculuğu. (101 notundaki "Geliştirme Akışı"nın PC versiyonu.)

**Mini proje:** Bir `hello.c` yaz, derle, çalıştır. Sonra `gcc -S hello.c` ile ürettiği assembly'ye göz at — "kodum makine diline böyle dönüyormuş" de.

**Gömülüde ne işime yarar?** F407'de aynı zincir var, sadece `gcc` yerine `arm-none-eabi-gcc`. Şimdi öğrendiğin "derle-link et-çalıştır" mantığı orada birebir aynı.

**Bitti kriteri:** Terminalden tek komutla derleyip çalıştırabiliyorum.

---

## 🟦 MODÜL 1 — Tipler, `sizeof` ve Sabit-Genişlik Tamsayılar

**Konu:** `int/char/short/long`, işaretli vs işaretsiz, `sizeof`, taşma (overflow). **`<stdint.h>`** → `uint8_t`, `uint16_t`, `uint32_t`. Gömülüde `int` değil, **boyutu net belli olan** tipler kullanılır.

**Mini proje — Byte/Tip Kâşifi:** Bir program yaz, tüm tiplerin `sizeof`'unu yazdırsın. `uint8_t`'yi 255'ten 1 artırınca ne olduğunu gör (overflow → 0). `printf("%u %d %x")` format belirteçlerini dene.

**Gömülüde ne işime yarar?** Register'lar tam olarak `uint32_t`. Bir sensörden gelen veri `uint16_t`. Yanlış tip seçimi = taşan sayaç, bozuk veri. Bu modül senin sayı evrenin.

**Bitti kriteri:** Hangi durumda hangi `uintN_t`'yi seçeceğimi ve overflow'un neden olduğunu açıklayabiliyorum.

---

## 🟦 MODÜL 2 — Kontrol Akışı ve Fonksiyonlar

**Konu:** `if/else`, `switch`, `for/while`, fonksiyon tanımı, parametre geçişi (değer ile kopya), `return`. Modüler düşünme.

**Mini proje — Mini Hesap Makinesi:** Kullanıcıdan iki sayı + işlem (`+ - * /`) al, sonucu yazdır. Sıfıra bölmeyi yakala. Her işlemi ayrı bir fonksiyon yap (`int topla(int, int)`...).

**Gömülüde ne işime yarar?** F407'de `main()` içinde `while(1)` ana döngün olacak (101 notu, Bölüm 0). `switch-case` ile komut/durum yönetimi gömülünün ekmeği.

**Bitti kriteri:** Programı temiz fonksiyonlara bölebiliyorum, `switch` ile durum seçebiliyorum.

---

## 🟦 MODÜL 3 — Bitwise İşlemler ⭐ (Gömülünün Kalbi)

**Konu:** `&` `|` `^` `~` `<<` `>>`. Bit **set/clear/toggle/read** kalıpları. (101 notunda yazdığın `REG |= (1<<3)` tam buradan.)

**Mini proje — Register Simülatörü:** `uint32_t reg = 0;` diye sahte bir register tut. Şu fonksiyonları yaz:
- `set_bit(reg, n)` → `reg |= (1u << n)`
- `clear_bit(reg, n)` → `reg &= ~(1u << n)`
- `toggle_bit(reg, n)` → `reg ^= (1u << n)`
- `read_bit(reg, n)` → `(reg >> n) & 1u`
Her adımda register'ı binary olarak yazdır (kendi `print_binary()` fonksiyonunu yaz). 5. bити set et, 5. ve 3.'ü oku, 5.'i temizle — değişimi gözünle gör.

**Gömülüde ne işime yarar?** Bu **birebir** F407'de LED yakmaktır. `GPIOD->ODR |= (1<<12);` dediğinde yeşil LED yanar. Bu modülü hakkıyla yaparsan, donanıma geçişin yarısını şimdiden halletmiş olursun.

**Bitti kriteri:** Bir register'ın istediğim bitini, diğerlerini bozmadan set/clear/toggle edebiliyorum — kâğıtta bile.

---

## 🟦 MODÜL 4 — Diziler ve String'ler

**Konu:** Diziler, dizi-pointer ilişkisi (ön bakış), C string'leri (null-terminated `char[]`), `<string.h>` fonksiyonları.

**Mini proje — Log Parser:** Bir metin dizisi (birkaç satır "log") içinde "ERROR" kelimesini ara, kaç tane olduğunu say ve o satırları yazdır. (101 notundaki `grep` mantığının C versiyonu.)

**Gömülüde ne işime yarar?** UART'tan gelen veri bir `char` dizisidir. Gelen komutu/mesajı parse etmek tam olarak bu beceridir.

**Bitti kriteri:** Bir karakter dizisini gezip içinde arama/sayma yapabiliyorum.

---

## 🟦 MODÜL 5 — Pointer'lar ⭐ (En Kritik Modül)

**Konu:** Adres (`&`) ve dereference (`*`), pointer aritmetiği, `NULL`, pointer-dizi ilişkisi, fonksiyona pointer geçirmek (referansla değiştirme).

**Mini proje — Sıfırdan String Kütüphanesi:** Hiçbir `<string.h>` kullanmadan kendi `my_strlen()`, `my_strcpy()`, `my_strcmp()` fonksiyonlarını yaz — sadece pointer aritmetiğiyle. Sonra bir `swap(int *a, int *b)` yaz ve iki değişkeni gerçekten yer değiştir.

**Gömülüde ne işime yarar?** Bir register'a erişmek demek, bir **adrese pointer ile yazmak** demek: `*(volatile uint32_t*)0x40020C14 = ...`. Pointer'ı sindirmeden gömülü yapılmaz. Bu modülde acele etme, gerekirse iki kat zaman ayır.

**Bitti kriteri:** "Pointer bir adres tutar" cümlesini bir örnekle, çizerek anlatabiliyorum; fonksiyonla bir değişkeni dışarıdan değiştirebiliyorum.

---

## 🟦 MODÜL 6 — Struct, Union, Enum ve Padding

**Konu:** `struct` ile veri gruplama, `union` (aynı belleği paylaşan alanlar), `enum`, **struct padding** (101 notunda Bölüm 1'de yazdığın hizalama tuzağı).

**Mini proje — Sensör Paketi Modeli:** Bir `struct SensorPacket { uint8_t id; uint32_t timestamp; uint16_t value; }` tanımla. `sizeof`'unu yazdır — üyelerin toplamından büyük çıkacak (padding!). Sonra `__attribute__((packed))` ekle, farkı gör. Üyeleri büyükten küçüğe sırala, tekrar ölç.

**Gömülüde ne işime yarar?** Haberleşme paketleri (UART/SPI/CAN) struct ile modellenir. Padding'i bilmezsen "bir taraf 12 byte yazar, diğeri 16 byte okur" (101 notundaki uyarı). `union` ise register bit-field'larında ve byte/word dönüşümlerinde her yerde.

**Bitti kriteri:** Bir struct'ın boyutunu önceden tahmin edebiliyorum, padding'i neyin oluşturduğunu biliyorum.

---

## 🟦 MODÜL 7 — Dinamik Bellek

**Konu:** `malloc`/`calloc`/`realloc`/`free`, heap kavramı, bellek sızıntısı (memory leak), dangling pointer.

**Mini proje — Büyüyen Dinamik Dizi:** Çalışma anında boyutu artan bir tamsayı dizisi yaz (`realloc` ile). Her `malloc`'a karşılık bir `free` koy. `valgrind ./program` ile çalıştır, "no leaks" çıktısını gör.

**Gömülüde ne işime yarar?** 101 notunda yazdığın gibi: gömülüde heap'ten **kaçınılır** (fragmentation + öngörülemezlik). Ama *neden* kaçınıldığını anlamak için önce nasıl çalıştığını görmen lazım. Bu modül "neden statik tahsis tercih edilir" sorusunun cevabıdır.

**Bitti kriteri:** Aldığım her belleği geri verebiliyorum; leak'in ne olduğunu valgrind'de görüp düzeltebiliyorum.

---

## 🟦 MODÜL 8 — Linked List ve Veri Yapıları

**Konu:** `struct` + pointer ile tek yönlü bağlı liste. Düğüm ekleme/silme/gezme. (Modül 5 + 6 + 7'nin birleşimi — gerçek bir sınav.)

**Mini proje — Tek Yönlü Liste:** `insert_front`, `delete`, `print_all`, `find` fonksiyonları olan bir linked list yaz. Sonunda tüm düğümleri `free` et.

**Gömülüde ne işime yarar?** İş kuyrukları, olay listeleri, sürücü tabloları hep bu yapıyla kurulur. Ayrıca klasik bir mülakat sorusudur (101 notu, Faz 10).

**Bitti kriteri:** Pointer'larla bir veri yapısını sıfırdan kurup yönetebiliyorum.

---

## 🟦 MODÜL 9 — Storage Class & Qualifier'lar ⭐

**Konu:** `static` (kalıcı + dosya-özel), `extern` (paylaşımlı global), `const` (Flash'a yerleşir), **`volatile`** (optimizasyon kırıcı). 101 notunda Bölüm 1'de teorisini yazdın — şimdi uygulayacağız.

**Mini proje — Sayaçlı State Machine:** Fonksiyon içinde `static int count` ile çağrı sayısını tutan bir fonksiyon yaz (her çağrıda sıfırlanmadığını gör). Sonra basit bir trafik ışığı state machine'i kur (`enum State`, `switch`). `volatile` bir bayrak simüle et: "donanım bunu değiştirebilir" senaryosunu yorum satırıyla anlat.

**Gömülüde ne işime yarar?** Bu dördü gömülüde her gün karşına çıkar: ISR ile paylaşılan bayrak → `volatile`; lookup tablosu → `const`; modül-içi durum → `static`. (101 notu, Bölüm 2: "Paylaşılan değişkenler `volatile` olmalı".)

**Bitti kriteri:** Dört qualifier'ın her birini ne zaman kullanacağımı bir örnekle söyleyebiliyorum.

---

## 🟦 MODÜL 10 — Preprocessor, Makrolar ve Çok Dosyalı Proje

**Konu:** `#include`, `#define`, fonksiyon-benzeri makrolar, `#ifdef` koşullu derleme, header guard (`#ifndef`), `.h`/`.c` ayrımı, basit **Makefile**.

**Mini proje — Modüler Proje:** Önceki bir projeni (örn. hesap makinesi) `main.c` + `math_ops.h` + `math_ops.c` olarak böl. Bir `Makefile` yaz. `#define DEBUG` ile koşullu log ekle.

**Gömülüde ne işime yarar?** Her STM32 projesi çok dosyalı + Makefile/CMake tabanlı (101 notu, Faz 1: [[Make ve CMake]]). Register tanımları dev `#define` makro setleridir. Bu modül seni "tek dosya" amatörlüğünden çıkarır.

**Bitti kriteri:** Projeyi mantıklı dosyalara bölüp Makefile ile derleyebiliyorum.

---

## 🏁 MODÜL 11 — BİTİRME PROJESİ: Ring Buffer + Komut Parser

**Konu:** Önceki her şeyin birleşimi. Bir **circular (ring) buffer** + basit bir **komut yorumlayıcı (CLI)**.

**Mini proje:** Bir programa terminalden komut yaz: `set led 1`, `read temp`, `help`, `reboot`. Program bunları bir ring buffer'a koysun, parse etsin, uygun yanıtı versin. (Şimdilik "led" sahte bir değişken.)

**Gömülüde ne işime yarar?** Bu **birebir** 101 notundaki [[UART Sürücü ve Komut Satırı]] desenidir — sadece UART yerine klavye. F407'ye geçtiğinde `scanf` yerine UART RX interrupt koyacaksın, gerisi aynı kod. Yani bu projeyi bitirdiğinde, gömülü dünyasının en yaygın desenini PC'de zaten yazmış olacaksın.

**Bitti kriteri:** Komut alıp, buffer'da tutup, parse edip yanıt veren çalışan bir CLI'm var. → **Artık C temelin atıldı, C++'a ve F407'ye geçmeye hazırsın.**

---

## 📚 Kaynaklar

- **Kitap (ana):** *The C Programming Language* — Kernighan & Ritchie (K&R). İnce ama yoğun; her bölüm sonunda bu nottaki ilgili projeyi yap.
- **Online ücretsiz:** *Modern C* — Jens Gustedt (PDF), *Beej's Guide to C Programming*.
- **Pratik:** Exercism.io "C track" veya LeetCode'da C ile 20–30 kolay problem.
- **Görselleştirme:** [pythontutor.com](https://pythontutor.com) C modu — pointer ve belleği adım adım canlı gösterir. Modül 5'te altın değerinde.

---

## ➡️ Sonraki Adım

Bu not bitince: [[C++ — Gömülü için Modern C++]] (RAII, `enum class`, `constexpr`, no-exception subset) → sonra [[STM32 — HAL'dan Register Seviyesine]] ile F407'ye ilk dokunuş.

Ana harita: [[🚀 Gömülü Sistemler 101]]

%% Oluşturuldu: 2026-05-16 · Eylem planına dönüştürüldü: 2026-05-31 %%
