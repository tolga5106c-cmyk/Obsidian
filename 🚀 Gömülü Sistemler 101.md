---
title: Gömülü Sistemler 101
aliases:
  - Embedded Systems 101
  - Gömülü 101
tags:
  - embedded
  - c-cpp
  - mcu
  - rtos
  - iot
  - gomulu-sistemler
created: 2026-05-16
status: active
type: note
area: gomulu-sistemler
---

# 🚀 Gömülü Sistemler 101 

> [!ABSTRACT]+ TL;DR
> Bare-metal C/C++'tan RTOS'a, UART'tan MQTT'ye gömülü sistemlerin tüm temel taşları. Mülakat sorularını, sahada karşılaşılan tuzakları (bug, race condition, watchdog reset) ve ne zaman hangi protokolün/işletim sisteminin seçileceğini kapsar.

> [!INFO] Nasıl çalışılır?
> - Bölümler bağımsız okunabilir ama **sırayla** ilerlemek mantığı oturtur.
> - Kalın yazılan **İngilizce terimleri** ezberle — iş ilanları ve datasheet'ler bu dilden konuşur.
> - Her bölümün sonunda **"Pratikte"** notu, teoriyi gerçek bir sahneye oturtur.

---

## 🧭 BÖLÜM 0: TEMEL KAVRAMLAR VE EKOSİSTEM

Gömülü sistem = belirli bir görev için tasarlanmış, sınırlı kaynaklı (RAM, CPU, güç) bilgisayar. Akıllı saatten uydu kontrol kartına kadar her yerde.

- **Mikrocontroller (MCU) vs Mikroprocessor (MPU):**
    - **MCU** (örn: STM32, ESP32, ATmega): CPU + RAM + Flash + çevre birimleri **tek çipte**. Bare-metal veya RTOS koşar. Watch, beyaz eşya, otomotiv ECU.
    - **MPU** (örn: Raspberry Pi'deki BCM2711, i.MX): Dış RAM ve depolama gerektirir, **Linux** koşturur. Daha güçlü ama daha güç tüketir.

- **Çalışma Modeli — Hangi Düzeyde Yazıyorsun?**
    1. **Bare-metal:** Doğrudan register'lara yaz, `main()` içinde `while(1)` ana döngü. Hiçbir işletim sistemi yok. Maksimum kontrol, minimum kolaylık.
    2. **RTOS** (FreeRTOS, Zephyr, ThreadX): Görev (task) zamanlayıcısı var, deterministik zamanlama garantisi sağlar.
    3. **Gömülü Linux** (Yocto, Buildroot): Tam işletim sistemi, dosya sistemi, ağ stack'i hazır. Determinizm yok ama özellik bol.

- **Geliştirme Akışı:**
    - Kod → **Cross-compiler** (örn: `arm-none-eabi-gcc`) → `.elf`/`.hex`/`.bin` → **Programmer/Debugger** (ST-Link, J-Link) → Flash'a yazılır → Çip çalışır.
    - PC'den **farklı mimariye** derliyoruz: x86 makinada yazıp ARM/RISC-V/AVR çipe yüklüyoruz. Buna **cross-compilation** denir.

> [!EXAMPLE] Pratikte
> Bir akıllı termostat: Sensör okuma + ekran + Wi-Fi → MCU (ESP32) yeterli. Bir araba kamerası AI işleme: MPU (i.MX 8) + Linux gerekir.

---

## 🧠 BÖLÜM 1: C / C++ VE BELLEK MİMARİSİ (BARE-METAL)

Gömülü sistemlerde RAM ve CPU döngüleri altından daha değerlidir. Belleğe tam anlamıyla hükmetmek zorundasın.

- **`volatile` Keyword'ü (Optimizasyon Kırıcı):** Derleyiciler (GCC) kodu hızlandırmak için değişkenleri işlemcinin önbelleğinde (cache/register) tutar. Ancak donanım, bir değişkenin değerini arka planda aniden değiştirebilir (örneğin bir sensör pini). `volatile`, derleyiciye "Bana akıllılık yapma, optimizasyon yapma; bu değişkeni her seferinde üşenmeden git fiziksel adresten (RAM'den) oku" emrini verir.
    - Ne zaman zorunlu: ISR içinde değişen flag'ler, donanım register pointer'ları, multi-threaded shared değişkenler.

- **`const` ve `static`:**
    - **`const`** sadece "değiştirilemez" değil; gömülüde **Flash'a** yerleştirilmesi anlamına gelir → RAM'den tasarruf. Sabit string'ler ve lookup tablolar `const` olmalı.
    - **`static`** global scope'ta dosyaya özel görünürlük, fonksiyon içinde ise değişkenin **kalıcı (Flash/BSS'te)** olmasını sağlar — her çağrıda sıfırlanmaz.

- **Bitwise (Register Seviyesi) İşlemler:**
    - **Set (1 Yapmak):** İlgili biti diğerlerini bozmadan `1` yapmak için **OR (`|`)** kullanılır. `REG |= (1 << 3);`
    - **Clear (0 Yapmak):** İlgili biti `0` yapmak için **AND ve NOT (`& ~`)** kullanılır. `REG &= ~(1 << 3);`
    - **Toggle (Terslemek):** Biti durumunun tersine çevirmek için **XOR (`^`)** kullanılır. `REG ^= (1 << 3);`
    - **Read (Okumak):** `(REG >> 3) & 1` veya `(REG & (1 << 3)) != 0`.

- **Stack vs Heap (Hayati Ayrım):**
    - **Stack:** Fonksiyon çağrıları, yerel değişkenler. Derleyici otomatik yönetir. **Sınırlıdır** (örn: 4 KB) — derin recursion veya büyük local array `Stack Overflow`a yol açar, sistem çöker.
    - **Heap:** `malloc/new` ile dinamik ayırma. **Gömülüde heap kullanımından genellikle kaçınılır:** öngörülemezlik + fragmentation + bellek sızıntısı riski. Tasarımda mümkünse statik/pool tabanlı tahsis tercih edilir.

