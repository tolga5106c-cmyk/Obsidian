# Embedded Öğrenme Planı

## Kaynaklar

### C Temeli

**Beej's Guide to C Programming** — ücretsiz, online
- beej.us/guide/bgc/
- Başlangıç için K&R'dan daha erişilebilir

**Pointers on C — Kenneth Reek** — kitap
- Sadece pointer bölümü için aç, baştan sona okumak zorunda değilsin
- Modül 5'e gelince işine yarar

**pythontutor.com** — görselleştirme
- C modunda pointer ve belleği adım adım gösterir
- Kafanın karıştığı her anda aç

---

### Embedded C + STM32

**FastBit Embedded Brain Academy — Kiran Nayak (Udemy)**
- r/embedded'da en çok önerilen kurs
- İki kurs var:
  - "Microcontroller Embedded C Programming: Absolute Beginners"
  - "Embedded Systems Programming on ARM Cortex-M3/M4"
- Fiyat: liste $80-180, neredeyse her zaman indirimde → gerçek fiyat $10-15
- Sertifika kursa dahil

**CS50x — Harvard (edX)**
- Kursu izlemek ücretsiz
- Sertifika ~$149 ama almana gerek yok
- C temelini çok iyi oturtuyor, teorin varsa hızlı geçersin

---

### Embedded C++ (C bittikten sonra)

**"A Tour of C++" — Bjarne Stroustrup** — kitap
- ~250 sayfa, tüm dili özet geçer
- Bunu bitirince embedded subset'e odaklan

**CppCon YouTube konuşmaları** — ücretsiz
- "Embedded C++" etiketli konuşmalar
- Özellikle: "What Has My Compiler Done for Me Lately?" — Matt Godbolt

---

### STM32 Derinleşme

**"Mastering STM32" — Carmine Noviello** — kitap/PDF
- HAL'dan register seviyesine

**YouTube:**
- ControllersTech — HAL seviyesi, hızlı pratik
- Phil's Lab — daha derin, sinyal işleme + donanım

---

## Sertifikalar Hakkında

Udemy ve CS50x sertifikaları endüstride ağırlık taşımıyor.
Embedded alanda işe alımda değerli olan:
- GitHub'da çalışan projeler
- STM32/ESP32 ile bitirilen projeler
- Açık kaynak katkı

Kursu al, öğren — sertifikaya para verme.

---

## Çalışma Sırası

1. Kiran Nayak'ın Embedded C kursunu al
2. C notundaki modülleri kursla paralel ilerlet
3. Her modül bitince Claude ile tartış, seviye testi yap
4. C bitti → Embedded C++ subset
5. STM32'de register seviyesine in

---

## Embedded C++ Subset (Hedef)

Tüm C++ değil, sadece bunlar:
- RAII
- constexpr
- enum class
- Template (basit, ölçülü)
- exceptions yok, RTTI yok, STL çok az
