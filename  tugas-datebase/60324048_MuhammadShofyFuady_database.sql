-- ============================================================
-- TUGAS 2: DESAIN DATABASE PERPUSTAKAAN LENGKAP
-- File  : NIM_Nama_database.sql
-- Fitur : Tabel relasional, FK, soft delete, stored procedure,
--         tabel rak (BONUS)
-- ============================================================

-- ============================================================
-- BAGIAN 0: SETUP DATABASE
-- ============================================================

DROP DATABASE IF EXISTS perpustakaan;
CREATE DATABASE perpustakaan
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE perpustakaan;


-- ============================================================
-- BAGIAN 1: CREATE TABLE
-- ============================================================

-- 1A. Tabel kategori_buku
CREATE TABLE kategori_buku (
    id_kategori   INT AUTO_INCREMENT PRIMARY KEY,
    nama_kategori VARCHAR(50)  NOT NULL UNIQUE,
    deskripsi     TEXT,
    created_at    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    deleted_at    TIMESTAMP    NULL DEFAULT NULL   -- soft delete
);

-- 1B. Tabel penerbit
CREATE TABLE penerbit (
    id_penerbit   INT AUTO_INCREMENT PRIMARY KEY,
    nama_penerbit VARCHAR(100) NOT NULL,
    alamat        TEXT,
    telepon       VARCHAR(15),
    email         VARCHAR(100),
    created_at    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    deleted_at    TIMESTAMP    NULL DEFAULT NULL   -- soft delete
);

-- 1C. Tabel rak (BONUS)
CREATE TABLE rak (
    id_rak     INT AUTO_INCREMENT PRIMARY KEY,
    kode_rak   VARCHAR(10)  NOT NULL UNIQUE,
    lokasi     VARCHAR(100) NOT NULL,
    kapasitas  INT          NOT NULL DEFAULT 50,
    created_at TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP    NULL DEFAULT NULL      -- soft delete
);

-- 1D. Tabel buku (dimodifikasi dengan FK)
CREATE TABLE buku (
    id_buku      INT AUTO_INCREMENT PRIMARY KEY,
    judul        VARCHAR(200) NOT NULL,
    pengarang    VARCHAR(100) NOT NULL,
    id_kategori  INT          NOT NULL,
    id_penerbit  INT          NOT NULL,
    id_rak       INT          NULL,                -- FK ke rak (BONUS)
    tahun_terbit YEAR         NOT NULL,
    harga        DECIMAL(12,0) NOT NULL,
    stok         INT          NOT NULL DEFAULT 0,
    isbn         VARCHAR(20)  UNIQUE,
    created_at   TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at   TIMESTAMP    NULL DEFAULT NULL,   -- soft delete

    CONSTRAINT fk_buku_kategori
        FOREIGN KEY (id_kategori) REFERENCES kategori_buku(id_kategori)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_buku_penerbit
        FOREIGN KEY (id_penerbit) REFERENCES penerbit(id_penerbit)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_buku_rak
        FOREIGN KEY (id_rak) REFERENCES rak(id_rak)
        ON UPDATE CASCADE ON DELETE SET NULL
);


-- ============================================================
-- BAGIAN 2: INSERT DATA SAMPLE
-- ============================================================

-- 2A. Data kategori_buku (7 kategori)
INSERT INTO kategori_buku (nama_kategori, deskripsi) VALUES
('Programming',      'Buku pemrograman komputer, algoritma, dan pengembangan perangkat lunak'),
('Database',         'Buku manajemen basis data, SQL, dan sistem informasi'),
('Jaringan',         'Buku jaringan komputer, keamanan sistem, dan infrastruktur IT'),
('Desain Grafis',    'Buku desain visual, UI/UX, dan multimedia digital'),
('Sistem Operasi',   'Buku tentang OS Linux, Windows, dan administrasi sistem'),
('Web Development',  'Buku pengembangan web, front-end, back-end, dan full-stack'),
('Kecerdasan Buatan','Buku machine learning, deep learning, dan AI terapan');