- **Struct Padding (Bellek Hizalama Tuzağı):** 64-bit bir işlemcide, C++ struct'ları içindeki değişkenleri alt alta toplamak boyutu vermez. İşlemci verileri 4'er veya 8'er byte'lık bloklar halinde okumak istediği için, küçük boyutlu verilerin (char, short) arasına boşluklar (padding) ekler. Bu mülakatlarda hep sorulur.
    - Kontrol etmek için: `sizeof(struct)` çıktısı + üye boyutları toplamı.
    - Disiplin: değişkenleri **büyükten küçüğe** sırala (uint64_t → uint32_t → uint16_t → uint8_t).
    - Networking paketlerinde `#pragma pack(1)` veya `__attribute__((packed))` ile padding'i kapatabilirsin — ama yavaşlama getirir.

- **Dinamik Bellek Yönetimi (Heap):**
    - C'de `malloc()` ile alınan bellek `free()` ile sisteme iade edilir.
    - C++'ta **`new`** operatörü ile dinamik olarak (Stack yerine Heap'te) bellek ayrılır. İşin bitince bellek sızıntısını (**Memory Leak**) önlemek için mutlaka **`delete`** operatörü kullanılmalıdır.
    - **Heap Fragmentation:** Sürekli `malloc/free` döngüsü, boş bellekte parçalı boşluklar bırakır. Toplam boş RAM yetse bile **büyük sürekli blok bulunamaz** → ayırma başarısız olur.

- **Referanslar (C++):** Pointer (işaretçi) yerine kullanılır. Doğru tanımı: `int &ref = x;` şeklindedir (Ampersand ile). Null olamaz, atandıktan sonra hedefi değişmez — pointer'a göre daha güvenlidir.

- **Endianness (Bayt Sırası):**
    - **Little Endian:** Düşük anlamlı bayt önce. x86, ARM (varsayılan), STM32.
    - **Big Endian:** Yüksek anlamlı bayt önce. Ağ protokolleri ("network byte order"), bazı eski MCU'lar.
    - **Önemi:** UART/SPI/network üzerinden çok-baytlık veri gönderirken iki taraf aynı endianness'a sahip değilse, sayılar tersine yorumlanır → `htons()`, `htonl()` veya manuel swap.

- **Memory Map ve Linker Script:**
    - Linker script (`.ld`), MCU'nun Flash ve RAM adres aralıkla rını derleyiciye söyler ve bölümlerin (`.text`, `.data`, `.bss`, `.heap`, `.stack`) nereye yerleşeceğini belirler.
    - `.text` → Flash (kod), `.data` → RAM (initialize edilmiş globaller), `.bss` → RAM (sıfır initialized), `.heap` ve `.stack` → RAM'in kalanı (genelde stack yukarıdan aşağıya büyür).

> [!WARNING] Bare-metal'in en çok kafa kıran bug'ları:
> - `volatile` unutmak → ISR flag'i hiç değişmiyor sanılıyor.
> - Stack overflow → tahmini imkânsız, rastgele crash.
> - Heap fragmentation → uzun süre çalıştıktan sonra "out of memory".
> - Padding farkındalığı eksikliği → bir taraf 12 byte yazıyor, diğer taraf 16 byte okuyor.

---

## ⚡ BÖLÜM 2: İŞLEMCİNİN SİNİR SİSTEMİ (KESMELER / INTERRUPTS)

İşlemciye "veri geldi mi?" diye sürekli sormak (**Polling**) sistemi kilitler. Bunun yerine donanımın "veri geldi!" diyerek işlemciyi uyarması (**Interrupt**) esastır.

- **Context Switch (Bağlam Değişimi):** Interrupt geldiğinde işlemcinin o anki işini bırakıp, değişkenlerini RAM'e (Stack) kaydetmesi ve işi bitince geri dönüp devam etmesidir.

- **ISR (Interrupt Service Routine — Kesme Servis Rutini) Altın Kuralları:**
    1. **Çok Kısa ve Hızlı Olmalı:** Sadece bayrak set edilmeli veya veri buffer'a alınmalıdır. Asıl iş `main()` loop'unda yapılır.
    2. **Blocking Kod Yasaktır:** ISR içinde `delay`, `printf`, büyük `while` döngüleri **asla** bulunamaz. Aksi takdirde **Watchdog Timer (WDT)** sistemi kilitlendi sanıp **Reset** atar.
    3. **Paylaşılan Değişkenler `volatile` Olmalı:** ISR ile main loop arasında paylaşılan değişken, mutlaka `volatile` işaretli olmalı.

- **Interrupt Priority (Öncelik):** Aynı anda iki kesme gelirse yüksek öncelikli olan kazanır. Kritik (motor stop, acil durdurma) → en yüksek öncelik. Düşük öncelikli (UART RX) → bekleyebilir.

- **Nested Interrupts (İç İçe Kesmeler):** Bir ISR çalışırken daha yüksek öncelikli bir kesmenin onu kesmesidir. ARM Cortex-M'de varsayılan olarak desteklenir; dikkatli kullanılmalı, yoksa stack şişer.

- **DMA (Direct Memory Access) — Sessiz Kahraman:**
    - CPU'yu bypass ederek belleğe/çevre birimine doğrudan veri taşıyan ayrı bir donanım motoru.
    - Örnek: ADC sürekli sample alıyor → DMA bu sample'ları RAM'deki buffer'a yazar → CPU başka iş yaparken buffer dolduğunda tek bir interrupt geliyor.
    - **Neden önemli:** "1000 sample alıp işle" senaryosunda CPU'yu binlerce ISR'den kurtarır → hem güç tasarrufu hem performans.

> [!EXAMPLE] Pratikte
> UART RX: byte gelir → ISR tetiklenir → byte'ı circular buffer'a yazar → ISR biter. Main loop, buffer'ı kontrol edip mesajı parse eder. ISR'de hiçbir `printf` yok.

---

## 🔌 BÖLÜM 3: DONANIM HABERLEŞME PROTOKOLLERİ

Sensörlerle ve diğer işlemcilerle konuşma yolları.

