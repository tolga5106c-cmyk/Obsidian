---
title: "Data Analysis With Python"
aliases: [Veri Analizi, Python Data Analysis]
tags: [python, data-analysis, numpy, pandas, matplotlib, proje]
created: 2026-05-16
status: active
type: note
area: veri-bilimi
---

# 📊 Veri Analizi Çalışmaları (Data Analysis)

Bu proje, **Python** ile veri analizi öğrenme sürecinde gerçekleştirilen tüm çalışmaları kapsamaktadır. NumPy, Pandas ve Matplotlib kütüphaneleri kullanılarak temel veri işleme, analiz ve görselleştirme teknikleri uygulanmıştır.

---

## 📁 Proje Yapısı

```
data_analysis/
│
├── numpy/                              # NumPy kütüphanesi çalışmaları
│   ├── numpy_introduction.py           # NumPy'a giriş ve temel array özellikleri
│   ├── serieswnumpy.py                 # Array oluşturma yöntemleri ve istatistiksel işlemler
│   ├── array_operations.py             # Array aritmetik işlemleri ve birleştirme
│   ├── indexing.py                     # Dizi indeksleme, dilimleme ve kopyalama
│   └── applications.py                # NumPy uygulamaları (reshape, filtreleme, matris işlemleri)
│
├── pandas/                             # Pandas kütüphanesi çalışmaları
│   ├── pandas_introduction.py          # Pandas Series'e giriş ve temel özellikler
│   ├── dataframe.py                    # DataFrame oluşturma yöntemleri
│   ├── row_col_inst.py                 # Satır ve sütun seçim yöntemleri (loc, iloc)
│   ├── filterin_with_dataframe.py      # DataFrame filtreleme ve boolean maskeleme
│   ├── dataframes_methods.py           # DataFrame metotları (apply, unique, sort, pivot_table)
│   ├── lost_and_bugged.py              # Eksik veri (NaN) yönetimi
│   ├── groupby.py                      # GroupBy ile gruplama ve toplama işlemleri
│   ├── join&merge.py                   # DataFrame birleştirme (merge, concat)
│   ├── string_funcs_with_pandas.py     # String fonksiyonları (upper, find, contains, split)
│   ├── reading_from_diff_file_types.py # Farklı dosya formatlarından veri okuma (CSV, JSON, SQLite)
│   ├── check_tables.py                 # JSON → SQLite tablo dönüşümü (Pokemon veri seti)
│   ├── imbd_data_analaysis_project.py  # IMDB Top 250 TV dizileri veri analizi projesi
│   ├── nba_data_project.py             # NBA oyuncu verileri analiz projesi
│   └── youtube.statistics.analysis.py  # YouTube US Trending videolar analiz projesi
│
├── matplotlib/                         # Matplotlib kütüphanesi çalışmaları
│   ├── intro.py                        # Matplotlib'e giriş ve temel çizgi grafik
│   ├── creatingfigure.py               # Figure ve Axes nesneleri ile grafik oluşturma
│   ├── creatingraph.py                 # Çoklu grafik türleri (subplots, Pandas plot)
│   └── graphs.py                       # Farklı grafik türleri (stackplot, pie, bar, histogram)
│
├── IMBD.csv                            # IMDB film veri seti
├── IMDB_Top250_Tvshows.csv             # IMDB Top 250 TV dizileri veri seti
├── USvideos.csv                        # YouTube US Trending videolar veri seti
├── nba.csv                             # NBA oyuncu verileri
├── pokemonDB_dataset.json              # Pokemon veritabanı (JSON)
├── pokemonDB_dataset.db                # Pokemon veritabanı (SQLite)
├── Nobel Laureates For *.csv           # Nobel ödüllü bilim insanları veri setleri (6 adet)
└── README.md                           # Bu dosya
```

---

## 🔢 NumPy Çalışmaları

NumPy (Numerical Python), sayısal hesaplama için temel kütüphanedir. Bu bölümde diziler üzerinde işlem yapmayı öğreniyoruz.

