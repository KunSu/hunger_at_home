CREATE database IF NOT EXISTS foodApp
DEFAULT CHARACTER SET utf8;
SET GLOBAL local_infile = 1;
SET default_storage_engine = InnoDB;


-- Specify Database [foodApp]
USE foodApp;


-- Create Table [userInfo]
DROP TABLE IF EXISTS `foodApp`.`userInfo`;
CREATE TABLE `foodApp`.`userInfo` (
  `userID` int NOT NULL AUTO_INCREMENT,
  `email` varchar(20) NOT NULL UNIQUE,
  `password` varchar(20) NOT NULL,
  `firstName` varchar(255) NOT NULL,
  `lastName` varchar(255) NOT NULL,
  `phoneNumber` int NOT NULL,
  `userIdentity` varchar(20) NOT NULL,
  PRIMARY KEY (userID)
); 