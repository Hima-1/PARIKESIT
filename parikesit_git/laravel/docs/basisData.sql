-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Dec 18, 2025 at 05:59 AM
-- Server version: 11.8.3-MariaDB-log
-- PHP Version: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `u357914986_parikesit`
--

-- --------------------------------------------------------

--
-- Table structure for table `aspeks`
--

CREATE TABLE `aspeks` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `domain_id` bigint(20) UNSIGNED NOT NULL,
  `nama_aspek` varchar(255) NOT NULL,
  `bobot_aspek` decimal(5,2) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `aspeks`
--

INSERT INTO `aspeks` (`id`, `domain_id`, `nama_aspek`, `bobot_aspek`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 1, 'Standar Data Statistik', 25.00, NULL, '2025-11-06 12:20:15', '2025-11-06 12:20:15'),
(2, 1, 'Metadata Statistik', 25.00, NULL, '2025-11-06 12:20:15', '2025-11-06 12:20:15'),
(3, 1, 'Interoperabilitas Data', 25.00, NULL, '2025-11-06 12:20:15', '2025-11-06 12:20:15'),
(4, 1, 'Kode Referensi dan atau Data Induk', 25.00, NULL, '2025-11-06 12:20:15', '2025-11-06 12:20:15'),
(5, 2, 'Relevansi', 21.00, NULL, '2025-11-06 12:20:15', '2025-11-06 12:20:15'),
(6, 2, 'Akurasi', 16.00, NULL, '2025-11-06 12:20:15', '2025-11-06 12:20:15'),
(7, 2, 'Aktualitas & Ketepatan Waktu', 21.00, NULL, '2025-11-06 12:20:15', '2025-11-06 12:20:15'),
(8, 2, 'Aksesibilitas', 21.00, NULL, '2025-11-06 12:20:15', '2025-11-06 12:20:15'),
(9, 2, 'Keterbandingan & Konsistensi', 21.00, NULL, '2025-11-06 12:20:15', '2025-11-06 12:20:15'),
(10, 3, 'Perencanaan Data', 32.00, NULL, '2025-11-06 12:20:15', '2025-11-06 12:20:15'),
(11, 3, 'Pengumpulan Data', 26.00, NULL, '2025-11-06 12:20:15', '2025-11-06 12:20:15'),
(12, 3, 'Pemeriksaan Data', 21.00, NULL, '2025-11-06 12:20:15', '2025-11-06 12:20:15'),
(13, 3, 'Penyebarluasan Data', 21.00, NULL, '2025-11-06 12:20:15', '2025-11-06 12:20:15'),
(14, 4, 'Profesionalitas', 35.00, NULL, '2025-11-06 12:20:15', '2025-11-06 12:20:15'),
(15, 4, 'SDM yang Memadai dan Kapabel', 30.00, NULL, '2025-11-06 12:20:15', '2025-11-06 12:20:15'),
(16, 4, 'Pengorganisasian Statistik', 35.00, NULL, '2025-11-06 12:20:15', '2025-11-06 12:20:15'),
(17, 5, 'Pemanfaatan Data Statistik', 34.00, NULL, '2025-11-06 12:20:15', '2025-11-06 12:20:15'),
(18, 5, 'Pengelolaan Kegiatan Statistik ', 33.00, NULL, '2025-11-06 12:20:15', '2025-11-06 12:20:15'),
(19, 5, 'Penguatan SSN Berkelanjutan', 33.00, NULL, '2025-11-06 12:20:15', '2025-11-06 12:20:15');

-- --------------------------------------------------------

--
-- Table structure for table `bukti_dukungs`
--

CREATE TABLE `bukti_dukungs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `penilaian_id` bigint(20) UNSIGNED NOT NULL,
  `path` varchar(255) NOT NULL,
  `nama_file` varchar(255) NOT NULL,
  `ukuran_file` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `dokumentasi_kegiatans`
--

CREATE TABLE `dokumentasi_kegiatans` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `created_by_id` bigint(20) UNSIGNED NOT NULL,
  `directory_dokumentasi` varchar(255) NOT NULL,
  `judul_dokumentasi` varchar(255) NOT NULL,
  `bukti_dukung_undangan_dokumentasi` varchar(255) NOT NULL,
  `daftar_hadir_dokumentasi` varchar(255) NOT NULL,
  `materi_dokumentasi` varchar(255) NOT NULL,
  `notula_dokumentasi` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `dokumentasi_kegiatans`
--

INSERT INTO `dokumentasi_kegiatans` (`id`, `created_by_id`, `directory_dokumentasi`, `judul_dokumentasi`, `bukti_dukung_undangan_dokumentasi`, `daftar_hadir_dokumentasi`, `materi_dokumentasi`, `notula_dokumentasi`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 49, 'kegiatan-admin-1762849890', 'kegiatan admin', 'file-dokumentasi/kegiatan-admin-1762849890\\bukti_dukung_undangan-1762849890.pdf', 'file-dokumentasi/kegiatan-admin-1762849890\\daftar_hadir-1762849890.pdf', 'file-dokumentasi/kegiatan-admin-1762849890\\materi-1762849890.pdf', 'file-dokumentasi/kegiatan-admin-1762849890\\notula-1762849890.pdf', '2025-11-11 08:31:30', '2025-11-11 08:31:30', NULL),
(2, 49, 'kegiatan-adminn-1763574611', 'kegiatan adminn', 'file-dokumentasi/kegiatan-adminn-1763574611/bukti_dukung_undangan-1763574611.pdf', 'file-dokumentasi/kegiatan-adminn-1763574611/daftar_hadir-1763574611.pdf', 'file-dokumentasi/kegiatan-adminn-1763574611/materi-1763574611.pdf', 'file-dokumentasi/kegiatan-adminn-1763574611/notula-1763574611.pdf', '2025-11-19 17:50:11', '2025-11-19 17:50:11', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `domains`
--

CREATE TABLE `domains` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nama_domain` varchar(255) NOT NULL,
  `bobot_domain` decimal(5,2) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `domains`
--

INSERT INTO `domains` (`id`, `nama_domain`, `bobot_domain`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 'Domain Prinsip SDI', 28.00, NULL, '2025-11-06 12:20:15', '2025-11-06 12:20:15'),
(2, 'Domain Kualitas Data', 24.00, NULL, '2025-11-06 12:20:15', '2025-11-06 12:20:15'),
(3, 'Domain Proses Bisnis Statistik', 19.00, NULL, '2025-11-06 12:20:15', '2025-11-06 12:20:15'),
(4, 'Domain Kelembagaan', 17.00, NULL, '2025-11-06 12:20:15', '2025-11-06 12:20:15'),
(5, 'Domain Statistik Nasional', 12.00, NULL, '2025-11-06 12:20:15', '2025-11-06 12:20:15');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `file_dokumentasis`
--

CREATE TABLE `file_dokumentasis` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `dokumentasi_kegiatan_id` bigint(20) UNSIGNED NOT NULL,
  `nama_file` text NOT NULL,
  `tipe_file` enum('png','jpg','jpeg','mp4','pdf','docx','xlsx','pptx','zip','rar') NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `file_dokumentasis`
--

INSERT INTO `file_dokumentasis` (`id`, `dokumentasi_kegiatan_id`, `nama_file`, `tipe_file`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 1, 'file-dokumentasi/kegiatan-admin-1762849890/media/media-0-1762849890.png', 'png', NULL, '2025-11-11 08:31:30', '2025-11-11 08:31:30'),
(2, 1, 'file-dokumentasi/kegiatan-admin-1762849890/media/media-1-1762849890.jpeg', 'jpeg', NULL, '2025-11-11 08:31:30', '2025-11-11 08:31:30'),
(3, 2, 'file-dokumentasi/kegiatan-adminn-1763574611/media/media-0-1763574611.jpeg', 'png', NULL, '2025-11-19 17:50:11', '2025-11-19 17:50:11'),
(4, 2, 'file-dokumentasi/kegiatan-adminn-1763574611/media/media-0-1763574611.jpeg', 'jpeg', NULL, '2025-11-19 17:50:11', '2025-11-19 17:50:11');

-- --------------------------------------------------------

--
-- Table structure for table `file_pembinaans`
--

CREATE TABLE `file_pembinaans` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `pembinaan_id` bigint(20) UNSIGNED NOT NULL,
  `nama_file` text NOT NULL,
  `tipe_file` enum('png','jpg','jpeg','mp4','pdf','docx','xlsx','pptx','zip','rar') NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `file_pembinaans`
--

INSERT INTO `file_pembinaans` (`id`, `pembinaan_id`, `nama_file`, `tipe_file`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 1, 'file-pembinaan/kegiatan-lingkungan-hidup-1762845157/media/media-0-1762845157.png', 'png', NULL, '2025-11-11 07:12:37', '2025-11-11 07:12:37'),
(2, 1, 'file-pembinaan/kegiatan-lingkungan-hidup-1762845157/media/media-1-1762845157.png', 'png', NULL, '2025-11-11 07:12:37', '2025-11-11 07:12:37'),
(3, 2, 'file-pembinaan/kegiatan-inspektorat-1762845832/media/media-0-1762845832.jpg', 'jpg', NULL, '2025-11-11 07:23:52', '2025-11-11 07:23:52'),
(4, 2, 'file-pembinaan/kegiatan-inspektorat-1762845832/media/media-1-1762845832.png', 'png', NULL, '2025-11-11 07:23:52', '2025-11-11 07:23:52'),
(5, 3, 'file-pembinaan/kegiatan-diskominfo-1762849016/media/media-0-1762849016.png', 'png', NULL, '2025-11-11 08:16:56', '2025-11-11 08:16:56'),
(6, 3, 'file-pembinaan/kegiatan-diskominfo-1762849016/media/media-1-1762849016.png', 'png', NULL, '2025-11-11 08:16:56', '2025-11-11 08:16:56'),
(7, 4, 'file-pembinaan/kegiatan-lingkungan-hidup-2222-1763536664/media/media-0-1763536664.jpeg', 'jpeg', NULL, '2025-11-19 07:17:44', '2025-11-19 07:17:44'),
(8, 4, 'file-pembinaan/kegiatan-lingkungan-hidup-2222-1763536664/media/media-1-1763536664.png', 'png', NULL, '2025-11-19 07:17:44', '2025-11-19 07:17:44'),
(10, 6, 'file-pembinaan/kegiatan-lingkungan-hidup-1234-1763573347/media/media-0-1763573347.jpeg', 'jpeg', NULL, '2025-11-19 17:29:07', '2025-11-19 17:29:07');

-- --------------------------------------------------------

--
-- Table structure for table `formulirs`
--

