DROP database IF EXISTS foodApp
CREATE database foodApp
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

-- Create Table [companyInfo]
DROP TABLE IF EXISTS `foodApp`.`companyInfo`;
CREATE TABLE `foodApp`.`companyInfo` (
  `companyID` int NOT NULL AUTO_INCREMENT, 
  `companyName` varchar(20) NOT NULL UNIQUE,
  `address` varchar(100) NOT NULL,
  `city` varchar(20) NOT NULL,
  `state` varchar(20) NOT NULL,
  `zipCode` int NOT NULL,
  `fedID` varchar(100) NOT NULL UNIQUE,
  `einID` varchar(100) NOT NULL UNIQUE,
   PRIMARY KEY (companyID)
); 