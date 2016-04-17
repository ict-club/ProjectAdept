-- phpMyAdmin SQL Dump
-- version 4.0.10.7
-- http://www.phpmyadmin.net
--
-- Host: localhost:3306
-- Generation Time: Apr 18, 2016 at 02:27 AM
-- Server version: 5.5.48-37.8-log
-- PHP Version: 5.4.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `rapidde_adept`
--

-- --------------------------------------------------------

--
-- Table structure for table `bodymeasures`
--

CREATE TABLE IF NOT EXISTS `bodymeasures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(31) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `exercisepositions`
--

CREATE TABLE IF NOT EXISTS `exercisepositions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(127) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `exercise_musclegroups`
--

CREATE TABLE IF NOT EXISTS `exercise_musclegroups` (
  `ExerciseId` int(11) DEFAULT NULL,
  `MuscleGroupId` int(11) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ExerciseId` (`ExerciseId`,`MuscleGroupId`),
  KEY `MuscleGroupId` (`MuscleGroupId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `musclegroups`
--

CREATE TABLE IF NOT EXISTS `musclegroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(127) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `muscletrends`
--

CREATE TABLE IF NOT EXISTS `muscletrends` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `UserId` int(11) DEFAULT NULL,
  `MuscleGroupId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UserId` (`UserId`,`MuscleGroupId`),
  KEY `MuscleGroupId` (`MuscleGroupId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `powercurves`
--

CREATE TABLE IF NOT EXISTS `powercurves` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(127) COLLATE utf8_bin NOT NULL,
  `CalculationFormula` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT 'Y=x',
  `Duration` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `recommendedexercises`
--

CREATE TABLE IF NOT EXISTS `recommendedexercises` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `UserId` int(11) DEFAULT NULL,
  `ExerciseId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UserId` (`UserId`,`ExerciseId`),
  KEY `ExerciseId` (`ExerciseId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `userdata`
--

CREATE TABLE IF NOT EXISTS `userdata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) COLLATE utf8_bin NOT NULL,
  `Age` int(11) NOT NULL DEFAULT '0',
  `OverallCondition` int(11) NOT NULL DEFAULT '0',
  `RecommendedCalories` double NOT NULL,
  `picture_small` text COLLATE utf8_bin,
  `picture_big` text COLLATE utf8_bin,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=9 ;

--
-- Dumping data for table `userdata`
--

INSERT INTO `userdata` (`id`, `Name`, `Age`, `OverallCondition`, `RecommendedCalories`, `picture_small`, `picture_big`) VALUES
(1, 'Borislav Filipov', 21, 2, 0, 'http://i.imgur.com/VcgfWmD.png', 'http://i.imgur.com/adPBkbc.png'),
(2, 'Ivo Zhulev', 21, 0, 0, 'http://i.imgur.com/xIytOfI.jpg', 'http://i.imgur.com/UnsugVH.jpg'),
(3, 'Martin Kuvandzhiev', 21, 0, 0, 'http://i.imgur.com/HWg3X8T.jpg', 'http://i.imgur.com/Y5KAATq.jpg'),
(4, 'Peter Lazarov', 21, 0, 0, 'http://i.imgur.com/A1d1yPg.jpg', 'http://i.imgur.com/dJNuAJ8.jpg'),
(5, 'Evgeni Sabev', 21, 0, 0, 'http://i.imgur.com/zWY916H.jpg', 'http://i.imgur.com/b3Co324.jpg'),
(6, 'Konstantin Jleibinkov', 21, 0, 0, 'http://i.imgur.com/V9ftPuZ.jpg', 'http://i.imgur.com/Dik00vs.jpg'),
(7, 'Teodora Malashevska', 20, 0, 0, 'http://i.imgur.com/s9p6m4L.jpg', 'http://i.imgur.com/NcDVyH7.jpg'),
(8, 'Georgi Velev', 21, 0, 0, 'http://i.imgur.com/9ViytcS.jpg', 'http://i.imgur.com/8YFSUzv.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `userdata_calories`
--

CREATE TABLE IF NOT EXISTS `userdata_calories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `UserId` int(11) NOT NULL,
  `CaloriesToBeBurned` double NOT NULL,
  `CaloriesBalance` double NOT NULL,
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UserId` (`UserId`,`Timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `userdata_height`
--

CREATE TABLE IF NOT EXISTS `userdata_height` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `UserID` int(11) DEFAULT NULL,
  `Height` double NOT NULL DEFAULT '0',
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UserID` (`UserID`,`Timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `userdata_musclestrength`
--

CREATE TABLE IF NOT EXISTS `userdata_musclestrength` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `UserId` int(11) NOT NULL,
  `MuscleGroupId` int(11) NOT NULL,
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UserId` (`UserId`,`MuscleGroupId`,`Timestamp`),
  KEY `MuscleGroup` (`MuscleGroupId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `userdata_overallcondition`
--

CREATE TABLE IF NOT EXISTS `userdata_overallcondition` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `UserId` int(11) NOT NULL,
  `BoneStructure` int(11) NOT NULL,
  `MuscleStrength` int(11) NOT NULL,
  `BMI` int(11) NOT NULL,
  `AvgCaloriesBalance` int(11) NOT NULL,
  `ActiveCaloriesBurned` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UserId` (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `userdata_weight`
--

CREATE TABLE IF NOT EXISTS `userdata_weight` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `UserId` int(11) DEFAULT NULL,
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Weight` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `UserId` (`UserId`,`Timestamp`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=2 ;

--
-- Dumping data for table `userdata_weight`
--

INSERT INTO `userdata_weight` (`id`, `UserId`, `Timestamp`, `Weight`) VALUES
(1, 1, '2016-04-17 16:28:56', 80);

-- --------------------------------------------------------

--
-- Table structure for table `userdata_wristbonestructure`
--

CREATE TABLE IF NOT EXISTS `userdata_wristbonestructure` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `UserId` int(11) NOT NULL,
  `WristCirc` double NOT NULL,
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UserId` (`UserId`,`Timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `userexerciselog`
--

CREATE TABLE IF NOT EXISTS `userexerciselog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ExersiceId` int(11) DEFAULT NULL,
  `PowerCurveId` int(11) DEFAULT NULL,
  `TotalForce` int(11) NOT NULL DEFAULT '0',
  `MaxForce` int(11) DEFAULT '0',
  `AvgHeartRate` int(11) NOT NULL DEFAULT '0',
  `DificultyLevel` enum('Easy','Medium','Hard') COLLATE utf8_bin DEFAULT NULL,
  `UserId` int(11) DEFAULT NULL,
  `Duration` int(11) NOT NULL DEFAULT '0',
  `Precision` double NOT NULL DEFAULT '0',
  `AverageForce` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `ExersiceId` (`ExersiceId`),
  KEY `PowerCurveId` (`PowerCurveId`),
  KEY `userexerciselog_ibfk_3` (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `user_bodymeasures`
--

CREATE TABLE IF NOT EXISTS `user_bodymeasures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `UserId` int(11) DEFAULT NULL,
  `BodyMeasureId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UserId` (`UserId`,`BodyMeasureId`),
  KEY `BodyMeasureId` (`BodyMeasureId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `exercise_musclegroups`
--
ALTER TABLE `exercise_musclegroups`
  ADD CONSTRAINT `exercise_musclegroups_ibfk_1` FOREIGN KEY (`ExerciseId`) REFERENCES `exercisepositions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `exercise_musclegroups_ibfk_2` FOREIGN KEY (`MuscleGroupId`) REFERENCES `musclegroups` (`id`);

--
-- Constraints for table `muscletrends`
--
ALTER TABLE `muscletrends`
  ADD CONSTRAINT `muscletrends_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `userdata` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `muscletrends_ibfk_2` FOREIGN KEY (`MuscleGroupId`) REFERENCES `musclegroups` (`id`);

--
-- Constraints for table `recommendedexercises`
--
ALTER TABLE `recommendedexercises`
  ADD CONSTRAINT `recommendedexercises_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `userdata` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `recommendedexercises_ibfk_2` FOREIGN KEY (`ExerciseId`) REFERENCES `exercisepositions` (`id`);

--
-- Constraints for table `userdata_calories`
--
ALTER TABLE `userdata_calories`
  ADD CONSTRAINT `userId` FOREIGN KEY (`UserId`) REFERENCES `userdata` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `userdata_height`
--
ALTER TABLE `userdata_height`
  ADD CONSTRAINT `userdata_height_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `userdata` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `userdata_musclestrength`
--
ALTER TABLE `userdata_musclestrength`
  ADD CONSTRAINT `MuscleGroup` FOREIGN KEY (`MuscleGroupId`) REFERENCES `musclegroups` (`id`),
  ADD CONSTRAINT `user` FOREIGN KEY (`UserId`) REFERENCES `userdata` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `userdata_overallcondition`
--
ALTER TABLE `userdata_overallcondition`
  ADD CONSTRAINT `userdata_overallcondition_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `userdata` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `userdata_weight`
--
ALTER TABLE `userdata_weight`
  ADD CONSTRAINT `userdata_weight_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `userdata` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `userdata_wristbonestructure`
--
ALTER TABLE `userdata_wristbonestructure`
  ADD CONSTRAINT `userData` FOREIGN KEY (`UserId`) REFERENCES `userdata` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `userexerciselog`
--
ALTER TABLE `userexerciselog`
  ADD CONSTRAINT `userexerciselog_ibfk_1` FOREIGN KEY (`ExersiceId`) REFERENCES `exercisepositions` (`id`),
  ADD CONSTRAINT `userexerciselog_ibfk_2` FOREIGN KEY (`PowerCurveId`) REFERENCES `powercurves` (`id`),
  ADD CONSTRAINT `userexerciselog_ibfk_3` FOREIGN KEY (`UserId`) REFERENCES `userdata` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `user_bodymeasures`
--
ALTER TABLE `user_bodymeasures`
  ADD CONSTRAINT `user_bodymeasures_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `userdata` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `user_bodymeasures_ibfk_2` FOREIGN KEY (`BodyMeasureId`) REFERENCES `bodymeasures` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