CREATE TABLE `formulirs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nama_formulir` varchar(255) NOT NULL,
  `tanggal_dibuat` date NOT NULL DEFAULT '2025-11-05',
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_by_id` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `formulirs`
--

INSERT INTO `formulirs` (`id`, `nama_formulir`, `tanggal_dibuat`, `deleted_at`, `created_at`, `updated_at`, `created_by_id`) VALUES
(1, 'kegiatan lingkungan hidup 2023', '2025-11-06', NULL, '2025-11-06 12:20:14', '2025-11-06 12:20:14', 16),
(2, 'kegiatan lingkungan hidup 2024', '2025-11-06', NULL, '2025-11-06 12:20:49', '2025-11-06 12:20:49', 16),
(3, 'kegiatan lingkungan hidup 2025', '2025-11-10', NULL, '2025-11-09 17:11:44', '2025-11-09 17:11:44', 16),
(4, 'kegiatan inspektorat daerah 2023', '2025-11-11', NULL, '2025-11-11 07:14:17', '2025-11-11 07:14:17', 2),
(5, 'Kompilasi Program Inovasi Daerah Pemerintah Kabupaten Klaten', '2025-11-18', NULL, '2025-11-18 01:17:47', '2025-11-18 01:17:47', 22),
(6, 'Kompilasi Data Kejadian Bencana di Kabupaten Klaten', '2025-11-18', NULL, '2025-11-18 07:02:43', '2025-11-18 07:02:43', 24),
(7, 'Kompilasi Peraturan Daerah Kabupaten Klaten', '2025-11-18', NULL, '2025-11-18 08:44:51', '2025-11-18 08:44:51', 3),
(8, 'Kompilasi Data Laporan Keuangan Pemerintah Daerah Kabupaten Klaten', '2025-11-19', NULL, '2025-11-19 03:15:43', '2025-11-19 03:15:43', 21),
(9, 'Kompilasi Data', '2025-11-19', NULL, '2025-11-19 03:16:16', '2025-11-19 03:16:16', 18),
(10, 'KOMPILASI DATA KEPEGAWAIAN KABUPATEN KLATEN', '2025-11-19', NULL, '2025-11-19 03:16:22', '2025-11-19 03:16:22', 20),
(11, 'Kompilasi Data Kesehatan Kabupaten Klaten', '2025-11-19', NULL, '2025-11-19 03:19:00', '2025-11-19 03:19:00', 7),
(12, 'kegiatan lingkungan hidup 2022', '2025-11-19', NULL, '2025-11-19 17:05:59', '2025-11-19 17:05:59', 16);

-- --------------------------------------------------------

--
-- Table structure for table `formulir_domains`
--

CREATE TABLE `formulir_domains` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `formulir_id` bigint(20) UNSIGNED NOT NULL,
  `domain_id` bigint(20) UNSIGNED NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `formulir_domains`
--

INSERT INTO `formulir_domains` (`id`, `formulir_id`, `domain_id`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 1, 1, NULL, '2025-11-06 12:20:21', '2025-11-06 12:20:21'),
(2, 1, 2, NULL, '2025-11-06 12:20:21', '2025-11-06 12:20:21'),
(3, 1, 3, NULL, '2025-11-06 12:20:21', '2025-11-06 12:20:21'),
(4, 1, 4, NULL, '2025-11-06 12:20:21', '2025-11-06 12:20:21'),
(5, 1, 5, NULL, '2025-11-06 12:20:21', '2025-11-06 12:20:21'),
(6, 2, 1, NULL, '2025-11-06 12:20:59', '2025-11-06 12:20:59'),
(7, 2, 2, NULL, '2025-11-06 12:20:59', '2025-11-06 12:20:59'),
(8, 2, 3, NULL, '2025-11-06 12:20:59', '2025-11-06 12:20:59'),
(9, 2, 4, NULL, '2025-11-06 12:20:59', '2025-11-06 12:20:59'),
(10, 2, 5, NULL, '2025-11-06 12:20:59', '2025-11-06 12:20:59'),
(11, 3, 1, NULL, '2025-11-09 17:11:49', '2025-11-09 17:11:49'),
(12, 3, 2, NULL, '2025-11-09 17:11:49', '2025-11-09 17:11:49'),
(13, 3, 3, NULL, '2025-11-09 17:11:49', '2025-11-09 17:11:49'),
(14, 3, 4, NULL, '2025-11-09 17:11:49', '2025-11-09 17:11:49'),
(15, 3, 5, NULL, '2025-11-09 17:11:49', '2025-11-09 17:11:49'),
(16, 4, 1, NULL, '2025-11-11 07:14:21', '2025-11-11 07:14:21'),
(17, 4, 2, NULL, '2025-11-11 07:14:21', '2025-11-11 07:14:21'),
(18, 4, 3, NULL, '2025-11-11 07:14:21', '2025-11-11 07:14:21'),
(19, 4, 4, NULL, '2025-11-11 07:14:21', '2025-11-11 07:14:21'),
(20, 4, 5, NULL, '2025-11-11 07:14:21', '2025-11-11 07:14:21'),
(21, 5, 1, NULL, '2025-11-18 01:18:04', '2025-11-18 01:18:04'),
(22, 5, 2, NULL, '2025-11-18 01:18:04', '2025-11-18 01:18:04'),
(23, 5, 3, NULL, '2025-11-18 01:18:04', '2025-11-18 01:18:04'),
(24, 5, 4, NULL, '2025-11-18 01:18:04', '2025-11-18 01:18:04'),
(25, 5, 5, NULL, '2025-11-18 01:18:04', '2025-11-18 01:18:04'),
(26, 6, 1, NULL, '2025-11-18 07:02:53', '2025-11-18 07:02:53'),
(27, 6, 2, NULL, '2025-11-18 07:02:53', '2025-11-18 07:02:53'),
(28, 6, 3, NULL, '2025-11-18 07:02:53', '2025-11-18 07:02:53'),
(29, 6, 4, NULL, '2025-11-18 07:02:53', '2025-11-18 07:02:53'),
(30, 6, 5, NULL, '2025-11-18 07:02:53', '2025-11-18 07:02:53'),
(31, 7, 1, NULL, '2025-11-18 08:45:17', '2025-11-18 08:45:17'),
(32, 7, 2, NULL, '2025-11-18 08:45:17', '2025-11-18 08:45:17'),
(33, 7, 3, NULL, '2025-11-18 08:45:17', '2025-11-18 08:45:17'),
(34, 7, 4, NULL, '2025-11-18 08:45:17', '2025-11-18 08:45:17'),
(35, 7, 5, NULL, '2025-11-18 08:45:17', '2025-11-18 08:45:17'),
(36, 8, 1, NULL, '2025-11-19 03:16:06', '2025-11-19 03:16:06'),
(37, 8, 2, NULL, '2025-11-19 03:16:06', '2025-11-19 03:16:06'),
(38, 8, 3, NULL, '2025-11-19 03:16:06', '2025-11-19 03:16:06'),
(39, 8, 4, NULL, '2025-11-19 03:16:06', '2025-11-19 03:16:06'),
(40, 8, 5, NULL, '2025-11-19 03:16:06', '2025-11-19 03:16:06'),
(41, 9, 1, NULL, '2025-11-19 03:16:30', '2025-11-19 03:16:30'),
(42, 9, 2, NULL, '2025-11-19 03:16:30', '2025-11-19 03:16:30'),
(43, 9, 3, NULL, '2025-11-19 03:16:30', '2025-11-19 03:16:30'),
(44, 9, 4, NULL, '2025-11-19 03:16:30', '2025-11-19 03:16:30'),
(45, 9, 5, NULL, '2025-11-19 03:16:30', '2025-11-19 03:16:30'),
(46, 10, 1, NULL, '2025-11-19 03:16:40', '2025-11-19 03:16:40'),
(47, 10, 2, NULL, '2025-11-19 03:16:40', '2025-11-19 03:16:40'),
(48, 10, 3, NULL, '2025-11-19 03:16:40', '2025-11-19 03:16:40'),
(49, 10, 4, NULL, '2025-11-19 03:16:40', '2025-11-19 03:16:40'),
(50, 10, 5, NULL, '2025-11-19 03:16:40', '2025-11-19 03:16:40'),
(51, 11, 1, NULL, '2025-11-19 03:19:57', '2025-11-19 03:19:57'),
(52, 11, 2, NULL, '2025-11-19 03:19:57', '2025-11-19 03:19:57'),
(53, 11, 3, NULL, '2025-11-19 03:19:57', '2025-11-19 03:19:57'),
(54, 11, 4, NULL, '2025-11-19 03:19:57', '2025-11-19 03:19:57'),
(55, 11, 5, NULL, '2025-11-19 03:19:57', '2025-11-19 03:19:57'),
(56, 12, 1, NULL, '2025-11-19 17:06:03', '2025-11-19 17:06:03'),
(57, 12, 2, NULL, '2025-11-19 17:06:03', '2025-11-19 17:06:03'),
(58, 12, 3, NULL, '2025-11-19 17:06:03', '2025-11-19 17:06:03'),
(59, 12, 4, NULL, '2025-11-19 17:06:03', '2025-11-19 17:06:03'),
(60, 12, 5, NULL, '2025-11-19 17:06:03', '2025-11-19 17:06:03');

-- --------------------------------------------------------

--
-- Table structure for table `formulir_penilaian_disposisis`
--

CREATE TABLE `formulir_penilaian_disposisis` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `formulir_id` bigint(20) UNSIGNED NOT NULL,
  `indikator_id` bigint(20) UNSIGNED DEFAULT NULL,
  `from_profile_id` bigint(20) UNSIGNED DEFAULT NULL,
  `to_profile_id` bigint(20) UNSIGNED DEFAULT NULL,
  `assigned_profile_id` bigint(20) UNSIGNED DEFAULT NULL,
  `status` enum('sent','returned','approved','rejected') NOT NULL DEFAULT 'sent',
  `catatan` text DEFAULT NULL,
  `is_completed` tinyint(1) NOT NULL DEFAULT 0,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `indikators`
--

CREATE TABLE `indikators` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `aspek_id` bigint(20) UNSIGNED NOT NULL,
  `nama_indikator` varchar(255) NOT NULL,
  `bobot_indikator` decimal(5,2) DEFAULT NULL,
  `level_1_kriteria` text DEFAULT NULL,
  `level_2_kriteria` text DEFAULT NULL,
  `level_3_kriteria` text DEFAULT NULL,
  `level_4_kriteria` text DEFAULT NULL,
  `level_5_kriteria` text DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `kode_indikator` varchar(255) DEFAULT NULL,
  `level_1_kriteria_10101` text DEFAULT NULL,
  `level_2_kriteria_10101` text DEFAULT NULL,
  `level_3_kriteria_10101` text DEFAULT NULL,
  `level_4_kriteria_10101` text DEFAULT NULL,
  `level_5_kriteria_10101` text DEFAULT NULL,
  `level_1_kriteria_10201` text DEFAULT NULL,
  `level_2_kriteria_10201` text DEFAULT NULL,
  `level_3_kriteria_10201` text DEFAULT NULL,
  `level_4_kriteria_10201` text DEFAULT NULL,
  `level_5_kriteria_10201` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `indikators`
--

INSERT INTO `indikators` (`id`, `aspek_id`, `nama_indikator`, `bobot_indikator`, `level_1_kriteria`, `level_2_kriteria`, `level_3_kriteria`, `level_4_kriteria`, `level_5_kriteria`, `deleted_at`, `created_at`, `updated_at`, `kode_indikator`, `level_1_kriteria_10101`, `level_2_kriteria_10101`, `level_3_kriteria_10101`, `level_4_kriteria_10101`, `level_5_kriteria_10101`, `level_1_kriteria_10201`, `level_2_kriteria_10201`, `level_3_kriteria_10201`, `level_4_kriteria_10201`, `level_5_kriteria_10201`) VALUES
(1, 1, 'Tingkat Kematangan Penerapan Standar Data Statistik (SDS)', 100.00, 'Penerapan Standar Data Statistik (SDS) belum dilakukan oleh seluruh Produsen Data', 'Penerapan Standar Data Statistik (SDS) telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing', 'Penerapan Standar Data Statistik (SDS) telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data', 'Penerapan Standar Data Statistik (SDS) telah dilakukan reviu dan evaluasi secara berkala', 'Penerapan Standar Data Statistik (SDS) telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2, 2, 'Tingkat Kematangan Penerapan Metadata Statistik', 100.00, 'Penerapan Metadata Statistik belum dilakukan oleh seluruh Produsen Data', 'Penerapan Metadata Statistik telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing', 'Penerapan Metadata Statistik telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data', 'Penerapan Metadata Statistik telah dilakukan reviu dan evaluasi secara berkala', 'Penerapan Metadata Statistik telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(3, 3, 'Tingkat Kematangan Penerapan Interoperabilitas Data', 100.00, 'Penerapan Interoperabilitas Data belum dilakukan oleh seluruh Produsen Data', 'Penerapan Interoperabilitas Data telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing', 'Penerapan Interoperabilitas Data telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data', 'Penerapan Interoperabilitas Data telah dilakukan reviu dan evaluasi secara berkala', 'Penerapan Interoperabilitas Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(4, 4, 'Tingkat Kematangan Penerapan Kode Referensi', 100.00, 'Penerapan Kode Referensi belum dilakukan oleh seluruh Produsen Data', 'Penerapan Kode Referensi telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing', 'Penerapan Kode Referensi telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data', 'Penerapan Kode Referensi telah dilakukan reviu dan evaluasi secara berkala', 'Penerapan Kode Referensi telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(5, 5, 'Tingkat Kematangan Relevansi Data Terhadap Pengguna', 60.00, 'Relevansi Data terhadap Pengguna belum dilakukan oleh seluruh Produsen Data', 'Relevansi Data terhadap Pengguna telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing', 'Relevansi Data terhadap Pengguna telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data', 'Relevansi Data terhadap Pengguna telah dilakukan reviu dan evaluasi secara berkala', 'Relevansi Data terhadap Pengguna telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(6, 5, 'Tingkat Kematangan Proses Identifikasi Kebutuhan Data', 40.00, 'Proses Identifikasi Kebutuhan Data belum dilakukan oleh seluruh Produsen Data', 'Proses Identifikasi Kebutuhan Data telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing', 'Proses Identifikasi Kebutuhan Data telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data', 'Proses Identifikasi Kebutuhan Data telah dilakukan reviu dan evaluasi secara berkala', 'Proses Identifikasi Kebutuhan Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(7, 6, 'Tingkat Kematangan Penilaian Akurasi Data', 100.00, 'Penilaian Akurasi Data belum dilakukan oleh seluruh Produsen Data', 'Penilaian Akurasi Data telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing', 'Penilaian Akurasi Data telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data', 'Penilaian Akurasi Data telah dilakukan reviu dan evaluasi secara berkala', 'Penilaian Akurasi Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(8, 7, 'Tingkat Kematangan Penjaminan Aktualitas Data', 50.00, 'Penjaminan Aktualitas Data belum dilakukan oleh seluruh Produsen Data', 'Penjaminan Aktualitas Data telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing', 'Penjaminan Aktualitas Data telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data', 'Penjaminan Aktualitas Data telah dilakukan reviu dan evaluasi secara berkala', 'Penjaminan Aktualitas Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(9, 7, 'Tingkat Kematangan Pemantauan Ketepatan Waktu Diseminasi', 50.00, 'Pemantauan ketepatan Waktu Diseminasi belum dilakukan oleh seluruh Produsen Data', 'Pemantauan Ketepatan Waktu Diseminasi telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing', 'Pemantauan Ketepatan Waktu Diseminasi telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data', 'Pemantauan Ketepatan Waktu Diseminasi telah dilakukan reviu dan evaluasi secara berkala', 'Pemantauan Ketepatan Waktu Diseminasi telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(10, 8, 'Tingkat Kematangan Ketersediaan Data untuk Pengguna Data', 34.00, 'Penjaminan Ketersediaan Data belum dilakukan oleh seluruh Produsen Data', 'Penjaminan Ketersediaan Data telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing', 'Penjaminan Ketersediaan Data telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data', 'Penjaminan Ketersediaan Data telah dilakukan reviu dan evaluasi secara berkala', 'Penjaminan Ketersediaan Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(11, 8, 'Tingkat Kematangan Akses Media Penyebarluasan Data', 33.00, 'Penjaminan Akses Media Penyebarluasan Data belum dilakukan oleh seluruh Produsen Data', 'Penjaminan Akses Media Penyebarluasan Data telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing', 'Penjaminan Akses Media Penyebarluasan Data telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data', 'Penjaminan Akses Media Penyebarluasan Data telah dilakukan reviu dan evaluasi secara berkala', 'Penjaminan Akses Media Penyebarluasan Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12, 8, 'Tingkat Kematangan Penyediaan Format Data', 33.00, 'Penjaminan Penyediaan Format Data yang beragam belum dilakukan oleh seluruh Produsen Data', 'Penjaminan Penyediaan Format Data yang beragam telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing', 'Penjaminan Penyediaan Format Data yang beragam telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data', 'Penjaminan Penyediaan Format Data yang beragam telah dilakukan reviu dan evaluasi secara berkala', 'Penjaminan Penyediaan Format Data yang beragam telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(13, 9, 'Tingkat Kematangan Keterbandingan Data', 50.00, 'Penjaminan Keterbandingan Data belum dilakukan oleh seluruh Produsen Data', 'Penjaminan Keterbandingan Data telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing', 'Penjaminan Keterbandingan Data telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data', 'Penjaminan Keterbandingan Data telah dilakukan reviu dan evaluasi secara berkala', 'Penjaminan Keterbandingan Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(14, 9, 'Tingkat Kematangan Konsistensi Statistik', 50.00, 'Penjaminan Konsistensi Statistik belum dilakukan oleh seluruh Produsen Data', 'Penjaminan Konsistensi Statistik telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing', 'Penjaminan Konsistensi Statistik telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data', 'Penjaminan Konsistensi Statistik telah dilakukan reviu dan evaluasi secara berkala', 'Penjaminan Konsistensi Statistik telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(15, 10, 'Tingkat Kematangan Pendefinisian Kebutuhan Statistik', 33.00, 'Pendefinisian Kebutuhan Statistik belum dilakukan oleh seluruh Produsen Data', 'Pendefinisian Kebutuhan Statistik telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing', 'Pendefinisian Kebutuhan Statistik telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data', 'Pendefinisian Kebutuhan Statistik telah dilakukan reviu dan evaluasi secara berkala', 'Pendefinisian Kebutuhan Statistik telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(16, 10, 'Tingkat Kematangan Desain Statistik', 33.00, 'Penerapan Desain Statistik belum dilakukan oleh seluruh Produsen Data', 'Penerapan Desain Statistik telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing', 'Penerapan Desain Statistik telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data', 'Penerapan Desain Statistik telah dilakukan reviu dan evaluasi secara berkala', 'Penerapan Desain Statistik telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(17, 10, 'Tingkat Kematangan Penyiapan Instrumen', 34.00, 'Penyiapan Instrumen belum dilakukan oleh seluruh Produsen Data', 'Penyiapan Instrumen telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing', 'Penyiapan Instrumen telah dilakukan berdasarkan prosedur baku yang telah ditetapkan dan berlaku untuk seluruh Produsen Data', 'Penyiapan Instrumen telah dilakukan reviu dan evaluasi secara berkala', 'Penyiapan Instrumen telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(18, 11, 'Tingkat Kematangan Proses Pengumpulan Data atau Akuisisi Data', 100.00, 'Proses Pengumpulan Data atau Akuisisi Data belum dilakukan oleh seluruh Produsen Data', 'Proses Pengumpulan Data atau Akuisisi Data telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing', 'Proses Pengumpulan Data atau Akuisisi Data telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data', 'Proses Pengumpulan Data atau Akuisisi Data telah dilakukan reviu dan evaluasi secara berkala', 'Proses Pengumpulan Data atau Akuisisi Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(19, 12, 'Tingkat Kematangan Pengolahan Data', 50.00, 'Pengolahan Data belum dilakukan oleh seluruh Produsen Data', 'Pengolahan Data telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing', 'Pengolahan Data telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data', 'Pengolahan Data telah dilakukan reviu dan evaluasi secara berkala', 'Pengolahan Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(20, 12, 'Tingkat Kematangan Analisis Data', 50.00, 'Proses Analisis Data belum dilakukan oleh seluruh Produsen Data', 'Proses Analisis Data telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing', 'Proses Analisis Data telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data', 'Proses Analisis Data telah dilakukan reviu dan evaluasi secara berkala', 'Proses Analisis Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(21, 13, 'Tingkat Kematangan Diseminasi Data', 100.00, 'Proses Diseminasi Data belum dilakukan oleh Walidata', 'Proses Diseminasi Data telah dilakukan oleh Walidata sesuai standar masing-masing Produsen Data', 'Proses Diseminasi Data telah dilakukan oleh Walidata berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data', 'Proses Diseminasi Data telah dilakukan reviu dan evaluasi secara berkala', 'Proses Diseminasi Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(22, 14, 'Tingkat Kematangan  Penjaminan Transparansi  Informasi Statistik', 25.00, 'Penjaminan Transparansi Informasi Statistik bagi Pengguna Data belum dilakukan oleh seluruh Produsen Data', 'Penjaminan Transparansi Informasi Statistik bagi Pengguna Data telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing', 'Penjaminan Transparansi Informasi Statistik bagi Pengguna Data telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data', 'Penjaminan Transparansi Informasi Statistik bagi Pengguna Data telah dilakukan reviu dan evaluasi secara berkala', 'Penjaminan Transparansi Informasi Statistik bagi Pengguna Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(23, 14, 'Tingkat Kematangan  Penjaminan Netralitas dan  Objektivitas terhadap  Penggunaan Sumber Data  Metodologi', 25.00, 'Penjaminan Netralitas dan Objektivitas terhadap Penggunaan Sumber Data dan Metodologi belum dilakukan oleh seluruh Produsen Data', 'Penjaminan Netralitas dan Objektivitas terhadap Penggunaan Sumber Data dan Metodologi telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing', 'Penjaminan Netralitas dan Objektivitas terhadap Penggunaan Sumber Data dan Metodologi telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data', 'Penjaminan Netralitas dan Objektivitas terhadap Penggunaan Sumber Data dan Metodologi telah dilakukan reviu dan evaluasi secara berkala', 'Penjaminan Netralitas dan Objektivitas terhadap Penggunaan Sumber Data dan Metodologi telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(24, 14, 'Tingkat Kematangan  Penjaminan Kualitas Data', 25.00, 'Penjaminan Kualitas Data belum dilakukan oleh seluruh Produsen Data', 'Penjaminan Kualitas Data telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing', 'Penjaminan Kualitas Data telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data', 'Penjaminan Kualitas Data telah dilakukan reviu dan evaluasi secara berkala', 'Penjaminan Kualitas Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(25, 14, 'Tingkat Kematangan  Penjaminan Konfidensialitas  Data', 25.00, 'Penjaminan Konfidensialitas Data belum dilakukan oleh seluruh Produsen Data', 'Penjaminan Konfidensialitas Data telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing', 'Penjaminan Konfidensialitas Data telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data', 'Penjaminan Konfidensialitas Data telah dilakukan reviu dan evaluasi secara berkala', 'Penjaminan Konfidensialitas Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(26, 15, 'Tingkat Kematangan Penerapan Kompetensi Sumber Daya Manusia Bidang Statistik', 50.00, 'Pemenuhan Kompetensi Sumber Daya Manusia Bidang Statistik belum dilakukan oleh seluruh Produsen Data', 'Pemenuhan Kompetensi Sumber Daya Manusia Bidang Statistik telah dilakukan oleh setiap Produsen Data sesuai dengan perencanaan', 'Pemenuhan Kompetensi Sumber Daya Manusia Bidang Statistik telah dilakukannya yaitu kompetensi di bidang proses bisinis penyelenggaraan Statistik Sektoral', 'Pemenuhan Kompetensi Sumber Daya Manusia Bidang Statistik telah dilakukan peningkatan, penilaian, reviu, dan evaluasi secara berkala', 'Pemenuhan Kompetensi Sumber Daya Manusia Bidang Statistik telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(27, 15, 'Tingkat Kematangan Penerapan Kompetensi Sumber Daya Manusia Bidang Manajemen Data ', 50.00, 'Pemenuhan Kompetensi Sumber Daya Manusia Bidang Manajemen Data belum dilakukan oleh seluruh Produsen Data', 'Pemenuhan Kompetensi Sumber Daya Manusia Bidang Manajemen Data telah dilakukan oleh setiap Produsen Data sesuai dengan perencanaan', 'Pemenuhan Kompetensi Sumber Daya Manusia Bidang Manajemen Data telah dilakukan seluruhnya yaitu kompetensi di bidang proses bisinis penyelenggaraan Statistik Sektoral', 'Pemenuhan Kompetensi Sumber Daya Manusia Bidang Manajemen Data telah dilakukan peningkatan, penilaian, reviu, dan evaluasi secara berkala', 'Pemenuhan Kompetensi Sumber Daya Manusia Bidang Manajemen Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(28, 16, 'Tingkat Kematangan Kolaborasi Penyelenggaraan Kegiatan Statistik ', 25.00, 'Kolaborasi antar unit kerja/perangkat daerah di Instansi Pusat/Pemerintahan Daerah dalam penyelenggaraan kegiatan statistik belum dilaksanakan', 'Kolaborasi antar unit kerja/perangkat daerah di Instansi Pusat/Pemerintahan Daerah dalam penyelenggaraan kegiatan statistik telah dilaksanakan secara informal', 'Kolaborasi antar unit kerja/perangkat daerah di Instansi Pusat/Pemerintahan Daerah dalam penyelenggaraan kegiatan statistik telah dilaksanakan oleh tim yang dibentuk secara formal', 'Kolaborasi antar unit kerja/perangkat daerah di Instansi Pusat/Pemerintahan Daerah dalam penyelenggaraan kegiatan statistik telah dilakukan melalui koordinasi kepala lembaga/kepala daerah serta dilakukan reviu dan evaluasi secara berkala', 'Kolaborasi antar unit kerja/perangkat daerah di Instansi Pusat/Pemerintahan Daerah dalam penyelenggaraan kegiatan statistik telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29, 16, 'Tingkat Kematangan Penyelenggaraan Forum Satu Data Indonesia', 25.00, 'Walidata/Walidata pendukung belum terlibat dalam Forum Satu Data Indonesia', 'Walidata/Walidata pendukung telah terlibat dalam Forum Satu Data Indonesia sesuai dengan rencana aksi Forum Satu Data Indonesia', 'Walidata/Walidata pendukung telah melaksanakan rencana aksi yang ditetapkan/disepakati dalam Forum Satu Data Indonesia', 'Walidata/Walidata pendukung telah melaksanakan rencana aksi dan berkolaborasi dengan Walidata lain atau Pembina Data Statistik dalam Forum Satu Data Indonesia dan telah dilakukan reviu dan evaluasi secara berkala', 'Walidata/Walidata pendukung telah menindaklanjuti hasil reviu dan evaluasi dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30, 16, 'Tingkat Kematangan Kolaborasi dengan Pembina Data Statistik', 25.00, 'Kolaborasi pembangunan/pengembangan data dengan Pembina Data Statistik belum dilakukan', 'Kolaborasi pembangunan/pengembangan data dengan Pembina Data Statistik telah dilakukan secara informal', 'Kolaborasi pembangunan/pengembangan data dengan Pembina Data Statistik telah dilakukan secara formal', 'Kolaborasi pembangunan/pengembangan data dengan Pembina Data Statistik telah dilakukan reviu dan evaluasi secara berkala', 'Kolaborasi pembangunan/pengembangan data dengan Pembina Data Statistik telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(31, 16, 'Tingkat Kematangan Penyelenggaraan Pelaksanaan Tugas Sebagai Walidata', 25.00, 'Walidata belum ditetapkan', 'Tugas/program kerja Walidata belum dilakukan seluruhnya', 'Tugas/program kerja Walidata telah dilakukan seluruhnya', 'Tugas/program kerja Walidata telah dilakukan secara terpadu dengan seluruh Produsen Data yang dikordinasikan dalam Forum SDI tingkat pusat/daerah, serta telah dilakukan reviu dan evaluasi secara berkala', 'Tugas/program kerja Walidata telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32, 17, 'Tingkat Kematangan  Penggunaan Data Statistik  Dasar untuk Perencanaan,  Monitoring, dan Evaluasi,  dan atau Penyusunan  Kebijakan', 34.00, 'Penggunaan Data Statistik Dasar untuk Perencanaan, Monitoring, dan Evaluasi, dan atau Penyusunan Kebijakan belum dilakukan oleh seluruh Produsen Data', 'Penggunaan Data Statistik Dasar untuk Perencanaan, Monitoring, dan Evaluasi, dan atau Penyusunan Kebijakan telah dilakukan oleh setiap Produsen Data sesuai kepentingannya masing-masing', 'Penggunaan Data Statistik Dasar untuk Perencanaan, Monitoring, dan Evaluasi, dan atau Penyusunan Kebijakan telah dilakukan oleh Produsen Data bersama Walidata untuk kepentingan Instansi Pusat/Pemerintahan Daerah', 'Penggunaan Data Statistik Dasar untuk Perencanaan, Monitoring, dan Evaluasi, dan atau Penyusunan Kebijakan telah dilakukan oleh Instansi Pusat/Pemerintahan Daerah bersama Walidata untuk kepentingan Pusat/Pemerintahan Daerah/Nasional, telah dilakukan koordinasi/konsultasi dengan Pembina Data Statistik, serta telah dilakukan reviu dan evaluasi secara berkala', 'Penggunaan Data Statistik Dasar untuk Perencanaan, Monitoring, dan Evaluasi, dan atau Penyusunan Kebijakan telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(33, 17, 'Tingkat Kematangan  Penggunaan Data Statistik  Sektoral untuk Perencanaan,  Monitoring, dan Evaluasi,  dan atau Penyusunan  Kebijakan', 33.00, 'Penggunaan Data Statistik Sektoral untuk Perencanaan, Monitoring, dan Evaluasi, dan atau Penyusunan Kebijakan belum dilakukan oleh seluruh Produsen Data', 'Penggunaan Data Statistik Sektoral untuk Perencanaan, Monitoring, dan Evaluasi, dan atau Penyusunan Kebijakan telah dilakukan oleh setiap Produsen Data sesuai kepentingannya masing-masing', 'Penggunaan Data Statistik Sektoral untuk Perencanaan, Monitoring, dan Evaluasi, dan atau Penyusunan Kebijakan telah dilakukan oleh Produsen Data bersama Walidata sesuai dengan kepentingan Instansi Pusat/Pemerintahan Daerah', 'Penggunaan Data Statistik Sektoral untuk Perencanaan, Monitoring, dan Evaluasi, dan atau Penyusunan Kebijakan telah dilakukan oleh Instansi Pusat/Pemerintahan Daerah, telah dilakukan koordinasi/konsultasi/rekomendasi dari Pembina Data Statistik, serta telah dilakukan reviu dan evaluasi secara berkala', 'Penggunaan Data Statistik Sektoral untuk Perencanaan, Monitoring, dan Evaluasi, dan atau Penyusunan Kebijakan telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(34, 17, 'Tingkat Kematangan  Sosialisasi dan Literasi Data  Statistik', 33.00, 'Sosialisasi Data Statistik kepada publik belum dilakukan oleh seluruh Produsen Data', 'Sosialisasi Data Statistik kepada publik telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing', 'Sosialisasi Data Statistik kepada publik yang telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data', 'Sosialisasi Data Statistik kepada publik telah dilakukan reviu dan evaluasi secara berkala', 'Sosialisasi Data Statistik kepada publik telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(35, 18, 'Tingkat Kematangan Pelaksanaan Rekomendasi Kegiatan Statistik', 100.00, 'Pemberitahuan rancangan kegiatan statistik ke BPS belum dilaksanakan oleh seluruh Produsen Data', 'Pemberitahuan rancangan kegiatan statistik ke BPS telah dilaksanakan oleh setiap Produsen Data sesuai standarnya masing-masing', 'Pemberitahuan rancangan kegiatan statistik ke BPS telah dilaksanakan berdasarkan prosedur baku yang ditetapkan, berlaku untuk seluruh Produsen Data, telah dikoordinasikan oleh walidata, serta telah ada rekomendasi dari BPS', 'Pelaksanaan Rekomendasi Kegiatan Statistik telah dilakukan reviu dan evaluasi secara berkala', 'Pelaksanaan Rekomendasi Kegiatan Statistik telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(36, 19, 'Tingkat Kematangan Perencanaan Pembangunan Statistik', 33.00, 'Perencanaan Pembangunan Statistik di Instansi Pusat/Pemerintahan Daerah belum disusun', 'Perencanaan Pembangunan Statistik di Instansi Pusat/Pemerintahan Daerah telah disusun dan ditetapkan', 'Perencanaan Pembangunan Statistik di Instansi Pusat/Pemerintahan Daerah telah dilaksanakan', 'Perencanaan Pembangunan Statistik di Instansi Pusat/Pemerintahan Daerah telah dilakukan reviu serta evaluasi bersama Pembina Data Statistik', 'Perencanaan Pembangunan Statistik di Instansi Pusat/Pemerintahan Daerah telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(37, 19, 'Tingkat Kematangan Penyebarluasan Data', 33.00, 'Penyebarluasan Data belum dilakukan oleh seluruh Produsen Data', 'Penyebarluasan Data dilakukan oleh setiap Produsen Data untuk kepentingan masing-masing', 'Penyebarluasan Data telah dilakukan oleh Walidata untuk kepentingan Instansi Pusat/Pemerintahan Daerah', 'Penyebarluasan Data telah dilakukan oleh Walidata melalui pujian informasi statistik, portal Satu Data Indonesia, Jaringan Informasi Geospasial Nasional (atau Sistem Big Data Permendagri) serta dilakukan reviu dan evaluasi secara berkala', 'Penyebarluasan Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(38, 19, 'Tingkat Kematangan Pemanfaatan Big Data', 34.00, 'Pemanfaatan Big Data dalam kegiatan Statistik belum dilakukan oleh seluruh Produsen Data', 'Pemanfaatan Big Data dalam kegiatan Statistik telah dilakukan oleh setiap Produsen Data dalam bentuk uji coba dan eksperiman', 'Pemanfaatan Big Data dalam kegiatan Statistik telah dilakukan oleh Produsen Data atau Walidata untuk menghasilkan data statistik pendukung', 'Pemanfaatan Big Data dalam kegiatan Statistik telah dilakukan reviu dan evaluasi secara berkala bersama Pembina Data Statistik', 'Pemanfaatan Big Data dalam kegiatan Statistik telah dilakukan pemutakhiran dalam rangka peningkatan kualitas', NULL, '2025-11-06 12:20:15', '2025-11-06 13:10:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_reset_tokens_table', 1),
(3, '2019_08_19_000000_create_failed_jobs_table', 1),
(4, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(5, '2025_04_20_084751_create_formulirs_table', 1),
(6, '2025_04_20_085001_create_domains_table', 1),
(7, '2025_04_20_085151_create_aspeks_table', 1),
(8, '2025_04_20_085348_create_indikators_table', 1),
(9, '2025_04_20_093349_create_penilaians_table', 1),
(10, '2025_05_02_032558_create_bukti_dukungs_table', 1),
(13, '2025_05_06_041056_create_pembinaans_table', 1),
(14, '2025_05_08_045203_create_permission_tables', 1),
(15, '2025_06_17_041308_create_formulir_penilaian_disposisis_table', 1),
(16, '2025_06_19_144508_create_formulir_domains_table', 1),
(17, '2025_07_08_161624_create_dokumentasi_kegiatans_table', 1),
(18, '2025_07_21_103513_create_file_pembinaans_table', 1),
(19, '2025_07_21_114558_create_file_dokumentasis_table', 1),
(20, '2025_08_04_150720_add_created_by_id_to_formulirs_table', 1),
(21, '2025_08_04_151113_add_created_by_id_to_penilaians_table', 1),
(22, '2025_08_04_231320_add_status_to_penilaians_table', 1),
(23, '2025_08_17_224220_add_evaluasi_walidata_to_penilaians_table', 1),
(24, '2025_08_17_225716_add_evaluasi_walidata_to_penilaians_table', 1),
(25, '2025_08_28_221904_alter_bukti_dukung_to_text_in_penilaians_table', 1),
(26, '2025_09_03_220344_add_level_kriteria_to_indikators_table', 1),
(27, '2025_10_31_234800_add_plain_password_to_users_table', 1),
(28, '2025_11_01_001447_add_catatan_koreksi_to_penilaians_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `model_has_permissions`
--

CREATE TABLE `model_has_permissions` (
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `model_has_roles`
--

CREATE TABLE `model_has_roles` (
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pembinaans`
--