### `numpy_introduction.py` — NumPy'a Giriş

- Python listesinden NumPy array'i oluşturma (`np.array()`)
- `type()` ile tip karşılaştırması (list vs ndarray)
- `reshape()` ile 1D diziyi 2D matrise dönüştürme
- Array özellikleri: `ndim`, `shape`, `size`, `itemsize`

### `serieswnumpy.py` — Array Oluşturma ve İstatistik

- **Array oluşturma yöntemleri:**
  - `np.arange()` — Belirli aralıkta sayılar
  - `np.zeros()` — Sıfırlardan oluşan dizi
  - `np.ones()` — Birlerden oluşan dizi
  - `np.eye()` — Birim matris
  - `np.linspace()` — Eşit aralıklı sayılar
  - `np.random.rand()` — Uniform rastgele sayılar
  - `np.random.randn()` — Normal dağılımlı rastgele sayılar
  - `np.random.randint()` — Rastgele tam sayılar
- **İstatistiksel fonksiyonlar:** `max()`, `min()`, `argmin()`, `argmax()`, `mean()`, `std()`, `var()`, `sort()`, `argsort()`
- **Eksen bazlı toplam:** `sum(axis=0)` (sütun), `sum(axis=1)` (satır)

### `array_operations.py` — Array İşlemleri

- Eleman bazlı aritmetik işlemler (`+`, `-`, `*`, `/`)
- Matematiksel fonksiyonlar: `np.sin()`, `np.sqrt()`
- Dizi birleştirme: `np.vstack()` (dikey), `np.hstack()` (yatay)
- Boolean maskeleme ile filtreleme

### `indexing.py` — İndeksleme ve Dilimleme

- Temel indeksleme: `arr[0]`, `arr[-1]`
- Dilimleme (slicing): `arr[0:3]`, `arr[:3]`, `arr[3:]`
- Ters çevirme: `arr[::-1]`
- 3D array indeksleme: `arr[0,1,1]`, `arr[:,1,0]`
- **Referans vs Kopya:** `arr2 = arr1` (referans) vs `arr3 = arr1.copy()` (bağımsız kopya)

### `applications.py` — NumPy Uygulamaları

- `reshape()` ile matris oluşturma
- Matris toplam, ortalama, min, max hesaplamaları
- `argmin()` / `argmax()` ile konum bulma
- Dilimleme ve 2D erişim: `result[1,2]`, `result[:,0]`
- Matris üssü alma: `result**2`
- Koşullu filtreleme: `result[((result%2==0) & (result>0))]`

---

## 🐼 Pandas Çalışmaları

Pandas, tablo formatındaki verileri işlemek için en güçlü kütüphanedir. Bu bölümde Series ve DataFrame yapıları üzerinde kapsamlı çalışmalar yapılmıştır.

### `pandas_introduction.py` — Pandas Series'e Giriş

- Farklı veri tiplerinden Series oluşturma (list, dict, numpy array)
- Özel indeks atama
- Series özellikleri: `ndim`, `size`, `shape`, `index`, `values`, `dtype`
- İstatistiksel fonksiyonlar: `sum()`, `mean()`, `min()`, `max()`
- Koşullu filtreleme: `series[series>=2]`
- İki Series'i toplama (ortak olmayan indeksler → NaN)

### `dataframe.py` — DataFrame Oluşturma Yöntemleri

DataFrame oluşturmanın **5 farklı yolu** gösterilmiştir:

| Yöntem | Açıklama |
|--------|----------|
| `pd.Series()` birleştirme | İki Series'i sütun olarak birleştir |
| İç içe liste | `[['john',23], ['smith',23]]` |
| Liste + özel indeks | `index=["a","b","c","d"]` ile |
| Dictionary | `{"name": [...], "age": [...]}` |
| Dictionary listesi | `[{"name":"Ahmet","age":50}, ...]` |

### `row_col_inst.py` — Satır ve Sütun Seçimi