- **GPIO (General Purpose I/O) — En Temel Birim:**
    - **Input / Output** olarak yapılandırılır.
    - **Pull-up / Pull-down resistor:** Pin "yüzer" durumda kalmasın diye iç direnç ile besleme veya toprağa çekilir. Buton okumada Pull-up + butona basınca toprağa çekme klasik düzendir.
    - **Push-Pull vs Open-Drain:** Push-pull hem 1 hem 0 sürer. Open-drain sadece 0 sürer, 1 için dış pull-up gerekir (I2C bus bu yüzden açık-drenajdır).

- **UART (Asenkron):** Saat sinyali (Clock) yoktur. Tarafların aynı **baud rate** (hız) değerine ayarlanması **zorunludur**. Eğer hızlar uyuşmazsa (**Baud Rate Mismatch**), veriler kayar ve **Framing Error** oluşur.
    - 2 hat: TX(Verici), RX(Alıcı) (artı GND). RS-232/RS-485 ile uzun mesafeye çıkar.

- **SPI (Senkron — Yüksek Hız):** **MISO** (Master In Slave Out), **MOSI** (Master Out Slave In), **SCK** (Clock) hatlarını kullanır. Aynı hatta birden fazla slave (köle) cihaz kullanılacaksa, ortak hat çekilemez; işlemciden her cihaza **ayrı bir CS (Chip Select)** pini gitmek zorundadır. Bu pin israfıdır ama hız (kamera, ekran, SD kart) için buna katlanılır.
    - Full-duplex (eşzamanlı oku/yaz), 10 MHz+ hızlara çıkar.

- **I2C (Senkron — Çoklu Cihaz):** Sadece 2 kablo (**SDA**/data(Serial Data Line), **SCL**(Serial Clock)/clock) kullanır. Aynı hatta onlarca cihaz, onlara atanan **benzersiz donanım/yazılım adresleri** (Örn: 0x68) sayesinde birbiriyle çakışmadan konuşur.
    - Half-duplex, tipik hızlar 100 kHz / 400 kHz / 1 MHz.
    - Açık-drenaj olduğu için **harici pull-up direnci** zorunludur (genelde 4.7k Ω).