CREATE TABLE `pembinaans` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `created_by_id` bigint(20) UNSIGNED NOT NULL,
  `directory_pembinaan` varchar(255) NOT NULL,
  `judul_pembinaan` varchar(255) NOT NULL,
  `bukti_dukung_undangan_pembinaan` varchar(255) NOT NULL,
  `daftar_hadir_pembinaan` varchar(255) NOT NULL,
  `materi_pembinaan` varchar(255) NOT NULL,
  `notula_pembinaan` varchar(255) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `pembinaans`
--

INSERT INTO `pembinaans` (`id`, `created_by_id`, `directory_pembinaan`, `judul_pembinaan`, `bukti_dukung_undangan_pembinaan`, `daftar_hadir_pembinaan`, `materi_pembinaan`, `notula_pembinaan`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 16, 'kegiatan-lingkungan-hidup-1762845157', 'kegiatan lingkungan hidup', 'file-pembinaan/kegiatan-lingkungan-hidup-1762845157\\bukti_dukung_undangan-1762845157.pdf', 'file-pembinaan/kegiatan-lingkungan-hidup-1762845157\\daftar_hadir-1762845157.pdf', 'file-pembinaan/kegiatan-lingkungan-hidup-1762845157\\materi-1762845157.pdf', 'file-pembinaan/kegiatan-lingkungan-hidup-1762845157\\notula-1762845157.pdf', NULL, '2025-11-11 07:12:37', '2025-11-11 07:12:37'),
(2, 2, 'kegiatan-inspektorat-1762845832', 'kegiatan inspektorat', 'file-pembinaan/kegiatan-inspektorat-1762845832\\bukti_dukung_undangan-1762845832.pdf', 'file-pembinaan/kegiatan-inspektorat-1762845832\\daftar_hadir-1762845832.pdf', 'file-pembinaan/kegiatan-inspektorat-1762845832\\materi-1762845832.pdf', 'file-pembinaan/kegiatan-inspektorat-1762845832\\notula-1762845832.pdf', NULL, '2025-11-11 07:23:52', '2025-11-11 07:23:52'),
(3, 25, 'kegiatan-diskominfo-1762849016', 'kegiatan diskominfo', 'file-pembinaan/kegiatan-diskominfo-1762849016\\bukti_dukung_undangan-1762849016.pdf', 'file-pembinaan/kegiatan-diskominfo-1762849016\\daftar_hadir-1762849016.pdf', 'file-pembinaan/kegiatan-diskominfo-1762849016\\materi-1762849016.pdf', 'file-pembinaan/kegiatan-diskominfo-1762849016\\notula-1762849016.pdf', NULL, '2025-11-11 08:16:56', '2025-11-11 08:16:56'),
(4, 16, 'kegiatan-lingkungan-hidup-2222-1763536664', 'kegiatan lingkungan hidup 2222', 'file-pembinaan/kegiatan-lingkungan-hidup-2222-1763536664/bukti_dukung_undangan-1763536664.pdf', 'file-pembinaan/kegiatan-lingkungan-hidup-2222-1763536664/daftar_hadir-1763536664.pdf', 'file-pembinaan/kegiatan-lingkungan-hidup-2222-1763536664/materi-1763536664.pdf', 'file-pembinaan/kegiatan-lingkungan-hidup-2222-1763536664/notula-1763536664.pdf', NULL, '2025-11-19 07:17:44', '2025-11-19 07:17:44'),
(6, 16, 'kegiatan-lingkungan-hidup-1234-1763573347', 'kegiatan lingkungan hidup 1234', '/home/u357914986/domains/parikesit-klaten.xyz/public_html/public/file-pembinaan/kegiatan-lingkungan-hidup-1234-1763573347/bukti_dukung_undangan-1763573347.pdf', '/home/u357914986/domains/parikesit-klaten.xyz/public_html/public/file-pembinaan/kegiatan-lingkungan-hidup-1234-1763573347/daftar_hadir-1763573347.pdf', '/home/u357914986/domains/parikesit-klaten.xyz/public_html/public/file-pembinaan/kegiatan-lingkungan-hidup-1234-1763573347/materi-1763573347.pdf', '/home/u357914986/domains/parikesit-klaten.xyz/public_html/public/file-pembinaan/kegiatan-lingkungan-hidup-1234-1763573347/notula-1763573347.pdf', NULL, '2025-11-19 17:29:07', '2025-11-19 17:29:07');