- **`loc[]`** — Etiket bazlı seçim: `df.loc["A"]`, `df.loc["A","col1"]`
- **`iloc[]`** — İndeks bazlı seçim: `df.iloc[0]`
- Sütun seçimi: `df[["col1"]]` (DataFrame olarak)
- Aralık dilimleme: `df.loc["A":"B", :"col1"]`
- Sütun silme: `df.drop("col1", axis=1)`

### `filterin_with_dataframe.py` — Filtreleme Teknikleri

- `head()` / `tail()` — İlk/son satırları getir
- Tek/çoklu sütun seçimi
- **Boolean maskeleme:** `df > 50`, `df[df > 50]`
- **Koşullu filtreleme:**
  - `&` (VE): `df[(df["Column1"]>50) & (df["Column1"]<=70)]`
  - `|` (VEYA): `df[(df["Column1"]<25) | (df["Column2"]>70)]`
- **`query()` metodu:** `df.query("Column1>=50 & Column1%2 == 0")`

### `dataframes_methods.py` — DataFrame Metotları

- **`apply()`** — Fonksiyon uygulama (normal fonksiyon, lambda)
- **`unique()`** / **`nunique()`** — Benzersiz değerler ve sayısı
- **`value_counts()`** — Frekans tablosu
- **`sort_values()`** — Sıralama (artan/azalan)
- **`info()`** — DataFrame özet bilgisi
- **`pivot_table()`** — Pivot tablo oluşturma (satır: Ay, sütun: Kategori, değer: Gelir)

### `lost_and_bugged.py` — Eksik Veri (NaN) Yönetimi

- `reindex()` ile eksik indeksler → NaN oluşturma
- **Tespit:** `isnull()`, `notnull()`, `isnull().sum()`
- **Filtreleme:** `df[df["column1"].isnull()]`
- **Silme — `dropna()`:**
  - `axis=0` (satır) / `axis=1` (sütun)
  - `how="any"` / `how="all"`
  - `subset=["col1","col2"]` ile belirli sütunlara göre
  - `thresh=2` — En az 2 dolu değer
- **Doldurma:** `fillna(value="-1")`
- **İstatistik:** Toplam NaN sayısı, dolu hücre sayısı

### `groupby.py` — GroupBy ile Gruplama

- `groupby("Departman").groups` — Grup anahtarlarını göster
- `get_group("Kadıköy")` — Belirli bir grubu getir
- `mean()`, `count()` — Grup bazlı istatistik
- **`agg()`** — Birden fazla fonksiyon uygulama: `agg([np.mean, np.min, np.max])`
- **`.loc["Muhasebe"]`** — Belirli bir grubun agg sonuçlarını seç

### `join&merge.py` — DataFrame Birleştirme

- **`pd.merge()`** — SQL tarzı birleştirme:
  - `how="inner"` — Sadece eşleşen kayıtlar
  - `how="left"` — Sol tablonun tüm kayıtları
  - `how="right"` — Sağ tablonun tüm kayıtları
- **`pd.concat()`** — Basit birleştirme:
  - `axis=0` — Dikey (alt alta)
  - `axis=1` — Yatay (yan yana)

### `string_funcs_with_pandas.py` — String Fonksiyonları

- `str.upper()` — Büyük harfe çevir
- `str.find("A")` — Karakter arama
- `str.contains("Saul")` — İçerik kontrolü ile filtreleme
- `str.replace(" ", "_")` — Karakter değiştirme
- `str.split(expand=True)` — Stringleri parçalayarak yeni sütunlar oluştur
- `str.len()` — String uzunluğu hesaplama

### `reading_from_diff_file_types.py` — Farklı Dosya Formatlarından Okuma

| Fonksiyon | Dosya Tipi |
|-----------|------------|
| `pd.read_csv()` | CSV dosyası |
| `pd.read_json()` | JSON dosyası |
| `pd.read_sql_query()` | SQLite veritabanı |

### `check_tables.py` — JSON → SQLite Dönüşümü

- Pokemon veri setini JSON'dan okuyup her Pokemon için ayrı SQLite tablosu oluşturma
- Tablo adlarındaki özel karakterleri temizleme (`replace()`)
- `to_sql()` ile DataFrame'i veritabanına yazma