-- 2B. Data penerbit (7 penerbit)
INSERT INTO penerbit (nama_penerbit, alamat, telepon, email) VALUES
('Informatika Bandung',
    'Jl. Pasir Putih No.12, Bandung, Jawa Barat 40135',
    '022-7531234', 'info@informatika.co.id'),
('Andi Publisher',
    'Jl. Beo No.38-40, Yogyakarta 55281',
    '0274-561881', 'andi@andipublisher.com'),
('Elex Media Komputindo',
    'Jl. Palmerah Barat No.29-37, Jakarta 10270',
    '021-5300880', 'elex@elex.co.id'),
('Graha Ilmu',
    'Jl. Raya Ring Road Barat No.72, Sleman, Yogyakarta',
    '0274-620098', 'grahai@grahaIlmu.co.id'),
('Deepublish',
    'Jl. Rajawali No.14, Yogyakarta 55166',
    '0274-453932', 'penerbit@deepublish.co.id'),
('Lokomedia',
    'Jl. Nogotirto III No.11, Sleman, Yogyakarta',
    '0274-620976', 'info@lokomedia.co.id'),
('Teknokrat Press',
    'Jl. ZA. Pagar Alam No.9-11, Bandar Lampung',
    '0721-702022', 'press@teknokrat.ac.id');

-- 2C. Data rak (BONUS – 5 rak)
INSERT INTO rak (kode_rak, lokasi, kapasitas) VALUES
('RAK-A1', 'Lantai 1 – Sayap Kiri, baris 1',  40),
('RAK-A2', 'Lantai 1 – Sayap Kiri, baris 2',  40),
('RAK-B1', 'Lantai 1 – Sayap Kanan, baris 1', 35),
('RAK-B2', 'Lantai 1 – Sayap Kanan, baris 2', 35),
('RAK-C1', 'Lantai 2 – Tengah, baris 1',       50);

-- 2D. Data buku (18 buku)
INSERT INTO buku (judul, pengarang, id_kategori, id_penerbit, id_rak, tahun_terbit, harga, stok, isbn) VALUES
-- Programming
('Belajar PHP dari Nol',           'Budi Raharjo',     1, 1, 1, 2023,  89000, 12, '978-602-123-001-1'),
('Pemrograman Python Modern',       'Ahmad Fauzi',      1, 2, 1, 2024, 110000,  8, '978-602-123-002-2'),
('Struktur Data & Algoritma C++',   'Budi Raharjo',     1, 3, 1, 2022,  95000,  3, '978-602-123-003-3'),
('JavaScript untuk Pemula',         'Rina Kusuma',      1, 4, 1, 2024,  78000, 15, '978-602-123-004-4'),
('Pemrograman Java SE 17',          'Dian Pratama',     1, 2, 1, 2023, 125000,  6, '978-602-123-005-5'),

-- Database
('MySQL untuk Pemula',              'Budi Raharjo',     2, 1, 2, 2023,  85000, 10, '978-602-123-006-6'),
('PostgreSQL Database Administration','Siti Aminah',    2, 3, 2, 2024, 135000,  4, '978-602-123-007-7'),
('Desain Basis Data Relasional',    'Hendra Wijaya',    2, 5, 2, 2022,  99000,  7, '978-602-123-008-8'),

-- Web Development
('HTML & CSS3 Modern',              'Rina Kusuma',      6, 4, 3, 2024,  72000, 18, '978-602-123-009-9'),
('Laravel 11 Framework',            'Ahmad Fauzi',      6, 2, 3, 2024, 145000,  9, '978-602-123-010-0'),
('React.js Fundamental',            'Dian Pratama',     6, 3, 3, 2023, 119000,  5, '978-602-123-011-1'),
('Full-Stack dengan Next.js',       'Yudi Santoso',     6, 6, 3, 2024, 155000,  2, '978-602-123-012-2'),

