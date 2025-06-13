-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: trend_clothes
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `brands`
--

DROP TABLE IF EXISTS `brands`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `brands` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `brands`
--

LOCK TABLES `brands` WRITE;
/*!40000 ALTER TABLE `brands` DISABLE KEYS */;
/*!40000 ALTER TABLE `brands` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_locks`
--

LOCK TABLES `cache_locks` WRITE;
/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_items`
--

DROP TABLE IF EXISTS `cart_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cart_items` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `product_id` bigint(20) unsigned NOT NULL,
  `size_id` bigint(20) unsigned DEFAULT NULL,
  `size` varchar(255) DEFAULT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cart_items_user_id_foreign` (`user_id`),
  KEY `cart_items_product_id_foreign` (`product_id`),
  KEY `cart_items_size_id_foreign` (`size_id`),
  CONSTRAINT `cart_items_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cart_items_size_id_foreign` FOREIGN KEY (`size_id`) REFERENCES `sizes` (`id`) ON DELETE SET NULL,
  CONSTRAINT `cart_items_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_items`
--

LOCK TABLES `cart_items` WRITE;
/*!40000 ALTER TABLE `cart_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `categories_slug_unique` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (2,'Camisetas','camisetas',NULL,'categories/6GeSj7rlfsq4wdNzi4EnvMOB6JyB3nmULmwErU3g.webp','2025-05-27 12:09:08','2025-05-27 12:09:08'),(3,'Sudaderas','sudaderas',NULL,'categories/zcrKIggigYOIjxtL50Ecv4g1yhuogQC3UeOKWFX8.webp','2025-05-27 12:49:02','2025-05-29 05:18:30'),(4,'Pantalones','pantalones',NULL,'categories/ZYVBseY2amUrChdcCaRjraisGz9MxUncAc7Ixvrf.jpg','2025-05-28 08:34:53','2025-05-28 08:34:53');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `failed_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) unsigned NOT NULL,
  `reserved_at` int(10) unsigned DEFAULT NULL,
  `available_at` int(10) unsigned NOT NULL,
  `created_at` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'0001_01_01_000000_create_users_table',1),(2,'0001_01_01_000001_create_cache_table',1),(3,'0001_01_01_000002_create_jobs_table',1),(4,'2025_05_06_155209_add_role_to_users_table',1),(5,'2025_05_06_181833_create_categories_table',1),(6,'2025_05_06_182027_create_sizes_table',1),(7,'2025_05_06_182042_create_products_table',1),(8,'2025_05_06_182120_create_reviews_table',1),(9,'2025_05_06_182132_create_promotions_table',1),(10,'2025_05_06_184425_create_product_promotion_table',1),(11,'2025_05_06_214520_create_product_images_table',1),(12,'2025_05_11_111422_add_color_and_brand_to_products_table',1),(13,'2025_05_12_152853_create_brands_table',1),(14,'2025_05_13_142523_add_published_to_products_table',1),(15,'2025_05_17_105038_create_product_size_table',1),(16,'2025_05_18_103403_add_avatar_to_users_table',1),(17,'2025_05_25_094000_create_user_addresses_table',1),(18,'2025_05_25_094140_create_orders_table',1),(19,'2025_05_25_094141_create_payments_table',1),(20,'2025_05_25_095314_create_order_items_table',1),(21,'2025_05_25_095341_create_cart_items_table',1),(22,'2025_05_25_114906_add_stock_to_products_table',1),(23,'2025_05_26_080632_add_size_id_to_order_items_table',2);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_items` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) unsigned NOT NULL,
  `product_id` bigint(20) unsigned NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(8,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `size_id` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_items_order_id_foreign` (`order_id`),
  KEY `order_items_product_id_foreign` (`product_id`),
  KEY `order_items_size_id_foreign` (`size_id`),
  CONSTRAINT `order_items_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_size_id_foreign` FOREIGN KEY (`size_id`) REFERENCES `sizes` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (61,60,4,1,59.99,'2025-05-28 13:22:52','2025-05-28 13:22:52',4),(62,61,4,1,59.99,'2025-05-28 13:23:25','2025-05-28 13:23:25',4),(63,61,4,1,59.99,'2025-05-28 13:23:25','2025-05-28 13:23:25',5),(64,62,4,1,59.99,'2025-05-28 13:24:44','2025-05-28 13:24:44',4),(65,62,4,2,59.99,'2025-05-28 13:24:44','2025-05-28 13:24:44',5),(66,63,4,1,59.99,'2025-05-30 06:50:49','2025-05-30 06:50:49',5),(67,64,4,1,59.99,'2025-05-30 06:52:05','2025-05-30 06:52:05',5),(68,65,4,1,59.99,'2025-05-30 07:12:31','2025-05-30 07:12:31',7),(69,66,4,1,59.99,'2025-05-30 08:08:01','2025-05-30 08:08:01',8),(70,67,4,1,59.99,'2025-05-30 08:12:54','2025-05-30 08:12:54',8),(71,68,4,1,59.99,'2025-05-30 08:13:45','2025-05-30 08:13:45',8),(72,69,4,1,59.99,'2025-05-30 08:29:53','2025-05-30 08:29:53',8),(73,70,4,1,59.99,'2025-05-30 08:36:33','2025-05-30 08:36:33',8),(74,71,4,1,59.99,'2025-05-30 08:42:06','2025-05-30 08:42:06',8),(75,72,4,1,59.99,'2025-05-30 08:58:30','2025-05-30 08:58:30',8),(76,73,4,1,59.99,'2025-05-30 08:59:50','2025-05-30 08:59:50',8),(77,74,4,1,59.99,'2025-05-30 10:54:19','2025-05-30 10:54:19',8),(78,75,4,1,59.99,'2025-06-01 06:53:52','2025-06-01 06:53:52',8),(79,76,4,1,59.99,'2025-06-01 06:55:56','2025-06-01 06:55:56',5),(80,77,9,1,17.99,'2025-06-05 08:16:52','2025-06-05 08:16:52',4),(81,77,9,1,17.99,'2025-06-05 08:16:52','2025-06-05 08:16:52',8),(82,78,9,2,17.99,'2025-06-05 08:23:34','2025-06-05 08:23:34',4),(83,78,9,1,17.99,'2025-06-05 08:23:34','2025-06-05 08:23:34',8),(84,79,9,1,17.99,'2025-06-05 08:24:22','2025-06-05 08:24:22',8),(85,79,9,1,17.99,'2025-06-05 08:24:22','2025-06-05 08:24:22',4),(86,80,4,1,59.99,'2025-06-10 11:47:09','2025-06-10 11:47:09',5);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `total` decimal(8,2) NOT NULL,
  `status` varchar(255) NOT NULL,
  `user_address_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `orders_user_id_foreign` (`user_id`),
  KEY `orders_user_address_id_foreign` (`user_address_id`),
  CONSTRAINT `orders_user_address_id_foreign` FOREIGN KEY (`user_address_id`) REFERENCES `user_addresses` (`id`) ON DELETE SET NULL,
  CONSTRAINT `orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,1,20.00,'completed',1,'2025-05-26 05:51:16','2025-05-26 05:51:37'),(2,1,30.00,'completed',1,'2025-05-26 06:09:52','2025-05-26 06:10:21'),(3,1,30.00,'completed',1,'2025-05-26 06:20:21','2025-05-26 06:21:13'),(4,1,20.00,'completed',1,'2025-05-26 06:33:26','2025-05-26 06:33:55'),(5,1,20.00,'completed',1,'2025-05-26 06:40:44','2025-05-26 06:41:11'),(6,1,5.00,'completed',1,'2025-05-26 07:42:55','2025-05-26 07:43:13'),(7,1,5.00,'completed',1,'2025-05-26 07:54:18','2025-05-26 07:54:41'),(8,1,5.00,'pending',1,'2025-05-26 07:56:58','2025-05-26 07:56:58'),(9,1,10.00,'pending',1,'2025-05-26 07:57:21','2025-05-26 07:57:21'),(10,1,10.00,'pending',1,'2025-05-26 07:58:19','2025-05-26 07:58:19'),(11,1,15.00,'pending',1,'2025-05-26 08:01:20','2025-05-26 08:01:20'),(12,1,5.00,'pending',1,'2025-05-26 08:03:10','2025-05-26 08:03:10'),(17,1,6.00,'completed',1,'2025-05-26 08:35:55','2025-05-26 08:36:17'),(18,1,6.00,'completed',1,'2025-05-26 08:41:49','2025-05-26 08:42:11'),(19,2,6.00,'pending',2,'2025-05-27 04:35:13','2025-05-27 04:35:13'),(20,2,6.00,'completed',2,'2025-05-27 04:37:01','2025-05-27 04:37:46'),(21,2,6.00,'completed',2,'2025-05-27 04:54:07','2025-05-27 04:54:30'),(22,2,6.00,'cancelled',2,'2025-05-27 05:04:11','2025-05-27 05:04:30'),(23,2,6.00,'cancelled',2,'2025-05-27 05:05:17','2025-05-27 05:05:39'),(24,2,12.00,'completed',2,'2025-05-27 05:06:39','2025-05-27 05:07:03'),(25,2,6.00,'completed',2,'2025-05-27 05:13:14','2025-05-27 05:13:37'),(26,2,6.00,'completed',2,'2025-05-27 05:15:58','2025-05-27 05:16:23'),(27,2,6.00,'completed',2,'2025-05-27 05:20:56','2025-05-27 05:21:17'),(28,2,6.00,'cancelled',2,'2025-05-27 05:29:50','2025-05-27 05:30:15'),(29,2,6.00,'completed',2,'2025-05-27 05:44:08','2025-05-27 05:44:34'),(30,2,6.00,'completed',2,'2025-05-27 05:55:37','2025-05-27 05:55:58'),(31,2,6.00,'completed',2,'2025-05-27 06:02:12','2025-05-27 06:02:33'),(32,2,6.00,'completed',2,'2025-05-27 06:03:36','2025-05-27 06:03:57'),(33,2,6.00,'completed',2,'2025-05-27 06:04:51','2025-05-27 06:05:17'),(34,2,6.00,'completed',2,'2025-05-27 06:07:43','2025-05-27 06:08:02'),(35,2,6.00,'pending',2,'2025-05-27 06:12:25','2025-05-27 06:12:25'),(36,2,6.00,'completed',2,'2025-05-27 06:13:17','2025-05-27 06:13:41'),(37,1,6.00,'completed',1,'2025-05-27 09:14:01','2025-05-27 09:14:22'),(38,1,6.00,'completed',1,'2025-05-27 09:27:56','2025-05-27 09:28:18'),(39,1,6.00,'completed',1,'2025-05-27 09:30:00','2025-05-27 09:30:20'),(40,1,6.00,'pending',1,'2025-05-27 09:37:30','2025-05-27 09:37:30'),(41,1,6.00,'completed',1,'2025-05-27 09:39:37','2025-05-27 09:40:00'),(42,1,6.00,'completed',1,'2025-05-27 09:41:42','2025-05-27 09:42:03'),(43,1,6.00,'completed',1,'2025-05-27 09:59:28','2025-05-27 09:59:47'),(44,1,50.00,'completed',3,'2025-05-27 12:07:38','2025-05-27 12:10:07'),(45,1,50.00,'completed',1,'2025-05-27 12:11:36','2025-05-27 12:12:14'),(46,1,6.00,'completed',1,'2025-05-27 12:51:45','2025-05-27 12:52:11'),(47,1,6.00,'completed',1,'2025-05-27 12:54:04','2025-05-27 12:54:27'),(48,1,50.00,'completed',1,'2025-05-27 13:28:44','2025-05-27 13:29:00'),(49,1,6.00,'completed',1,'2025-05-27 13:34:39','2025-05-27 13:34:56'),(50,1,6.00,'completed',1,'2025-05-27 13:37:05','2025-05-27 13:37:22'),(51,1,6.00,'completed',1,'2025-05-27 13:45:44','2025-05-27 13:46:04'),(52,1,6.00,'completed',1,'2025-05-27 14:21:50','2025-05-27 14:22:10'),(53,1,50.00,'completed',3,'2025-05-27 14:24:03','2025-05-27 14:24:21'),(54,1,50.00,'completed',1,'2025-05-27 14:50:06','2025-05-27 14:50:25'),(55,1,50.00,'completed',1,'2025-05-27 14:53:07','2025-05-27 14:53:23'),(56,1,50.00,'pending',1,'2025-05-27 15:03:24','2025-05-27 15:03:24'),(57,1,50.00,'pending',1,'2025-05-27 15:05:52','2025-05-27 15:05:52'),(58,1,50.00,'pending',1,'2025-05-27 15:08:26','2025-05-27 15:08:26'),(59,1,50.00,'pending',1,'2025-05-27 15:09:40','2025-05-27 15:09:40'),(60,1,59.99,'pending',1,'2025-05-28 13:22:52','2025-05-28 13:22:52'),(61,1,59.99,'pending',1,'2025-05-28 13:23:25','2025-05-28 13:23:25'),(62,1,59.99,'pending',1,'2025-05-28 13:24:44','2025-05-28 13:24:44'),(63,1,59.99,'pending',1,'2025-05-30 06:50:48','2025-05-30 06:50:48'),(64,1,59.99,'pending',1,'2025-05-30 06:52:05','2025-05-30 06:52:05'),(65,1,59.99,'completed',1,'2025-05-30 07:12:31','2025-05-30 07:12:56'),(66,1,59.99,'pending',1,'2025-05-30 08:08:01','2025-05-30 08:08:01'),(67,1,59.99,'pending',1,'2025-05-30 08:12:54','2025-05-30 08:12:54'),(68,1,59.99,'completed',1,'2025-05-30 08:13:45','2025-05-30 08:14:05'),(69,1,59.99,'completed',1,'2025-05-30 08:29:53','2025-05-30 08:30:11'),(70,1,59.99,'completed',1,'2025-05-30 08:36:33','2025-05-30 08:36:52'),(71,1,59.99,'completed',1,'2025-05-30 08:42:05','2025-05-30 08:42:23'),(72,1,59.99,'pending',1,'2025-05-30 08:58:30','2025-05-30 08:58:30'),(73,1,59.99,'completed',1,'2025-05-30 08:59:50','2025-05-30 09:00:44'),(74,1,59.99,'completed',1,'2025-05-30 10:54:19','2025-05-30 10:54:41'),(75,1,59.99,'completed',1,'2025-06-01 06:53:52','2025-06-01 06:54:17'),(76,1,59.99,'completed',3,'2025-06-01 06:55:56','2025-06-01 06:56:14'),(77,1,35.98,'pending',3,'2025-06-05 08:16:52','2025-06-05 08:16:52'),(78,1,35.98,'cancelled',3,'2025-06-05 08:23:34','2025-06-05 08:23:44'),(79,1,35.98,'completed',3,'2025-06-05 08:24:22','2025-06-05 08:25:51'),(80,1,59.99,'completed',4,'2025-06-10 11:47:09','2025-06-10 11:47:23');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) unsigned NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `status` varchar(255) NOT NULL,
  `payment_method` varchar(255) NOT NULL,
  `transaction_id` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `payments_order_id_foreign` (`order_id`),
  CONSTRAINT `payments_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (1,1,20.00,'completed','stripe','pi_3RSvonD5Rx3Lku1o0HaAD80H','2025-05-26 05:51:17','2025-05-26 05:51:37'),(2,2,30.00,'completed','stripe','pi_3RSw6vD5Rx3Lku1o1eF4AuI2','2025-05-26 06:09:53','2025-05-26 06:10:21'),(3,3,30.00,'completed','stripe','pi_3RSwHQD5Rx3Lku1o0I2igj4K','2025-05-26 06:20:22','2025-05-26 06:21:13'),(4,4,20.00,'completed','stripe','pi_3RSwTjD5Rx3Lku1o0paQYLcl','2025-05-26 06:33:31','2025-05-26 06:33:55'),(5,5,20.00,'completed','stripe','pi_3RSwalD5Rx3Lku1o1HuUEe7p','2025-05-26 06:40:45','2025-05-26 06:41:11'),(6,6,5.00,'completed','stripe','pi_3RSxYoD5Rx3Lku1o17kWsi59','2025-05-26 07:42:55','2025-05-26 07:43:13'),(7,7,5.00,'completed','stripe','pi_3RSxjuD5Rx3Lku1o1K7ERUf1','2025-05-26 07:54:19','2025-05-26 07:54:41'),(8,17,6.00,'completed','stripe','pi_3RSyO9D5Rx3Lku1o1CiCHRc4','2025-05-26 08:35:56','2025-05-26 08:36:17'),(9,18,6.00,'completed','stripe','pi_3RSyTsD5Rx3Lku1o1kzqZti3','2025-05-26 08:41:50','2025-05-26 08:42:11'),(10,19,6.00,'pending','stripe','cs_test_a1H5XXSMNxJgdkDDe90I9KYyl970CVOhT3y8RExzriSKzGWJb7S4ulEC50','2025-05-27 04:35:31','2025-05-27 04:35:31'),(11,20,6.00,'completed','stripe','pi_3RTH8sD5Rx3Lku1o0DIpGXi6','2025-05-27 04:37:03','2025-05-27 04:37:46'),(12,21,6.00,'completed','stripe','pi_3RTHP4D5Rx3Lku1o1IlpUAk9','2025-05-27 04:54:08','2025-05-27 04:54:30'),(13,22,6.00,'cancelled','stripe','cs_test_a1bylrfFrG2mnj0AdZaSAB84KBsefeYZf7oBRysJRkksAeTw0zig9Yzsmk','2025-05-27 05:04:12','2025-05-27 05:04:30'),(14,23,6.00,'cancelled','stripe','cs_test_a1ePmuat7Iy8Ot2B13oJqyAfj3dUWhsckvvkQBchM3tkHDzKxx5EdQjMKT','2025-05-27 05:05:18','2025-05-27 05:05:39'),(15,24,12.00,'completed','stripe','pi_3RTHbDD5Rx3Lku1o1J4azgre','2025-05-27 05:06:40','2025-05-27 05:07:03'),(16,25,6.00,'completed','stripe','pi_3RTHhaD5Rx3Lku1o0MRZP1MQ','2025-05-27 05:13:15','2025-05-27 05:13:37'),(17,26,6.00,'completed','stripe','pi_3RTHkFD5Rx3Lku1o1aUfBNjp','2025-05-27 05:16:00','2025-05-27 05:16:23'),(18,27,6.00,'completed','stripe','pi_3RTHozD5Rx3Lku1o1QmZ4cVu','2025-05-27 05:20:57','2025-05-27 05:21:17'),(19,28,6.00,'cancelled','stripe','cs_test_a1y1DTKtpjClHDJeigZ6I6OI4k8jwnlyxBfQbjb9OFepssnWChWTV69tsF','2025-05-27 05:29:52','2025-05-27 05:30:15'),(20,29,6.00,'completed','stripe','pi_3RTIBXD5Rx3Lku1o1QbizQsa','2025-05-27 05:44:09','2025-05-27 05:44:34'),(21,30,6.00,'completed','stripe','pi_3RTIMYD5Rx3Lku1o1TBMrRiL','2025-05-27 05:55:38','2025-05-27 05:55:58'),(22,31,6.00,'completed','stripe','pi_3RTISwD5Rx3Lku1o1DOZLiLS','2025-05-27 06:02:13','2025-05-27 06:02:33'),(23,32,6.00,'completed','stripe','pi_3RTIUHD5Rx3Lku1o11AZafMl','2025-05-27 06:03:38','2025-05-27 06:03:57'),(24,33,6.00,'completed','stripe','pi_3RTIVZD5Rx3Lku1o1lxgFdTm','2025-05-27 06:04:53','2025-05-27 06:05:17'),(25,34,6.00,'completed','stripe','pi_3RTIYED5Rx3Lku1o0Lal8tlp','2025-05-27 06:07:44','2025-05-27 06:08:02'),(26,35,6.00,'pending','stripe','cs_test_a19r8VJO4yu0YEakw4g5xHWri9j17Y3VDD3B1T2SqP6s6xFAEh3TORHDHd','2025-05-27 06:12:26','2025-05-27 06:12:26'),(27,36,6.00,'completed','stripe','pi_3RTIdhD5Rx3Lku1o1yNwUboD','2025-05-27 06:13:17','2025-05-27 06:13:41'),(28,37,6.00,'completed','stripe','pi_3RTLSYD5Rx3Lku1o1aWsP3tB','2025-05-27 09:14:03','2025-05-27 09:14:22'),(29,38,6.00,'completed','stripe','pi_3RTLg1D5Rx3Lku1o0vZwO3J0','2025-05-27 09:27:58','2025-05-27 09:28:18'),(30,39,6.00,'completed','stripe','pi_3RTLi0D5Rx3Lku1o0lVdM4nk','2025-05-27 09:30:01','2025-05-27 09:30:20'),(31,40,6.00,'pending','stripe','cs_test_a1DkYeU4bhTgBF5YbGAnyXeGsqlaRKHDN6fnFkbnQxrfJl9tbK7ebzlBJq','2025-05-27 09:37:31','2025-05-27 09:37:31'),(32,41,6.00,'completed','stripe','pi_3RTLrLD5Rx3Lku1o14lHp9bJ','2025-05-27 09:39:38','2025-05-27 09:40:00'),(33,42,6.00,'completed','stripe','pi_3RTLtKD5Rx3Lku1o15z6mSB9','2025-05-27 09:41:44','2025-05-27 09:42:03'),(34,43,6.00,'completed','stripe','pi_3RTMAVD5Rx3Lku1o1DX35096','2025-05-27 09:59:29','2025-05-27 09:59:47'),(35,44,50.00,'completed','stripe','pi_3RTOCdD5Rx3Lku1o15EB6zFK','2025-05-27 12:07:39','2025-05-27 12:10:07'),(36,45,50.00,'completed','stripe','pi_3RTOEgD5Rx3Lku1o0jnAP8Ym','2025-05-27 12:11:37','2025-05-27 12:12:14'),(37,46,6.00,'completed','stripe','pi_3RTOrLD5Rx3Lku1o0lU4x85j','2025-05-27 12:51:47','2025-05-27 12:52:11'),(38,47,6.00,'completed','stripe','pi_3RTOtXD5Rx3Lku1o16kxLXL8','2025-05-27 12:54:06','2025-05-27 12:54:27'),(39,48,50.00,'completed','stripe','pi_3RTPR0D5Rx3Lku1o0yOp5rbi','2025-05-27 13:28:44','2025-05-27 13:29:00'),(40,49,6.00,'completed','stripe','pi_3RTPWjD5Rx3Lku1o1UcaXU4J','2025-05-27 13:34:40','2025-05-27 13:34:56'),(41,50,6.00,'completed','stripe','pi_3RTPZ6D5Rx3Lku1o0x9DnSDZ','2025-05-27 13:37:06','2025-05-27 13:37:22'),(42,51,6.00,'completed','stripe','pi_3RTPhVD5Rx3Lku1o1GBNGUjN','2025-05-27 13:45:45','2025-05-27 13:46:04'),(43,52,6.00,'completed','stripe','pi_3RTQGRD5Rx3Lku1o1yapoTVP','2025-05-27 14:21:51','2025-05-27 14:22:10'),(44,53,50.00,'completed','stripe','pi_3RTQIZD5Rx3Lku1o0IIKG9Cu','2025-05-27 14:24:03','2025-05-27 14:24:21'),(45,54,50.00,'completed','stripe','pi_3RTQhnD5Rx3Lku1o1akQV4Kf','2025-05-27 14:50:07','2025-05-27 14:50:25'),(46,55,50.00,'completed','stripe','pi_3RTQkfD5Rx3Lku1o0vlCL3No','2025-05-27 14:53:07','2025-05-27 14:53:23'),(47,65,59.99,'completed','stripe','pi_3RUOzhD5Rx3Lku1o1DCnUamR','2025-05-30 07:12:36','2025-05-30 07:12:56'),(48,66,59.99,'pending','stripe','cs_test_a1iiAvg90KEZ99KvUogA8Fmi6HgpXKeRAswn8LzCYTmCJrfDvdFuqcy87D','2025-05-30 08:08:05','2025-05-30 08:08:05'),(49,67,59.99,'pending','stripe','cs_test_a1e8byO1sunwB2rm9xdNcL2bvwf4GbxhCi1loQV8Lmr9nnmybmt6K5NNZz','2025-05-30 08:12:55','2025-05-30 08:12:55'),(50,68,59.99,'completed','stripe','pi_3RUPwrD5Rx3Lku1o0guyMgec','2025-05-30 08:13:45','2025-05-30 08:14:05'),(51,69,59.99,'completed','stripe','pi_3RUQCSD5Rx3Lku1o0dtgyu4q','2025-05-30 08:29:54','2025-05-30 08:30:11'),(52,70,59.99,'completed','stripe','pi_3RUQIuD5Rx3Lku1o0ARMdZdQ','2025-05-30 08:36:34','2025-05-30 08:36:52'),(53,71,59.99,'completed','stripe','pi_3RUQOGD5Rx3Lku1o0hfMV4Vs','2025-05-30 08:42:06','2025-05-30 08:42:23'),(54,72,59.99,'pending','stripe','cs_test_a1qrUYE70BCDC0rQUQT3htCMWxoODRlQi0pl35ZimrPyOLJL0lbJOQ4qdC','2025-05-30 08:58:31','2025-05-30 08:58:31'),(55,73,59.99,'completed','stripe','pi_3RUQg0D5Rx3Lku1o1A35RdeO','2025-05-30 08:59:51','2025-05-30 09:00:44'),(56,74,59.99,'completed','stripe','pi_3RUSSFD5Rx3Lku1o0nWFSlqn','2025-05-30 10:54:21','2025-05-30 10:54:41'),(57,75,59.99,'completed','stripe','pi_3RV7ekD5Rx3Lku1o1BsEnEaJ','2025-06-01 06:53:57','2025-06-01 06:54:17'),(58,76,59.99,'completed','stripe','pi_3RV7gdD5Rx3Lku1o1v6LiSkR','2025-06-01 06:55:57','2025-06-01 06:56:14'),(59,77,35.98,'pending','stripe','cs_test_b1q4vzFKtqTbJKhd9uIY6WiReqZR2XNtDhmhk3BuhXgdQEyc23b8zhmXnv','2025-06-05 08:16:57','2025-06-05 08:16:57'),(60,78,35.98,'cancelled','stripe','cs_test_b1Sb3pVXmZpUs37nVkesd7dtTSNRjJgHR1i6VLGITerXJWaigQpe6YDvqw','2025-06-05 08:23:35','2025-06-05 08:23:44'),(61,79,35.98,'completed','stripe','pi_3RWazXD5Rx3Lku1o0fTaYbKX','2025-06-05 08:24:23','2025-06-05 08:25:51'),(62,80,59.99,'completed','stripe','pi_3RYSWMD5Rx3Lku1o1Nln0dSk','2025-06-10 11:47:10','2025-06-10 11:47:23');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_images`
--

DROP TABLE IF EXISTS `product_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_images` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` bigint(20) unsigned NOT NULL,
  `image_path` varchar(255) DEFAULT NULL,
  `is_main` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_images_product_id_foreign` (`product_id`),
  CONSTRAINT `product_images_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=192 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_images`
--

LOCK TABLES `product_images` WRITE;
/*!40000 ALTER TABLE `product_images` DISABLE KEYS */;
INSERT INTO `product_images` VALUES (2,4,'product_images/2jU7xCaqvoREpvvdSFcLrGS68lGwd0BPGQddv3KJ.webp',0,'2025-05-28 08:40:02','2025-05-28 08:40:02'),(3,4,'product_images/hM5l2GgYECR0TmtW7lYLMHkeqBkGGNz6JvYcUmSX.webp',0,'2025-05-28 08:40:02','2025-05-28 08:40:02'),(4,4,'product_images/xTxqgmYGfQfDmtvxSp362ajpfJw1xrrfQvwqrHK9.webp',0,'2025-05-28 08:40:02','2025-05-28 08:40:02'),(5,4,'product_images/L1qLtie0hXSJQ6l5yQArV3VoLl8UseGi54VIIcXR.webp',0,'2025-05-28 08:40:02','2025-05-28 08:40:02'),(6,5,'product_images/siQDu0IdVpXuUBsj87yVfy67lIY5arKtYnyQpTek.jpg',0,'2025-06-04 05:11:24','2025-06-04 05:11:24'),(7,5,'product_images/DdeIhs3vPvN4AHNt0uwouR0zVHhh4HK9kGkb3ALY.jpg',0,'2025-06-04 05:11:24','2025-06-04 05:11:24'),(8,5,'product_images/wg6HFHnfEitSogOeMSI1FZuna2vwczQGyoTXC1xn.jpg',0,'2025-06-04 05:11:24','2025-06-04 05:11:24'),(9,5,'product_images/xxYHzWrdbtWRESEkZ3SIRdlEogZC3UlxWJu17zKZ.jpg',0,'2025-06-04 05:11:24','2025-06-04 05:11:24'),(10,5,'product_images/1Ey29Y0wQckw25AJNIfki4gWfZa8U3CCE7bwS0ph.jpg',0,'2025-06-04 05:11:24','2025-06-04 05:11:24'),(11,6,'product_images/qW1Wz9BrnkHEPXE8qtM0lKUVNoDxHNwDMNiuW4Fi.jpg',0,'2025-06-04 05:13:53','2025-06-04 05:13:53'),(12,6,'product_images/b3BIenjwZQXL3ruV3OC9OqyInaAUE8UspdSLiek0.jpg',0,'2025-06-04 05:13:53','2025-06-04 05:13:53'),(13,6,'product_images/ZX6vwmpUfumdpYRJzQkwjMHeQn5u90na6Fb4F62n.jpg',0,'2025-06-04 05:13:53','2025-06-04 05:13:53'),(14,6,'product_images/39kIVyXXHdPgAqQM4zXzXsTpmljHceHodRdbsCkl.jpg',0,'2025-06-04 05:13:53','2025-06-04 05:13:53'),(15,6,'product_images/Mzjx2mxvtbc6zes7It11vYMGedz3ScvFLNYhoZEe.jpg',0,'2025-06-04 05:13:53','2025-06-04 05:13:53'),(16,7,'product_images/LC6znjZqHBYqHZ1OTLNAi2UTo0BjBnED1NISfig4.jpg',0,'2025-06-04 05:15:15','2025-06-04 05:15:15'),(17,7,'product_images/5TIVVdTYmb7ZCGt3Z1jYhNN8XSQBtUXHGJYLnNZS.jpg',0,'2025-06-04 05:15:15','2025-06-04 05:15:15'),(18,7,'product_images/OQB3NcGN6O6ZR830m4ULGYbTWZZXwUCzzJFtBqtf.jpg',0,'2025-06-04 05:15:15','2025-06-04 05:15:15'),(19,7,'product_images/HX64A6LizJxVXEe8a5pHLJVOa4Safwip1EwwfvIJ.jpg',0,'2025-06-04 05:15:15','2025-06-04 05:15:15'),(20,7,'product_images/YaX6SCgPMRDwFeSKDXDg0jUo9eRH82Gv9UdtHjx3.jpg',0,'2025-06-04 05:15:15','2025-06-04 05:15:15'),(21,8,'product_images/fnqmhCUavz9EmQcIdkjsMOahOjqB9rJfEwDtT83T.jpg',0,'2025-06-04 05:17:13','2025-06-04 05:17:13'),(22,8,'product_images/6SomcgmXYn2SwSVxMfQEPL8ecAmdkFO6S3gKHAgT.jpg',0,'2025-06-04 05:17:13','2025-06-04 05:17:13'),(23,8,'product_images/pH5kw34orI2IyxhO3Ef6ZA5jjl4efz83JVgFMijm.jpg',0,'2025-06-04 05:17:13','2025-06-04 05:17:13'),(24,8,'product_images/tggvyM0TU5k6zxRnM2Ui9rZGblXidtNINIh4v8cT.jpg',0,'2025-06-04 05:17:13','2025-06-04 05:17:13'),(25,8,'product_images/DFm4rr1rcZ0uNnE1kjw545w8GugNKW830s8GOz6E.jpg',0,'2025-06-04 05:17:13','2025-06-04 05:17:13'),(26,9,'product_images/xZjcJ6hzfLpaqm3TqJwdu6KJ5vKefnfD3f0qOdyS.jpg',0,'2025-06-04 05:19:07','2025-06-04 05:19:07'),(27,9,'product_images/TIpo7KrJtIHzrYc6Edkfi0SthWyqCNc0BLWoxXnt.jpg',0,'2025-06-04 05:19:07','2025-06-04 05:19:07'),(28,9,'product_images/uDenviQ1qIdTG5KgP97vNQIvYRRf423cwwVmpkpW.jpg',0,'2025-06-04 05:19:07','2025-06-04 05:19:07'),(29,9,'product_images/MpHtXCtUjDhlhOytTJgOTDrw8VSOTLarL9TholLd.jpg',0,'2025-06-04 05:19:07','2025-06-04 05:19:07'),(30,10,'product_images/1LZsEY49lnXw8ZwjSzaNEMS94yKSr9Me5BBC9UQ5.jpg',0,'2025-06-04 05:21:06','2025-06-04 05:21:06'),(31,10,'product_images/cnTnXM7NEhgUs57BkGEzfCGt3sI8CvP7yDlOFcDp.jpg',0,'2025-06-04 05:21:06','2025-06-04 05:21:06'),(32,10,'product_images/MfuBqU58yDwNM9SNt3PgIT1tT1XwWz1C9XGDBKkm.jpg',0,'2025-06-04 05:21:06','2025-06-04 05:21:06'),(33,10,'product_images/s1KofiDDjiA1PRkTpdM7uw7bZPrW4npbpCQH8LO8.jpg',0,'2025-06-04 05:21:06','2025-06-04 05:21:06'),(34,10,'product_images/8wK2O0cMgEqTLDM3TPI2cBmJgJcjhXSJkwuAvEM3.jpg',0,'2025-06-04 05:21:06','2025-06-04 05:21:06'),(43,12,'product_images/INSWT1uHGfEVeOaQsC3gsjRHk3nar68G9GrMstwF.jpg',0,'2025-06-09 10:57:11','2025-06-09 10:57:11'),(44,12,'product_images/pMWtt3MxGjzMCuD26Hlvh92cx3JDbBYPrGmao1Kd.jpg',0,'2025-06-09 10:57:11','2025-06-09 10:57:11'),(45,12,'product_images/1MDzvq71cnUjF9iM0qbreKDeLDfwvT5VC90oBazI.jpg',0,'2025-06-09 10:57:11','2025-06-09 10:57:11'),(46,12,'product_images/efZzLUYx6rIkjMHMHxsL5wnlSID0yMVRHEGdtocT.jpg',0,'2025-06-09 10:57:11','2025-06-09 10:57:11'),(47,13,'product_images/520yJmVitfntQUajlNohOqav4s2G7WCs6jaKEQau.jpg',0,'2025-06-09 10:58:28','2025-06-09 10:58:28'),(48,13,'product_images/I51QTHB6vIEDizbaYKdW918w0OS51LkvAcyQq41B.jpg',0,'2025-06-09 10:58:28','2025-06-09 10:58:28'),(49,13,'product_images/VDT6769yf91AemyVg1Mnj64KtiOfbBkgItHEUdzJ.jpg',0,'2025-06-09 10:58:28','2025-06-09 10:58:28'),(50,13,'product_images/tqfm8erFEp3P9194tNOrmTH3dagRHlGJRXU6dWlB.jpg',0,'2025-06-09 10:58:28','2025-06-09 10:58:28'),(51,14,'product_images/2EXj9vcVjLi1GdlrWquzARP4O5t6lM1kbUqgEaId.jpg',0,'2025-06-09 10:59:45','2025-06-09 10:59:45'),(52,14,'product_images/0PZVnLiFQFfRUO7ILcZDmd7DnBypfPes8wYQ3HJz.jpg',0,'2025-06-09 10:59:45','2025-06-09 10:59:45'),(53,14,'product_images/B3TykEQ636o6XblaUMdXrTvYJIu2lGafNq5P72zo.jpg',0,'2025-06-09 10:59:45','2025-06-09 10:59:45'),(54,14,'product_images/KbqbItE5qgFUKlGwyPW13bzPodPmuAF3Xf1eOqy9.jpg',0,'2025-06-09 10:59:45','2025-06-09 10:59:45'),(55,15,'product_images/ZpFkIp995X25pY5F4Dois76dcDLirgDWlpwm0YhA.jpg',0,'2025-06-09 11:03:15','2025-06-09 11:03:15'),(56,15,'product_images/b89s7VeCuwgezz2IxOjVRudlfM3g3CnSlYuqHC4g.jpg',0,'2025-06-09 11:03:15','2025-06-09 11:03:15'),(57,15,'product_images/G7ntT7ePmbrEc6rU4Ov9hzt9fspni1eQnBiHlnqQ.jpg',0,'2025-06-09 11:03:15','2025-06-09 11:03:15'),(58,15,'product_images/Tub6HiepKkmnUB0EUXsmKNWN4v8Lfjzusjizg3NL.jpg',0,'2025-06-09 11:03:15','2025-06-09 11:03:15'),(59,16,'product_images/EOyHr6J07Pnp2CNPtBO3U0LHydDyrT5wJRdO13ZG.jpg',0,'2025-06-09 11:04:32','2025-06-09 11:04:32'),(60,16,'product_images/jX0lhp6Z00tNQeODwm6l0W4lIjRO5rJIEfAtTqtA.jpg',0,'2025-06-09 11:04:32','2025-06-09 11:04:32'),(61,16,'product_images/Lk85Y2YrmY8tBTupBXcy4idTMxCyjROHLDY0TZhj.jpg',0,'2025-06-09 11:04:32','2025-06-09 11:04:32'),(62,16,'product_images/FT0WWwoR1i6PUCoY0NndSnBYeBrmHY9H66l8YgAd.jpg',0,'2025-06-09 11:04:32','2025-06-09 11:04:32'),(63,17,'product_images/CdY53uSeaetVKXctDoVYoeUTQ72GDY6Ve4EljvUU.jpg',0,'2025-06-09 11:08:08','2025-06-09 11:08:08'),(64,17,'product_images/g7jNwp6RiKVh8kJy610N3pBFV0Eq5Kp06NJtqE1y.jpg',0,'2025-06-09 11:08:08','2025-06-09 11:08:08'),(65,17,'product_images/lDNnwXnp1rDhUyAr86ADuVnnwu0yxcwLZXJLKJzI.jpg',0,'2025-06-09 11:08:08','2025-06-09 11:08:08'),(66,17,'product_images/zXOK8Bil8oAng9urniFizoSqK1SLT22NgnOgW4qT.jpg',0,'2025-06-09 11:08:08','2025-06-09 11:08:08'),(67,18,'product_images/bcH9z9dzmiN7WbQbaG1iXKzUMGLBUZQTe679qgyE.jpg',0,'2025-06-09 11:09:11','2025-06-09 11:09:11'),(68,18,'product_images/t4e4s42CxuBmIcChukeWE0hi1UyinxmqH7bflsZ8.jpg',0,'2025-06-09 11:09:11','2025-06-09 11:09:11'),(69,18,'product_images/nE7fZRnccmSAdjY9XGspdvcuSyjcXEqdWrHeQXVc.jpg',0,'2025-06-09 11:09:11','2025-06-09 11:09:11'),(70,18,'product_images/T7bCxGioJHBq7HqQsSmDjgVtZKHh3EushbI6toIK.jpg',0,'2025-06-09 11:09:11','2025-06-09 11:09:11'),(71,18,'product_images/v3wxQX3RBsQx8Rr4swEqguzjW1iCYHDmwewX8kmw.jpg',0,'2025-06-09 11:09:11','2025-06-09 11:09:11'),(72,19,'product_images/BvCLCRafJKuRKWwBK2En4yeXqJiFjKPUPvwjazzZ.jpg',0,'2025-06-09 11:10:16','2025-06-09 11:10:16'),(73,19,'product_images/iF86AfaZggv70Yqs5HllVlv9IEWPu6g7PpAHlFaU.jpg',0,'2025-06-09 11:10:16','2025-06-09 11:10:16'),(74,19,'product_images/Hhg2RSS5WZZ0m7xBw6Vwnr2ZN3IxpswhKR47Fpw2.jpg',0,'2025-06-09 11:10:16','2025-06-09 11:10:16'),(75,19,'product_images/pWvGR0kROWg2UnZ3JAf4Lxbwhn3nUg8QUCCyQkhu.jpg',0,'2025-06-09 11:10:16','2025-06-09 11:10:16'),(76,20,'product_images/yLhHHwhZRHk6weEyUfnE2cOhdOIvHOqVPSJiU7hP.jpg',0,'2025-06-09 11:11:21','2025-06-09 11:11:21'),(77,20,'product_images/VgAXYI1TERA7rzZGoy5hbO6dyYARbF1RIc77emL3.jpg',0,'2025-06-09 11:11:21','2025-06-09 11:11:21'),(78,20,'product_images/fN1dQvEHgm8RlSrDfcLzIPy4LTtxvsIYxtZPxhRP.jpg',0,'2025-06-09 11:11:21','2025-06-09 11:11:21'),(79,20,'product_images/EFPBKn1QtrFvRy5ydiPT0ipItcfEYTOv7zACdd7L.jpg',0,'2025-06-09 11:11:21','2025-06-09 11:11:21'),(80,21,'product_images/EgWrOQnNTg8HlxGHCJblBxiZ6Gp2R5ENUcnXde93.jpg',0,'2025-06-09 11:13:02','2025-06-09 11:13:02'),(81,21,'product_images/AM0y7K7XfmO8yulbim1Ha2UzPltOXnLdEx8gIs18.jpg',0,'2025-06-09 11:13:02','2025-06-09 11:13:02'),(82,21,'product_images/O2Gha2bPMPod8AiMurEvHqa3QEEmcLdDGapPHIay.jpg',0,'2025-06-09 11:13:02','2025-06-09 11:13:02'),(83,21,'product_images/i9DBDlSEYQHZmt556XVmwD2ADVNYyzKyWG314JCc.jpg',0,'2025-06-09 11:13:02','2025-06-09 11:13:02'),(84,22,'product_images/uBJzhVeGHwovOJhO6QE4SWl9sTvSRFA1QPXDRtlM.jpg',0,'2025-06-09 11:14:16','2025-06-09 11:14:16'),(85,22,'product_images/7wz3c0FpWyxz8exyzIj1xKhAyqpbDpwhUJiJBsFr.jpg',0,'2025-06-09 11:14:16','2025-06-09 11:14:16'),(86,22,'product_images/NjmDqM5iB6qyiirYjHfWtKgXGf6dQGLf7SFKwLuy.jpg',0,'2025-06-09 11:14:16','2025-06-09 11:14:16'),(87,22,'product_images/TTUtIrMojMmHYqUowwwf696iZkBU6sRni7S0sO38.jpg',0,'2025-06-09 11:14:16','2025-06-09 11:14:16'),(88,23,'product_images/PuhVgNEzFPw0G9QeIzBwNWhOEuCbrjbiUfhy4pNc.jpg',0,'2025-06-09 14:31:27','2025-06-09 14:31:27'),(89,23,'product_images/SqFOKZFzEfhahuZF2aAW2DKVwrSyUXM2XyKC9t5W.jpg',0,'2025-06-09 14:31:27','2025-06-09 14:31:27'),(90,23,'product_images/HSf3jysOPpeqtKyUTJTwhyMb6ZM7J3iwV9Iudaxh.jpg',0,'2025-06-09 14:31:27','2025-06-09 14:31:27'),(91,23,'product_images/RFvZGafRUOztUs2acKlvRBbenyRscJ7yVMjHP2bv.jpg',0,'2025-06-09 14:31:27','2025-06-09 14:31:27'),(92,24,'product_images/RN0VeESWc9VwcBOwVueKTJEHi1pJJv3ur3aH2q1D.jpg',0,'2025-06-09 14:36:22','2025-06-09 14:36:22'),(93,24,'product_images/2YoAI2ZjOkd8B3CwHj7FnVS2iJSxZCWHEWcsiFzz.jpg',0,'2025-06-09 14:36:22','2025-06-09 14:36:22'),(94,24,'product_images/HH16aJI9WiuZVQY6uW4upToCkpVizRu4ylJgXZ08.jpg',0,'2025-06-09 14:36:22','2025-06-09 14:36:22'),(95,24,'product_images/OcwgSgCJOdLiSDnBoGCDJ5fezn4oO7FbPSFgYGKJ.jpg',0,'2025-06-09 14:36:22','2025-06-09 14:36:22'),(96,24,'product_images/pwaJZk8qUYCh0kkBUP0D5snVyRF2FN8W6QUSody6.jpg',0,'2025-06-09 14:36:22','2025-06-09 14:36:22'),(97,25,'product_images/fYsH6nlk7ZxlgealUKIsdnWi1ataj2cHRejSc7YY.jpg',0,'2025-06-09 14:43:45','2025-06-09 14:43:45'),(98,25,'product_images/UnE3euBQkPek2hARqsebNWx0dlYPwgEzhGZXSugX.jpg',0,'2025-06-09 14:43:45','2025-06-09 14:43:45'),(99,25,'product_images/v8SFXtJJzacaSE6Pzk3DfAbnJwbRA4o0P1CnBbTG.jpg',0,'2025-06-09 14:43:45','2025-06-09 14:43:45'),(100,25,'product_images/t0ewxRgeQ0lQJf1QUC7VunsB9TWsMjPyJ3Ow9S50.jpg',0,'2025-06-09 14:43:45','2025-06-09 14:43:45'),(101,25,'product_images/LGHKdnF5uYPzWyFy38TTt4ciWaCll8n3xaS7PXEg.jpg',0,'2025-06-09 14:43:45','2025-06-09 14:43:45'),(102,26,'product_images/XQWF90Ton2qJkQtUxfB2nvm5tAWdSHq8lwD4gKm3.jpg',0,'2025-06-09 14:45:19','2025-06-09 14:45:19'),(103,26,'product_images/KO175xiVSa2BFFnoFZ6HKbQBx9E3AiR0pUk4OeEy.jpg',0,'2025-06-09 14:45:19','2025-06-09 14:45:19'),(104,26,'product_images/YYq7FAoPfZ6KIzoL8H6QH5slzJ8BafWCZO8VESv5.jpg',0,'2025-06-09 14:45:19','2025-06-09 14:45:19'),(105,26,'product_images/8Mumaaz7UbibxAdddxNslrQNU7OfxCMPjnHPc7so.jpg',0,'2025-06-09 14:45:19','2025-06-09 14:45:19'),(106,26,'product_images/DoNN731ee2HX9hkALfO30trPv3SKO79UAiEmS7RC.jpg',0,'2025-06-09 14:45:19','2025-06-09 14:45:19'),(107,27,'product_images/njC2bDhKVDglgk3qu8ZzxKF6GgJQMCCsp64Osa2O.jpg',0,'2025-06-09 14:47:10','2025-06-09 14:47:10'),(108,27,'product_images/G1rLlIuBptW4fVWKYoEXO640O66CLvoqhLevc837.jpg',0,'2025-06-09 14:47:10','2025-06-09 14:47:10'),(109,27,'product_images/Qq6ePzczlGTGDv50S63WTYU9qRYRfXudMVaZII7S.jpg',0,'2025-06-09 14:47:10','2025-06-09 14:47:10'),(110,27,'product_images/6iw5idi1dnpCvaN4IIoOZSLkPjOyXzWZWIQ9JsSC.jpg',0,'2025-06-09 14:47:10','2025-06-09 14:47:10'),(111,27,'product_images/OFxDNR1U2DSYg4lrqHv7GTS6NOcpAxVm5kVmHKDU.jpg',0,'2025-06-09 14:47:10','2025-06-09 14:47:10'),(112,28,'product_images/kLixD8Pf8haL0RHfS3uQQqk2OaeUsBRjv1QP6K63.jpg',0,'2025-06-09 14:48:15','2025-06-09 14:48:15'),(113,28,'product_images/8QqygLPAre9VCPCZ2YCam9CZDPqfF5pyNshbraif.jpg',0,'2025-06-09 14:48:15','2025-06-09 14:48:15'),(114,28,'product_images/i7llhwjoVMyn2W0hnT0wNFrLmukFb6FVs2A6UGc7.jpg',0,'2025-06-09 14:48:15','2025-06-09 14:48:15'),(115,28,'product_images/qxPdoBoL6FwljtxxWc60C2BlRghghY7a2CYTvBbz.jpg',0,'2025-06-09 14:48:15','2025-06-09 14:48:15'),(116,28,'product_images/IQ5amTMtcV1ac24A4LC9euXUqpwVWQkxC4iOoGNF.jpg',0,'2025-06-09 14:48:15','2025-06-09 14:48:15'),(117,29,'product_images/xGlcB4LLMJTW7ZmCL3y9YgOCVKlALZeUSjusA0uK.jpg',0,'2025-06-09 14:49:14','2025-06-09 14:49:14'),(118,29,'product_images/S6XgFZjASXYPLalMYB6VecRhgVt9lc5RSbMXTEHJ.jpg',0,'2025-06-09 14:49:14','2025-06-09 14:49:14'),(119,29,'product_images/ym31BVbRqzWOy3QMIJY10gQ1mTiivwzJ0FCXTrMb.jpg',0,'2025-06-09 14:49:14','2025-06-09 14:49:14'),(120,29,'product_images/jpe71dtPlh3ROvK6JHtwYkLYGxi31PXVJCl37IGC.jpg',0,'2025-06-09 14:49:14','2025-06-09 14:49:14'),(121,29,'product_images/XwDb7D5SVvsQ6Wrt6b9w6sS8SwqtnKnRh7EatONV.jpg',0,'2025-06-09 14:49:14','2025-06-09 14:49:14'),(122,30,'product_images/6LK3z6soAD8fVuNAwpRZsosbLcEfadT18EPn0twe.jpg',0,'2025-06-09 14:51:22','2025-06-09 14:51:22'),(123,30,'product_images/fsDBFQCIklAMINYa7yrSVnkvd2prsKqv4k2rnMU7.jpg',0,'2025-06-09 14:51:22','2025-06-09 14:51:22'),(124,30,'product_images/THONYrXVZ4095PZPMR1oeDzZXzW6Dor8ORs9BXhk.jpg',0,'2025-06-09 14:51:22','2025-06-09 14:51:22'),(125,30,'product_images/kInhrkfKvZLHsY8vswTL67a8P4tZXQROMh0OmqcY.jpg',0,'2025-06-09 14:51:22','2025-06-09 14:51:22'),(126,30,'product_images/lAgEFXyBuZS0uE8Dhn8lQKjEDOrmPVSWk5GzH3ce.jpg',0,'2025-06-09 14:51:22','2025-06-09 14:51:22'),(127,31,'product_images/nA92dkk3uo2jD9NDyMEFb8IYohJo0MX7QCndIEnV.jpg',0,'2025-06-09 14:52:45','2025-06-09 14:52:45'),(128,31,'product_images/QKiY1ODclkpMA3p9PGe3FnNV4TnSg7Eq9TYGZKuC.jpg',0,'2025-06-09 14:52:45','2025-06-09 14:52:45'),(129,31,'product_images/I3h0M2OFvKek5bTuDupZkvaTYoixTR6TnSoEy8UO.jpg',0,'2025-06-09 14:52:45','2025-06-09 14:52:45'),(130,31,'product_images/6fvrUDQ4IHrIyR8L7MzAK051kg2or5VZPwK3Luqg.jpg',0,'2025-06-09 14:52:45','2025-06-09 14:52:45'),(131,31,'product_images/8Rax9izRgERRFI7ryww0V8iVyxPapU1GDF1XWSEK.jpg',0,'2025-06-09 14:52:45','2025-06-09 14:52:45'),(132,32,'product_images/OSpSxWFgO5ANwWdgCEeVYmpmHo8UfJEpySxqjq0k.jpg',0,'2025-06-09 14:55:57','2025-06-09 14:55:57'),(133,32,'product_images/JopqFtJa0QX3RcOOuXLcORul4a1mPIS347C1kM06.jpg',0,'2025-06-09 14:55:57','2025-06-09 14:55:57'),(134,32,'product_images/GZr3Q8nmJqxzroF7M9a0WliqUoPsb7Ev6mWXnnw1.jpg',0,'2025-06-09 14:55:57','2025-06-09 14:55:57'),(135,32,'product_images/vRXbGMYUQLJ8EJSZpuSYb7xjkYocMnwkqaz4s3T6.jpg',0,'2025-06-09 14:55:57','2025-06-09 14:55:57'),(136,32,'product_images/TRSkMegCGCbNnU8xOJlGhQzAPSCISbJagkPWNE6s.jpg',0,'2025-06-09 14:55:57','2025-06-09 14:55:57'),(137,33,'product_images/SpEv4bFboGkWd1i4kgKMwQ7nl84g2Z5GJCgAoVH5.jpg',0,'2025-06-09 14:58:28','2025-06-09 14:58:28'),(138,33,'product_images/XOyloA0CNigpQk6X6VPfcnD0Hr1wFjnke7ytQfpY.jpg',0,'2025-06-09 14:58:28','2025-06-09 14:58:28'),(139,33,'product_images/kzikSVmCnwxLBSZdBfpDBFM1ESexDO62TSuPsEym.jpg',0,'2025-06-09 14:58:28','2025-06-09 14:58:28'),(140,33,'product_images/N6etEsSqXt1msYIPQaXfBAxocMYxqtPVDeqsVnfa.jpg',0,'2025-06-09 14:58:28','2025-06-09 14:58:28'),(141,33,'product_images/s5eDc2SNySztfbIRQnhQTeTPb0CL0HDSyY2hY5EQ.jpg',0,'2025-06-09 14:58:28','2025-06-09 14:58:28'),(142,34,'product_images/OuwkvjXSvAQRSFEt7G2yKYGofMdDbbK63zhhsGBT.jpg',0,'2025-06-09 15:00:24','2025-06-09 15:00:24'),(143,34,'product_images/cVVFjM1ZwmbkBMeLvV3PEqx7tFg1mF0ifIt6e1N6.jpg',0,'2025-06-09 15:00:24','2025-06-09 15:00:24'),(144,34,'product_images/8U7QCZ4D7yjqSV0gQ6l85WqKx75lAheYqpLHdag5.jpg',0,'2025-06-09 15:00:24','2025-06-09 15:00:24'),(145,34,'product_images/F4H5ZnKGYt2sQXZwRsNpz8EH6E4l3AHkxpDacC6z.jpg',0,'2025-06-09 15:00:24','2025-06-09 15:00:24'),(146,34,'product_images/8GO0cA64TSsT1MCSOuPKXFuv6dhp1Ai9tWbmfQDe.jpg',0,'2025-06-09 15:00:24','2025-06-09 15:00:24'),(147,35,'product_images/fGMiL6FLMg2NB01PsVaKKbLericcF8DmPgBnly9o.jpg',0,'2025-06-09 15:02:19','2025-06-09 15:02:19'),(148,35,'product_images/e5d1ewmPUFb1bhLCN76lFBKV0a4DEWAnPLS9VUrC.jpg',0,'2025-06-09 15:02:19','2025-06-09 15:02:19'),(149,35,'product_images/O1WefRgH71D3kq6eba1gF2TEl1EdRuduOGgAzTr3.jpg',0,'2025-06-09 15:02:19','2025-06-09 15:02:19'),(150,35,'product_images/nkScwMTIxqNNMx8d1M6Anq2ouiHU9GMVG1aLVz0g.jpg',0,'2025-06-09 15:02:19','2025-06-09 15:02:19'),(151,35,'product_images/aZeDu4eF261ZFfxIuQKbMULSEGyy6LVWg9YBJUV6.jpg',0,'2025-06-09 15:02:19','2025-06-09 15:02:19'),(152,36,'product_images/DKswiEtxlVvGnTR1QOiEywRYUsVpzMBDVEWeVhHN.jpg',0,'2025-06-09 15:03:31','2025-06-09 15:03:31'),(153,36,'product_images/N7ZU1UIh5AYaKgBIrtX6eCxMHiYBXLf51gECRK4k.jpg',0,'2025-06-09 15:03:31','2025-06-09 15:03:31'),(154,36,'product_images/AK27HILeXGvhWecdIuKDMjt1hsJex2cUtTb1URvR.jpg',0,'2025-06-09 15:03:31','2025-06-09 15:03:31'),(155,36,'product_images/7dmm16ga9jJEBIQMmsDdQmsoFZUoGTNE8X6v1aeZ.jpg',0,'2025-06-09 15:03:31','2025-06-09 15:03:31'),(156,36,'product_images/Fazgun03zRIx51vwv2lWoZpFz9HiAT2ZTYGYYQQt.jpg',0,'2025-06-09 15:03:31','2025-06-09 15:03:31'),(157,37,'product_images/WSw6yTdSYj7io01UCfbdwePoGzOLBjbJZBKEtA2e.jpg',0,'2025-06-09 15:06:26','2025-06-09 15:06:26'),(158,37,'product_images/9DDbOXhNLopLNKwF9WpWvwVH7R3UGPb38UHQhaOe.jpg',0,'2025-06-09 15:06:26','2025-06-09 15:06:26'),(159,37,'product_images/nymCmNg08WMiSxT00AK0EkddYYhHlRmzMRKfjegQ.jpg',0,'2025-06-09 15:06:26','2025-06-09 15:06:26'),(160,37,'product_images/f9DeFc0CKk2grfMdbMjAEkpNA8y68GFVIoGzIE3H.jpg',0,'2025-06-09 15:06:26','2025-06-09 15:06:26'),(161,37,'product_images/fHU2Kb91pxsIXB4uPtkaCk5UFiTkl0c5HP3qnfUa.jpg',0,'2025-06-09 15:06:26','2025-06-09 15:06:26'),(162,38,'product_images/GJ5aixFlQb0Kyo0Dm2yjkZ4TuHQ5K6dAf797nPeo.jpg',0,'2025-06-09 15:11:13','2025-06-09 15:11:13'),(163,38,'product_images/nnIk2pou4j9pyi1UvEybIyPCOBFi2TV4aqHKQdIR.jpg',0,'2025-06-09 15:11:13','2025-06-09 15:11:13'),(164,38,'product_images/qbqXkY63vK03y3kWyGdHbbKFgdXrnYbPva2OaO1t.jpg',0,'2025-06-09 15:11:13','2025-06-09 15:11:13'),(165,38,'product_images/p499QW5XRU8KLNdTQo2puDRWGvGMXoet8iHAatzt.jpg',0,'2025-06-09 15:11:13','2025-06-09 15:11:13'),(166,38,'product_images/ifhHt3Kg4bhKLZnvTfpedR4iPArOcvti5emsdgR9.jpg',0,'2025-06-09 15:11:13','2025-06-09 15:11:13'),(167,39,'product_images/AUa76Hyae18UWcU1HZ4kWZt2izGSshpW7X8ru2qI.jpg',0,'2025-06-09 15:20:32','2025-06-09 15:20:32'),(168,39,'product_images/pJ5QqiaCJCLpwhCBnW71Ihi1G6DogFtNiwkKnEES.jpg',0,'2025-06-09 15:20:32','2025-06-09 15:20:32'),(169,39,'product_images/EyMpz7ezwOCvC2U42GoWI4yFcLSHH1OGr4FVkh36.jpg',0,'2025-06-09 15:20:32','2025-06-09 15:20:32'),(170,39,'product_images/9ctn03lx8ni1n5VWsRuVXTKZTyKuDJLh5EXS3WX7.jpg',0,'2025-06-09 15:20:32','2025-06-09 15:20:32'),(171,39,'product_images/Swf6JrJanuwk22nAoS5KVKaGU6W8HlfszeMY6O4n.jpg',0,'2025-06-09 15:20:32','2025-06-09 15:20:32'),(172,40,'product_images/eqIbL2vWNxiEeHeJh1sd4c2jPIfaVOCRzAw4zGtX.jpg',0,'2025-06-09 15:22:09','2025-06-09 15:22:09'),(173,40,'product_images/9bClxpoWVFNog1Vr0ty55HBcV74iQgSeyHbT31fl.jpg',0,'2025-06-09 15:22:09','2025-06-09 15:22:09'),(174,40,'product_images/9OEncU9hxGQjg6s0eukZXTiOVZRuZfDZ2IoAd1wq.jpg',0,'2025-06-09 15:22:09','2025-06-09 15:22:09'),(175,40,'product_images/oFPHllPqKADW52pVR3IogWJJIzH4CE49JGK1LDuN.jpg',0,'2025-06-09 15:22:09','2025-06-09 15:22:09'),(176,40,'product_images/5PQrc5ahXR9aMY5SyY4RZ1PYxkASiGe41guZkYjF.jpg',0,'2025-06-09 15:22:09','2025-06-09 15:22:09'),(177,41,'product_images/BN2oD29OqoQvFVG3cAEWm3HlCC85aECwahYxYTeT.jpg',0,'2025-06-09 15:23:31','2025-06-09 15:23:31'),(178,41,'product_images/pUBHHrAOElrKh2v3vK1OTYYjSX9M1DGHpP2oQ7IK.jpg',0,'2025-06-09 15:23:31','2025-06-09 15:23:31'),(179,41,'product_images/1Doeeb0s301fbhKC7nU52IoK586A4sxaQoojEYr2.jpg',0,'2025-06-09 15:23:31','2025-06-09 15:23:31'),(180,41,'product_images/bfKQMEcPnqMhGPBgLqCwXDIrv7tUE7AT5Cp0Lwqw.jpg',0,'2025-06-09 15:23:31','2025-06-09 15:23:31'),(181,41,'product_images/CgsMOiPJ0AsN50p7Bmn1aulerYjl8HPYViVmfDF3.jpg',0,'2025-06-09 15:23:31','2025-06-09 15:23:31'),(182,42,'product_images/OUsEMaH5k2oSzPgPHt2jc76P2sfXmw0a2EFrI8LN.jpg',0,'2025-06-09 15:25:54','2025-06-09 15:25:54'),(183,42,'product_images/mn13gcVjtPirqoWPfPN9movTYbWF95NFw3kiMWCE.jpg',0,'2025-06-09 15:25:54','2025-06-09 15:25:54'),(184,42,'product_images/pQwxB69k2gluIeSXSPysk6WjXfdLytyP86QKlyGN.jpg',0,'2025-06-09 15:25:54','2025-06-09 15:25:54'),(185,42,'product_images/8Mj69IhRg19a1NSe4WVhBS1a4ua6Zh0263wt8kzE.jpg',0,'2025-06-09 15:25:54','2025-06-09 15:25:54'),(186,42,'product_images/qBkOupMcCpKvnaBX85V2zTkVv0XiO99Ctk2Wy5Je.jpg',0,'2025-06-09 15:25:54','2025-06-09 15:25:54'),(187,43,'product_images/q6CP5wuRjABT0vZrmgadYOV4Tox2J3tGhYxIhqEV.jpg',0,'2025-06-09 15:27:00','2025-06-09 15:27:00'),(188,43,'product_images/h5r5aVc3dw2yaZyEfP7agYsG1TJwmlckRLSbhLF8.jpg',0,'2025-06-09 15:27:00','2025-06-09 15:27:00'),(189,43,'product_images/9jsIcRZgK8YWlTTYujU4Hp0MpQbymFTkQ6PeaeIp.jpg',0,'2025-06-09 15:27:00','2025-06-09 15:27:00'),(190,43,'product_images/abwqFoESKtajIUJSkQcRXNkU4wooaHLqYmRHAIYt.jpg',0,'2025-06-09 15:27:00','2025-06-09 15:27:00'),(191,43,'product_images/SZKtY7PodlRblZB3f4DzHu3g9TjBPpYFWoInvoJj.jpg',0,'2025-06-09 15:27:00','2025-06-09 15:27:00');
/*!40000 ALTER TABLE `product_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_promotion`
--

DROP TABLE IF EXISTS `product_promotion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_promotion` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` bigint(20) unsigned NOT NULL,
  `promotion_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_promotion_product_id_foreign` (`product_id`),
  KEY `product_promotion_promotion_id_foreign` (`promotion_id`),
  CONSTRAINT `product_promotion_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_promotion_promotion_id_foreign` FOREIGN KEY (`promotion_id`) REFERENCES `promotions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_promotion`
--

LOCK TABLES `product_promotion` WRITE;
/*!40000 ALTER TABLE `product_promotion` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_promotion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_size`
--

DROP TABLE IF EXISTS `product_size`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_size` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` bigint(20) unsigned NOT NULL,
  `size_id` bigint(20) unsigned NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_size_product_id_size_id_unique` (`product_id`,`size_id`),
  KEY `product_size_size_id_foreign` (`size_id`),
  CONSTRAINT `product_size_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_size_size_id_foreign` FOREIGN KEY (`size_id`) REFERENCES `sizes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=204 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_size`
--

LOCK TABLES `product_size` WRITE;
/*!40000 ALTER TABLE `product_size` DISABLE KEYS */;
INSERT INTO `product_size` VALUES (6,4,4,2,'2025-05-28 08:40:02','2025-06-01 06:53:03'),(7,4,5,3,'2025-05-28 08:40:02','2025-06-10 11:47:09'),(8,4,6,3,'2025-05-28 08:40:02','2025-06-01 06:53:03'),(9,4,7,4,'2025-05-28 08:40:02','2025-06-01 06:53:03'),(10,4,8,0,'2025-05-28 08:40:02','2025-06-01 06:53:52'),(11,5,5,5,'2025-06-04 05:11:24','2025-06-04 05:11:24'),(12,5,6,0,'2025-06-04 05:11:24','2025-06-04 05:11:24'),(13,5,7,0,'2025-06-04 05:11:24','2025-06-04 05:11:24'),(14,5,8,0,'2025-06-04 05:11:24','2025-06-04 05:11:24'),(15,6,5,2,'2025-06-04 05:13:53','2025-06-04 05:13:53'),(16,6,6,0,'2025-06-04 05:13:53','2025-06-04 05:13:53'),(17,6,7,0,'2025-06-04 05:13:53','2025-06-04 05:13:53'),(18,6,8,0,'2025-06-04 05:13:53','2025-06-04 05:13:53'),(19,6,4,0,'2025-06-04 05:13:53','2025-06-04 05:13:53'),(20,7,5,5,'2025-06-04 05:15:15','2025-06-04 05:15:15'),(21,7,6,5,'2025-06-04 05:15:15','2025-06-04 05:15:15'),(22,7,7,5,'2025-06-04 05:15:15','2025-06-04 05:15:15'),(23,7,8,5,'2025-06-04 05:15:15','2025-06-04 05:15:15'),(24,7,4,5,'2025-06-04 05:15:15','2025-06-04 05:15:15'),(25,8,5,5,'2025-06-04 05:17:13','2025-06-04 05:17:13'),(26,8,4,5,'2025-06-04 05:17:13','2025-06-04 05:17:13'),(27,8,6,5,'2025-06-04 05:17:13','2025-06-04 05:17:13'),(28,8,7,5,'2025-06-04 05:17:13','2025-06-04 05:17:13'),(29,8,8,5,'2025-06-04 05:17:13','2025-06-04 05:17:13'),(30,9,4,1,'2025-06-04 05:19:07','2025-06-05 08:24:22'),(31,9,5,3,'2025-06-04 05:19:07','2025-06-04 05:19:07'),(32,9,6,3,'2025-06-04 05:19:07','2025-06-04 05:19:07'),(33,9,7,3,'2025-06-04 05:19:07','2025-06-04 05:19:07'),(34,9,8,1,'2025-06-04 05:19:07','2025-06-05 08:24:22'),(35,10,4,5,'2025-06-04 05:21:06','2025-06-04 05:21:06'),(36,10,6,5,'2025-06-04 05:21:06','2025-06-04 05:21:06'),(37,10,7,0,'2025-06-04 05:21:06','2025-06-04 05:21:06'),(38,10,5,5,'2025-06-04 05:21:06','2025-06-04 05:21:06'),(44,12,4,5,'2025-06-09 10:57:11','2025-06-09 10:57:11'),(45,12,5,5,'2025-06-09 10:57:11','2025-06-09 10:57:11'),(46,12,6,5,'2025-06-09 10:57:11','2025-06-09 10:57:11'),(47,12,7,0,'2025-06-09 10:57:11','2025-06-09 10:57:11'),(48,12,8,0,'2025-06-09 10:57:11','2025-06-09 10:57:11'),(49,13,4,10,'2025-06-09 10:58:28','2025-06-09 10:58:28'),(50,13,5,10,'2025-06-09 10:58:28','2025-06-09 10:58:28'),(51,13,6,10,'2025-06-09 10:58:28','2025-06-09 10:58:28'),(52,13,7,10,'2025-06-09 10:58:28','2025-06-09 10:58:28'),(53,13,8,10,'2025-06-09 10:58:28','2025-06-09 10:58:28'),(54,14,6,5,'2025-06-09 10:59:45','2025-06-09 10:59:45'),(55,14,7,5,'2025-06-09 10:59:45','2025-06-09 10:59:45'),(56,14,8,5,'2025-06-09 10:59:45','2025-06-09 10:59:45'),(57,14,4,0,'2025-06-09 10:59:45','2025-06-09 10:59:45'),(58,14,5,5,'2025-06-09 10:59:45','2025-06-09 10:59:45'),(59,15,4,5,'2025-06-09 11:03:15','2025-06-09 11:03:15'),(60,15,5,5,'2025-06-09 11:03:15','2025-06-09 11:03:15'),(61,15,6,5,'2025-06-09 11:03:15','2025-06-09 11:03:15'),(62,15,7,5,'2025-06-09 11:03:15','2025-06-09 11:03:15'),(63,15,8,5,'2025-06-09 11:03:15','2025-06-09 11:03:15'),(64,16,4,10,'2025-06-09 11:04:32','2025-06-09 11:04:32'),(65,16,5,12,'2025-06-09 11:04:32','2025-06-09 11:04:32'),(66,16,6,12,'2025-06-09 11:04:32','2025-06-09 11:04:32'),(67,16,7,13,'2025-06-09 11:04:32','2025-06-09 11:04:32'),(68,16,8,15,'2025-06-09 11:04:32','2025-06-09 11:04:32'),(69,17,4,12,'2025-06-09 11:08:08','2025-06-09 11:08:08'),(70,17,5,14,'2025-06-09 11:08:08','2025-06-09 11:08:08'),(71,17,6,18,'2025-06-09 11:08:08','2025-06-09 11:08:08'),(72,17,7,22,'2025-06-09 11:08:08','2025-06-09 11:08:08'),(73,17,8,14,'2025-06-09 11:08:08','2025-06-09 11:08:08'),(74,18,4,14,'2025-06-09 11:09:11','2025-06-09 11:09:11'),(75,18,5,17,'2025-06-09 11:09:11','2025-06-09 11:09:11'),(76,18,6,18,'2025-06-09 11:09:11','2025-06-09 11:09:11'),(77,18,7,5,'2025-06-09 11:09:11','2025-06-09 11:09:11'),(78,18,8,4,'2025-06-09 11:09:11','2025-06-09 11:09:11'),(79,19,4,1,'2025-06-09 11:10:16','2025-06-09 11:10:16'),(80,19,5,2,'2025-06-09 11:10:16','2025-06-09 11:10:16'),(81,19,6,3,'2025-06-09 11:10:16','2025-06-09 11:10:16'),(82,19,7,4,'2025-06-09 11:10:16','2025-06-09 11:10:16'),(83,19,8,5,'2025-06-09 11:10:16','2025-06-09 11:10:16'),(84,20,4,6,'2025-06-09 11:11:21','2025-06-09 11:11:21'),(85,20,5,5,'2025-06-09 11:11:21','2025-06-09 11:11:21'),(86,20,6,4,'2025-06-09 11:11:21','2025-06-09 11:11:21'),(87,20,7,3,'2025-06-09 11:11:21','2025-06-09 11:11:21'),(88,20,8,2,'2025-06-09 11:11:21','2025-06-09 11:11:21'),(89,21,5,5,'2025-06-09 11:13:02','2025-06-09 11:13:02'),(90,21,6,5,'2025-06-09 11:13:02','2025-06-09 11:13:02'),(91,21,7,5,'2025-06-09 11:13:02','2025-06-09 11:13:02'),(92,21,8,5,'2025-06-09 11:13:02','2025-06-09 11:13:02'),(93,21,4,0,'2025-06-09 11:13:02','2025-06-09 11:13:02'),(94,22,4,0,'2025-06-09 11:14:16','2025-06-09 11:14:16'),(95,22,5,1,'2025-06-09 11:14:16','2025-06-09 11:14:16'),(96,22,6,2,'2025-06-09 11:14:16','2025-06-09 11:14:16'),(97,22,7,2,'2025-06-09 11:14:16','2025-06-09 11:14:16'),(98,22,8,3,'2025-06-09 11:14:16','2025-06-09 11:14:16'),(99,23,4,5,'2025-06-09 14:31:27','2025-06-09 14:31:27'),(100,23,5,5,'2025-06-09 14:31:27','2025-06-09 14:31:27'),(101,23,6,5,'2025-06-09 14:31:27','2025-06-09 14:31:27'),(102,23,7,5,'2025-06-09 14:31:27','2025-06-09 14:31:27'),(103,23,8,5,'2025-06-09 14:31:27','2025-06-09 14:31:27'),(104,24,4,5,'2025-06-09 14:36:22','2025-06-09 14:36:22'),(105,24,5,5,'2025-06-09 14:36:22','2025-06-09 14:36:22'),(106,24,6,5,'2025-06-09 14:36:22','2025-06-09 14:36:22'),(107,24,7,5,'2025-06-09 14:36:22','2025-06-09 14:36:22'),(108,24,8,5,'2025-06-09 14:36:22','2025-06-09 14:36:22'),(109,25,4,5,'2025-06-09 14:43:45','2025-06-09 14:43:45'),(110,25,5,5,'2025-06-09 14:43:45','2025-06-09 14:43:45'),(111,25,6,5,'2025-06-09 14:43:45','2025-06-09 14:43:45'),(112,25,7,5,'2025-06-09 14:43:45','2025-06-09 14:43:45'),(113,25,8,5,'2025-06-09 14:43:45','2025-06-09 14:43:45'),(114,26,4,0,'2025-06-09 14:45:19','2025-06-09 14:45:19'),(115,26,5,5,'2025-06-09 14:45:19','2025-06-09 14:45:19'),(116,26,6,5,'2025-06-09 14:45:19','2025-06-09 14:45:19'),(117,26,7,5,'2025-06-09 14:45:19','2025-06-09 14:45:19'),(118,26,8,5,'2025-06-09 14:45:19','2025-06-09 14:45:19'),(119,27,4,5,'2025-06-09 14:47:11','2025-06-09 14:47:11'),(120,27,6,5,'2025-06-09 14:47:11','2025-06-09 14:47:11'),(121,27,5,5,'2025-06-09 14:47:11','2025-06-09 14:47:11'),(122,27,7,5,'2025-06-09 14:47:11','2025-06-09 14:47:11'),(123,27,8,5,'2025-06-09 14:47:11','2025-06-09 14:47:11'),(124,28,4,0,'2025-06-09 14:48:15','2025-06-09 14:48:15'),(125,28,5,3,'2025-06-09 14:48:15','2025-06-09 14:48:15'),(126,28,6,0,'2025-06-09 14:48:15','2025-06-09 14:48:15'),(127,28,7,1,'2025-06-09 14:48:15','2025-06-09 14:48:15'),(128,28,8,0,'2025-06-09 14:48:15','2025-06-09 14:48:15'),(129,29,4,0,'2025-06-09 14:49:14','2025-06-09 14:49:14'),(130,29,5,0,'2025-06-09 14:49:14','2025-06-09 14:49:14'),(131,29,6,1,'2025-06-09 14:49:14','2025-06-09 14:49:14'),(132,29,7,0,'2025-06-09 14:49:14','2025-06-09 14:49:14'),(133,29,8,0,'2025-06-09 14:49:14','2025-06-09 14:49:14'),(134,30,4,0,'2025-06-09 14:51:22','2025-06-09 14:51:22'),(135,30,5,5,'2025-06-09 14:51:22','2025-06-09 14:51:22'),(136,30,6,5,'2025-06-09 14:51:22','2025-06-09 14:51:22'),(137,30,7,5,'2025-06-09 14:51:22','2025-06-09 14:51:22'),(138,30,8,5,'2025-06-09 14:51:22','2025-06-09 14:51:22'),(139,31,4,0,'2025-06-09 14:52:45','2025-06-09 14:52:45'),(140,31,5,0,'2025-06-09 14:52:45','2025-06-09 14:52:45'),(141,31,6,5,'2025-06-09 14:52:45','2025-06-09 14:52:45'),(142,31,7,5,'2025-06-09 14:52:45','2025-06-09 14:52:45'),(143,31,8,2,'2025-06-09 14:52:45','2025-06-09 14:52:45'),(144,32,4,5,'2025-06-09 14:55:57','2025-06-09 14:55:57'),(145,32,5,5,'2025-06-09 14:55:57','2025-06-09 14:55:57'),(146,32,6,5,'2025-06-09 14:55:57','2025-06-09 14:55:57'),(147,32,7,5,'2025-06-09 14:55:57','2025-06-09 14:55:57'),(148,32,8,5,'2025-06-09 14:55:57','2025-06-09 14:55:57'),(149,33,4,0,'2025-06-09 14:58:28','2025-06-09 14:58:28'),(150,33,5,2,'2025-06-09 14:58:28','2025-06-09 14:58:28'),(151,33,6,2,'2025-06-09 14:58:28','2025-06-09 14:58:28'),(152,33,7,2,'2025-06-09 14:58:28','2025-06-09 14:58:28'),(153,33,8,2,'2025-06-09 14:58:28','2025-06-09 14:58:28'),(154,34,4,5,'2025-06-09 15:00:24','2025-06-09 15:00:24'),(155,34,5,5,'2025-06-09 15:00:24','2025-06-09 15:00:24'),(156,34,6,5,'2025-06-09 15:00:24','2025-06-09 15:00:24'),(157,34,7,5,'2025-06-09 15:00:24','2025-06-09 15:00:24'),(158,34,8,0,'2025-06-09 15:00:24','2025-06-09 15:00:24'),(159,35,4,2,'2025-06-09 15:02:19','2025-06-09 15:02:19'),(160,35,5,2,'2025-06-09 15:02:19','2025-06-09 15:02:19'),(161,35,6,2,'2025-06-09 15:02:19','2025-06-09 15:02:19'),(162,35,8,0,'2025-06-09 15:02:19','2025-06-09 15:02:19'),(163,35,7,2,'2025-06-09 15:02:19','2025-06-09 15:02:19'),(164,36,4,5,'2025-06-09 15:03:31','2025-06-09 15:03:31'),(165,36,5,5,'2025-06-09 15:03:31','2025-06-09 15:03:31'),(166,36,6,5,'2025-06-09 15:03:31','2025-06-09 15:03:31'),(167,36,7,5,'2025-06-09 15:03:31','2025-06-09 15:03:31'),(168,36,8,5,'2025-06-09 15:03:31','2025-06-09 15:03:31'),(169,37,4,5,'2025-06-09 15:06:26','2025-06-09 15:06:26'),(170,37,5,5,'2025-06-09 15:06:26','2025-06-09 15:06:26'),(171,37,6,5,'2025-06-09 15:06:26','2025-06-09 15:06:26'),(172,37,7,5,'2025-06-09 15:06:26','2025-06-09 15:06:26'),(173,37,8,0,'2025-06-09 15:06:26','2025-06-09 15:06:26'),(174,38,4,5,'2025-06-09 15:11:13','2025-06-09 15:11:13'),(175,38,5,5,'2025-06-09 15:11:13','2025-06-09 15:11:13'),(176,38,6,5,'2025-06-09 15:11:13','2025-06-09 15:11:13'),(177,38,7,0,'2025-06-09 15:11:13','2025-06-09 15:11:13'),(178,38,8,0,'2025-06-09 15:11:13','2025-06-09 15:11:13'),(179,39,4,0,'2025-06-09 15:20:32','2025-06-09 15:20:32'),(180,39,5,2,'2025-06-09 15:20:32','2025-06-09 15:20:32'),(181,39,6,2,'2025-06-09 15:20:32','2025-06-09 15:20:32'),(182,39,8,2,'2025-06-09 15:20:32','2025-06-09 15:20:32'),(183,39,7,2,'2025-06-09 15:20:32','2025-06-09 15:20:32'),(184,40,4,0,'2025-06-09 15:22:09','2025-06-09 15:22:09'),(185,40,5,2,'2025-06-09 15:22:09','2025-06-09 15:22:09'),(186,40,6,0,'2025-06-09 15:22:09','2025-06-09 15:22:09'),(187,40,7,2,'2025-06-09 15:22:09','2025-06-09 15:22:09'),(188,40,8,2,'2025-06-09 15:22:09','2025-06-09 15:22:09'),(189,41,4,2,'2025-06-09 15:23:31','2025-06-09 15:23:31'),(190,41,5,2,'2025-06-09 15:23:31','2025-06-09 15:23:31'),(191,41,6,2,'2025-06-09 15:23:31','2025-06-09 15:23:31'),(192,41,7,2,'2025-06-09 15:23:31','2025-06-09 15:23:31'),(193,41,8,2,'2025-06-09 15:23:31','2025-06-09 15:23:31'),(194,42,4,1,'2025-06-09 15:25:54','2025-06-09 15:25:54'),(195,42,5,0,'2025-06-09 15:25:54','2025-06-09 15:25:54'),(196,42,6,0,'2025-06-09 15:25:54','2025-06-09 15:25:54'),(197,42,7,0,'2025-06-09 15:25:54','2025-06-09 15:25:54'),(198,42,8,0,'2025-06-09 15:25:54','2025-06-09 15:25:54'),(199,43,4,0,'2025-06-09 15:27:00','2025-06-09 15:27:00'),(200,43,5,0,'2025-06-09 15:27:00','2025-06-09 15:27:00'),(201,43,6,0,'2025-06-09 15:27:00','2025-06-09 15:27:00'),(202,43,7,0,'2025-06-09 15:27:00','2025-06-09 15:27:00'),(203,43,8,2,'2025-06-09 15:27:00','2025-06-09 15:27:00');
/*!40000 ALTER TABLE `product_size` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(8,2) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  `category_id` bigint(20) unsigned NOT NULL,
  `gender` enum('male','female','unisex') NOT NULL DEFAULT 'unisex',
  `color` varchar(255) DEFAULT NULL,
  `brand` varchar(255) DEFAULT NULL,
  `main_image` varchar(255) DEFAULT NULL,
  `images` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`images`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `published` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `products_slug_unique` (`slug`),
  KEY `products_category_id_foreign` (`category_id`),
  CONSTRAINT `products_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (4,'adidas Originals Sudadera Island Club Crew','adidas-originals-sudadera-island-club-crew','Sueña con el paraíso en los días más grises con esta sudadera Island Club Crew para mujer de adidas Originals. En color blanco, esta prenda exclusiva de JD está confeccionada en un tejido suave y afelpado de algodón y poliéster reciclado. Con hombros caídos, cuello redondo y ribetes acanalados, este jersey se remata con la marca adidas Island Club y el logo Trefoil en la parte delantera. Se puede lavar a máquina. | Nuestra modelo mide 1,70 m y lleva una talla S. | JW8817\r\nComposición y materiales\r\n70% Cotton/30% Recycled Polyester\r\nCódigo de producto: 19694064_jdsportses/754162',59.99,0,3,'female','Blanco','Adidas','products/ElbTVWccps2u2Vf6mKOkkocpw0nDjVzvtSKPFwUq.webp',NULL,'2025-05-28 08:40:02','2025-05-30 10:56:37',1),(5,'Nike Club','nike-club','Un clásico versátil\r\nViste con un básico por excelencia de Nike en tu día a día y mantén tu cuerpo cálido allá a donde vayas con esta sudadera para hombre con capucha, diseñada con el logo bordado en el pecho en color blanco. Su suave tejido Fleece, afelpado en el interior, te proporcionará la capa de calidez que necesitas.\r\n\r\nTejido\r\nafelpado\r\nCon\r\ncapucha\r\nCómo cuidar tu sudadera\r\nLavar a máquina.\r\nNo usar lejía.\r\nSe recomienda no usar secadora.',34.99,0,3,'male','Naranja','Nike','products/c18mCmU0hgfdYNBfWC45DQSbglw0eiKjMQDpHp2X.jpg',NULL,'2025-06-04 05:11:24','2025-06-04 05:11:28',1),(6,'Fila Tape','fila-tape','Estilo casual\r\nLa sudadera Fila Tape es una prenda versátil y funcional, perfecta para cualquier ocasión. Su diseño moderno y su tejido afelpado te garantizan confort y calidez en todo momento. Además, cuenta con una capucha ajustable y bolsillos centrales para mayor comodidad.\r\n\r\nTejido\r\nafelpado\r\nCon\r\ncapucha\r\nCaracterísticas:\r\nElástico en puños y cintura.\r\nIncorpora capucha.\r\nBolsillos centrales.\r\nInstrucciones de lavado:\r\nLavar a máquina.\r\nNo se recomienda secar en secadora.\r\nComposición:\r\n\r\nTejido principal: 35% algodón 65% poliéster',14.99,0,3,'male','Negro','Fila','products/RLpQCBMp4rNI3enIChim1pfDwoDYmqsrKzs2lC2G.jpg',NULL,'2025-06-04 05:13:53','2025-06-04 05:25:02',1),(7,'adidas Future Icons','adidas-future-icons','Crea tus mejores outfits\r\nDeja tu huella allá donde vayas con la sudadera adidas Future Icons. Con un corte clásico que combina comodidad y estilo, esta sudadera es tan fácilmente combinalble que podrás crear outfits increíbles. Prueba a combinarla con unos pantalones de chándal o unos vaqueros y lucirás un look a la última. El cuello redondo aporta un toque de elegancia, y los puños de canalé evitan que las mangas se suban. Además, el logotipo de adidas estampado aporta modernidad al outfit.\r\n\r\nY, por si fuera poco, está fabricada con un 70% de materiales reciclados. Únete al movimiento Future Icons y sé el cambio que deseas ver en el mundo.\r\n\r\nSin\r\ncapucha\r\nEmplea materiales reciclados\r\nCaracterísticas\r\nCorte clásico.\r\nInterlock 64% algodón / 36% poliéster reciclado.\r\nPuños y dobladillo de canalé.\r\nLogotipo de adidas estampado en relieve.\r\nContiene al menos un 70% de material reciclado y renovable.\r\nCómo cuidar tu sudadera\r\nLavar a máquina.\r\nSe recomienda no usar secadora.',34.99,0,3,'male','Verde','Adidas','products/YTZMwsvyfDdMeBeJ0gJB9Uyy6paqMRmaiJn6jP4F.jpg',NULL,'2025-06-04 05:15:15','2025-06-04 05:25:01',1),(8,'adidas 3s','adidas-3s','Suave\r\n¡Haz que cada día sea más cómodo con la sudadera con capucha de adidas Essentials! Con su corte holgado y el suave tejido de rizo francés, disfrutarás de una sensación de confort absoluto mientras te mantienes a la moda. El cuarto de cremallera te permite ajustar la ventilación según lo necesites, y la capucha ajustable con cordón te protege del frío. Además, el icónico diseño de las 3 bandas en las mangas añade un toque clásico que nunca pasa de moda. El práctico bolsillo canguro es ideal para mantener tus manos calientes.\r\n\r\nFabricada con un 70% de materiales reciclados, esta sudadera no solo te hace sentir bien por fuera, sino también por dentro.\r\n\r\nBolsillo de\r\ncanguro\r\nCon\r\ncapucha\r\nCaracterísticas\r\nCorte holgado.\r\nCremallera hasta el pecho.\r\nBolsillo canguro.\r\nCapucha con cordón ajustable.\r\nContiene al menos un 70% de material reciclado y renovable.\r\nCómo cuidar tu sudadera\r\nLavar a máquina.\r\nSe recomienda no usar secadora.\r\nComposición:\r\n\r\nTejido principal: 36% poliéster reciclado 9% viscosa',34.99,0,3,'female','Beige','Adidas','products/2OOrMBktwxYXPPuFtRz78rjUb8QENbOpNao3C2A6.jpg',NULL,'2025-06-04 05:17:13','2025-06-04 05:25:00',1),(9,'Fila Big Logo','fila-big-logo','Comodidad y estilo con Fila\r\nLa sudadera de felpa para mujer Fila Big Logo es una prenda versátil y moderna. Su diseño de cuello caja la hace óptima para un look deportivo o casual. Confeccionada en tejido afelpado, ofrece una sensación de calidez y comodidad. Su corte regular se adapta a cualquier tipo de figura, realzando la silueta femenina.\r\n\r\nTejido\r\nafelpado\r\nCuello\r\ncaja\r\n \r\nCaracterísticas:\r\nElástico en puños y cintura.\r\nDiseño de cuello caja.\r\nTejido afelpado en el interior.\r\nInstrucciones de lavado:\r\nLavar a máquina.\r\nNo se recomienda secar en secadora.\r\nComposición:\r\n\r\nTejido principal: 35% algodón 65% poliéster',17.99,0,3,'female','Blanco','Fila','products/JryYjV3lnrQCYjLVfU1YED1lgOd73s8cwVOe1KEV.jpg',NULL,'2025-06-04 05:19:07','2025-06-04 05:24:59',1),(10,'Sudadera Nike','sudadera-nike','Confort esencial para el día a día\r\nLa sudadera con capucha de Nike es la elección correcta para quienes buscan comodidad y estilo desenfadado. Con un diseño práctico y versátil, incluye un bolsillo canguro para mantener las manos calientes o guardar tus pequeños objetos. Los puños y el dobladillo son acanalados, para un ajuste seguro, y el tejido afelpado proporciona una sensación acogedora. Ideal para usar en caminatas, entrenamientos ligeros o simplemente para relajarte en tu día a día.\r\n\r\nTejido\r\nafelpado\r\nBolsillo de\r\ncanguro\r\nCon\r\ncapucha\r\nCaracterísticas:\r\nCapucha ajustable.\r\nBolsillo canguro.\r\nTejido afelpado.\r\nPuños y dobladillo acanalados.\r\nDiseño clásico y versátil.\r\nInstrucciones de cuidado:\r\nLavar a máquina a temperaturas bajas.\r\nNo usar lejía.\r\nSe recomienda no secar en secadora.\r\nPlanchar a baja temperatura, si es necesario.',34.99,0,3,'female','Verde','Nike','products/T2wuQ7CilEaIUFy2bQxvG6gNsJiJvcWUPe5NiJbU.jpg',NULL,'2025-06-04 05:21:06','2025-06-04 05:24:58',1),(12,'Nike Nsw Swoosh','nike-nsw-swoosh','Logo grande en el centro\r\nLa camiseta Nike Club Swoosh para hombre está confeccionada con tejido ligero que mantiene el sudor a raya durante tu entrenamiento. La manga corta te permite moverte con libertad, una prenda pensada para tus entrenamientos diarios.\r\n\r\nTejido\r\nligero\r\nManga\r\ncorta\r\nCaracterísticas:\r\nCorte clásico.\r\nManga corta.\r\nTejido ligero y transpirable.\r\nInstrucciones de lavado:\r\nLavar a máquina.\r\nNo se recomienda secar en secadora.',19.99,0,2,'male','Azul','Nike','products/wErLYforRsuvRHzvCrBzB5d3odXpgqVdjC6larcQ.jpg',NULL,'2025-06-09 10:57:11','2025-06-09 10:57:12',1),(13,'adidas Linear','adidas-linear','Comodidad y autenticidad en uno\r\nLuce un estilo casual con esta camiseta de adidas Essentials Linear, diseñada para hombres que buscan comodidad y un look moderno. Con un corte recto que se adapta perfectamente a tu cuerpo, esta camiseta te ofrece un ajuste relajado y cómodo para cualquier ocasión. El cuello redondo añade un toque clásico, mientras que el diseño de hombro caído aporta un aire desenfadado y actual, perfecto para tus días más relajados. Confeccionada en 100% algodón, esta camiseta garantiza suavidad y transpirabilidad, manteniéndote cómodo durante todo el día.\r\n\r\nLa marca llamativa en el pecho destaca tu afinidad por adidas, añadiendo un toque de autenticidad y estilo deportivo.\r\n\r\nManga\r\ncorta\r\nCuello\r\nredondo\r\nCaracterísticas\r\nCorte clásico.\r\nCuello redondo.\r\n100% algodón.\r\nCómo cuidar tu camiseta\r\nLavar a máquina.\r\nSe recomienda no usar secadora.\r\nComposición:\r\n\r\nTejido principal:algodon',17.99,0,2,'male','Rojo','Adidas','products/vXj2vXHAvbdFypPrMhvNJnG9olsgXAs4u6Gh1tWh.jpg',NULL,'2025-06-09 10:58:28','2025-06-09 10:58:30',1),(14,'Camiseta Converse','camiseta-converse','Camiseta Converse\r\n¡Luce increíble con esta camiseta de hombre de Converse! Esta camiseta de corte estándar es perfecta para los días de verano, con un tejido ligero para mantenerte fresco y cómodo.\r\n\r\nTejido\r\nligero\r\nCorte\r\nestándar\r\nCómo cuidar tu camiseta\r\nLavar a máquina.\r\nNo usar secadora.\r\nComposición:\r\n\r\nTejido principal:algodón',17.99,0,2,'male','Negro','Converse','products/jM2Z5RLfjzBjBSnKMlyn7Is2GyNyxGcPdOuK0dLl.jpg',NULL,'2025-06-09 10:59:45','2025-06-09 10:59:47',1),(15,'Puma Big Logo','puma-big-logo','Comodidad y estilo asegurados\r\nLa camiseta Puma Big Logo es una prenda idónea para quienes buscan un look deportivo diario. Confeccionada en algodón suave, ofrece una sensación agradable al contacto con la piel. Su diseño de manga corta y corte clásico proporciona libertad de movimiento. El logotipo de Puma en la parte frontal añade un toque distintivo y moderno.\r\n\r\nCómo cuidar tu camiseta\r\nLavar a máquina.\r\nSe recomienda no usar secadora.',17.99,0,2,'male','Blanco','Puma','products/ysdE3Oo1y8Nz5geHP0GANGVpIUmIQwYwvmQzWWnd.jpg',NULL,'2025-06-09 11:03:15','2025-06-09 11:03:17',1),(16,'adidas Tiro','adidas-tiro','Destaca con esta camiseta adidas\r\nEsta camiseta de adidas te hará lucir un estilo único allá donde vayas. Esta prenda no solo te brinda una comodidad inigualable, también evoca un legado deportivo, esta camiseta fabricada con algodón suave se convertirá en tu favorita del armario. Los gráficos deportivos y el icónico logotipo de adidas en el pecho evocan la rica historia del fútbol, conectándote con décadas de pasión y triunfo en el campo.\r\n\r\nNo es solo una camiseta, es una declaración de estilo para quienes viven y respiran por el deporte. Con esta camiseta adidas, cada día es una oportunidad para destacar.\r\n\r\nCuello\r\nredondo\r\nCorte\r\nestándar\r\nCaracterísticas\r\nCorte clásico.\r\nCuello redondo de canalé.\r\n100% algodón.\r\nCómo cuidar tu camiseta\r\nLavar a máquina.\r\nSe recomienda no usar secadora.\r\nComposición:\r\n\r\nMateriales sintéticos',24.99,0,2,'male','Blanco','Adidas','products/djVne4ejx888H35gjN1X03vEypJQaqytUM6iX5ah.jpg',NULL,'2025-06-09 11:04:32','2025-06-09 11:04:34',1),(17,'Camiseta Puma','camiseta-puma','Comodidad y estilo diario\r\nLa camiseta Puma Logo es una prenda básica que necesitas en tu armario. Confeccionada en un suave tejido de algodón, ofrece un ajuste cómodo y relajado. Su diseño de manga corta y cuello redondo permite libertad de movimiento, mientras que el icónico logotipo de Puma se destaca en la parte frontal, añadiendo un toque distintivo. Para combinar con tus atuendos casuales, esta camiseta es una opción versátil para cualquier ocasión.\r\n\r\nCómo cuidar tu camiseta\r\nLavar a máquina.\r\nSe recomienda no usar secadora.',22.99,0,2,'female','Rosa','Puma','products/xk0T7k880ZxMl2TSH2PB7HDEbXxSCsgnr4nIx2Xq.jpg',NULL,'2025-06-09 11:08:08','2025-06-09 11:08:09',1),(18,'Fila Graphic Logo','fila-graphic-logo','Estilo y comodidad deportiva\r\nDescubre camiseta de algodón para mujer Fila Graphic Logo, diseñada para ofrecerte confort y estilo en cada entrenamiento. Su tejido ligero y transpirable garantiza frescura, mientras que su corte estándar y manga corta proporcionan libertad de movimiento.\r\n\r\nTejido\r\nligero\r\nTejido\r\ntranspirable\r\nCaracterísticas:\r\nCorte clásico.\r\nManga corta.\r\nTejido ligero y transpirable.\r\nInstrucciones de lavado:\r\nLavar a máquina.\r\nNo se recomienda secar en secadora.\r\nComposición:\r\n\r\nTejido principal:algodón',16.99,0,2,'female','Azul','Fila','products/gDAcGDhLGXeIrY1rg6dsf2K1qNrxeoTrtgIll26Z.jpg',NULL,'2025-06-09 11:09:11','2025-06-09 11:09:21',1),(19,'Camiseta Reebok','camiseta-reebok','Movimiento sin restricciones\r\nEsta camiseta Reebok destaca por su estilo básico con el logo de la marca en el pecho. Su corte estándar y confección en tejido ligero te ofrecen comodidad para moverte sin restricciones durante tus ejercicios o actividades diarias. Puedes combinarla con leggings, pantalones o shorts para crear looks versátiles.\r\n\r\nTejido\r\nligero\r\nManga\r\ncorta\r\nCaracterísticas:\r\nNombre de la marca en el pecho.\r\nCuello redondo clásico.\r\nCorte estándar y cómodo.\r\nTejido ligero para mayor frescura.\r\nInstrucciones de lavado:\r\nLavar a máquina.\r\nSe recomienda no secar a máquina.',14.99,0,2,'female','Verde','Reebok','products/ntNGyDQryemiGGs0pwlCiyQ7wHQrt8Tz002pfRFm.jpg',NULL,'2025-06-09 11:10:16','2025-06-09 11:10:17',1),(20,'Nike Legend Crew','nike-legend-crew','Confort sin límites\r\nEntrena con total comodidad con la camiseta Nike Legend. Presenta un diseño ligero, con un tejido suave y transpirable gracias a su tecnología Dri-FIT. Además, está confeccionada con 100% de fibras de poliéster reciclado.\r\n\r\nTejido\r\nligero\r\nPrenda\r\nsostenible\r\nCaracterísticas\r\nTecnología Dri-FIT: mantiene la transpirabilidad.\r\nTejido reciclado.\r\nManga corta.\r\nInstrucciones de lavado:\r\nLavar a máquina.\r\nSe recomienda no secar a máquina.',29.99,0,2,'female','Morado','Nike','products/Fuy1uiDY8mqy6x0i4G2uXW9PjF35eya153yFKrOC.jpg',NULL,'2025-06-09 11:11:21','2025-06-09 11:11:22',1),(21,'Camiseta Puma','camiseta-puma-1','Silueta de Puma\r\nLa camiseta de running de Puma está confeccionada en un tejido ligero y transpirable para mantener la piel libre de sudor durante las sesiones de running. Su corte clásico se adapta al cuerpo sin restringir el movimiento, permitiendo una total libertad.\r\n\r\nCaracterísticas:\r\nCorte clásico.\r\nTejido ligero y transpirable.\r\nLogotipo de Puma en el pecho.\r\nConsejos de cuidado:\r\nLavar a máquina.\r\nNo usar lejía.\r\nSe recomienda no secar en secadora.',19.99,0,2,'male','Rojo','Puma','products/DGQonAn3ZkZzstOW7lB3XiRr54z54JaDpy5J8mT2.jpg',NULL,'2025-06-09 11:13:02','2025-06-09 11:13:03',1),(22,'Camiseta Puma','camiseta-puma-2','Simplicidad que destaca\r\nLa camiseta Puma combina un corte estándar cómodo con un diseño minimalista, gracias al logo discreto en el centro. Hecha de tejido ligero y transpirable, es ideal para tus entrenamientos o para usar en el día a día, manteniéndote cómodo y con estilo.\r\n\r\nCaracterísticas:\r\nCorte estándar cómodo.\r\nLogo pequeño en el centro.\r\nTejido ligero y transpirable.\r\nInstrucciones de lavado:\r\nLavar a máquina.\r\nSe recomienda no secar en secadora..',19.99,0,2,'male','Verde','Puma','products/eXlbrZ5dNTkDVQKQfVnHV4CKODLITFFGTCDbu5eL.jpg',NULL,'2025-06-09 11:14:16','2025-06-09 11:34:26',1),(23,'Fila Small Logo','fila-small-logo','Composición:\r\n\r\nTejido principal: 28% poliéster 68% algodón 4% spandex',19.99,0,2,'female','Verde','Fila','products/zZwaT4KWSKfK9mIifURaCOLG94qlafqKyITlRPOm.jpg',NULL,'2025-06-09 14:31:27','2025-06-09 14:31:35',1),(24,'Pantalón Corto Nike','pantalon-corto-nike','Estilo relajado y cómodo\r\nEste pantalón corto de Nike es idóneo tanto para ir al gimnasio como para hacer deporte al aire libre. Está confeccionado en tejido ligero, suave al tacto y resistente al desgaste. Lleva el logo de la marca destacado en grande en la parte trasera, formado con tejido de malla técnica con perforaciones, para aumentar la circulación del aire.\r\n\r\nTejido\r\nligero\r\nEvacúa\r\nel sudor\r\nCaracterísticas:\r\nCintura elástica.\r\nCosturas planas para evitar irritaciones.\r\nTejido ligero y transpirable.\r\nInstrucciones de lavado:\r\nLavar a máquina.\r\nNo se recomienda secar en secadora.',29.99,0,2,'male','Negro','Nike','products/TqU0nqto90B5yU1R09OtOITNGquSIWEK75RH3iu3.jpg',NULL,'2025-06-09 14:36:22','2025-06-09 14:36:24',1),(25,'adidas Collegiate','adidas-collegiate','Pantalón cómodo\r\nEstos pantalones cortos de adidas son la mejor elección si lo que buscas es comodidad y estilo, son la combinación perfecta de ambos. Están confeccionados en un suave tejido de rizo francés, por lo que ofrecen un confort insuperable, ideal tanto para entrenar con él como para un día de relax en casa. El toque de color granate en el logotipo y las icónicas 3 bandas de la marca son un detalle vibrante que sin duda mejora tu look deportivo. Además, están hechos con un 70% de materiales reciclados, por lo que también estás haciendo una elección consciente con el medio ambiente.\r\n\r\nYa sea para un día activo o para descansar, estos pantalones cortos adidas te acompañarán en cada momento.\r\n\r\nCintura\r\nelástica\r\nAjuste con\r\ncordón\r\nCaracterísticas\r\nCorte clásico.\r\nCintura elástica con cordón.\r\n55% algodón / 36% poliéster (reciclado) / 9% viscosa.\r\nBolsillos frontales.\r\nContiene al menos un 70% de material reciclado y renovable.\r\nCómo cuidar tu pantalón\r\nLavar a máquina.\r\nSe recomienda no usar secadora.',29.99,0,4,'male','Verde','Adidas','products/W6sBTeDhgygiyA1NbT1hw1D0eiSAytHhOpz0wMN2.jpg',NULL,'2025-06-09 14:43:45','2025-06-09 14:43:46',1),(26,'Nike Club','nike-club-1','Estilo deportivo\r\nDescubre el pantalón corto Nike Club diseñado para ofrecer confort y estilo tanto en un entrenamienot, como en un día casual. Confeccionado con algodón, su tejido es ligero y transpirable. Cuenta con cintura elástica ajustable con cordón y bolsillos a los lados.\r\n\r\nTejido\r\nligero\r\nEvacúa\r\nel sudor\r\nCaracterísticas:\r\nCintura elástica.\r\nCosturas planas para evitar irritaciones.\r\nTejido ligero y transpirable.\r\nBolsillos laterales.\r\nInstrucciones de lavado:\r\nLavar a máquina.\r\nNo se recomienda secar en secadora.',39.99,0,4,'male','Azul','Nike','products/BzMW9sLkLE5NhjLsKqXD5lVY9vhQvgfHBOW2szaU.jpg',NULL,'2025-06-09 14:45:19','2025-06-09 14:45:23',1),(27,'Nike Alumni','nike-alumni','Confort con estilo\r\nLos pantalones cortos Nike Club Alumni están hechos para días relajados. El tejido suave te ofrece comodidad durante todo el día y el acabado deshilachado en los bordes añade un toque diferente al look. Tienen cintura elástica con cordón y bolsillos para llevar todo lo que necesitas.\r\n\r\nCaracterísticas:\r\nTejido suave y cómodo.\r\nCintura elástica con cordón.\r\nBolsillos laterales y uno trasero.\r\nAcabado deshilachado.\r\nInstrucciones de lavado:\r\nLavar a máquina en frío.\r\nNo usar lejía.\r\nNo secar en secadora.',44.99,0,4,'male','Blanca','Adidas','products/jfXMjICWHTiRO29ihqmHpyRj2hcEO4RzbFhY2yRr.jpg',NULL,'2025-06-09 14:47:10','2025-06-09 14:47:12',1),(28,'adidas 3s','adidas-3s-1','Pantalón corto esencial\r\nConquista cada entrenamiento con el pantalón corto de adidas Essentials Chelsea. Este básico versátil combina funcionalidad y estilo, ya que es una gran opción para cualquier actividad. Con su cintura elástica y cordón, se adapta a tu cuerpo para brindarte un ajuste seguro y cómodo, ideal tanto para tus entrenamientos como para relajarte en casa. Los bolsillos delanteros te permiten llevar tus esenciales siempre a mano, mientras que el forro de malla añade una capa extra de transpirabilidad.\r\n\r\nConfeccionado con materiales 100% reciclados, este pantalón corto no solo te mantiene cómodo, sino que también te permite contribuir al cuidado del medio ambiente. Las icónicas 3 bandas laterales y el tejido liso le dan un toque clásico y deportivo a tu look.\r\n\r\nCintura\r\nelástica\r\nAjuste con\r\ncordón\r\nCaracterísticas\r\nCorte clásico.\r\nCintura elástica con cordón.\r\n100% poliéster (reciclado).\r\nBolsillos frontales.\r\nForro de malla.\r\nCómo cuidar tu pantalón\r\nLavar a máquina.\r\nSe recomienda no usar secadora.',27.99,0,4,'male','Azul','Adidas','products/itQZPsrWhsBgvoQNpWdadVRLC2MYQiaQoY0QjCUR.jpg',NULL,'2025-06-09 14:48:15','2025-06-09 14:48:17',1),(29,'adidas 3s','adidas-3s-2','El pantalón corto más versátil\r\nCon este pantalón corto de adidas Essentials, llevarás la comodidad y el estilo clásico de la marca a todos lados. Su diseño cuenta con un cierre de cordón que te garantiza un ajuste que se adapta a ti en cada uso, además de estar fabricado en un 70% con materiales reciclados, lo que lo convierte en una opción sostenible para tu día a día.\r\n\r\nLas icónicas 3 bandas de adidas a los lados y el logotipo de las 3 barras en la pernera te aportan ese toque auténtico y deportivo que solo adidas puede ofrecer. Ideal tanto para tus entrenamientos como para tus momentos de relax, este pantalón corto te acompañará en cada paso.\r\n\r\nAjuste con\r\ncordón\r\nTejido\r\nligero\r\nCaracterísticas\r\nCorte clásico.\r\nCierre de cordón.\r\n55% algodón / 36% poliéster (reciclado) / 9% viscosa.\r\nContiene al menos un 70% de material reciclado y renovable.\r\nCómo cuidar tu pantalón\r\nLavar a máquina.\r\nSe recomienda no usar secadora.',32.99,0,4,'male','Rojo','Adidas','products/ChtvOrKo1qndYeWITzmX1YERNFobo3qpyKFZs50m.jpg',NULL,'2025-06-09 14:49:14','2025-06-09 14:49:16',1),(30,'Pantalón Corto Puma','pantalon-corto-puma','Para tus días casuales\r\nEl pantalón corto Puma es una elección imprescindible para quienes buscan comodidad y estilo en sus actividades diarias. Confeccionado en suave algodón, ofrece un ajuste relajado que se adapta a tus movimientos. Su cintura elástica con cordón ajustable garantiza un ajuste personalizado, mientras que los bolsillos laterales te permiten llevar tus esenciales con facilidad.\r\n\r\nCómo cuidar tu pantalón\r\nLavar a máquina.\r\nNo usar secadora.',27.99,0,4,'male','Marrón','Puma','products/gHjgrzrmxmhDCNHl1xDrYCtV5EfjF0bOmVNtH7I2.jpg',NULL,'2025-06-09 14:51:22','2025-06-09 14:51:24',1),(31,'Puma Ess 2','puma-ess-2','Estilo casual\r\nEl pantalón Puma Ess 2 está fabricado con una cintura elástica y un cordón ajustable, para adaptarse a tu cuerpo de forma segura. Sus bolsillos laterales te permiten llevar tus pertenencias de manera práctica y segura. Idóneo para actividades cotidianas o para disfrutar de un día de descanso, este pantalón combina funcionalidad y diseño moderno.\r\n\r\nCómo cuidar tu pantalón\r\nLavar a máquina.\r\nNo usar secadora.',27.99,0,4,'male','Azul','Puma','products/tyvHMuc3jvZ8TaTJqom73zoZqxjJHbbULUUoelDg.jpg',NULL,'2025-06-09 14:52:45','2025-06-09 14:53:55',1),(32,'Jordan Diamond','jordan-diamond','Máxima ligereza\r\nEl pantalón corto Jordan Diamond está diseñado principalmente para practicar baloncesto. Confeccionado con un tejido muy ligero y transpirable, este pantalón corto ofrece una comodidad excepcional durante el entrenamiento. Presenta microperforaciones que lo hacen más ligero, para mejorar tus movimientos, a la vez que aumenta la circulación del aire.\r\n\r\nTejido\r\nligero\r\nEvacúa\r\nel sudor\r\nCaracterísticas:\r\nCintura elástica.\r\nCosturas planas para evitar irritaciones.\r\nTejido ligero y transpirable.\r\nInstrucciones de lavado:\r\nLavar a máquina.\r\nNo se recomienda secar en secadora.',49.99,0,4,'male','Negro','Jordan','products/yMSpCtRHu3K78Wr2osqUvbLUvs48kdD28Et6iatY.jpg',NULL,'2025-06-09 14:55:57','2025-06-09 14:56:10',1),(33,'Puma Individual Liga','puma-individual-liga','Ref: 0389721\r\nColor: Negro',27.99,0,4,'male','Negro','Puma','products/2nvCzJZQyETKs7P4TatfD9gvUowS579ly2XWD7do.jpg',NULL,'2025-06-09 14:58:28','2025-06-09 14:58:29',1),(34,'Pantalón Corto Nike','pantalon-corto-nike-1','Doble cintura elástica\r\nEl pantalón corto Nike presenta una banda elástica sobre la cintura, creando un corte de tiro alto a la vez que ofrece un ajuste seguro y cómodo. Sus prácticos bolsillos laterales te permiten llevar tus esenciales sin complicaciones. La banda elástica con el logo de Nike añade un toque moderno y distintivo.\r\n\r\nCómo cuidar tu pantalón\r\nLavar a máquina.\r\nNo usar secadora.',39.99,0,4,'female','Rosa','Nike','products/1EwbUyeO9JSDE2ALr3eUjv8VFGQxAmqSj1vhp3iY.jpg',NULL,'2025-06-09 15:00:24','2025-06-09 15:00:26',1),(35,'Pantalón Corto Nike','pantalon-corto-nike-2','Ref: 0396028\r\nColor: Negro',44.99,0,4,'female','Negro','Nike','products/nFvO6WDVa85FgFGuJYFTR96hEZdpWa7IhOoV4eT2.jpg',NULL,'2025-06-09 15:02:19','2025-06-09 15:02:20',1),(36,'Pantalón Corto Fila','pantalon-corto-fila','Composición:\r\n\r\nTejido principal:algodón',19.99,0,4,'female','Blanco','Fila','products/QEyNSCyRXtQAuqaKrPYtF0LDJkVXc14nPgpQQFLu.jpg',NULL,'2025-06-09 15:03:31','2025-06-09 15:04:11',1),(37,'adidas 3s','adidas-3s-3','El pantalón más estiloso\r\nDisfruta de la comodidad y el estilo que te ofrece el pantalón corto de adidas Essentials, diseñado para adaptarse a tus movimientos sin esfuerzo. Con un ajuste holgado y cintura alta, este short te ofrece el soporte que necesitas para cada actividad. La cintura elástica con cordón asegura un ajuste personalizado, mientras que los bolsillos delanteros te permiten llevar lo esencial siempre a mano.\r\n\r\nLas icónicas 3 bandas a lo largo de los laterales añaden ese toque inconfundible de adidas que tanto te encanta. Ya sea para tus entrenamientos o para un día relajado, este pantalón corto se convertirá en tu mejor aliado.\r\n\r\nCintura\r\nelástica\r\nAjuste con\r\ncordón\r\nCaracterísticas\r\nCorte holgado.\r\nCintura elástica con cordón.\r\n100% poliamida (reciclada).\r\nTalle alto.\r\nBolsillos frontales.\r\nCómo cuidar tu pantalón\r\nLavar a máquina.\r\nSe recomienda no usar secadora.',29.99,0,4,'female','Blanco','Adidas','products/2bDSBZsYA5twIhgbka0I8C6jJQ9naHohAtYIEu7g.jpg',NULL,'2025-06-09 15:06:26','2025-06-09 15:06:27',1),(38,'Pantalón Corto Nike','pantalon-corto-nike-3','Destaca con estilo deportivo\r\nCon el pantalón corto Nike, disfrutarás de una prenda diseñada para ofrecerte libertad de movimiento y confort. Este pantalón cuenta con una cintura elástica ajustable mediante cordón, asegurando un ajuste personalizado y seguro. Sus bolsillos laterales te permiten llevar tus esenciales de manera práctica y segura.\r\n\r\nCómo cuidar tu pantalón\r\nLavar a máquina.\r\nNo usar secadora.',32.99,0,4,'female','Blanco','Nike','products/IqBHrCKbYke5QEii8MxfpqtRgFPWRHcfyWTThGBr.jpg',NULL,'2025-06-09 15:11:13','2025-06-09 15:11:16',1),(39,'Sudadera Under Armour','sudadera-under-armour','Ref: 0390744\r\nColor: Negro',59.99,0,3,'male','Negro','Under Armour','products/RckFv4cb62oLTFrsCrhKHFpABpcsC0nuxrGsGsUl.jpg',NULL,'2025-06-09 15:20:32','2025-06-09 15:20:33',1),(40,'Puma Individual','puma-individual','Ref: 0389712\r\nColor: Negro',59.99,0,3,'male','Negro','Puma','products/PVlG8MXC7wtKjZHaySHlK6n8Fki85VaGPRdKyzll.jpg',NULL,'2025-06-09 15:22:09','2025-06-09 15:22:10',1),(41,'Nike Air','nike-air','Ajuste a tu cuerpo\r\nLa sudadera Nike Air está diseñada para brindarte confort y un look moderno. Su tejido afelpado te mantendrá cálido en los días más fríos, mientras que su corte ceñido con cuello redondo, se adaptará a tu cuerpo. El elástico en puños y cintura asegura un ajuste perfecto.\r\n\r\nTejido\r\nafelpado\r\nCuello\r\ncaja\r\nCaracterísticas:\r\nElástico en puños y cintura.\r\nCuello redondo acanalado.\r\nTejido transpirable.\r\nInstrucciones de lavado:\r\nLavar a máquina.\r\nNo se recomienda secar en secadora.',59.99,0,3,'male','Beige','Nike','products/tMh7rdOJE4jd5iaUd3MI2zfIYUTA2atmvJZ3JQze.jpg',NULL,'2025-06-09 15:23:31','2025-06-09 15:23:32',1),(42,'Puma Evo','puma-evo','Estilo deportivo\r\nLa sudadera con cremallera Puma Evo presenta un diseño moderno y deportivo, con un tejido cálido y transpirable. La capucha incorporada y los bolsillos a los lados añaden un toque práctico.\r\n\r\nTejido\r\nafelpado\r\nCon\r\ncapucha\r\nCaracterísticas:\r\nElástico en puños y cintura.\r\nIncorpora capucha.\r\nBolsillos laterales.\r\nInstrucciones de lavado:\r\nLavar a máquina.\r\nNo se recomienda secar en secadora.',29.99,0,3,'female','Morado','Puma','products/LSsmfPkZG046xanirnWpn3JXlK1lJIhC1MJ5cezw.jpg',NULL,'2025-06-09 15:25:54','2025-06-09 15:25:55',1),(43,'adidas 3s','adidas-3s-4','Elegancia y propósito en cada movimiento\r\nDeslúmbrate con la sudadera para mujer de adidas, la compañera perfecta para elevar tus looks casual con un toque de estilo y comodidad incomparables. Ideal para combinar con vaqueros o disfrutar de una tarde relajada en casa, su corte clásico, puños y dobladillo de canalé añaden detalles sutiles y elegantes. Confeccionada en un tejido de felpa con mezcla de algodón, se siente suave al tacto, proporcionando una experiencia de uso acogedora. Las icónicas 3 bandas de adidas agregan un toque deportivo distintivo, celebrando la autenticidad de la marca. Además, esta sudadera es un símbolo de compromiso ecológico al haber sido fabricada a través de la iniciativa Better Cotton, destacando la responsabilidad ambiental de adidas. Viste con estilo y propósito con la sudadera para mujer de adidas.\r\n\r\nCuello\r\nredondo\r\nContiene materiales\r\nreciclados\r\nCaracterísticas\r\nCorte clásico.\r\nPuños y dobladillo de canalé.\r\nProducto creado en colaboración con Better Cotton.\r\n22% de poliéster reciclado.\r\nCómo cuidar tu sudadera\r\nNo usar lejía.\r\nNo utilizar suavizante.\r\nPlanchar en frío.\r\nNo lavar en seco.\r\nLavar a máquina con agua templada.',24.99,0,3,'female','Verde','Adidas','products/B4giCLOjCrRPcP9cRx17JjLraJFXGoX3tFPOrvD0.jpg',NULL,'2025-06-09 15:27:00','2025-06-09 15:27:01',1);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `promotions`
--

DROP TABLE IF EXISTS `promotions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `promotions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `discount_percentage` decimal(5,2) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promotions`
--

LOCK TABLES `promotions` WRITE;
/*!40000 ALTER TABLE `promotions` DISABLE KEYS */;
/*!40000 ALTER TABLE `promotions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reviews` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `product_id` bigint(20) unsigned NOT NULL,
  `rating` int(11) NOT NULL,
  `comment` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `reviews_user_id_foreign` (`user_id`),
  KEY `reviews_product_id_foreign` (`product_id`),
  CONSTRAINT `reviews_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES ('bAerELgwIPvP46rte1XeA9OJQIoH292n4mpAgrRm',NULL,'172.18.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiSEFhZGE5c1YzTG1DSDRjd3J4MjNEUnQ5dllrN1F0ZWNYU004WUJJbSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1749562953),('qZbZtaTDJW5J3O79v2oxA07G5Y6eJBDY8b87Px8I',NULL,'172.18.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoidGpORVBTQzA1UXIwVk90TG41dDN2Y2dMdjhFQnBFb0lvNFB1VERpbSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozNzoiaHR0cDovL2xvY2FsaG9zdDo4MDAwL2FkbWluL2Rhc2hib2FyZCI7fXM6OToiX3ByZXZpb3VzIjthOjE6e3M6MzoidXJsIjtzOjIxOiJodHRwOi8vbG9jYWxob3N0OjgwMDAiO319',1749729140),('rl9hp0jxxGx3cXOwxJeMgCI9kSZGFEOO8FnYzHal',NULL,'172.18.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiaXhJRXo5MmZ0elBlUUZkWnRUcFlHQTQxTzJsb1Y0RWZNcGdCZnhJSyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9jYXRlZ29yaWVzIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==',1749745806),('Tb1oz2Zda9r2jEKJhA0Je22BuAL4zxONDR1k4pZk',NULL,'172.18.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','YToyOntzOjY6Il90b2tlbiI7czo0MDoiUE9WTjR5OXI2TmZ6bjNEYmpzOEIzdFR4Mk5MZkVpRXhCMExsSm5nbSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==',1749637662),('y4k8whMClI66df4aATyaiGGXdrOoEWLZa1JajXut',1,'172.18.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiTEpadnhNZnNaYlBoa2RzVWF4cVZhcVJacnRRa3lzV3VyR3h3VWNBRCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9kZXNjYXJnYXItZmFjdHVyYS84MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjE7fQ==',1749563282),('yzrpWaS7fkDimMlT0l1ZORynkAblE8uOgjZzCdtG',1,'172.18.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoickRMZzBZWVY2TDdyRGJINzNmTFdFcjVvVkkxeG9DTmpIUHNmQm1DTyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6MTt9',1749637958);
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sizes`
--

DROP TABLE IF EXISTS `sizes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sizes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sizes`
--

LOCK TABLES `sizes` WRITE;
/*!40000 ALTER TABLE `sizes` DISABLE KEYS */;
INSERT INTO `sizes` VALUES (4,'XS','2025-05-28 08:37:07','2025-05-28 08:37:07'),(5,'S','2025-05-28 08:37:11','2025-05-28 08:37:11'),(6,'M','2025-05-28 08:37:15','2025-05-28 08:37:15'),(7,'L','2025-05-28 08:37:21','2025-05-28 08:37:21'),(8,'XL','2025-05-28 08:37:28','2025-05-28 08:37:28');
/*!40000 ALTER TABLE `sizes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_addresses`
--

DROP TABLE IF EXISTS `user_addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_addresses` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `address` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `state` varchar(255) NOT NULL,
  `zip_code` varchar(255) NOT NULL,
  `country` varchar(255) NOT NULL,
  `is_main` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_addresses_user_id_foreign` (`user_id`),
  CONSTRAINT `user_addresses_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_addresses`
--

LOCK TABLES `user_addresses` WRITE;
/*!40000 ALTER TABLE `user_addresses` DISABLE KEYS */;
INSERT INTO `user_addresses` VALUES (1,1,'Plaza Canovas, 12','Huelva','Huelva','21110','España',1,'2025-05-26 05:50:54','2025-05-26 05:50:54'),(2,2,'Calle Galaroza, 23','Aljaraque','Huelva','21110','España',1,'2025-05-27 04:35:05','2025-05-27 04:35:05'),(3,1,'calle galaroza, 12','huelva','huelva','21002','España',0,'2025-05-27 12:07:28','2025-05-27 12:07:28'),(4,1,'calle palma','huelva','huelva','21002','España',0,'2025-06-10 11:47:06','2025-06-10 11:47:06');
/*!40000 ALTER TABLE `user_addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `role` varchar(255) NOT NULL DEFAULT 'client',
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','admin@example.com','avatars/oJp9iLID4jiBWSg3fzXiPsPzHNvux99tjlRhGsby.jpg',NULL,'$2y$12$WpTWvln9gzFtwcS.lujFVO1Oo1SJcFVKNJNpIbrfzJhihB9fAZNO.','XRhABJb7vsUfAfhksKH0RMuRTTCtrL2DUHCYSWWl1iEXLDyp4HBxkyfNW6LK','2025-05-26 05:46:48','2025-06-05 07:39:36','admin'),(2,'emilio','emiliomartinn09@gmail.com',NULL,NULL,'$2y$12$ZRF6CP3PprxVQGizbdHcN.pgUg170mBLC6xiPrCfcGsqYhGZ/Wf1W',NULL,'2025-05-27 04:33:55','2025-05-27 04:33:55','admin'),(3,'form','form@gmail.com',NULL,NULL,'$2y$12$OHgP7mtEavbQV4CQsqmBOeXy8Fmv6ZG3jcWBq.QiR62WbUwR4BLNC',NULL,'2025-05-29 13:11:03','2025-05-29 13:11:03','client'),(4,'prueba','prueba@gmail.com',NULL,NULL,'$2y$12$tI3ekKcGJ67iPsIcHSopGupLRHFZ2/f7EBOQOnkLnF2LZ/1mw/DI6','CpxLWt3uZxi7cBMQeIGFqGvaQVtSoRHICmyZViQ5FMXB9AP6B4EPHXjJaIcI','2025-05-30 05:42:55','2025-06-04 06:39:54','client'),(5,'docker','docker@gmail.com',NULL,NULL,'$2y$12$knqaXZc4ZkKbUkbvk3Lo7OcXxZexf/5ajVbl5akb0c0jBmU9GAzbC',NULL,'2025-06-06 10:59:38','2025-06-06 10:59:38','client');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-12 18:36:39