-- --------------------------------------------------------

--
-- Table structure for table `penilaians`
--

CREATE TABLE `penilaians` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `indikator_id` bigint(20) UNSIGNED NOT NULL,
  `formulir_id` bigint(20) UNSIGNED NOT NULL,
  `nilai` decimal(5,2) NOT NULL,
  `catatan` varchar(255) DEFAULT NULL,
  `tanggal_penilaian` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `bukti_dukung` text DEFAULT NULL,
  `dikerjakan_by` bigint(20) UNSIGNED DEFAULT NULL,
  `nilai_diupdate` decimal(5,2) DEFAULT NULL,
  `catatan_koreksi` text DEFAULT NULL,
  `diupdate_by` bigint(20) UNSIGNED DEFAULT NULL,
  `tanggal_diperbarui` timestamp NULL DEFAULT NULL,
  `nilai_koreksi` decimal(5,2) DEFAULT NULL,
  `dikoreksi_by` bigint(20) UNSIGNED DEFAULT NULL,
  `evaluasi` text DEFAULT NULL,
  `tanggal_dikoreksi` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `penilaians`
--

INSERT INTO `penilaians` (`id`, `indikator_id`, `formulir_id`, `nilai`, `catatan`, `tanggal_penilaian`, `user_id`, `bukti_dukung`, `dikerjakan_by`, `nilai_diupdate`, `catatan_koreksi`, `diupdate_by`, `tanggal_diperbarui`, `nilai_koreksi`, `dikoreksi_by`, `evaluasi`, `tanggal_dikoreksi`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 1, 3.00, 'baik', '2025-11-05 17:00:00', 16, '[\"bukti-dukung\\/1762431970-16-BAST Parikesit-1.pdf.pdf\",\"bukti-dukung\\/1762431970-16-BAST PARIKESIT.pdf.pdf\"]', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 12:26:10', '2025-11-06 12:26:10', NULL),
(2, 2, 1, 4.00, 'kegiatan dilaksanakan pada bulan januari', '2025-11-05 17:00:00', 16, '[\"bukti-dukung\\/1762432541-16-lembar pengesahan.pdf.pdf\",\"bukti-dukung\\/1762432541-16-Peraturan_Badan_Pusat_Statistik_Nomor_3_Tahun_2022_1679381490-22-39.pdf.pdf\"]', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 12:35:41', '2025-11-06 12:35:41', NULL),
(3, 3, 1, 2.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 12:44:00', '2025-11-06 12:44:00', NULL),
(4, 4, 1, 3.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 12:44:12', '2025-11-06 12:44:12', NULL),
(5, 5, 1, 2.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:07:54', '2025-11-06 13:07:54', NULL),
(6, 6, 1, 5.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:08:11', '2025-11-06 13:08:11', NULL),
(7, 7, 1, 2.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:08:41', '2025-11-06 13:08:41', NULL),
(8, 21, 1, 2.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:11:49', '2025-11-06 13:11:49', NULL),
(9, 15, 1, 3.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:12:09', '2025-11-06 13:12:09', NULL),
(10, 8, 1, 5.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:13:11', '2025-11-06 13:13:11', NULL),
(11, 9, 1, 4.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:13:36', '2025-11-06 13:13:36', NULL),
(12, 12, 1, 2.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:13:50', '2025-11-06 13:13:50', NULL),
(13, 11, 1, 5.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:14:03', '2025-11-06 13:14:03', NULL),
(14, 10, 1, 2.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:14:11', '2025-11-06 13:14:11', NULL),
(15, 13, 1, 2.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:14:21', '2025-11-06 13:14:21', NULL),
(16, 14, 1, 5.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:14:29', '2025-11-06 13:14:29', NULL),
(17, 16, 1, 2.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:17:53', '2025-11-06 13:17:53', NULL),
(18, 17, 1, 5.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:18:01', '2025-11-06 13:18:01', NULL),
(19, 19, 1, 2.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:18:09', '2025-11-06 13:18:09', NULL),
(20, 20, 1, 2.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:18:30', '2025-11-06 13:18:30', NULL),
(21, 22, 1, 1.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:19:02', '2025-11-06 13:19:02', NULL),
(22, 23, 1, 4.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:19:10', '2025-11-06 13:19:10', NULL),
(23, 24, 1, 3.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:19:16', '2025-11-06 13:19:16', NULL),
(24, 25, 1, 1.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:19:29', '2025-11-06 13:19:29', NULL),
(25, 26, 1, 2.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:21:44', '2025-11-06 13:21:44', NULL),
(26, 27, 1, 1.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:21:56', '2025-11-06 13:21:56', NULL),
(27, 30, 1, 3.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:22:06', '2025-11-06 13:22:06', NULL),
(28, 28, 1, 2.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:22:17', '2025-11-06 13:22:17', NULL),
(29, 29, 1, 5.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:22:24', '2025-11-06 13:22:24', NULL),
(30, 31, 1, 1.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:22:35', '2025-11-06 13:22:35', NULL),
(31, 32, 1, 2.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:22:47', '2025-11-06 13:22:47', NULL),
(32, 33, 1, 3.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:22:55', '2025-11-06 13:22:55', NULL),
(33, 34, 1, 4.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:23:04', '2025-11-06 13:23:04', NULL),
(34, 35, 1, 1.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:23:10', '2025-11-06 13:23:10', NULL),
(35, 36, 1, 2.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:23:30', '2025-11-06 13:23:30', NULL),
(36, 37, 1, 4.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:23:39', '2025-11-06 13:23:39', NULL),
(37, 38, 1, 2.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:23:53', '2025-11-06 13:23:53', NULL),
(38, 18, 1, 1.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:24:17', '2025-11-06 13:24:17', NULL),
(39, 18, 1, 1.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 13:24:17', '2025-11-06 13:24:17', NULL),
(40, 1, 2, 2.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 14:51:13', '2025-11-06 14:51:13', NULL),
(41, 3, 2, 5.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 14:51:20', '2025-11-06 14:51:20', NULL),
(42, 2, 2, 3.00, NULL, '2025-11-18 01:51:22', 16, '-', NULL, 2.00, NULL, 25, '2025-11-18 01:51:22', NULL, NULL, NULL, NULL, '2025-11-06 14:51:30', '2025-11-18 01:51:22', NULL),
(43, 4, 2, 5.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 14:51:38', '2025-11-06 14:51:38', NULL),
(44, 5, 2, 2.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 15:10:09', '2025-11-06 15:10:09', NULL),
(45, 6, 2, 3.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 15:10:17', '2025-11-06 15:10:17', NULL),
(46, 14, 2, 2.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 15:10:26', '2025-11-06 15:10:26', NULL),
(47, 13, 2, 1.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 15:10:35', '2025-11-06 15:10:35', NULL),
(48, 7, 2, 4.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 15:12:21', '2025-11-06 15:12:21', NULL),
(49, 8, 2, 4.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 15:12:31', '2025-11-06 15:12:31', NULL),
(50, 9, 2, 3.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 15:12:39', '2025-11-06 15:12:39', NULL),
(51, 12, 2, 2.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 15:12:48', '2025-11-06 15:12:48', NULL),
(52, 11, 2, 5.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 15:12:57', '2025-11-06 15:12:57', NULL),
(53, 10, 2, 2.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 15:13:08', '2025-11-06 15:13:08', NULL),
(54, 15, 2, 5.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 15:13:31', '2025-11-06 15:13:31', NULL),
(55, 16, 2, 2.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 15:13:40', '2025-11-06 15:13:40', NULL),
(56, 17, 2, 3.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 15:13:49', '2025-11-06 15:13:49', NULL),
(57, 21, 2, 4.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 15:13:57', '2025-11-06 15:13:57', NULL),
(58, 20, 2, 2.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 15:14:07', '2025-11-06 15:14:07', NULL),
(59, 18, 2, 1.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 15:14:18', '2025-11-06 15:14:18', NULL),
(60, 19, 2, 2.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 15:14:30', '2025-11-06 15:14:30', NULL),
(61, 32, 2, 2.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 15:53:02', '2025-11-06 15:53:02', NULL),
(62, 33, 2, 1.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 15:53:09', '2025-11-06 15:53:09', NULL),
(63, 34, 2, 4.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 15:53:17', '2025-11-06 15:53:17', NULL),
(64, 38, 2, 2.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 15:53:26', '2025-11-06 15:53:26', NULL),
(65, 35, 2, 1.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 15:53:35', '2025-11-06 15:53:35', NULL),
(66, 37, 2, 4.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 15:53:43', '2025-11-06 15:53:43', NULL),
(67, 36, 2, 2.00, NULL, '2025-11-05 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-06 15:53:53', '2025-11-06 15:53:53', NULL),
(68, 1, 3, 2.00, NULL, '2025-11-11 08:21:14', 16, '-', NULL, 3.00, 'kwgiatan dilaksanakan', 25, '2025-11-11 07:43:08', 2.00, 49, 'kegiatan telah dilaksanakan', '2025-11-11 08:21:14', '2025-11-09 17:12:45', '2025-11-11 08:21:14', NULL),
(69, 2, 3, 2.00, NULL, '2025-11-11 08:30:19', 16, '-', NULL, 1.00, NULL, 25, '2025-11-11 07:43:45', 5.00, 49, 'aaaa', '2025-11-11 08:30:19', '2025-11-09 17:12:53', '2025-11-11 08:30:19', NULL),
(70, 3, 3, 2.00, NULL, '2025-11-11 08:29:54', 16, '-', NULL, 4.00, 'kegiatan dilakd=sanakan lagi', 25, '2025-11-11 07:44:12', 4.00, 49, 'okede', '2025-11-11 08:29:54', '2025-11-09 17:13:01', '2025-11-11 08:29:54', NULL),
(71, 4, 3, 1.00, NULL, '2025-11-11 08:30:34', 16, '-', NULL, 3.00, NULL, 25, '2025-11-11 07:45:28', 2.00, 49, 'siap deh', '2025-11-11 08:30:34', '2025-11-09 17:13:09', '2025-11-11 08:30:34', NULL),
(72, 5, 3, 1.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:13:26', '2025-11-09 17:13:26', NULL),
(73, 6, 3, 1.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:13:34', '2025-11-09 17:13:34', NULL),
(74, 7, 3, 1.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:13:43', '2025-11-09 17:13:43', NULL),
(75, 8, 3, 2.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:13:52', '2025-11-09 17:13:52', NULL),
(76, 9, 3, 1.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:14:02', '2025-11-09 17:14:02', NULL),
(77, 10, 3, 2.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:14:21', '2025-11-09 17:14:21', NULL),
(78, 11, 3, 1.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:14:31', '2025-11-09 17:14:31', NULL),
(79, 12, 3, 1.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:14:42', '2025-11-09 17:14:42', NULL),
(80, 13, 3, 2.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:14:52', '2025-11-09 17:14:52', NULL),
(81, 14, 3, 2.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:14:59', '2025-11-09 17:14:59', NULL),
(82, 15, 3, 2.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:15:18', '2025-11-09 17:15:18', NULL),
(83, 16, 3, 2.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:15:27', '2025-11-09 17:15:27', NULL),
(84, 16, 3, 2.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:15:28', '2025-11-09 17:15:28', NULL),
(85, 16, 3, 2.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:15:29', '2025-11-09 17:15:29', NULL),
(86, 17, 3, 1.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:15:37', '2025-11-09 17:15:37', NULL),
(87, 18, 3, 1.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:15:47', '2025-11-09 17:15:47', NULL),
(88, 19, 3, 2.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:15:55', '2025-11-09 17:15:55', NULL),
(89, 20, 3, 2.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:16:04', '2025-11-09 17:16:04', NULL),
(90, 21, 3, 2.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:16:16', '2025-11-09 17:16:16', NULL),
(91, 22, 3, 2.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:16:36', '2025-11-09 17:16:36', NULL),
(92, 23, 3, 2.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:16:45', '2025-11-09 17:16:45', NULL),
(93, 24, 3, 2.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:16:54', '2025-11-09 17:16:54', NULL),
(94, 25, 3, 2.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:17:00', '2025-11-09 17:17:00', NULL),
(95, 26, 3, 3.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:17:10', '2025-11-09 17:17:10', NULL),
(96, 27, 3, 1.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:17:19', '2025-11-09 17:17:19', NULL),
(97, 28, 3, 2.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:17:36', '2025-11-09 17:17:36', NULL),
(98, 29, 3, 2.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:17:48', '2025-11-09 17:17:48', NULL),
(99, 30, 3, 2.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:17:56', '2025-11-09 17:17:56', NULL),
(100, 31, 3, 2.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:18:04', '2025-11-09 17:18:04', NULL),
(101, 32, 3, 1.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:18:25', '2025-11-09 17:18:25', NULL),
(102, 33, 3, 2.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:18:33', '2025-11-09 17:18:33', NULL),
(103, 34, 3, 1.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:18:42', '2025-11-09 17:18:42', NULL),
(104, 35, 3, 1.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:18:53', '2025-11-09 17:18:53', NULL),
(105, 36, 3, 1.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:19:02', '2025-11-09 17:19:02', NULL),
(106, 37, 3, 1.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:19:12', '2025-11-09 17:19:12', NULL),
(107, 38, 3, 1.00, NULL, '2025-11-09 17:00:00', 16, '-', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-09 17:19:21', '2025-11-09 17:19:21', NULL),
(108, 1, 4, 2.00, NULL, '2025-11-11 08:17:52', 2, '-', NULL, 4.00, NULL, 25, '2025-11-11 08:17:52', NULL, NULL, NULL, NULL, '2025-11-11 07:14:51', '2025-11-11 08:17:52', NULL),
(109, 2, 4, 2.00, NULL, '2025-11-11 08:18:14', 2, '-', NULL, 5.00, 'kegiatan telah dilaksananakankankanka', 25, '2025-11-11 08:18:14', NULL, NULL, NULL, NULL, '2025-11-11 07:16:03', '2025-11-11 08:18:14', NULL),
(110, 3, 4, 2.00, NULL, '2025-11-11 08:18:51', 2, '-', NULL, 2.00, NULL, 25, '2025-11-11 08:18:51', NULL, NULL, NULL, NULL, '2025-11-11 07:18:25', '2025-11-11 08:18:51', NULL),
(111, 4, 4, 5.00, NULL, '2025-11-11 08:19:02', 2, '-', NULL, 3.00, NULL, 25, '2025-11-11 08:19:02', NULL, NULL, NULL, NULL, '2025-11-11 07:18:36', '2025-11-11 08:19:02', NULL),
(112, 1, 7, 2.00, 'bukti dukung sudah sesuai', '2025-11-18 09:05:59', 3, '[\"bukti-dukung\\/1763455981-3-sds sekwan.pdf.pdf\"]', NULL, 2.00, 'bukti dukung sesuai', 25, '2025-11-18 09:05:59', NULL, NULL, NULL, NULL, '2025-11-18 08:53:01', '2025-11-18 09:05:59', NULL),
(113, 2, 7, 2.00, 'bukti dukung sesuai', '2025-11-17 17:00:00', 3, '[\"bukti-dukung\\/1763456397-3-metadata sekwan.pdf.pdf\",\"bukti-dukung\\/1763456397-3-sds sekwan.pdf.pdf\"]', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-18 08:59:57', '2025-11-18 08:59:57', NULL),
(114, 22, 2, 2.00, NULL, '2025-11-19 00:00:00', 16, '[\"bukti-dukung\\/1763536814-16-BAST PARIKESIT.pdf.pdf\"]', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-19 07:20:14', '2025-11-19 07:20:14', NULL),
(115, 23, 2, 1.00, NULL, '2025-11-19 00:00:00', 16, '[\"bukti-dukung\\/1763571105-16-Peraturan_Badan_Pusat_Statistik_Nomor_3_Tahun_2022_1679381490-22-39.pdf.pdf\",\"bukti-dukung\\/1763571105-16-BAST PARIKESIT.pdf.pdf\"]', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-19 16:51:45', '2025-11-19 16:51:45', NULL),
(116, 1, 12, 1.00, NULL, '2025-11-19 00:00:00', 16, '[\"bukti-dukung\\/1763572002-16-BAST PARIKESIT.pdf.pdf\",\"bukti-dukung\\/1763572002-16-Lembar Perbaikan Hasil Seminar Skripsi.pdf.pdf\"]', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-19 17:06:42', '2025-11-19 17:06:42', NULL),
(117, 5, 12, 2.00, 'aaa', '2025-11-20 00:00:00', 16, '[\"bukti-dukung\\/1763622708-16-Peraturan_Badan_Pusat_Statistik_Nomor_3_Tahun_2022_1679381490-22-39.pdf.pdf\"]', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-20 14:11:48', '2025-11-20 14:11:48', NULL),
(118, 1, 6, 2.00, NULL, '2025-11-20 08:50:38', 24, '[\"bukti-dukung\\/1763623493-24-screencapture-ms-sds-web-bps-go-id-sds-2025-11-20-14_24_02.png.png\"]', NULL, 2.00, 'Bukti dukung sudah sesuai', 25, '2025-11-20 15:50:38', NULL, NULL, NULL, NULL, '2025-11-20 14:24:53', '2025-11-20 15:50:38', NULL),
(119, 2, 6, 2.00, 'Sudah Sesuai', '2025-11-20 08:51:33', 24, '[\"bukti-dukung\\/1763627114-24-screencapture-ms-sds-web-bps-go-id-sds-2025-11-20-14_24_02.png.png\"]', NULL, 2.00, 'bukti dukung sudah sesuai', 25, '2025-11-20 15:51:33', NULL, NULL, NULL, NULL, '2025-11-20 15:25:14', '2025-11-20 15:51:33', NULL),
(120, 3, 6, 2.00, 'Sudah Sesuai', '2025-11-20 08:51:44', 24, '[\"bukti-dukung\\/1763627134-24-screencapture-ms-sds-web-bps-go-id-sds-2025-11-20-14_24_02.png.png\"]', NULL, 2.00, 'bukti dukung sudah sesuai', 25, '2025-11-20 15:51:44', NULL, NULL, NULL, NULL, '2025-11-20 15:25:34', '2025-11-20 15:51:44', NULL),
(121, 4, 6, 2.00, 'Sudah sesuai', '2025-11-20 08:51:56', 24, '[\"bukti-dukung\\/1763627154-24-screencapture-ms-sds-web-bps-go-id-sds-2025-11-20-14_24_02.png.png\"]', NULL, 2.00, 'bukti dukung sudah sesuai', 25, '2025-11-20 15:51:56', NULL, NULL, NULL, NULL, '2025-11-20 15:25:54', '2025-11-20 15:51:56', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `guard_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `guard_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `role_has_permissions`
--

CREATE TABLE `role_has_permissions` (
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `plain_password` varchar(255) DEFAULT NULL,
  `role` varchar(255) NOT NULL DEFAULT 'user',
  `alamat` varchar(255) NOT NULL,
  `nomor_telepon` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `plain_password`, `role`, `alamat`, `nomor_telepon`, `remember_token`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 'Admin', 'admin@gmail.com', '2025-11-05 13:56:16', '$2y$10$L.1zL7mUOQQCVp.MFUMeLu7J8EspNjIY2Eq1Ggoi.qy33hgGYId9C', 'chelseaazishiah', 'admin', 'Kabupaten Klaten', '081234567890', 'WrUfCHy5R8dB6Y9BkeUBUGtffmtJ7mXiqOEXToqQbEfE8fSRzgHCtrAvnQHB', NULL, '2025-11-05 13:56:16', '2025-11-05 14:02:10'),
(2, 'Inspektorat Daerah', 'inspektorat@klaten.go.id', '2025-11-05 13:56:16', '$2y$10$kJJIQbeKDC6z2LHDqH3AjeHqQwyKq4Qqya.upj0pu/.Q5xhB3t6A.', 'password', 'opd', 'Kabupaten Klaten, Jawa Tengah', '-', 'I02NiXiZcFpoghk4BxFW5uZsFo9xxlUHXSskpWCbfa6uyqhB1X409yg8QOLq', NULL, '2025-11-05 13:56:16', '2025-11-05 13:56:16'),
(3, 'Sekretariat Dewan Perwakilan Rakyat Daerah', 'sekretariatad77@gmail.com', '2025-11-05 13:56:16', '$2y$10$GRjVvr58XLgWUv2pJSPwVOdRZWtwPtaOQwxdpdRjq8QS.EdyjqNHi', 'password', 'opd', 'Kabupaten Klaten, Jawa Tengah', '-', 'mf3FuitenCHWFSTxbbIKyBqq7QBOlpna0aX3mEI0qbj8UpSxQTVF0DHolwFK', NULL, '2025-11-05 13:56:16', '2025-11-05 13:56:16'),
(4, 'Dinas Pemberdayaan Masyarakat dan Desa', 'dispermasdes@klaten.go.id', '2025-11-05 13:56:16', '$2y$10$yXpJT9oeK3bT6Hu.BAz/h.6Le1Fm0eT01LGbxq2.ss1hcQKJCOhhq', 'password', 'opd', 'Kabupaten Klaten, Jawa Tengah', '-', 'EIbAmZPwsY', NULL, '2025-11-05 13:56:16', '2025-11-05 13:56:16'),
(5, 'Dinas Pendidikan', 'klatendisdik@gmail.com', '2025-11-05 13:56:16', '$2y$10$zrLiTRGRGwWTAIU/Nhkw4uVO7DgUnl0HnNxXyMzEyrxBpSphO7L4y', 'password', 'opd', 'Kabupaten Klaten, Jawa Tengah', '-', 'z5mtt6YL6L', NULL, '2025-11-05 13:56:16', '2025-11-05 13:56:16'),
(6, 'Dinas Kebudayaan, Kepemudaan, Olahraga dan Pariwisata', 'disbudporapar@klaten.go.id', '2025-11-05 13:56:17', '$2y$10$/HfflHCFRnoc8qGOqeQ.qu3PqE6R7v/o/4iFLwYOAVSncb8mF8E7O', 'password', 'opd', 'Kabupaten Klaten, Jawa Tengah', '-', 'DRiiqlNKtT', NULL, '2025-11-05 13:56:17', '2025-11-05 13:56:17'),
(7, 'Dinas Kesehatan', 'dinas.kesehatan@klaten.go.id', '2025-11-05 13:56:17', '$2y$10$.bnDPRepHioe1BguDWoOiOHEsGoaA3sFm.msIQVLfKwy.UsYvfxdi', 'password', 'opd', 'Kabupaten Klaten, Jawa Tengah', '-', 'iWFIGMtsAS6T5ihmOSCTexdjpQd8711fKsQhWT51UO2y5WsO8ojIMjJ8WWay', NULL, '2025-11-05 13:56:17', '2025-11-05 13:56:17'),
(8, 'Dissos P3APPKB', 'dinsosp3akb.klaten@gmail.com', '2025-11-05 13:56:17', '$2y$10$P87XenvsfARWuCzE88tJce0VfCuSmoB7p9UipQNZhT534v.enR2De', 'password', 'opd', 'Kabupaten Klaten, Jawa Tengah', '-', 'C7GURiVY3JTDhuVAqwnu9hiAgfP5zRIkvVNiW4ptWqDNpuSXU80UEjIEagxQ', NULL, '2025-11-05 13:56:17', '2025-11-05 13:56:17'),
(9, 'Dinas Kependudukan dan Pencatatan Sipil', 'disdukcapil@klaten.g.id', '2025-11-05 13:56:17', '$2y$10$.z.6tfy1bTVq74snz8eB5OnvF1NI8mxXPSJ.3jx3t8n0dmvmygmQa', 'password', 'opd', 'Kabupaten Klaten, Jawa Tengah', '-', 'd5vOTj0lm8', NULL, '2025-11-05 13:56:17', '2025-11-05 13:56:17'),
(10, 'Dinas Penanaman Modal dan Pelayanan Terpadu Satu Pintu', 'dpmptsp@klaten.go.id', '2025-11-05 13:56:17', '$2y$10$.hOlG//LqIjmoAKTKSwTCOEfbk4.crqwcmP/Z0p6sKU133Zy2mmJe', 'password', 'opd', 'Kabupaten Klaten, Jawa Tengah', '-', 'TZGo8HDdl4', NULL, '2025-11-05 13:56:17', '2025-11-05 13:56:17'),
(11, 'Dinas Koperasi, Usaha Kecil Menengah dan Perdagangan', 'dkukmp@klaten.go.id', '2025-11-05 13:56:17', '$2y$10$S2aWIgraeTun1pIGrzfbu.4qTMWcubu7oeH3g1pOARYefpdtkcPuO', 'password', 'opd', 'Kabupaten Klaten, Jawa Tengah', '-', 'dCG8F9Z0Dz', NULL, '2025-11-05 13:56:17', '2025-11-05 13:56:17'),
(12, 'Dinas Perindustrian dan Tenaga Kerja', 'disperinaker@klaten.go.id', '2025-11-05 13:56:17', '$2y$10$e/iWGKoA/V19ppQHj53jC.MDWeEBWmHS1zdn52BuzGhF0t7yEc9B6', 'password', 'opd', 'Kabupaten Klaten, Jawa Tengah', '-', 'kTwFd1nsN7', NULL, '2025-11-05 13:56:17', '2025-11-05 13:56:17'),
(13, 'Dinas Perumahan Rakyat dan Kawasan Permukiman', 'disperakim@klaten.go.id', '2025-11-05 13:56:17', '$2y$10$cxuiHvbyJUcH8G6kTlajgejIjEjpgA3JLUOBaSBp0ZRp5GpjdW9LG', 'password', 'opd', 'Kabupaten Klaten, Jawa Tengah', '-', 'zYjiNZd311', NULL, '2025-11-05 13:56:17', '2025-11-05 13:56:17'),
(14, 'Dinas Pekerjaan Umum dan Penataan Ruang', 'dpupr@klaten.go.id', '2025-11-05 13:56:17', '$2y$10$rfwSmmiCxGK4LTBT2Vb2c.TG5VN3lS4liIx86ZBNEEolUHNWVWjOK', 'password', 'opd', 'Kabupaten Klaten, Jawa Tengah', '-', 'EBnOPLNvU3', NULL, '2025-11-05 13:56:17', '2025-11-05 13:56:17'),
(15, 'Dinas Perhubungan', 'dinas.perhubungan@klaten.go.id', '2025-11-05 13:56:17', '$2y$10$i6UZ5zvwDE1L2b4l/U4L2OGWKPTaQLgatyAmNecd4DANOlu2TxUDC', 'password', 'opd', 'Kabupaten Klaten, Jawa Tengah', '-', 'zakP7PiWXp', NULL, '2025-11-05 13:56:17', '2025-11-05 13:56:17'),
(16, 'Dinas Lingkungan Hidup', 'dinas.lh@klaten.go.id', '2025-11-05 13:56:18', '$2y$10$QaFLoy07YfSh4aICS7MxeeX2t38Q0V06FoHZQ6rcOVGATmk0TICwq', 'password', 'opd', 'Kabupaten Klaten, Jawa Tengah', '-', 'WSclOWJATzSyQ6zK9uMP9XI0CTBMx0z12H8JWT4pZ2g2GtDAjZdCu73CJU5Y', NULL, '2025-11-05 13:56:18', '2025-11-05 13:56:18'),
(17, 'Dinas Ketahanan Pangan dan Pertanian', 'dispertanklaten@gmail.com', '2025-11-05 13:56:18', '$2y$10$8UE8AMJ7Aq4zIxmtQ06UKO6SnY9gEp65X5u0M7WC0n4eg19yztbhm', 'password', 'opd', 'Kabupaten Klaten, Jawa Tengah', '-', 'pyUo9Sfqou', NULL, '2025-11-05 13:56:18', '2025-11-05 13:56:18'),
(18, 'Dinas Perpustakaan dan Kearsipan', 'dispersip@klaten.go.id', '2025-11-05 13:56:18', '$2y$10$Un1KXcIg7qVeL2A4B.56cu4vY2bzD69fwTuJjunhUF6uE1v0Nxhmu', 'password', 'opd', 'Kabupaten Klaten, Jawa Tengah', '-', 'QLyIVPXBqy', NULL, '2025-11-05 13:56:18', '2025-11-05 13:56:18'),
(19, 'Satuan Polisi Pamong Praja dan Pemadan Kebakaran', 'satpol.pp.klaten@gmail.com', '2025-11-05 13:56:18', '$2y$10$IgFK6vlB5zYP/RN3cj6XkuqYPqtozLstGl.SKoCVm7nnQcFArwXge', 'password', 'opd', 'Kabupaten Klaten, Jawa Tengah', '-', 'ApGx4j7Eya', NULL, '2025-11-05 13:56:18', '2025-11-05 13:56:18'),
(20, 'Badan Kepegawaian dan Pengembangan Sumber Daya Manusia', 'bkpsdm@klaten.go.id', '2025-11-05 13:56:18', '$2y$10$Jm1Ga3aWlOpxXBRu60VRUOrG227q3bcLQxqRySb/ZyrNNUPPW3xFu', 'password', 'opd', 'Kabupaten Klaten, Jawa Tengah', '-', 'Zz0L6Y9l6AxIAoPPLrGuIsU50P7Q5HpkNcjb5bm81q18TniU6wPL9S2pOWHT', NULL, '2025-11-05 13:56:18', '2025-11-05 13:56:18'),
(21, 'Badan Pengelolaan Keuangan, Pendapatan dan Aset Daerah', 'bpkpad@klaten.gi.id', '2025-11-05 13:56:18', '$2y$10$P8Hjig6mHb3xTk6tMjf.yuGW1A5dGAbLtD35QwS4UKo4OS69Y8AZe', 'password', 'opd', 'Kabupaten Klaten, Jawa Tengah', '-', 'tVhDj7tvJU', NULL, '2025-11-05 13:56:18', '2025-11-05 13:56:18'),
(22, 'Badan Perencanaan Pembangunan, Riset, dan Inovasi Daerah', 'bapperida@klaten.go.id', '2025-11-05 13:56:18', '$2y$10$fgUuCuzUcmLsegkHqvozdu.AtKVedaUCU3X0hBavmFG4tq08qDdLa', 'password', 'opd', 'Kabupaten Klaten, Jawa Tengah', '-', '4DhWmdvsi7LZB9K9geNLaCbplKqZ2qj0i8iAMXtmePs1WwTO3Z68qFYXIIxj', NULL, '2025-11-05 13:56:18', '2025-11-05 13:56:18'),
(23, 'Badan Kesatuan Bangsa dan Politik', 'kesbangpolklaten@gmail.com', '2025-11-05 13:56:18', '$2y$10$9pzkDWso1VSjjksVE97IQ.6YAEWVo94WTWVxtd/KuXIkyxelRH7Q6', 'password', 'opd', 'Kabupaten Klaten, Jawa Tengah', '-', 'B5sUMY3bEC', NULL, '2025-11-05 13:56:18', '2025-11-05 13:56:18'),
(24, 'Badan Penanggulangan Bencana Daerah', 'bpbd@klaten.go.id', '2025-11-05 13:56:18', '$2y$10$ZprA3gftzn7wi48CImlpEuOsHZJlpXAjhva2eDlBdnECHe7ormN9K', 'password', 'opd', 'Kabupaten Klaten, Jawa Tengah', '-', 'l0CkaqpHyRvgp46hT89WvrDUoasPBZmHS859TMZTrmFSTZMnv7G2vk6jJNkU', NULL, '2025-11-05 13:56:18', '2025-11-05 13:56:18'),
(25, 'Dinas Komunikasi dan Informatika', 'diskominfo@klaten.go.id', '2025-11-05 13:56:18', '$2y$10$f8MkP3dm6SH0yFtFbLtSguZb9oPnl5tEYKUnE.anVhrQafVkp4KiG', 'password', 'walidata', 'Kabupaten Klaten, Jawa Tengah', '-', 'eziJsZuwHD3Cok2nbEsKZyo79GdEwiNVw6AvdVinN7fbd4VARm2GCPeifYjV', NULL, '2025-11-05 13:56:18', '2025-11-05 13:56:18'),
(26, 'ADI TEGUH WIYONO, SST', 'adi.wiyono@bps.go.id', '2025-11-05 13:56:19', '$2y$10$c76NMjLbm6ybzEwNxFsn0ewTU0ar95zJRIkJI4znN7M.iFjGJy74S', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'KfKPMzP2uV', NULL, '2025-11-05 13:56:19', '2025-11-05 13:56:19'),
(27, 'ALFIAH YUNI ASTUTI, SST', 'alfiah@bps.go.id', '2025-11-05 13:56:19', '$2y$10$j/qwFje9QZz9VrXqWQeQk.da5hWnVPf/OotFTSHIYjuYGVzJrcC2y', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'sqfU5GSSfF', NULL, '2025-11-05 13:56:19', '2025-11-05 13:56:19'),
(28, 'ANDHIKA RAHMADANI, SST', 'andhikarahm@bps.go.id', '2025-11-05 13:56:19', '$2y$10$lsxQkVcxm6C8bXdJBgg.t.C.3U7hBq02oPOay0/DbEi6dajtAr4.6', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'LEbLq7XBBO', NULL, '2025-11-05 13:56:19', '2025-11-05 13:56:19'),
(29, 'ANDIRA IKA NUGRAHENI, SST', 'andira.nugraheni@bps.go.id', '2025-11-05 13:56:19', '$2y$10$VHJuRqq1l7K9L8/NMwMtvuUTVkrEZlgpZrBohDWYLP66MUs6lerlq', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'PTpSLdQD0w', NULL, '2025-11-05 13:56:19', '2025-11-05 13:56:19'),
(30, 'BANGKIT SASETIA UTAMA', 'bangkit.utama@bps.go.id', '2025-11-05 13:56:19', '$2y$10$9IIiq5r6ef3pbXbwc6UTFeBGztc3QE5B1d7k6syHIzxvyLxTbLl7S', 'password', 'admin', 'BPS Kabupaten Klaten', '-', '5yfTd2I1cw', NULL, '2025-11-05 13:56:19', '2025-11-05 13:56:19'),
(31, 'BASUKI HARIS SUKARNO', 'basukiharis@bps.go.id', '2025-11-05 13:56:19', '$2y$10$rI2yDArZ5avWFyhnYQRA4ucgw4NGZwGKUpPRyaQajhYYbADHDYL8S', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'UfMRkggm5w', NULL, '2025-11-05 13:56:19', '2025-11-05 13:56:19'),
(32, 'Cahyo Kristiono, SST., M.Stat', 'ckris@bps.go.id', '2025-11-05 13:56:19', '$2y$10$qmBsOhyUNkbUPI05ZurKE.FLOylyXeP7P3QKIQHVai.VbnClumni.', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'Gaa4QUuC7R', NULL, '2025-11-05 13:56:19', '2025-11-05 13:56:19'),
(33, 'EKO DWI PUDJIANA', 'eko.dwip@bps.go.id', '2025-11-05 13:56:19', '$2y$10$hFpZtHKHWQN6oBajvPDk7.ueWH0kyOvhx9FaPJutjeBl6M3U/GEOS', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'irKYhCKdiV', NULL, '2025-11-05 13:56:19', '2025-11-05 13:56:19'),
(34, 'EKO PUJIYANTO, SE', 'eko.pujiyanto@bps.go.id', '2025-11-05 13:56:19', '$2y$10$4OZ1T1z/X1yaAhFQCAWorOXFByUrxnlaTlZLW7Daox1NPilZhLMqC', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'MDhBdmyBLe', NULL, '2025-11-05 13:56:19', '2025-11-05 13:56:19'),
(35, 'EMA YULANDIKA SETYANING P., SST', 'emayulandika@bps.go.id', '2025-11-05 13:56:19', '$2y$10$DI4C4IrZI603teTT1pxePeqiDyqfmZuCyjGwIR7RbOHWkVPJlOHRC', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'l0Ez2k0Bwd', NULL, '2025-11-05 13:56:19', '2025-11-05 13:56:19'),
(36, 'EVAN SAKTI HERAWAN, A.Md', 'evanherawan@bps.go.id', '2025-11-05 13:56:19', '$2y$10$vBL4nPOFjp/TeGZTvVHMvOf4gLeytfIuh3xQcLb8Vm49AGDIGUX6W', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'BoJxNzlMlT', NULL, '2025-11-05 13:56:19', '2025-11-05 13:56:19'),
(37, 'FARIDA NURKHAYYATI, SST., M.Ec.Dev', 'faridanur@bps.go.id', '2025-11-05 13:56:20', '$2y$10$nsv2UHVCCN281S2Riyad8ucbISzILP3rixgwiEXBVstYrkhTWbPji', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'jgvnGeObip', NULL, '2025-11-05 13:56:20', '2025-11-05 13:56:20'),
(38, 'Ir. ANDHIKASARI KUSHARDATI', 'andhika@bps.go.id', '2025-11-05 13:56:20', '$2y$10$HKrMCytmu2mL1NssWBYqN.PNrWmlVHgxoIVXkVWX49MHiDuVDdA3u', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'gBB4C5SkY2GblpMLYpDsWfNzNTpu2QaBXNwBDA9KxSca9Dze5iLG0ceDgyhu', NULL, '2025-11-05 13:56:20', '2025-11-05 13:56:20'),
(39, 'Ir. EFIYANTI PUSPITORINI', 'efiyanti@bps.go.id', '2025-11-05 13:56:20', '$2y$10$w4LUBGiBhQV3zZsxsd83EeCbsEwDZx86wCbqbrTidSxbrmRNnIx6e', 'password', 'admin', 'BPS Kabupaten Klaten', '-', '95zvkUY2Jh', NULL, '2025-11-05 13:56:20', '2025-11-05 13:56:20'),
(40, 'Ir. SUDARMADI, M.Si', 'sudarmadi2@bps.go.id', '2025-11-05 13:56:20', '$2y$10$ohxBy1903NafXpP45jUOCObQn1Aff1NwODhYQ9gl6GVVvR/udJyeK', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'gCGuy15gvB', NULL, '2025-11-05 13:56:20', '2025-11-05 13:56:20'),
(41, 'Ir. SUPARYANTO', 'paryanto@bps.go.id', '2025-11-05 13:56:20', '$2y$10$IvWNLMUZsKUx.w0aQF1SfulNo6kxR90vOkmbLQ5aUoAOU9LNKriKa', 'password', 'admin', 'BPS Kabupaten Klaten', '-', '7F5nCjOnjJ', NULL, '2025-11-05 13:56:20', '2025-11-05 13:56:20'),
(42, 'IRWAN, S.Si., MA.', 'irwan2@bps.go.id', '2025-11-05 13:56:20', '$2y$10$OaQhltQ5ISqo/sjvQiRk.OrCbABOyn4qyp9Osg3wz8yx1OxS4lDXS', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'DtE28mcZMZ', NULL, '2025-11-05 13:56:20', '2025-11-05 13:56:20'),
(43, 'ISWADI', 'iswadi@bps.go.id', '2025-11-05 13:56:20', '$2y$10$vU7JXC6kobdDduLz8yE4nusGqNbsjdHxSLvM73f.zlW9NjHRGDGEG', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'ixwV0mc746', NULL, '2025-11-05 13:56:20', '2025-11-05 13:56:20'),
(44, 'LARA AYU CAHYANINGTYAS, S.Tr.Stat.', 'laraayu@bps.go.id', '2025-11-05 13:56:20', '$2y$10$O0BkVhtFTVBZjhl4/3UEIOKrhlHJ9UVu4s3dU0/jHxerOsKWbU956', 'password', 'admin', 'BPS Kabupaten Klaten', '-', '1xbIiLBWDk', NULL, '2025-11-05 13:56:20', '2025-11-05 13:56:20'),
(45, 'LATIF EFENDI', 'latif.effendi@bps.go.id', '2025-11-05 13:56:20', '$2y$10$Mpu8v2mQSYJ2CD49JPovwO6WbV58wnTjQf2466GoEzYPpS3XPNhWC', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'ItP5AA1mUv', NULL, '2025-11-05 13:56:20', '2025-11-05 13:56:20'),
(46, 'LATIFAH ANDRIANI, SST', 'latifah.andriani@bps.go.id', '2025-11-05 13:56:21', '$2y$10$xGusKa.Ho8nCGh7.DbhAteIn9jOjbpZwBFI5rStzL69Uc.9syvb6y', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'NMdqu8pMs3', NULL, '2025-11-05 13:56:21', '2025-11-05 13:56:21'),
(47, 'M. SALAMUDIN', 'salamudin@bps.go.id', '2025-11-05 13:56:21', '$2y$10$e/u8brhWZcpj4A7oH1yz4.eIxajG1D5p08jn/YokTmiXZVarwc7om', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'RF6pfpk9WQ', NULL, '2025-11-05 13:56:21', '2025-11-05 13:56:21'),
(48, 'MASKANATUL MAULIDA, A.Md.Stat', 'maskanatul.maulida@bps.go.id', '2025-11-05 13:56:21', '$2y$10$9f2TW/oEnDVrJeJmRs.jXeGftr4.2S9sLPBGhYvzfCp4KngvZ.7um', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'g5E3EMruwb', NULL, '2025-11-05 13:56:21', '2025-11-05 13:56:21'),
(49, 'MIDDIA MARTANTI DEWI, SST., M.Sc.', 'middia@bps.go.id', '2025-11-05 13:56:21', '$2y$10$cTGA4llts.b6T5XjjXxWZepg1D1hDSa9khPbHLIxDhEzG3Bz6v0Xi', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'ng9mfZNwnQH4KaJ9ph9NL4rfbpLtVIYFAwFm7nS74kWGXA4RkuMcshjl6Rz9', NULL, '2025-11-05 13:56:21', '2025-11-05 13:56:21'),
(50, 'MUHAMMAD ANIES MIZFAR, SST', 'muhammad.mizfar@bps.go.id', '2025-11-05 13:56:21', '$2y$10$JLTIdvkZbGp.aq8CSlCIYuQH5z0O8YD.J9IKd3cJe9g145g.N3Txy', 'password', 'admin', 'BPS Kabupaten Klaten', '-', '6vRhmXzGMe', NULL, '2025-11-05 13:56:21', '2025-11-05 13:56:21'),
(51, 'MURDIYANTO, SE', 'murdiyanto@bps.go.id', '2025-11-05 13:56:21', '$2y$10$W27zsUQvdDa6xv08i3Bxje30t1MhzxWDX3X8VJ80k06myF9zk8F4S', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'xiw8jHkJi9', NULL, '2025-11-05 13:56:21', '2025-11-05 13:56:21'),
(52, 'NUR HIDAYAH, S.Si', 'nur.hidayah@bps.go.id', '2025-11-05 13:56:21', '$2y$10$ivYCqX1HR.BI7y.5QenGB.IzKzL1JvbfKo.tyDgG1IdMQVVw22COC', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'VqRtVbETtL', NULL, '2025-11-05 13:56:21', '2025-11-05 13:56:21'),
(53, 'NURUL KHASNAH, A.Md', 'nurulasa@bps.go.id', '2025-11-05 13:56:21', '$2y$10$pF2vMewdIXtMnUVV8nLEqO9WZp8BzIM5MVe7FEQFjOhznJtBYceNW', 'password', 'admin', 'BPS Kabupaten Klaten', '-', '4qxSSKuk4g', NULL, '2025-11-05 13:56:21', '2025-11-05 13:56:21'),
(54, 'NUUR RAFI WISMAMIEN, S.Si', 'nurafi@bps.go.id', '2025-11-05 13:56:22', '$2y$10$HlXwc6k.VjN4ajfJ5f1gx.5mqnm.nAbClXqRUuYsIi4wlq0g74Rt.', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'lRh1vJUPU2', NULL, '2025-11-05 13:56:22', '2025-11-05 13:56:22'),
(55, 'PRASETIYO NUGROHO, SST', 'pras.nugroho@bps.go.id', '2025-11-05 13:56:22', '$2y$10$.GdNwBOU.fGkO0lbHx9jzOJjuil.0kQ7yzNzK/RFBLxF/rpb.QW1y', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'xBH0qCrEcA', NULL, '2025-11-05 13:56:22', '2025-11-05 13:56:22'),
(56, 'PULUNG JATI SUDARMINTO, S.Si', 'pulung.jati@bps.go.id', '2025-11-05 13:56:22', '$2y$10$JAbbB4JE6nmPXfVOAp75VuOo5GlLqHKGWUsW0zvYLzl1Tj9ZWqTpG', 'password', 'admin', 'BPS Kabupaten Klaten', '-', '5royEXJIXr', NULL, '2025-11-05 13:56:22', '2025-11-05 13:56:22'),
(57, 'RIFKY YUDHA ARDHANA, STrStat', 'rifky.yudha@bps.go.id', '2025-11-05 13:56:22', '$2y$10$5j20ghjkK.OzUz9v.wq8LO9mrWkYTDZLt.uaUQ7kT03x0xL9IR7Va', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'yM18CuNgq3', NULL, '2025-11-05 13:56:22', '2025-11-05 13:56:22'),
(58, 'ROHMAN WIDODO, SE', 'rohman.widodo@bps.go.id', '2025-11-05 13:56:22', '$2y$10$DjLfycvYL5jpuonzpoSxhO05sT4rDPx6mB/HET9EsaEOh30CRMEb.', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'tuXOgVYJpO', NULL, '2025-11-05 13:56:22', '2025-11-05 13:56:22'),
(59, 'SITI AMALIA, A.Md', 'siti.amalia@bps.go.id', '2025-11-05 13:56:22', '$2y$10$4YGYM2/jGRuJ95vOrBjOmOEUTRRloMtE/H1N1asjdaSg.SpBgdCoe', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'XUNljIOH1L', NULL, '2025-11-05 13:56:22', '2025-11-05 13:56:22'),
(60, 'SITI BADRIYAH, SE', 'siti.badriyah@bps.go.id', '2025-11-05 13:56:22', '$2y$10$k5Xkuh65UekhpFfZokQc9.8vOWl3AK82FB8BI4eX1QLYiLqCASJdK', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'K8Pt7QSgPp', NULL, '2025-11-05 13:56:22', '2025-11-05 13:56:22'),
(61, 'SLAMET WIDODO', 'slamet.widodo@bps.go.id', '2025-11-05 13:56:22', '$2y$10$i4nUXMeS5xKpkZsaiFtSWeAFmsfpUQfCOH61Z3.KaPMH2xuJLdr6C', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'TuhrkuRGps', NULL, '2025-11-05 13:56:22', '2025-11-05 13:56:22'),
(62, 'STEFANUS RIAN ALDESKA', 'aldeska@bps.go.id', '2025-11-05 13:56:22', '$2y$10$1ArTAi4wogxxWkZgMvqRLOGq3KEHEPZym2m3rhSba/x8Y.bWQgnh6', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'jixFpKbYyN', NULL, '2025-11-05 13:56:22', '2025-11-05 13:56:22'),
(63, 'SUNARDI, SST., M.Si.', 'nardi@bps.go.id', '2025-11-05 13:56:22', '$2y$10$sTlqPsy7u7/EQRsmDDMKbe22OoxPEI7pHgpLiRBj8F6J0OziWPsGy', 'password', 'admin', 'BPS Kabupaten Klaten', '-', '8ZK76eoigi3bZEBW7LXAqASRybSalo2TiqzeguIEMdMzxhMQNpkLpXycUu9P', NULL, '2025-11-05 13:56:22', '2025-11-05 13:56:22'),
(64, 'SUSI PEBRIANA, A.Md', 'susi.pebriana@bps.go.id', '2025-11-05 13:56:23', '$2y$10$FddA6JXCZnPklacug2kxZ.Nx.oPBcTyjk/bSL/RIWSX6twYtS2Yxq', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'zg0ib98vKR', NULL, '2025-11-05 13:56:23', '2025-11-05 13:56:23'),
(65, 'TAFIANINGSIH, A.Md', 'tafianingsih@bps.go.id', '2025-11-05 13:56:23', '$2y$10$4ZzqOB9E6ok2Zwfa8IToYeOgTXJsIsD8MtV4jMjBMBlw.PtoBHCd.', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'foqdXDf99T', NULL, '2025-11-05 13:56:23', '2025-11-05 13:56:23'),
(66, 'TATIK RUWIYANTI, A.Md', 'tatik_ruwiyati@bps.go.id', '2025-11-05 13:56:23', '$2y$10$4JvhF2MYfY8LE3kofjtE9OiUgvoC2t40kHv13Q23mAEuPSg/rEvki', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'zDYDQnVQHD', NULL, '2025-11-05 13:56:23', '2025-11-05 13:56:23'),
(67, 'TYAS JUALITA SANTY, SST, M.E.K.K', 'tyasjualita@bps.go.id', '2025-11-05 13:56:23', '$2y$10$t0LlJVceKHNljt66B40TcukVehZkPrn/IXBjggZwV2u4MFwK4B.oC', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'PpfQaoXRIr', NULL, '2025-11-05 13:56:23', '2025-11-05 13:56:23'),
(68, 'UNTUNG KURNIAWAN, SST., M.Si', 'untungk@bps.go.id', '2025-11-05 13:56:23', '$2y$10$VqvA9u5QDpu6GhlKq37k8uWuySlFJS3BfBZu.aACK/cm8aRFewtE6', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'Kd8fWJzMbl', NULL, '2025-11-05 13:56:23', '2025-11-05 13:56:23'),
(69, 'WAHYU DEWI WIDYANTI, S.Si', 'dewi.widyanti@bps.go.id', '2025-11-05 13:56:23', '$2y$10$unLz8seof8MO7BCgIOjc4.bHRBk9XYkBBa1QbzG8LJXxwTiFfdU8S', 'password', 'admin', 'BPS Kabupaten Klaten', '-', '6W9UQHddQo', NULL, '2025-11-05 13:56:23', '2025-11-05 13:56:23'),
(70, 'WAHYUNI SETYORINI, A.Md', 'wahyuni.setyorini@bps.go.id', '2025-11-05 13:56:23', '$2y$10$6RJ83RGuFoD0NhFVCxhM1uq0gW0RhmidpusIJHQgQ3K1XVDlN0/5q', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'zVhnD34FbK', NULL, '2025-11-05 13:56:23', '2025-11-05 13:56:23'),
(71, 'WISNU TRI WARDOYO', 'wisnu.wardoyo@bps.go.id', '2025-11-05 13:56:23', '$2y$10$JaKM/Sqms2sFoDaInZLYXeTJhTr4BhauWKm0C7td8FXRwNcqN2f1G', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'X8hPYJyiHp', NULL, '2025-11-05 13:56:23', '2025-11-05 13:56:23'),
(72, 'WORO INDAH PALUPI', 'woro.indah@bps.go.id', '2025-11-05 13:56:23', '$2y$10$7GcpA/kCZZVt1Bh0eukXoOY5JmwqKPAdzycfI/TnpKEAm4.uGeGQS', 'password', 'admin', 'BPS Kabupaten Klaten', '-', 'MYgr1gu3v7', NULL, '2025-11-05 13:56:23', '2025-11-05 13:56:23');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `aspeks`
--
ALTER TABLE `aspeks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `aspeks_domain_id_foreign` (`domain_id`);

--
-- Indexes for table `bukti_dukungs`
--
ALTER TABLE `bukti_dukungs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bukti_dukungs_penilaian_id_foreign` (`penilaian_id`);

--
-- Indexes for table `dokumentasi_kegiatans`
--
ALTER TABLE `dokumentasi_kegiatans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `dokumentasi_kegiatans_created_by_id_foreign` (`created_by_id`);

--
-- Indexes for table `domains`
--
ALTER TABLE `domains`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `file_dokumentasis`
--
ALTER TABLE `file_dokumentasis`
  ADD PRIMARY KEY (`id`),
  ADD KEY `file_dokumentasis_dokumentasi_kegiatan_id_foreign` (`dokumentasi_kegiatan_id`);

--
-- Indexes for table `file_pembinaans`
--
ALTER TABLE `file_pembinaans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `file_pembinaans_pembinaan_id_foreign` (`pembinaan_id`);

--
-- Indexes for table `formulirs`
--
ALTER TABLE `formulirs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `formulirs_created_by_id_foreign` (`created_by_id`);

--
-- Indexes for table `formulir_domains`
--
ALTER TABLE `formulir_domains`
  ADD PRIMARY KEY (`id`),
  ADD KEY `formulir_domains_formulir_id_foreign` (`formulir_id`),
  ADD KEY `formulir_domains_domain_id_foreign` (`domain_id`);

--
-- Indexes for table `formulir_penilaian_disposisis`
--
ALTER TABLE `formulir_penilaian_disposisis`
  ADD PRIMARY KEY (`id`),
  ADD KEY `formulir_penilaian_disposisis_formulir_id_foreign` (`formulir_id`),
  ADD KEY `formulir_penilaian_disposisis_indikator_id_foreign` (`indikator_id`),
  ADD KEY `formulir_penilaian_disposisis_from_profile_id_foreign` (`from_profile_id`),
  ADD KEY `formulir_penilaian_disposisis_to_profile_id_foreign` (`to_profile_id`),
  ADD KEY `formulir_penilaian_disposisis_assigned_profile_id_foreign` (`assigned_profile_id`);

--
-- Indexes for table `indikators`
--
ALTER TABLE `indikators`
  ADD PRIMARY KEY (`id`),
  ADD KEY `indikators_aspek_id_foreign` (`aspek_id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  ADD KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Indexes for table `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  ADD KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `pembinaans`
--
ALTER TABLE `pembinaans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pembinaans_created_by_id_foreign` (`created_by_id`);

--
-- Indexes for table `penilaians`
--
ALTER TABLE `penilaians`
  ADD PRIMARY KEY (`id`),
  ADD KEY `penilaians_formulir_id_foreign` (`formulir_id`),
  ADD KEY `penilaians_user_id_foreign` (`user_id`),
  ADD KEY `penilaians_indikator_id_foreign` (`indikator_id`),
  ADD KEY `penilaians_dikerjakan_by_foreign` (`dikerjakan_by`),
  ADD KEY `penilaians_diupdate_by_foreign` (`diupdate_by`),
  ADD KEY `penilaians_dikoreksi_by_foreign` (`dikoreksi_by`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `permissions_name_guard_name_unique` (`name`,`guard_name`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_name_guard_name_unique` (`name`,`guard_name`);

--
-- Indexes for table `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`role_id`),
  ADD KEY `role_has_permissions_role_id_foreign` (`role_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `aspeks`
--
ALTER TABLE `aspeks`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `bukti_dukungs`
--
ALTER TABLE `bukti_dukungs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `dokumentasi_kegiatans`
--
ALTER TABLE `dokumentasi_kegiatans`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `domains`
--
ALTER TABLE `domains`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `file_dokumentasis`
--
ALTER TABLE `file_dokumentasis`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `file_pembinaans`
--
ALTER TABLE `file_pembinaans`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `formulirs`
--
ALTER TABLE `formulirs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `formulir_domains`
--
ALTER TABLE `formulir_domains`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT for table `formulir_penilaian_disposisis`
--
ALTER TABLE `formulir_penilaian_disposisis`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `indikators`
--
ALTER TABLE `indikators`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `pembinaans`
--
ALTER TABLE `pembinaans`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `penilaians`
--
ALTER TABLE `penilaians`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=122;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `aspeks`
--
ALTER TABLE `aspeks`
  ADD CONSTRAINT `aspeks_domain_id_foreign` FOREIGN KEY (`domain_id`) REFERENCES `domains` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `bukti_dukungs`
--
ALTER TABLE `bukti_dukungs`
  ADD CONSTRAINT `bukti_dukungs_penilaian_id_foreign` FOREIGN KEY (`penilaian_id`) REFERENCES `penilaians` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `dokumentasi_kegiatans`
--
ALTER TABLE `dokumentasi_kegiatans`
  ADD CONSTRAINT `dokumentasi_kegiatans_created_by_id_foreign` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `file_dokumentasis`
--
ALTER TABLE `file_dokumentasis`
  ADD CONSTRAINT `file_dokumentasis_dokumentasi_kegiatan_id_foreign` FOREIGN KEY (`dokumentasi_kegiatan_id`) REFERENCES `dokumentasi_kegiatans` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `file_pembinaans`
--
ALTER TABLE `file_pembinaans`
  ADD CONSTRAINT `file_pembinaans_pembinaan_id_foreign` FOREIGN KEY (`pembinaan_id`) REFERENCES `pembinaans` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `formulirs`
--
ALTER TABLE `formulirs`
  ADD CONSTRAINT `formulirs_created_by_id_foreign` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `formulir_domains`
--
ALTER TABLE `formulir_domains`
  ADD CONSTRAINT `formulir_domains_domain_id_foreign` FOREIGN KEY (`domain_id`) REFERENCES `domains` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `formulir_domains_formulir_id_foreign` FOREIGN KEY (`formulir_id`) REFERENCES `formulirs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `formulir_penilaian_disposisis`
--
ALTER TABLE `formulir_penilaian_disposisis`
  ADD CONSTRAINT `formulir_penilaian_disposisis_assigned_profile_id_foreign` FOREIGN KEY (`assigned_profile_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `formulir_penilaian_disposisis_formulir_id_foreign` FOREIGN KEY (`formulir_id`) REFERENCES `formulirs` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `formulir_penilaian_disposisis_from_profile_id_foreign` FOREIGN KEY (`from_profile_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `formulir_penilaian_disposisis_indikator_id_foreign` FOREIGN KEY (`indikator_id`) REFERENCES `indikators` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `formulir_penilaian_disposisis_to_profile_id_foreign` FOREIGN KEY (`to_profile_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `indikators`
--
ALTER TABLE `indikators`
  ADD CONSTRAINT `indikators_aspek_id_foreign` FOREIGN KEY (`aspek_id`) REFERENCES `aspeks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `pembinaans`
--
ALTER TABLE `pembinaans`
  ADD CONSTRAINT `pembinaans_created_by_id_foreign` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `penilaians`
--
ALTER TABLE `penilaians`
  ADD CONSTRAINT `penilaians_dikerjakan_by_foreign` FOREIGN KEY (`dikerjakan_by`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `penilaians_dikoreksi_by_foreign` FOREIGN KEY (`dikoreksi_by`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `penilaians_diupdate_by_foreign` FOREIGN KEY (`diupdate_by`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `penilaians_formulir_id_foreign` FOREIGN KEY (`formulir_id`) REFERENCES `formulirs` (`id`),
  ADD CONSTRAINT `penilaians_indikator_id_foreign` FOREIGN KEY (`indikator_id`) REFERENCES `indikators` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `penilaians_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
