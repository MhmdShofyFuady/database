# Tugas Database — Sistem Perpustakaan

| | |
|---|---|
| **Nama** | Muhammad Shofy Fuady |
| **NIM** | 60324048 |
| **Mata Kuliah** | Pemrograman web 2 |
| **Dosen** | MOHAMMAD REZA MAULANA, M.KOM |

---

## Daftar Isi

1. [Deskripsi Proyek](#deskripsi-proyek)
2. [Tugas 1 — Eksplorasi Database](#tugas-1--eksplorasi-database-40)
3. [Tugas 2 — Desain Database Lengkap](#tugas-2--desain-database-lengkap-60)
4. [ERD](#erd-entity-relationship-diagram)
5. [Cara Menjalankan](#cara-menjalankan)

---

## Deskripsi Proyek

Proyek ini berisi implementasi database perpustakaan menggunakan MySQL (MariaDB) via XAMPP. Database dirancang dengan relasi antar tabel menggunakan foreign key, dilengkapi fitur soft delete, dan stored procedure untuk operasi umum.

**Teknologi yang digunakan:**
- MySQL / MariaDB (via XAMPP)
- phpMyAdmin
- SQL

---

## Tugas 1 — Eksplorasi Database (40%)

File: `query_tugas.sql`

### 1. Statistik Buku

#### Total buku seluruhnya
```sql
SELECT COUNT(*) AS total_buku FROM buku;
```
> Screenshot hasil:

![Query 1 - Total Buku](screenshots/query_01_total_buku.png)

---

#### Total nilai inventaris
```sql
SELECT SUM(harga * stok) AS total_nilai_inventaris FROM buku;
```
> Screenshot hasil:

![Query 2 - Nilai Inventaris](screenshots/query_02_nilai_inventaris.png)

---

#### Rata-rata harga buku
```sql
SELECT AVG(harga) AS rata_rata_harga FROM buku;
```
> Screenshot hasil:

![Query 3 - Rata-rata Harga](screenshots/query_03_rata_harga.png)

---

#### Buku termahal
```sql
SELECT judul, harga FROM buku ORDER BY harga DESC LIMIT 1;
```
> Screenshot hasil:

![Query 4 - Buku Termahal](screenshots/query_04_buku_termahal.png)

---

#### Buku stok terbanyak
```sql
SELECT judul, stok FROM buku ORDER BY stok DESC LIMIT 1;
```
> Screenshot hasil:

![Query 5 - Stok Terbanyak](screenshots/query_05_stok_terbanyak.png)

---

### 2. Filter dan Pencarian

#### Buku Programming harga < 100.000
```sql
SELECT judul, pengarang, harga, stok
FROM buku
WHERE kategori = 'Programming' AND harga < 100000;
```
> Screenshot hasil:

![Query 6 - Programming < 100rb](screenshots/query_06_programming_murah.png)

---

#### Buku mengandung kata "PHP" atau "MySQL"
```sql
SELECT judul, pengarang, kategori, harga
FROM buku
WHERE judul LIKE '%PHP%' OR judul LIKE '%MySQL%';
```
> Screenshot hasil:

![Query 7 - PHP atau MySQL](screenshots/query_07_php_mysql.png)

---

#### Buku terbit tahun 2024
```sql
SELECT judul, pengarang, tahun_terbit, harga
FROM buku WHERE tahun_terbit = 2024;
```
> Screenshot hasil:

![Query 8 - Tahun 2024](screenshots/query_08_tahun_2024.png)

---

#### Buku stok antara 5-10
```sql
SELECT judul, pengarang, stok
FROM buku WHERE stok BETWEEN 5 AND 10;
```
> Screenshot hasil:

![Query 9 - Stok 5-10](screenshots/query_09_stok_5_10.png)

---

#### Buku karangan Budi Raharjo
```sql
SELECT judul, pengarang, kategori, harga, stok
FROM buku WHERE pengarang = 'Budi Raharjo';
```
> Screenshot hasil:

![Query 10 - Budi Raharjo](screenshots/query_10_budi_raharjo.png)

---

### 3. Grouping dan Agregasi

#### Jumlah buku per kategori
```sql
SELECT kategori, COUNT(*) AS jumlah_judul, SUM(stok) AS total_stok
FROM buku GROUP BY kategori;
```
> Screenshot hasil:

![Query 11 - Per Kategori](screenshots/query_11_per_kategori.png)

---

#### Rata-rata harga per kategori
```sql
SELECT kategori, ROUND(AVG(harga), 0) AS rata_rata_harga
FROM buku GROUP BY kategori;
```
> Screenshot hasil:

![Query 12 - Avg Harga Kategori](screenshots/query_12_avg_harga_kategori.png)

---

#### Kategori dengan nilai inventaris terbesar
```sql
SELECT kategori, SUM(harga * stok) AS total_nilai_inventaris
FROM buku GROUP BY kategori ORDER BY total_nilai_inventaris DESC LIMIT 1;
```
> Screenshot hasil:

![Query 13 - Inventaris Terbesar](screenshots/query_13_inventaris_terbesar.png)

---

### 4. Update Data

#### Naikkan harga Programming 5%
```sql
UPDATE buku SET harga = ROUND(harga * 1.05, 0)
WHERE kategori = 'Programming';
```
> Screenshot hasil:

![Query 14 - Update Harga](screenshots/query_14_update_harga.png)

---

#### Tambah stok 10 untuk stok < 5
```sql
UPDATE buku SET stok = stok + 10 WHERE stok < 5;
```
> Screenshot hasil:

![Query 15 - Update Stok](screenshots/query_15_update_stok.png)

---

### 5. Laporan Khusus

#### Buku yang perlu restocking (stok < 5)
```sql
SELECT judul, pengarang, kategori, stok
FROM buku WHERE stok < 5 ORDER BY stok ASC;
```
> Screenshot hasil:

![Query 16 - Restocking](screenshots/query_16_restocking.png)

---

#### Top 5 buku termahal
```sql
SELECT judul, pengarang, kategori, harga
FROM buku ORDER BY harga DESC LIMIT 5;
```
> Screenshot hasil:

![Query 17 - Top 5 Termahal](screenshots/query_17_top5_termahal.png)

---

## Tugas 2 — Desain Database Lengkap (60%)

File: `60324048_MuhammadShofyFuady_database.sql`

### Struktur Tabel

#### Tabel `kategori_buku`
| Kolom | Tipe | Keterangan |
|---|---|---|
| id_kategori | INT AUTO_INCREMENT | Primary Key |
| nama_kategori | VARCHAR(50) | Nama kategori, UNIQUE |
| deskripsi | TEXT | Deskripsi kategori |
| created_at | TIMESTAMP | Waktu dibuat |
| deleted_at | TIMESTAMP | Soft delete |

> Screenshot struktur:

![Struktur kategori_buku](screenshots/struktur_kategori_buku.png)

---

#### Tabel `penerbit`
| Kolom | Tipe | Keterangan |
|---|---|---|
| id_penerbit | INT AUTO_INCREMENT | Primary Key |
| nama_penerbit | VARCHAR(100) | Nama penerbit |
| alamat | TEXT | Alamat lengkap |
| telepon | VARCHAR(15) | Nomor telepon |
| email | VARCHAR(100) | Email penerbit |
| created_at | TIMESTAMP | Waktu dibuat |
| deleted_at | TIMESTAMP | Soft delete |

> Screenshot struktur:

![Struktur penerbit](screenshots/struktur_penerbit.png)

---

#### Tabel `rak` _(Bonus)_
| Kolom | Tipe | Keterangan |
|---|---|---|
| id_rak | INT AUTO_INCREMENT | Primary Key |
| kode_rak | VARCHAR(10) | Kode unik rak |
| lokasi | VARCHAR(100) | Lokasi fisik rak |
| kapasitas | INT | Kapasitas buku |
| created_at | TIMESTAMP | Waktu dibuat |
| deleted_at | TIMESTAMP | Soft delete |

> Screenshot struktur:

![Struktur rak](screenshots/struktur_rak.png)

---

#### Tabel `buku`
| Kolom | Tipe | Keterangan |
|---|---|---|
| id_buku | INT AUTO_INCREMENT | Primary Key |
| judul | VARCHAR(200) | Judul buku |
| pengarang | VARCHAR(100) | Nama pengarang |
| id_kategori | INT | FK → kategori_buku |
| id_penerbit | INT | FK → penerbit |
| id_rak | INT | FK → rak (Bonus) |
| tahun_terbit | YEAR | Tahun terbit |
| harga | DECIMAL(12,0) | Harga buku |
| stok | INT | Jumlah stok |
| isbn | VARCHAR(20) | ISBN unik |
| created_at | TIMESTAMP | Waktu dibuat |
| updated_at | TIMESTAMP | Waktu diperbarui |
| deleted_at | TIMESTAMP | Soft delete |

> Screenshot struktur:

![Struktur buku](screenshots/struktur_buku.png)

---

### Data Sample

- 7 kategori buku
- 7 penerbit
- 5 rak
- 18 buku dengan relasi yang benar

> Screenshot data tiap tabel:

![Data kategori_buku](screenshots/data_kategori_buku.png)
![Data penerbit](screenshots/data_penerbit.png)
![Data rak](screenshots/data_rak.png)
![Data buku](screenshots/data_buku.png)

---

### Query JOIN

#### Buku dengan nama kategori dan penerbit
```sql
SELECT b.judul, b.pengarang, k.nama_kategori AS kategori,
       p.nama_penerbit AS penerbit, b.tahun_terbit, b.harga, b.stok
FROM buku b
JOIN kategori_buku k ON b.id_kategori = k.id_kategori
JOIN penerbit p ON b.id_penerbit = p.id_penerbit
WHERE b.deleted_at IS NULL;
```
> Screenshot hasil:

![JOIN Buku](screenshots/join_buku_lengkap.png)

---

#### Jumlah buku per kategori
```sql
SELECT k.nama_kategori, COUNT(b.id_buku) AS jumlah_judul, SUM(b.stok) AS total_stok
FROM kategori_buku k
LEFT JOIN buku b ON k.id_kategori = b.id_kategori AND b.deleted_at IS NULL
GROUP BY k.id_kategori;
```
> Screenshot hasil:

![JOIN Per Kategori](screenshots/join_per_kategori.png)

---

#### Jumlah buku per penerbit
```sql
SELECT p.nama_penerbit, COUNT(b.id_buku) AS jumlah_judul
FROM penerbit p
LEFT JOIN buku b ON p.id_penerbit = b.id_penerbit AND b.deleted_at IS NULL
GROUP BY p.id_penerbit;
```
> Screenshot hasil:

![JOIN Per Penerbit](screenshots/join_per_penerbit.png)

---

## ERD (Entity Relationship Diagram)

![ERD Perpustakaan](screenshots/erd_perpustakaan.png)

**Relasi antar tabel:**
- `kategori_buku` ← one-to-many → `buku` (via `id_kategori`)
- `penerbit` ← one-to-many → `buku` (via `id_penerbit`)
- `rak` ← one-to-many → `buku` (via `id_rak`) _(Bonus)_

---

## Cara Menjalankan

1. Install XAMPP dan jalankan Apache + MySQL
2. Buka `localhost/phpmyadmin` di browser
3. Klik menu **Import** → pilih file `NIM_Nama_database.sql` → klik **Go**
4. Database `perpustakaan` otomatis terbuat beserta semua tabel dan data
5. Untuk menjalankan query Tugas 1, klik database `perpustakaan` → tab **SQL** → paste query dari `query_tugas.sql`

---

## Fitur Bonus

- **Tabel `rak`** — relasi buku ke lokasi rak fisik di perpustakaan
- **Soft delete** — semua tabel punya kolom `deleted_at` sehingga data tidak benar-benar terhapus
- **Stored Procedure** — 5 procedure siap pakai:
  - `sp_tambah_buku` — menambah buku baru
  - `sp_hapus_buku` — soft delete buku
  - `sp_restore_buku` — memulihkan buku yang dihapus
  - `sp_update_stok` — menambah stok buku
  - `sp_laporan_kategori` — laporan ringkasan per kategori
