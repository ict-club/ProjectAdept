-- ---
-- Globals
-- ---

-- SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
-- SET FOREIGN_KEY_CHECKS=0;

-- ---
-- Table 'Exercise_MuscleGroups'
-- 
-- ---

DROP TABLE IF EXISTS `Exercise_MuscleGroups`;
		
CREATE TABLE `Exercise_MuscleGroups` (
  `ExerciseId` INTEGER NULL DEFAULT NULL,
  `MuscleGroupId` INTEGER NULL DEFAULT NULL,
  `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY (`ExerciseId`, `MuscleGroupId`)
);

-- ---
-- Table 'ExercisePositions'
-- 
-- ---

DROP TABLE IF EXISTS `ExercisePositions`;
		
CREATE TABLE `ExercisePositions` (
  `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `Name` VARCHAR(127) NOT NULL,
  PRIMARY KEY (`id`)
);

-- ---
-- Table 'MuscleGroups'
-- 
-- ---

DROP TABLE IF EXISTS `MuscleGroups`;
		
CREATE TABLE `MuscleGroups` (
  `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `Name` VARCHAR(127) NOT NULL,
  PRIMARY KEY (`id`)
);

-- ---
-- Table 'PowerCurves'
-- 
-- ---

DROP TABLE IF EXISTS `PowerCurves`;
		
CREATE TABLE `PowerCurves` (
  `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `Name` VARCHAR(127) NOT NULL,
  `CalculationFormula` VARCHAR(255) NOT NULL DEFAULT 'Y=x',
  `Duration` INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
);

-- ---
-- Table 'UserData'
-- 
-- ---

DROP TABLE IF EXISTS `UserData`;
		
CREATE TABLE `UserData` (
  `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `Name` VARCHAR(255) NOT NULL,
  `Age` INTEGER NOT NULL DEFAULT 0,
  `OverallCondition` VARCHAR(31) NOT NULL,
  PRIMARY KEY (`id`)
);

-- ---
-- Table 'MuscleTrends'
-- 
-- ---

DROP TABLE IF EXISTS `MuscleTrends`;
		
CREATE TABLE `MuscleTrends` (
  `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `UserId` INTEGER NULL DEFAULT NULL,
  `MuscleGroupId` INTEGER NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY (`UserId`, `MuscleGroupId`)
);

-- ---
-- Table 'BodyMeasures'
-- 
-- ---

DROP TABLE IF EXISTS `BodyMeasures`;
		
CREATE TABLE `BodyMeasures` (
  `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `Name` VARCHAR(31) NOT NULL,
  PRIMARY KEY (`id`)
);

-- ---
-- Table 'User_BodyMeasures'
-- 
-- ---

DROP TABLE IF EXISTS `User_BodyMeasures`;
		
CREATE TABLE `User_BodyMeasures` (
  `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `UserId` INTEGER NULL DEFAULT NULL,
  `BodyMeasureId` INTEGER NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY (`UserId`, `BodyMeasureId`)
);

-- ---
-- Table 'RecommendedExercises'
-- 
-- ---

DROP TABLE IF EXISTS `RecommendedExercises`;
		
CREATE TABLE `RecommendedExercises` (
  `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `UserId` INTEGER NULL DEFAULT NULL,
  `ExerciseId` INTEGER NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY (`UserId`, `ExerciseId`)
);

-- ---
-- Table 'UserExerciseLog'
-- 
-- ---

DROP TABLE IF EXISTS `UserExerciseLog`;
		
CREATE TABLE `UserExerciseLog` (
  `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `Timestamp` TIMESTAMP NOT NULL,
  `ExersiceId` INTEGER NULL DEFAULT NULL,
  `PowerCurveId` INTEGER NULL DEFAULT NULL,
  `TotalForce` INTEGER NOT NULL DEFAULT 0,
  `MaxForce` INTEGER NULL DEFAULT 0,
  `AvgHeartRate` INTEGER NOT NULL DEFAULT 0,
  `DificultyLevel` ENUM NOT NULL,
  `UserId` INTEGER NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
);

-- ---
-- Foreign Keys 
-- ---

ALTER TABLE `Exercise_MuscleGroups` ADD FOREIGN KEY (ExerciseId) REFERENCES `ExercisePositions` (`id`);
ALTER TABLE `Exercise_MuscleGroups` ADD FOREIGN KEY (MuscleGroupId) REFERENCES `MuscleGroups` (`id`);
ALTER TABLE `MuscleTrends` ADD FOREIGN KEY (UserId) REFERENCES `UserData` (`id`);
ALTER TABLE `MuscleTrends` ADD FOREIGN KEY (MuscleGroupId) REFERENCES `MuscleGroups` (`id`);
ALTER TABLE `User_BodyMeasures` ADD FOREIGN KEY (UserId) REFERENCES `UserData` (`id`);
ALTER TABLE `User_BodyMeasures` ADD FOREIGN KEY (BodyMeasureId) REFERENCES `BodyMeasures` (`id`);
ALTER TABLE `RecommendedExercises` ADD FOREIGN KEY (UserId) REFERENCES `UserData` (`id`);
ALTER TABLE `RecommendedExercises` ADD FOREIGN KEY (ExerciseId) REFERENCES `ExercisePositions` (`id`);
ALTER TABLE `UserExerciseLog` ADD FOREIGN KEY (ExersiceId) REFERENCES `ExercisePositions` (`id`);
ALTER TABLE `UserExerciseLog` ADD FOREIGN KEY (PowerCurveId) REFERENCES `PowerCurves` (`id`);
ALTER TABLE `UserExerciseLog` ADD FOREIGN KEY (UserId) REFERENCES `UserData` (`id`);

-- ---
-- Table Properties
-- ---

-- ALTER TABLE `Exercise_MuscleGroups` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `ExercisePositions` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `MuscleGroups` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `PowerCurves` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `UserData` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `MuscleTrends` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `BodyMeasures` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `User_BodyMeasures` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `RecommendedExercises` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `UserExerciseLog` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ---
-- Test Data
-- ---

-- INSERT INTO `Exercise_MuscleGroups` (`ExerciseId`,`MuscleGroupId`,`id`) VALUES
-- ('','','');
-- INSERT INTO `ExercisePositions` (`id`,`Name`) VALUES
-- ('','');
-- INSERT INTO `MuscleGroups` (`id`,`Name`) VALUES
-- ('','');
-- INSERT INTO `PowerCurves` (`id`,`Name`,`CalculationFormula`,`Duration`) VALUES
-- ('','','','');
-- INSERT INTO `UserData` (`id`,`Name`,`Age`,`OverallCondition`) VALUES
-- ('','','','');
-- INSERT INTO `MuscleTrends` (`id`,`UserId`,`MuscleGroupId`) VALUES
-- ('','','');
-- INSERT INTO `BodyMeasures` (`id`,`Name`) VALUES
-- ('','');
-- INSERT INTO `User_BodyMeasures` (`id`,`UserId`,`BodyMeasureId`) VALUES
-- ('','','');
-- INSERT INTO `RecommendedExercises` (`id`,`UserId`,`ExerciseId`) VALUES
-- ('','','');
-- INSERT INTO `UserExerciseLog` (`id`,`Timestamp`,`ExersiceId`,`PowerCurveId`,`TotalForce`,`MaxForce`,`AvgHeartRate`,`DificultyLevel`,`UserId`) VALUES
-- ('','','','','','','','','');