-- Jaringan
('Jaringan Komputer dan Internet',  'Hendra Wijaya',    3, 1, 4, 2022,  88000, 11, '978-602-123-013-3'),
('Keamanan Sistem Informasi',       'Siti Aminah',      3, 5, 4, 2023, 105000,  6, '978-602-123-014-4'),

-- Kecerdasan Buatan
('Machine Learning dengan Python',  'Ahmad Fauzi',      7, 2, 5, 2024, 175000,  7, '978-602-123-015-5'),
('Deep Learning TensorFlow',        'Yudi Santoso',     7, 3, 5, 2024, 195000,  3, '978-602-123-016-6'),

-- Desain Grafis
('Figma UI/UX Design Profesional',  'Rina Kusuma',      4, 6, 4, 2024,  98000,  8, '978-602-123-017-7'),

-- Sistem Operasi
('Administrasi Linux Ubuntu',       'Dian Pratama',     5, 7, 2, 2023,  92000,  4, '978-602-123-018-8');


-- ============================================================
-- BAGIAN 3: QUERY JOIN DAN LAPORAN
-- ============================================================

-- 3.1 JOIN: tampilkan buku dengan nama kategori dan nama penerbit
SELECT
    b.id_buku,
    b.judul,
    b.pengarang,
    k.nama_kategori AS kategori,
    p.nama_penerbit AS penerbit,
    b.tahun_terbit,
    FORMAT(b.harga, 0) AS harga,
    b.stok
FROM buku b
JOIN kategori_buku k ON b.id_kategori = k.id_kategori
JOIN penerbit       p ON b.id_penerbit  = p.id_penerbit
WHERE b.deleted_at IS NULL
ORDER BY k.nama_kategori, b.judul;

-- 3.2 Jumlah buku per kategori
SELECT
    k.nama_kategori,
    COUNT(b.id_buku)  AS jumlah_judul,
    SUM(b.stok)       AS total_stok,
    FORMAT(SUM(b.harga * b.stok), 0) AS nilai_inventaris
FROM kategori_buku k
LEFT JOIN buku b
    ON k.id_kategori = b.id_kategori AND b.deleted_at IS NULL
WHERE k.deleted_at IS NULL
GROUP BY k.id_kategori, k.nama_kategori
ORDER BY jumlah_judul DESC;

-- 3.3 Jumlah buku per penerbit
SELECT
    p.nama_penerbit,
    p.telepon,
    COUNT(b.id_buku)  AS jumlah_judul,
    SUM(b.stok)       AS total_stok
FROM penerbit p
LEFT JOIN buku b
    ON p.id_penerbit = b.id_penerbit AND b.deleted_at IS NULL
WHERE p.deleted_at IS NULL
GROUP BY p.id_penerbit, p.nama_penerbit
ORDER BY jumlah_judul DESC;

-- 3.4 Detail lengkap buku (kategori + penerbit + rak)
SELECT
    b.isbn,
    b.judul,
    b.pengarang,
    k.nama_kategori                AS kategori,
    p.nama_penerbit                AS penerbit,
    p.email                        AS email_penerbit,
    r.kode_rak                     AS rak,
    r.lokasi                       AS lokasi_rak,
    b.tahun_terbit,
    FORMAT(b.harga, 0)             AS harga,
    b.stok,
    FORMAT(b.harga * b.stok, 0)   AS nilai_inventaris
FROM buku b
JOIN kategori_buku k ON b.id_kategori = k.id_kategori
JOIN penerbit       p ON b.id_penerbit  = p.id_penerbit
LEFT JOIN rak       r ON b.id_rak       = r.id_rak
WHERE b.deleted_at IS NULL
ORDER BY b.judul;


-- ============================================================
-- BAGIAN 4: BONUS – STORED PROCEDURES
-- ============================================================

DELIMITER $$