---

## 📈 Veri Analizi Projeleri

### `imbd_data_analaysis_project.py` — IMDB Top 250 TV Dizileri Analizi

**Veri Seti:** `IMDB_Top250_Tvshows.csv`

| Yapılan İşlem | Açıklama |
|----------------|----------|
| Temel keşif | `head()`, `columns`, sütun seçimi |
| Rating filtresi | Rating > 8.0 olan diziler |
| Yıl bazlı analiz | Bitiş yılını çıkarma (`str[-4:]`) ve 2015+ filtreleme |
| Oy dönüşümü | "(2.2M)" → 2200000, "(159K)" → 159000 formatını sayıya çevirme |
| Kombine filtre | 100K+ oy VEYA 8-9 arası puan |

### `nba_data_project.py` — NBA Oyuncu Analizi

**Veri Seti:** `nba.csv`

- Temel istatistikler: ortalama/max/min maaş
- En yüksek maaşlı oyuncuyu bulma
- Yaş bazlı filtreleme (20-25 arası)
- İsim bazlı arama (`str.contains("and")`)
- Takım bazlı gruplama: ortalama maaş, oyuncu sayısı, takım sayısı

### `youtube.statistics.analysis.py` — YouTube US Trending Videolar Analizi

**Veri Seti:** `USvideos.csv`

Bu çalışmada YouTube'un ABD'deki trend videolar veri seti kapsamlı olarak analiz edilmiştir:

| Adım | İşlem |
|------|-------|
| Veri temizleme | Gereksiz sütunları silme (`thumbnail_link`, `description` vb.) |
| En çok izlenen | `views` maksimum olan videonun başlığı |
| Top 10 video | İzlenmeye göre azalan sırada ilk 10 |
| Kategori analizi | Kategori bazlı ortalama beğeni ve toplam yorum |
| Yeni özellikler | `title_len` (başlık uzunluğu), `tag_count` (etiket sayısı) |
| Popülerlik skoru | `likes / (likes + dislikes)` formülü |
| Çoklu sıralama | Önce popülerliğe, eşitlik varsa beğeni sayısına göre sıralama |

---

## 📉 Matplotlib Çalışmaları

Matplotlib, Python'un en temel veri görselleştirme kütüphanesidir.

### `intro.py` — Matplotlib'e Giriş

- Temel çizgi grafik: `plt.plot(x, y)`
- Grafik özelleştirme: `marker`, `linestyle`, `color`, `label`
- `title()`, `xlabel()`, `ylabel()`, `legend()`, `grid()`
- Aynı grafik üzerine birden fazla fonksiyon çizme (`x²` ve `x³`)

### `creatingfigure.py` — Figure ve Axes ile Grafik Oluşturma

- **`figure.add_axes()`** — Manuel konum belirleyerek grafik alanı oluşturma
  - Ana grafik içine küçük iç grafik yerleştirme
- **Tek grafik üzerine çoklu çizim** — Lejant ile birlikte
- **`plt.subplots()`** — Alt grafik ızgarası oluşturma (`nrows=2, ncols=1`)
- **`tight_layout()`** — Grafiklerin üst üste binmesini engelleme
- **`savefig()`** — Grafikleri PNG olarak kaydetme

### `creatingraph.py` — Çoklu Grafik Türleri ve Subplots

- Format string ile hızlı grafik: `"o--r"` (daire, kesikli, kırmızı)
- `plt.axis()` ile eksen sınırlarını ayarlama
- `np.linspace()` ile düzgün eğriler
- **3 satırlık alt grafik** (`subplots(3)`)
- **2x2 alt grafik ızgarası** (`subplots(2,2)`)
- **Pandas `.plot()`** — NBA veri seti ile entegre grafik

### `graphs.py` — Grafik Türleri Koleksiyonu

