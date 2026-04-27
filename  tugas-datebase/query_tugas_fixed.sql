-- ============================================================
-- TUGAS 1: EKSPLORASI DATABASE PERPUSTAKAAN
-- File: query_tugas_fixed.sql
-- Fix : Kolom 'kategori' tidak ada di tabel buku (skema relasional).
--       Semua query yang butuh nama kategori kini pakai JOIN ke
--       tabel kategori_buku.
-- ============================================================

USE perpustakaan;

-- ============================================================
-- BAGIAN 1: STATISTIK BUKU
-- ============================================================

-- 1.1 Total buku seluruhnya
SELECT COUNT(*) AS total_buku
FROM buku;

-- 1.2 Total nilai inventaris
SELECT
    SUM(harga * stok)              AS total_nilai_inventaris,
    FORMAT(SUM(harga * stok), 0)   AS total_nilai_inventaris_format
FROM buku;

-- 1.3 Rata-rata harga buku
SELECT
    AVG(harga)            AS rata_rata_harga,
    FORMAT(AVG(harga), 0) AS rata_rata_harga_format
FROM buku;

-- 1.4 Buku termahal
SELECT judul, harga
FROM buku
ORDER BY harga DESC
LIMIT 1;

-- 1.5 Buku dengan stok terbanyak
SELECT judul, stok
FROM buku
ORDER BY stok DESC
LIMIT 1;


-- ============================================================
-- BAGIAN 2: FILTER DAN PENCARIAN
-- ============================================================

-- 2.1 Semua buku kategori Programming dengan harga < 100.000
--     FIX: JOIN kategori_buku, filter via nama_kategori
SELECT b.judul, b.pengarang, b.harga, b.stok
FROM buku b
JOIN kategori_buku k ON b.id_kategori = k.id_kategori
WHERE k.nama_kategori = 'Programming'
  AND b.harga < 100000;

-- 2.2 Buku yang judulnya mengandung kata "PHP" atau "MySQL"
--     FIX: tambah k.nama_kategori di SELECT, JOIN kategori_buku
SELECT b.judul, b.pengarang, k.nama_kategori AS kategori, b.harga
FROM buku b
JOIN kategori_buku k ON b.id_kategori = k.id_kategori
WHERE b.judul LIKE '%PHP%'
   OR b.judul LIKE '%MySQL%';

-- 2.3 Buku yang terbit tahun 2024
SELECT judul, pengarang, tahun_terbit, harga
FROM buku
WHERE tahun_terbit = 2024;

-- 2.4 Buku yang stoknya antara 5-10
SELECT judul, pengarang, stok
FROM buku
WHERE stok BETWEEN 5 AND 10
ORDER BY stok ASC;

-- 2.5 Buku yang pengarangnya "Budi Raharjo"
--     FIX: tambah JOIN untuk tampilkan nama kategori
SELECT b.judul, b.pengarang, k.nama_kategori AS kategori, b.harga, b.stok
FROM buku b
JOIN kategori_buku k ON b.id_kategori = k.id_kategori
WHERE b.pengarang = 'Budi Raharjo';


-- ============================================================
-- BAGIAN 3: GROUPING DAN AGREGASI
-- ============================================================

-- 3.1 Jumlah buku per kategori beserta total stok
--     FIX: GROUP BY k.id_kategori, JOIN kategori_buku
SELECT
    k.nama_kategori         AS kategori,
    COUNT(*)                AS jumlah_judul,
    SUM(b.stok)             AS total_stok
FROM buku b
JOIN kategori_buku k ON b.id_kategori = k.id_kategori
GROUP BY k.id_kategori, k.nama_kategori
ORDER BY jumlah_judul DESC;

-- 3.2 Rata-rata harga buku per kategori
SELECT
    k.nama_kategori                   AS kategori,
    COUNT(*)                          AS jumlah_buku,
    ROUND(AVG(b.harga), 0)            AS rata_rata_harga,
    FORMAT(AVG(b.harga), 0)           AS rata_rata_harga_format
FROM buku b
JOIN kategori_buku k ON b.id_kategori = k.id_kategori
GROUP BY k.id_kategori, k.nama_kategori
ORDER BY rata_rata_harga DESC;

-- 3.3 Kategori dengan total nilai inventaris terbesar
SELECT
    k.nama_kategori                        AS kategori,
    SUM(b.harga * b.stok)                  AS total_nilai_inventaris,
    FORMAT(SUM(b.harga * b.stok), 0)       AS total_nilai_format
FROM buku b
JOIN kategori_buku k ON b.id_kategori = k.id_kategori
GROUP BY k.id_kategori, k.nama_kategori
ORDER BY total_nilai_inventaris DESC
LIMIT 1;


-- ============================================================
-- BAGIAN 4: UPDATE DATA
-- ============================================================

-- 4.1 Naikkan harga semua buku kategori Programming sebesar 5%
--     FIX: subquery untuk dapat id_kategori dari nama 'Programming'

-- Cek sebelum update
SELECT b.judul, b.harga AS harga_sebelum
FROM buku b
JOIN kategori_buku k ON b.id_kategori = k.id_kategori
WHERE k.nama_kategori = 'Programming';

UPDATE buku
SET harga = ROUND(harga * 1.05, 0)
WHERE id_kategori = (
    SELECT id_kategori FROM kategori_buku WHERE nama_kategori = 'Programming'
);

-- Cek sesudah update
SELECT b.judul, b.harga AS harga_sesudah
FROM buku b
JOIN kategori_buku k ON b.id_kategori = k.id_kategori
WHERE k.nama_kategori = 'Programming';

-- 4.2 Tambah stok 10 untuk semua buku yang stoknya < 5
-- Cek sebelum update
SELECT judul, stok AS stok_sebelum
FROM buku
WHERE stok < 5;

UPDATE buku
SET stok = stok + 10
WHERE stok < 5;

-- Cek sesudah update
SELECT judul, stok AS stok_sesudah
FROM buku
WHERE stok < 15
ORDER BY stok ASC;


-- ============================================================
-- BAGIAN 5: LAPORAN KHUSUS
-- ============================================================

-- 5.1 Daftar buku yang perlu restocking (stok < 5)
--     FIX: JOIN untuk tampilkan nama kategori
SELECT
    b.judul,
    b.pengarang,
    k.nama_kategori    AS kategori,
    b.stok,
    'Perlu Restocking' AS status
FROM buku b
JOIN kategori_buku k ON b.id_kategori = k.id_kategori
WHERE b.stok < 5
ORDER BY b.stok ASC;

-- 5.2 Top 5 buku termahal
--     FIX: JOIN untuk tampilkan nama kategori
SELECT
    ROW_NUMBER() OVER (ORDER BY b.harga DESC) AS peringkat,
    b.judul,
    b.pengarang,
    k.nama_kategori   AS kategori,
    b.harga,
    FORMAT(b.harga, 0) AS harga_format
FROM buku b
JOIN kategori_buku k ON b.id_kategori = k.id_kategori
ORDER BY b.harga DESC
LIMIT 5;
