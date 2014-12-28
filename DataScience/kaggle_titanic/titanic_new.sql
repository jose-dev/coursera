-- MySQL dump 10.13  Distrib 5.5.31, for debian-linux-gnu (i686)
--
-- Host: localhost    Database: titanic
-- ------------------------------------------------------
-- Server version	5.5.31-0ubuntu0.12.10.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `titanic_test`
--

DROP TABLE IF EXISTS `titanic_test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `titanic_test` (
  `pclass` int(1) unsigned DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `sex` varchar(20) DEFAULT NULL,
  `age` int(2) unsigned DEFAULT NULL,
  `sibsp` int(2) unsigned DEFAULT NULL,
  `parch` int(2) unsigned DEFAULT NULL,
  `ticket` varchar(30) DEFAULT NULL,
  `fare` decimal(10,2) DEFAULT NULL,
  `cabin` varchar(30) DEFAULT NULL,
  `embarked` varchar(3) DEFAULT NULL,
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `sibsp_bool` tinyint(1) unsigned DEFAULT NULL,
  `parch_bool` tinyint(1) unsigned DEFAULT NULL,
  `family` tinyint(1) unsigned DEFAULT NULL,
  `under_5s` tinyint(1) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1535 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `titanic_train`
--

DROP TABLE IF EXISTS `titanic_train`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `titanic_train` (
  `survived` tinyint(1) DEFAULT NULL,
  `pclass` int(1) unsigned DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `sex` varchar(20) DEFAULT NULL,
  `age` int(2) unsigned DEFAULT NULL,
  `sibsp` int(2) unsigned DEFAULT NULL,
  `parch` int(2) unsigned DEFAULT NULL,
  `ticket` varchar(30) DEFAULT NULL,
  `fare` decimal(10,2) DEFAULT NULL,
  `cabin` varchar(30) DEFAULT NULL,
  `embarked` varchar(3) DEFAULT NULL,
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `sibsp_bool` tinyint(1) unsigned DEFAULT NULL,
  `parch_bool` tinyint(1) unsigned DEFAULT NULL,
  `family` tinyint(1) unsigned DEFAULT NULL,
  `under_5s` tinyint(1) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=892 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-06-14  0:01:24