- **CAN ve CAN FD:** Otomotiv/savunma sanayiinde kullanılır. **Diferansiyel sinyal** (CAN_H ve CAN_L iki kablo arasındaki fark) ile gürültüye ultra dayanıklıdır. Klasik CAN tek pakette 8 byte atarken, **CAN FD (Flexible Data-Rate)** daha büyük payload (64 byte'a kadar veri) ve daha yüksek hız destekler.
    - Multi-master, mesaj tabanlı (adres değil ID).

- **Hangi Protokolü Seç?**

| İhtiyaç | Protokol |
|---|---|
| 1-2 cihazla seri konuşma, uzun mesafe | **UART** (+ RS-485) |
| Yüksek hız, ekran/SD kart, kısa mesafe | **SPI** |
| Düşük hız, çok sensör, az kablo | **I2C** |
| Otomotiv, gürültülü ortam | **CAN/CAN FD** |
| USB cihaz/host | **USB** |
| Sensör ağı, kablosuz | **Wi-Fi / BLE / LoRa / Zigbee** |

---

## 🧪 BÖLÜM 4: ANALOG DÜNYA VE ZAMANLAMA (ÇEVRE BİRİMLERİ)

Sıcaklık sensörü, motor sürmek, LED parlaklığı — hepsi MCU'nun çevre birimleriyle olur.

- **ADC (Analog-to-Digital Converter):** Sürekli sinyali (gerilim) sayısal değere çevirir.
    - **Çözünürlük (Resolution):** 12-bit → 0–4095 arası 4096 farklı seviye.
    - **Örnekleme hızı (Sampling rate):** Saniyede kaç ölçüm.
    - **Vref (Reference voltage):** Ölçüm aralığının üst sınırı; doğruluk için kritik.

- **DAC (Digital-to-Analog Converter):** Tam tersi — sayısal değerden analog gerilim üretir. Ses, sinyal jeneratörü.

- **Timer ve PWM (Pulse Width Modulation):**
    - **Timer:** İşlemcinin sayaçları. Periyodik ISR (örn: her 10 ms), gecikme, ölçüm, PWM üretimi için kullanılır.
    - **PWM:** Sabit frekansta, doluluk oranı (duty cycle %0–100) değişen kare dalga. LED parlaklığı, motor hızı, servo açısı, ses üretimi PWM ile yapılır.
    - **Input Capture:** Bir pinin yükselen/düşen kenarındaki timer değerini yakalar — encoder, frekans ölçümü.
    - **Output Compare:** Timer belli bir değere ulaştığında pin değiştirir — hassas zamanlama.

- **RTC (Real-Time Clock):** Pille beslenebilen, sistem kapansa bile tarih/saat tutan modül. Loglama, alarm.

- **WDT (Watchdog Timer):** Kod düzgün çalışırken belirli aralıklarla "ben hâlâ buradayım" diye sıfırlanır. Sıfırlanamazsa donanımsal reset atar — sistemin sonsuza dek kilitli kalmasını önler.

> [!TIP] Mülakat tuzağı
> "Bir LED'i 0–100% arası yavaşça parlat" denirse cevap **PWM**, "Bir potansiyometre okumasını ekranda göster" denirse **ADC**.

---

## 🧵 BÖLÜM 5: AĞ VE IoT (NESNELERİN İNTERNETİ)

Sistemin dış dünya ve bulut ile bağlantısı.

- **OSI Modelinden Aklında Kalması Gereken 3 Katman:**
    - **L2 — Veri bağlantı (Ethernet, Wi-Fi, BLE):** MAC adresi seviyesi.
    - **L3 — Ağ (IP):** Cihazlar arası yönlendirme.
    - **L4 — Taşıma (TCP/UDP):** Süreçler arası iletim.
    - **L7 — Uygulama (HTTP, MQTT, CoAP):** Veri formatı.

- **TCP vs UDP:**
    - **TCP(Transmission Control Protocol):** Paketlerin ulaştığından %100 emin olmak ister. Güvenilirdir, **bağlantı tabanlıdır** (handshake), sıralı.
    - **UDP((User Datagram Protocol)):** Hata kontrolü yapmaz (**Fire-and-forget**), bu yüzden çok **hızlıdır**. Güvenilir veri iletimi sağlamaz (Örn: Canlı yayınlar, oyun, DNS sorgusu).

	- **MQTT(Message Queue Telemetry Transport Protocol (MQTT):** IoT ve gömülü sistemlerin kalbidir. Sistemin ağır HTTP istekleriyle boğulmasını engeller. Bir **broker** (sunucu, örn: Mosquitto, AWS IoT Core) üzerinden işleyen, **Publish/Subscribe (Yayınla/Abone Ol)** mimarisine dayanan, çok hafif ve düşük güç tüketen bir protokoldür.
    - **Topic** hiyerarşisi: `home/livingroom/temperature`.
    - **QoS** seviyeleri (0/1/2): 0 = en fazla bir kez, 1 = en az bir kez, 2 = tam bir kez.

- **CoAP:** MQTT'nin alternatifi — RESTful, UDP üzerinde çalışır, pil-dostu.

- **TLS / mTLS:** IoT cihazlarının buluta şifreli bağlanması; sertifika-tabanlı kimlik doğrulama. "Production'a giderken atlanmaz" sınıfı bir konu.

- **OTA (Over-The-Air) Güncelleme:** Cihaza fiziksel müdahale olmadan firmware güncellemek. **Bootloader** + güvenli imza doğrulama + yedek bölme (A/B partition) standart pratiktir.

> [!WARNING] IoT'de en sık yapılan hata
> Cihazı internete açıp güvenlik düşünmemek. Default şifre + açık MQTT broker + imzasız OTA = botnet bileti.

---

## 🧠 BÖLÜM 6: RTOS VE GÖMÜLÜ LİNUX (İŞLETİM SİSTEMLERİ)

Sistem büyüdüğünde ve aynı anda onlarca iş yapması gerektiğinde devreye girer.

- **RTOS'un Temel Amacı:** Maksimum veri işlemek (**throughput**) değildir. Ana amaç **Determinizm (Zaman Garantisi)** sağlamaktır. Acil bir görevin, ne olursa olsun gecikmeden çalıştırılmasını garanti eder.
    - **Hard real-time:** Deadline kaçırılırsa sistem **başarısız**dır (uçak fly-by-wire, ABS).
    - **Soft real-time:** Deadline kaçırılırsa kalite düşer ama sistem çalışır (video stream).

- **Task / Thread:** RTOS'taki en küçük çalışma birimi. Her birinin önceliği, kendi stack'i, durumu (Running/Ready/Blocked/Suspended) vardır.

- **Scheduler (Zamanlayıcı):** Hangi task'in koştuğuna karar verir. **Preemptive (kesintili)** scheduler, yüksek öncelikli task hazır olduğunda mevcut task'i kesip onu çalıştırır.

- **Senkronizasyon Yapıları:**
    - **Mutex:** RTOS'ta paylaşılan kritik bir kaynağa (Örn: SPI hattına) aynı anda sadece tek bir görevin (Task) erişmesini **güvence altına alan** kilit yapısıdır.
    - **Semaphore:** Sayaçlı mutex — kaynak n adetse n task aynı anda alabilir. **Binary semaphore** ISR → task sinyalleşmesi için tipik.
    - **Queue:** Task'lar arası güvenli veri kuyruğu. ISR'den task'a veri geçirmek için kullanılır.
    - **Event Flags / Notifications:** Hafif sinyalleşme.
    
    Mutex (Mutual Exclusion)

	- **Kilitlenme Mantığı:** Bir kilit (lock) mekanizmasıdır. Kaynağa ilk giren iş parçacığı kilidi alır. İşlem bitene kadar diğer iş parçacıkları bekletilir.
	- **Sahiplik (Ownership):** Kilidi alan iş parçacığı, kilidi serbest bırakma yetkisine sahiptir. Başka bir iş parçacığı bu kilidi açamaz.
	- **Kullanım Amacı:** Paylaşılan tek bir kaynağın (örn. bir dosya, global bir değişken veya veri tabanı bağlantısı) bozulmasını önlemek için özel kullanım sağlamak.
	- **Tür:** İkili (binary) yapıdadır; kilitli veya açık (müsait) olabilir. 

	Semaphore (Semafor)

	- **Sayaç Mantığı:** Bir sinyal (signaling) mekanizmasıdır. İzin verilen eş zamanlı işlem sayısını tutan bir tamsayı (integer) sayaç kullanır.
	- **Sahiplik:** Sahiplik kavramı yoktur. Bir iş parçacığı sayacı düşürürken, başka bir iş parçacığı sayacı artırabilir.
	- **Kullanım Amacı:** Kapasitesi sınırlı olan kaynak havuzlarını yönetmek veya iş parçacıkları arasında iletişim/sinyal göndermek.
	- **Türleri:** Hem tek kaynağa izin veren ikili semafor (binary semaphore - Mutex'e benzer) hem de birden fazla kaynağa izin veren sayımlı semafor (counting semaphore) çeşitleri vardır.
   
- **Priority Inversion (Öncelik Terslenmesi):** Düşük öncelikli bir görevin Mutex'i alması yüzünden, yüksek öncelikli bir görevin çalışamayıp araya orta öncelikli görevlerin girdiği kaotik bug'dır. **Priority Inheritance (Öncelik Mirası)** ile çözülür — mutex'i tutan low-priority task geçici olarak high-priority task'in seviyesine yükseltilir.

- **Deadlock:** İki task karşılıklı birbirinin tuttuğu mutex'i bekler → ikisi de ilerleyemez. Çözüm: mutex'leri her zaman **aynı sırada** al, timeout kullan.

- **Process vs Thread (Linux):**
    - **Process** kendilerine ait izole RAM kullanır (güvenlidir ama haberleşmesi zordur — IPC: pipe, socket, shared memory gerekir).
    - **Thread**ler aynı RAM alanını **ortak** kullanır (haberleşmesi kolaydır ama birisi hata yaparsa tüm sistem çöker ve Mutex kullanılmazsa **Race Condition** — Yarış Durumu yaşanır).

- **Gömülü Linux Terminali:**
    - `pwd`: Mevcut bulunduğun dizinin yolunu gösterir.
    - `ls -la`: Dosyaları izinleriyle birlikte listeler.
    - `cd /path`: Dizin değiştir.
    - `grep "pattern" file`: Bir dosya veya log içinde belirli bir kelimeyi (örn: "error") aramak için kullanılır.
    - `tail -f /var/log/syslog`: Logu canlı izle (debug klasiği).
    - `sudo`: Süper kullanıcı (root) yetkisiyle komut çalıştırmayı sağlar.
    - `top` / `htop`: Arka planda çalışan süreçlerin (Daemon) işlemci ve RAM kullanım durumlarını canlı olarak listeler.
    - `dmesg`: Kernel mesajları (donanım hataları, USB takılma).
    - `journalctl -u myservice`: systemd servis logları.
    - `strace ./app`: Bir uygulamanın hangi sistem çağrılarını yaptığını gör.

> [!QUESTION] Ne zaman bare-metal, ne zaman RTOS, ne zaman Linux?
> - **Bare-metal:** Tek iş, kritik zamanlama, ultra düşük güç (sensör + LoRa).
> - **RTOS:** Birden fazla eşzamanlı iş, deterministik zamanlama, 100 KB–1 MB RAM (motor + ekran + ağ).
> - **Linux:** Karmaşık sistem, dosya sistemi/ağ, MB+ RAM (kamera + AI + bulut).

---

## 🔋 BÖLÜM 7: GÜÇ YÖNETİMİ

Pille çalışan ve uzaktan bulunan cihazlar için **güç = pil ömrü = ürünün hayatta kalması**.

- **Çalışma Modları:**
    - **Run / Active:** Tüm sistem açık.
    - **Sleep:** CPU durdu, RAM ve çevre birimleri canlı; interrupt ile hızla uyanır.
    - **Stop / Deep Sleep:** RAM tutulur ama clock'lar kapanır, mikroamper seviyesinde tüketim.
    - **Standby / Shutdown:** Neredeyse her şey kapalı, sadece RTC ve dış pin tetikleri canlı.

- **Pratik Strateji ("Race to Sleep"):** İşi mümkün olduğu kadar **hızlı bitir**, sonra hemen Deep Sleep'e gir. Aktif iken hızlı koşmak, yavaş ve sürekli uyanık kalmaktan **daha az** harcar.

- **Tasarımda Dikkat:** Çekilen akımı azaltmak için pull-up direnci doğru tarafta, LED'leri PWM ile sürmek, kullanılmayan çevre birimlerinin clock'unu kapatmak.

---

## 🛠️ BÖLÜM 8: GELİŞTİRME, HATA AYIKLAMA, FIRMWARE GÜNCELLEME

- **Toolchain:** Cross-compiler (`arm-none-eabi-gcc`), linker, debugger (GDB), build sistemi (Make/CMake/PlatformIO/Zephyr west).

- **Build Çıktıları:**
    - `.elf`: Sembol bilgili, debugger okur.
    - `.bin` / `.hex`: Çipe yazılan ham firmware.
    - **Map dosyası:** Hangi sembol nereye yerleşti — RAM/Flash dolu mu, görmek için bak.

- **Debugger Donanımları:** ST-Link, J-Link, Black Magic Probe. **JTAG** (4-5 pin) ve **SWD** (2 pin, ARM Cortex-M standardı) ile çipi durdur, breakpoint koy, register'ları oku.

- **Debug Teknikleri:**
    1. **Breakpoint + step:** Klasik. Ama gerçek zamanlı bağımlılığı bozar (durdurunca timing kaçar).
    2. **`printf` Debug:** UART üzerinden log. Ucuz, etkili, ama ISR içinde **kullanma**.
    3. **LED Toggle:** En basit. "Bu noktaya geldi mi?" sorusuna cevap.
    4. **Logic Analyzer / Oscilloscope:** Donanım sinyallerini doğrudan görmek için olmazsa olmaz. SPI/I2C/UART zamanlamasını doğrular.
    5. **RTT (Real-Time Transfer):** SEGGER'in çözümü — printf'ten çok daha hızlı, runtime'ı bozmadan.

- **Bootloader:** Cihaz açıldığında ilk çalışan küçük program. İki görevi var:
    1. Ana uygulamayı başlatmak.
    2. Yeni firmware geldiğinde Flash'a yazmak (OTA / USB / UART üzerinden).
    - **Güvenli Boot:** Firmware'in imzasını (RSA/ECDSA) kontrol et, sahte yazılım yüklenmesini engelle.

- **Yaygın Çökme Sebepleri ve Tanıları:**

| Belirti | Olası Sebep |
|---|---|
| Açılır açılmaz hard fault | Linker script'te `.data` ya da stack pointer hatası |
| Rastgele reset | Watchdog, brown-out (besleme dalgalanması), stack overflow |
| Sadece debugger bağlıyken çalışıyor | Timing race condition, `volatile` eksiği |
| Belli bir süre sonra yavaşlama | Heap fragmentation, memory leak |
| ISR hiç tetiklenmiyor | Interrupt enable bayrağı veya NVIC priority unutuldu |

---

## 🗺️ Öğrenme Yol Haritası

Her satırdaki `[[wikilink]]` ileride o konuya odaklanmış kendi notuna açılır. Linke tıkla → boş not oluşur → o konuyu öğrendikçe doldur. Sıra önemli: önce yazılım temelleri, sonra donanım, sonra sistem-seviye konular.

---

### 🟦 FAZ 1 — Yazılım Temelleri (Donanıma dokunmadan önce)

> [!INFO]+ Süre: 4–6 hafta. Bu fazı atlama; gömülünün %70'i C, geri kalanı sabırdır.

- [[C Dili — Sıfırdan Derinlemesine]]
    Pointer, struct, union, bitwise, preprocessor makroları, scope/storage class (`static`, `extern`, `const`, `volatile`). Gömülüde her gün kullanacağın şeyler.
    **Nasıl ilerle:** K&R kitabı (The C Programming Language) bölüm bölüm + her bölüm sonunda küçük CLI uygulaması yaz (mini hesap makinesi, basit bir linked list, basit bir log parser). LeetCode'da 20–30 kolay/orta problem C ile çöz.
    **Ek kaynak:** Beej's Guide to C Programming, Modern C — Jens Gustedt (online ücretsiz).

- [[C++ — Gömülü için Modern C++]]
    RAII, `constexpr`, `enum class`, template'ler (ölçülü kullan), no-exception/no-RTTI subset'i. Gömülüde "modern ama ağır olmayan" C++ yazmayı öğrenmek kritik.
    **Nasıl ilerle:** Önce normal C++ (Stroustrup'un *Tour of C++*'ı), sonra "Embedded C++ subset" konuşmalarına geç. Bryce Adelstein Lelbach ve Odin Holmes'un CppCon talkları.
    **Ek kaynak:** ARM'ın "C++ for Embedded Programmers" rehberi.

- [[Git ve Versiyon Kontrolü]]
    `init/add/commit/push/pull`, branch + merge + rebase, `.gitignore`, GitHub workflow, conflict çözme.
    **Nasıl ilerle:** Pro Git kitabının ilk 3 bölümü + tüm yan projelerini GitHub'a koy. 20 commit sonrası rebase ve cherry-pick öğren.

- [[Make ve CMake]]
    Build sistemleri olmadan gömülü projesi yönetilmez. Önce Makefile elle yazmayı öğren, sonra CMake'e geç. Cross-compile toolchain'ini CMake'te tanıtmayı bil.
    **Nasıl ilerle:** Önce 3 dosyalık bir projeyi elle Makefile ile derle. Sonra aynı projeyi CMake'e taşı. STM32'de hem CubeIDE'nin ürettiği Makefile'a hem CMake template'ine bak.

- [[Linux Komut Satırı Temelleri]]
    `ls/cd/grep/find/sed/awk/pipe/redirect`, dosya izinleri, basit shell script yazma. Sonradan gömülü Linux'a geçtiğinde bu hayat kurtarır.
    **Nasıl ilerle:** WSL veya Ubuntu VM kur. *The Linux Command Line* (William Shotts) kitabı; günlük her şeyi terminalde yapmaya zorla.

---

### 🟧 FAZ 2 — Donanım ve Elektronik Temelleri

> [!INFO]+ Süre: 2–3 hafta. Yazılımcı olarak en az "şu pinler neden böyle çekildi" diyebilmen lazım.

- [[Dijital Elektronik Temelleri]]
    Gerilim, akım, Ohm yasası, kapasitör/direnç/diyot, lojik seviyeleri (3.3V vs 5V), pull-up/down, MOSFET ile sürme.
    **Nasıl ilerle:** Khan Academy "Electrical Engineering" kursu + breadboard üzerinde LED + buton + transistör pratikleri. *Practical Electronics for Inventors* kitabı (ilk 3 bölüm yeter).

- [[Şematik ve Datasheet Okuma]]
    Bir MCU datasheet'i 1000+ sayfa. Önemli olan navigasyon: pinout, electrical characteristics, register map, peripheral örnekleri.
    **Nasıl ilerle:** STM32F103 (Blue Pill) ve ESP32 datasheet'lerini indir. Pinout sayfasını yazdır. Bir register tablosu (örn: GPIO MODER) bul, her bit ne yapıyor satır satır anla.

- [[Multimetre ve Osiloskop Pratiği]]
    Gerilim ölç, süreklilik ara, sinyal yakala. Logic analyzer (Saleae klon ~$10) zorunlu yatırım.
    **Nasıl ilerle:** Bir UART hattını osiloskopta gör, baud rate hesabı yap. I2C trafiğini logic analyzer ile decode ettir.

---

### 🟩 FAZ 3 — İlk MCU (Arduino)

> [!INFO]+ Süre: 2–3 hafta. "Çabuk dopamin" fazı — hızla bir şeyler yanıp sönsün, sonra alt seviyeye in.

- [[Arduino ile Başlangıç]]
    Blink → buton (debounce) → seri haberleşme → ADC (potansiyometre) → PWM (LED parlaklığı) → I2C sensör (BMP280 veya DHT22) → SPI (OLED ekran).
    **Nasıl ilerle:** Arduino Uno veya Nano al. Her hafta bir proje bitir. Kütüphane kullanmadan, register'ları doğrudan yazarak da yapmaya çalış (`DDRB`, `PORTB`). Bu, sonraki MCU'ya geçişte sana iki ay kazandırır.
    **Ek adım:** Aynı projeyi PlatformIO'da yaz, Arduino IDE'den çık.

---

### 🟨 FAZ 4 — Gerçek MCU (STM32 ve ESP32)

> [!INFO]+ Süre: 6–8 hafta. Gerçek profesyonel iş bu fazdan sonra başlar.

- [[STM32 — HAL'dan Register Seviyesine]]
    STM32CubeIDE veya PlatformIO + STM32Cube HAL. Önce HAL ile yap, sonra aynı işi LL (Low Level) veya direkt register yazımıyla yap. CMSIS'i tanı.
    **Nasıl ilerle:** Blue Pill (STM32F103) veya Nucleo kart al, ST-Link debugger kullan. Sırayla: GPIO toggle → SysTick ile delay → UART printf → TIM ile PWM → ADC + DMA → I2C ile sensör → SPI ile ekran. Her birini hem HAL hem register seviyesinde yap.
    **Ek kaynak:** ControllersTech ve Phil's Lab YouTube kanalları, *Mastering STM32* (Carmine Noviello) kitabı.

- [[ESP32 ile Wi-Fi ve BLE]]
    ESP-IDF (resmi, FreeRTOS-tabanlı) veya Arduino-ESP32. Wi-Fi station/AP, HTTP, MQTT, BLE GATT server/client.
    **Nasıl ilerle:** ESP32 DevKit al. Önce Wi-Fi'ye bağlan, NTP'den saat al. Sonra bir HTTP server, sonra MQTT publish. BLE'de bir "sıcaklık yayını" beacon yap.
    **Ek kaynak:** ESP-IDF'in resmi `examples/` klasörü — en iyi öğrenme kaynağı.

- [[PlatformIO ile Modern Geliştirme]]
    VSCode + PlatformIO. Multi-platform (STM32/ESP32/AVR/RP2040) tek IDE, library manager, unit test desteği.
    **Nasıl ilerle:** Var olan Arduino projeni PlatformIO'ya taşı. `platformio.ini` dosyasını anla. Unit test framework'ünü dene.

---

### 🟥 FAZ 5 — Çevre Birimleri ve Sürücü Yazma

> [!INFO]+ Süre: 4–6 hafta. Burada "kütüphane kullanan" değil "kütüphane yazan" olmaya başlarsın.

- [[GPIO, Timer ve PWM Pratiği]]
    Pin mode konfigürasyonu, interrupt-on-change, input capture, output compare, PWM frekans/duty hesabı, servo sürme, encoder okuma.
    **Nasıl ilerle:** Bir RC servo + bir DC motor + bir rotary encoder al, üçünü aynı projede yönet.

- [[ADC ve Sinyal Filtreleme]]
    Resolution, sampling rate, Vref, oversampling, moving average filtresi, IIR low-pass filtresi.
    **Nasıl ilerle:** Bir analog mikrofon veya akım sensörü oku, ham veriyi UART'tan PC'ye gönder, Python'da matplotlib ile grafik çiz. Sonra filtreleri MCU'da uygula, farkı gör.

- [[UART Sürücü ve Komut Satırı]]
    Ring buffer ile UART RX, basit komut parser (CLI), `printf` retarget.
    **Nasıl ilerle:** Cihaza terminal aç: "set led 1", "read temp", "reboot" komutlarına yanıt versin. Bu pattern her gömülü cihazda lazım.

- [[I2C Sensör Sürücüsü Yazma]]
    Datasheet'ten register adresleri oku, bytes oluştur, CRC kontrol, scan fonksiyonu.
    **Nasıl ilerle:** BMP280 veya MPU6050 al. Önce kütüphane ile çalıştır, sonra hiçbir kütüphane olmadan baştan yaz — sadece HAL_I2C_Master_Transmit/Receive ile.

- [[SPI ile SD Kart ve Ekran]]
    SPI mode (CPOL/CPHA), CS yönetimi, FatFs (SD kart), SSD1306 OLED veya ILI9341 TFT sürme.
    **Nasıl ilerle:** Bir OLED'de "Hello World" yaz, sonra grafik primitif (çizgi, daire), sonra bitmap font yükle.

---

### 🟪 FAZ 6 — Gerçek Zamanlı Sistemler (RTOS)

> [!INFO]+ Süre: 3–4 hafta. Birden fazla işin aynı anda dönmesi gerektiğinde başla.

- [[FreeRTOS Sıfırdan]]
    Task oluşturma, priority, delay, queue, mutex, semaphore, event group, software timer. Stack size hesabı.
    **Nasıl ilerle:** STM32CubeMX'te FreeRTOS'u aç. İki task yarat: biri LED toggle, diğeri UART komut dinle. Sonra queue ile iletişim kurdur. Sonra producer-consumer pattern; sonra **bilerek deadlock yarat ve çöz**.
    **Ek kaynak:** *Mastering FreeRTOS* (resmi ücretsiz PDF).

- [[Zephyr — Modern RTOS]]
    Linux-vari yapıya sahip, Device Tree kullanan, multi-vendor RTOS. Endüstride yükselen seçenek.
    **Nasıl ilerle:** Zephyr'ın resmi "Getting Started" + `samples/` klasörü. ESP32 veya Nordic nRF52 üzerinde dene.

---

### 🟫 FAZ 7 — Ağ, IoT ve Bulut

> [!INFO]+ Süre: 3–4 hafta. Cihaz internete açılınca dünya değişir.

- [[MQTT ile Cihazdan Buluta]]
    Broker (Mosquitto), topic hiyerarşisi, QoS 0/1/2, retained mesaj, LWT (Last Will and Testament).
    **Nasıl ilerle:** Lokalde Mosquitto kur, ESP32'den sıcaklık publish et, `mosquitto_sub` ile dinle. Sonra Node-RED dashboard ekle. Sonra AWS IoT Core veya HiveMQ Cloud'a geç.

- [[BLE Pratiği]]
    GAP (advertising, scanning), GATT (services, characteristics), pairing, notification/indication.
    **Nasıl ilerle:** ESP32'yi BLE peripheral yap, telefondan nRF Connect uygulaması ile bağlan, characteristic okuyup yaz.

- [[Güvenli IoT — TLS ve Sertifika]]
    TLS handshake, sertifika doğrulama, cihaz başına unique cert, secure element (ATECC608).
    **Nasıl ilerle:** Cihazdan HTTPS GET yap, sonra sertifikayı kaldırıp ne olduğunu gör (man-in-the-middle riski). AWS IoT Core'da X.509 ile auth kur.

---

### ⬛ FAZ 8 — Sistem Seviyesi ve Üretim

> [!INFO]+ Süre: 4–6 hafta. Hobi projesi ile ticari ürün arasındaki fark bu faz.

- [[Linker Script ve Memory Map]]
    `.text/.data/.bss/.heap/.stack` bölümleri, Flash/RAM yerleşimi, custom section yerleştirme, `--print-memory-usage` çıktısı.
    **Nasıl ilerle:** STM32'nin default `.ld` dosyasını aç, satır satır anla. Sonra bir değişkeni özel bir bölgeye (`__attribute__((section(".my_data")))`) yerleştir.

- [[Bootloader ve OTA Güncelleme]]
    İki bölgeli (A/B) firmware, image header, CRC + dijital imza, secure boot zinciri, fallback mekanizması.
    **Nasıl ilerle:** Önce basit bir "UART üzerinden firmware yükle" bootloader yaz. Sonra HTTP üzerinden OTA, sonra imza doğrulamalı OTA. **MCUboot** kütüphanesini incele.

- [[Hata Ayıklama — JTAG, SWD ve GDB]]
    Breakpoint, watchpoint, step into/over, backtrace, hard fault analizi (CFSR/HFSR register okuma), RTT (SEGGER).
    **Nasıl ilerle:** Bilerek hard fault tetikleyen kod yaz (NULL pointer dereference, alignment hatası). GDB ile durdur, neyin yanlış olduğunu register'lardan çöz. Bu beceri seni junior'dan kurtarır.

- [[Logic Analyzer ile Donanım Debug]]
    SPI/I2C/UART decode, glitch yakalama, timing measurement.
    **Nasıl ilerle:** Çalışmayan bir I2C trafiğini analyzer'a bağla, datasheet'teki timing diagram ile karşılaştır.

- [[Test ve CI/CD Gömülüde]]
    Unit test (Unity, CppUTest), HIL (hardware-in-the-loop), GitHub Actions ile cross-compile + test.
    **Nasıl ilerle:** Bir sürücüyü PC'de mock'layarak test et. Sonra fiziksel donanım üzerinde otomatik test scripti yaz.

---

### 🟦 FAZ 9 — Gömülü Linux

> [!INFO]+ Süre: 6–8 hafta. MCU'dan sonra "küçük bilgisayar" dünyasına geç.

- [[Raspberry Pi ile Başlangıç]]
    GPIO, I2C, SPI; önce Python ile, sonra C/C++ ile. systemd servis yazma, otomatik başlatma.
    **Nasıl ilerle:** Raspbian (Pi OS) kur, bir Python script GPIO toggle, sonra C ile aynısı (`libgpiod`), sonra bunu systemd servisi yap.

- [[Cross-Compilation ve SDK]]
    x86 PC'de ARM hedef için derleme, sysroot, toolchain (`gcc-arm-linux-gnueabihf`).
    **Nasıl ilerle:** PC'de "Hello World" yaz, Pi için cross-compile et, `scp` ile gönder, çalıştır.

- [[Gömülü Linux — Yocto]]
    Recipe yazma, BSP, image customization, layer kavramı. (Bu notu zaten oluşturmuşsun — devamını doldur.)
    **Nasıl ilerle:** Yocto'nun resmi Mega-Manual'ı + bir BeagleBone veya Raspberry Pi için custom image kur. Bir kendi recipe'ini yaz (örn: kendi servisini içeren).

- [[Linux Kernel ve Device Tree]]
    DT overlay yazma, kernel module (basit char driver), `/proc` ve `/sys` üzerinden debug.
    **Nasıl ilerle:** *Linux Device Drivers* (LDD3) kitabı + bir LED'i kontrol eden minimal char driver yaz.

---

### ⬜ FAZ 10 — Kariyer ve Yumuşak Beceriler

> [!INFO]+ Süre: Sürekli — bu işler bittikçe değil, paralel ilerlemeli.

- [[Datasheet Okuma Sanatı]]
    Hangi bölüm ne için, electrical characteristics nasıl yorumlanır, errata neden hayati.
    **Nasıl ilerle:** Bir hafta her gün farklı bir çipin datasheet'inden 30 dakika "amaçlı" oku — bir özelliği bulup, register'ını gör, örnek kodla karşılaştır.

- [[Gömülü Mülakat Soruları]]
    `volatile`, big/little endian, struct padding, bit manipulation, ISR kuralları, mutex vs semaphore, race condition senaryoları, "blink yazarken delay kullanmadan nasıl yaparsın".
    **Nasıl ilerle:** *Programming Embedded Systems* (Barr & Massa) + Embedded.fm podcast + r/embedded subreddit.

- [[Açık Kaynak Gömülü Projelere Katkı]]
    Zephyr, NuttX, MicroPython, Tasmota, Marlin gibi projeler. Doc fix'ten başla.
    **Nasıl ilerle:** Bir projeyi seç, "good first issue" etiketli bir bug al, PR aç. Bu, CV'de 10 sertifikadan değerlidir.

- [[Kişisel Portföy Projesi]]
    Bir tane "tamamlanmış" cihaz: 3D yazıcı modifikasyonu, akıllı saat, ev otomasyonu hub'ı, hava istasyonu. Şema + PCB + firmware + bulut dashboard — hepsi sende olsun.
    **Nasıl ilerle:** Küçük başla (DHT22 + ESP32 + MQTT + Grafana), sonra her ay bir özellik ekle. GitHub'da README + video.

---

## ✅ Hızlı Başlangıç: 12 Hafta Mini Plan

Tüm fazları sırayla yapmadan önce kısa bir dolaşma istersen:

| Hafta | Hedef |
|---|---|
| 1–2 | C tazele (pointer, struct, bitwise) + Arduino blink/buton/UART |
| 3–4 | STM32 veya ESP32: HAL ile GPIO, Timer, ADC |
| 5–6 | Gerçek bir I2C/SPI sensörü datasheet'inden sür |
| 7–8 | FreeRTOS — iki task + queue + mutex |
| 9–10 | ESP32 + MQTT + Mosquitto + Node-RED/Grafana dashboard |
| 11–12 | Raspberry Pi'de C++ systemd servisi + cross-compile |

Sonra Faz 5+'a dön; haftada bir konuyu derinleştir.

---

## 🧭 Ekstra: Hangi Yöne Uzmanlaşacaksın?

12 haftalık temel bittikten sonra biriyle derinleş:

- **Otomotiv:** CAN/CAN FD + AUTOSAR + ISO 26262 (functional safety) + Vector CANoe.
- **IoT / Tüketici:** ESP32 + BLE + bulut + güç optimizasyonu + üretim/test fixture'ları.
- **Endüstriyel:** Modbus, EtherCAT, PROFINET + PLC entegrasyonu + IEC 61131.
- **Robotik:** ROS2 + DDS + sensör füzyonu + motor kontrolü (BLDC, PID).
- **AI on Edge:** TensorFlow Lite Micro, Edge Impulse, ESP32-S3 / STM32H7 / Coral.
- **Düşük Güç / Wearable:** nRF52/nRF53 + BLE + battery management + Zephyr.
- **Savunma / Havacılık:** DO-178C, MISRA C, deterministik RTOS (VxWorks, INTEGRITY).

---

%% Oluşturuldu: 2026-05-16 · Son güncelleme: 2026-05-16 (öğrenme yol haritası eklendi) %%