| Grafik Türü | Fonksiyon | Kullanım Alanı |
|-------------|-----------|----------------|
| Yığılmış Alan | `plt.stackplot()` | Zaman serisi karşılaştırma |
| Pasta | `plt.pie()` | Oran/yüzde gösterimi |
| Çubuk | `plt.bar()` | Kategorik karşılaştırma |
| Histogram | `plt.hist()` | Frekans dağılımı |

> [!TIP] Sonraki adım: Seaborn
> Matplotlib'e hâkim olduktan sonra **Seaborn** öğrenmek mantıklı. Pandas DataFrame'lerle doğrudan çalışır, istatistiksel grafikleri (boxplot, heatmap, pairplot) çok daha az kodla üretir ve Matplotlib'in üstüne oturduğu için mevcut bilgin doğrudan aktarılır. `pip install seaborn`

---

## 🗂️ Veri Setleri

| Dosya | Açıklama | Boyut |
|-------|----------|-------|
| `IMBD.csv` | IMDB film verileri | ~3 MB |
| `IMDB_Top250_Tvshows.csv` | Top 250 TV dizileri | ~15 KB |
| `USvideos.csv` | YouTube US Trending videolar | ~60 MB |
| `nba.csv` | NBA oyuncu verileri (isim, takım, yaş, maaş) | ~33 KB |
| `pokemonDB_dataset.json` | Pokemon veritabanı (JSON) | ~1.4 MB |
| `pokemonDB_dataset.db` | Pokemon veritabanı (SQLite) | ~6 MB |
| `Nobel Laureates *.csv` | Nobel ödüllü bilim insanları (6 kategori) | ~25-37 KB |

---

## 🛠️ Kullanılan Teknolojiler

| Teknoloji | Versiyon | Kullanım Amacı |
|-----------|----------|----------------|
| **Python** | 3.13 | Ana programlama dili |
| **NumPy** | - | Sayısal hesaplama ve dizi işlemleri |
| **Pandas** | - | Veri manipülasyonu ve analiz |
| **Matplotlib** | - | Veri görselleştirme |
| **SQLite3** | - | Veritabanı işlemleri |

---

## 🚀 Kurulum ve Çalıştırma

### Gereksinimler

```bash
pip install numpy pandas matplotlib
```

### Çalıştırma

```bash
# Herhangi bir dosyayı çalıştırmak için:
python pandas/nba_data_project.py
python numpy/applications.py
python matplotlib/graphs.py
```

> [!WARNING] Not
> Pandas dosyalarını çalıştırırken ilgili CSV/JSON/DB dosyalarının `pandas/` klasöründe veya doğru yolda olduğundan emin olun.

---

## 📚 Öğrenilen Kavramlar Özeti

### NumPy

- Array oluşturma, yeniden şekillendirme (`reshape`)
- İndeksleme, dilimleme, boolean maskeleme
- Matematiksel ve istatistiksel fonksiyonlar
- Referans vs kopya farkı
- Eksen bazlı işlemler (`axis=0`, `axis=1`)

### Pandas

- Series ve DataFrame veri yapıları
- Veri okuma (CSV, JSON, SQLite)
- Satır/sütun seçimi (`loc`, `iloc`)
- Filtreleme ve boolean maskeleme
- Eksik veri yönetimi (`dropna`, `fillna`, `isnull`)
- GroupBy ile gruplama ve toplama (`agg`)
- DataFrame birleştirme (`merge`, `concat`)
- String işlemleri (`str` accessor)
- Pivot tablo oluşturma
- `apply()` ile özel fonksiyon uygulama
- Çoklu sütuna göre sıralama

### Matplotlib

- Çizgi grafik, çubuk grafik, pasta grafik, histogram, yığılmış alan grafik
- Figure ve Axes nesneleri ile ileri düzey grafik kontrolü
- Alt grafik ızgaraları (`subplots`)
- Grafik kaydetme (`savefig`)
- Pandas ile entegre grafik çizimi

---

## 👤 Geliştirici

Bu çalışmalar Python ile veri analizi öğrenme sürecinde hazırlanmıştır.

---

*Son güncelleme: Mayıs 2026*

%% Oluşturuldu: 2026-05-16 %%