-- SP 1: Tambah buku baru
CREATE PROCEDURE sp_tambah_buku(
    IN p_judul        VARCHAR(200),
    IN p_pengarang    VARCHAR(100),
    IN p_id_kategori  INT,
    IN p_id_penerbit  INT,
    IN p_id_rak       INT,
    IN p_tahun_terbit YEAR,
    IN p_harga        DECIMAL(12,0),
    IN p_stok         INT,
    IN p_isbn         VARCHAR(20)
)
BEGIN
    INSERT INTO buku (judul, pengarang, id_kategori, id_penerbit, id_rak,
                      tahun_terbit, harga, stok, isbn)
    VALUES (p_judul, p_pengarang, p_id_kategori, p_id_penerbit, p_id_rak,
            p_tahun_terbit, p_harga, p_stok, p_isbn);

    SELECT LAST_INSERT_ID() AS id_buku_baru,
           p_judul          AS judul,
           'Buku berhasil ditambahkan' AS pesan;
END$$

-- SP 2: Soft delete buku
CREATE PROCEDURE sp_hapus_buku(IN p_id_buku INT)
BEGIN
    UPDATE buku
    SET deleted_at = NOW()
    WHERE id_buku = p_id_buku
      AND deleted_at IS NULL;

    IF ROW_COUNT() > 0 THEN
        SELECT p_id_buku AS id_buku, 'Buku berhasil dihapus (soft delete)' AS pesan;
    ELSE
        SELECT p_id_buku AS id_buku, 'Buku tidak ditemukan atau sudah dihapus' AS pesan;
    END IF;
END$$

-- SP 3: Restore buku yang sudah di-soft-delete
CREATE PROCEDURE sp_restore_buku(IN p_id_buku INT)
BEGIN
    UPDATE buku
    SET deleted_at = NULL
    WHERE id_buku = p_id_buku
      AND deleted_at IS NOT NULL;

    IF ROW_COUNT() > 0 THEN
        SELECT p_id_buku AS id_buku, 'Buku berhasil dipulihkan' AS pesan;
    ELSE
        SELECT p_id_buku AS id_buku, 'Buku tidak ditemukan atau masih aktif' AS pesan;
    END IF;
END$$

-- SP 4: Update stok buku
CREATE PROCEDURE sp_update_stok(IN p_id_buku INT, IN p_stok_tambah INT)
BEGIN
    UPDATE buku
    SET stok = stok + p_stok_tambah
    WHERE id_buku = p_id_buku
      AND deleted_at IS NULL;

    SELECT id_buku, judul, stok AS stok_terbaru
    FROM buku
    WHERE id_buku = p_id_buku;
END$$

-- SP 5: Laporan ringkasan per kategori
CREATE PROCEDURE sp_laporan_kategori()
BEGIN
    SELECT
        k.nama_kategori,
        COUNT(b.id_buku)                AS total_judul,
        COALESCE(SUM(b.stok), 0)        AS total_stok,
        COALESCE(ROUND(AVG(b.harga),0), 0) AS rata_harga,
        FORMAT(COALESCE(SUM(b.harga * b.stok), 0), 0) AS nilai_inventaris
    FROM kategori_buku k
    LEFT JOIN buku b
        ON k.id_kategori = b.id_kategori AND b.deleted_at IS NULL
    WHERE k.deleted_at IS NULL
    GROUP BY k.id_kategori, k.nama_kategori
    ORDER BY total_judul DESC;
END$$

DELIMITER ;


-- ============================================================
-- BAGIAN 5: CONTOH PEMANGGILAN STORED PROCEDURE
-- ============================================================

-- Contoh tambah buku baru
-- CALL sp_tambah_buku('Vue.js 3 Mastery', 'Rina Kusuma', 6, 4, 3, 2024, 130000, 5, '978-602-999-001-1');

-- Contoh soft delete buku id=18
-- CALL sp_hapus_buku(18);

-- Contoh restore buku id=18
-- CALL sp_restore_buku(18);

-- Contoh tambah stok buku id=3 sebanyak 10
-- CALL sp_update_stok(3, 10);

-- Contoh laporan kategori
-- CALL sp_laporan_kategori();
