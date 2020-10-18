DROP database IF EXISTS foodApp;
CREATE database foodApp
DEFAULT CHARACTER SET utf8;
SET GLOBAL local_infile = 1;
SET default_storage_engine = InnoDB;


-- Specify Database [foodApp]
USE foodApp;


-- Create Table [user]
DROP TABLE IF EXISTS `foodApp`.`user`;
CREATE TABLE `foodApp`.`user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(200) NOT NULL UNIQUE,
  `password` varchar(20) NOT NULL,
  `firstName` varchar(255) NOT NULL,
  `lastName` varchar(255) NOT NULL,
  `phoneNumber` varchar(255) NOT NULL,
  `userIdentity` varchar(20) NOT NULL,
  `companyID` int NOT NULL,
  `secureQuestion` varchar(255) NOT NULL,
  `secureAnswer` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `timestamp` date NOT NULL DEFAULT CURRENT_TIMESTAMP, 
  PRIMARY KEY (id)
); 

-- Create Table [company]
DROP TABLE IF EXISTS `foodApp`.`company`;
CREATE TABLE `foodApp`.`company` (
  `id` int NOT NULL AUTO_INCREMENT, 
  `companyName` varchar(20) NOT NULL UNIQUE,
  `fedID` varchar(100) NOT NULL UNIQUE,
  `einID` varchar(100) NOT NULL UNIQUE,
   `timestamp` date NOT NULL DEFAULT CURRENT_TIMESTAMP, 
   PRIMARY KEY (id)
); 

-- Create Table [address]
DROP TABLE IF EXISTS `foodApp`.`address`;
CREATE TABLE `foodApp`.`address` (
  `id` int NOT NULL AUTO_INCREMENT, 
  `address` varchar(100) NOT NULL,
  `city` varchar(20) NOT NULL,
  `state` varchar(20) NOT NULL,
  `zipCode` int NOT NULL,
  `timestamp` date NOT NULL DEFAULT CURRENT_TIMESTAMP, 
   PRIMARY KEY (id)
); 

-- Create Table [companyAddressAssociate]
DROP TABLE IF EXISTS `foodApp`.`companyAddressAssociate`;
CREATE TABLE `foodApp`.`companyAddressAssociate` (
  `addressID` int NOT NULL, 
  `companyID` int NOT NULL,  
  `timestamp` date NOT NULL DEFAULT CURRENT_TIMESTAMP, 
   PRIMARY KEY (addressID, companyID)
); 

-- Create Table [item]
DROP TABLE IF EXISTS `foodApp`.`item`;
CREATE TABLE `foodApp`.`item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `foodName` varchar(255) NOT NULL,
  `foodCategory` varchar(255) NOT NULL,
  `expireDate` date NOT NULL,
  `quantity` varchar(255) NOT NULL,
  `temperature` varchar(255) NOT NULL,
  `timestamp` date NOT NULL DEFAULT CURRENT_TIMESTAMP, 
  PRIMARY KEY (id)
); 

-- Create Table [order]
DROP TABLE IF EXISTS `foodApp`.`orderRecord`;
CREATE TABLE `foodApp`.`orderRecord` (
  `id` int NOT NULL AUTO_INCREMENT,
  `note` varchar(255) NOT NULL,
  `addressID` varchar(100) NOT NULL,
  `pickUpTime` date NOT NULL,
  `status` varchar(100) NOT NULL,
  `orderType` varchar(100) NOT NULL,
  `timestamp` date NOT NULL DEFAULT CURRENT_TIMESTAMP, 
  PRIMARY KEY (id)
); 

-- Create Table [orderAssociate]
DROP TABLE IF EXISTS `foodApp`.`orderAssociate`;
CREATE TABLE `foodApp`.`orderAssociate` (
  `orderID` int NOT NULL, 
  `driverID` int,  
  `donorID` int NOT NULL,  
  `recipientID` int NOT NULL,
  `adminID` int NOT NULL,
  `timestamp` date NOT NULL DEFAULT CURRENT_TIMESTAMP, 
   PRIMARY KEY (orderID, donorID, recipientID, adminID)
); 

-- Create Table [orderItemAssociate]
DROP TABLE IF EXISTS `foodApp`.`orderItemAssociate`;
CREATE TABLE `foodApp`.`orderItemAssociate` (
  `orderID` int NOT NULL, 
  `itemID` int,  
  `timestamp` date NOT NULL DEFAULT CURRENT_TIMESTAMP, 
   PRIMARY KEY (orderID, itemID)
); 

select * from orderRecord
