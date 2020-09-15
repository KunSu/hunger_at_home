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
  `email` varchar(20) NOT NULL UNIQUE,
  `password` varchar(20) NOT NULL,
  `firstName` varchar(255) NOT NULL,
  `lastName` varchar(255) NOT NULL,
  `phoneNumber` int NOT NULL,
  `userIdentity` varchar(20) NOT NULL,
  `companyID` int NOT NULL,
  `secureQuestion` varchar(255) NOT NULL,
  `secureAnswer` varchar(255) NOT NULL,
  `timestamp` date NOT NULL,
  PRIMARY KEY (id)
); 

-- Create Table [company]
DROP TABLE IF EXISTS `foodApp`.`company`;
CREATE TABLE `foodApp`.`company` (
  `id` int NOT NULL AUTO_INCREMENT, 
  `companyName` varchar(20) NOT NULL UNIQUE,
  `fedID` varchar(100) NOT NULL UNIQUE,
  `einID` varchar(100) NOT NULL UNIQUE,
   `timestamp` date NOT NULL,
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
  `timestamp` date NOT NULL,
   PRIMARY KEY (id)
); 

-- Create Table [companyAddressAssociate]
DROP TABLE IF EXISTS `foodApp`.`companyAddressAssociate`;
CREATE TABLE `foodApp`.`companyAddressAssociate` (
  `addressID` int NOT NULL, 
  `companyID` int NOT NULL,  
  `timestamp` date NOT NULL,
   PRIMARY KEY (addressID, companyID)
); 

-- Create Table [donation]
DROP TABLE IF EXISTS `foodApp`.`donation`;
CREATE TABLE `foodApp`.`donation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `foodName` varchar(255) NOT NULL,
  `foodCategory` varchar(255) NOT NULL,
  `expireDate` date NOT NULL,
  `quantity` varchar(255) NOT NULL,
  `note` varchar(255) NOT NULL,
  `address` varchar(100) NOT NULL,
  `city` varchar(20) NOT NULL,
  `state` varchar(20) NOT NULL,
  `zipCode` int NOT NULL,
  `pickUpTime` date NOT NULL,
  `donorID` int NOT NULL,
  `driverID` int NOT NULL,
  `status` varchar(100) NOT NULL,
  `timestamp` date NOT NULL,
  PRIMARY KEY (id)
); 

-- Create Table [request]
DROP TABLE IF EXISTS `foodApp`.`request`;
CREATE TABLE `foodApp`.`request` (
  `id` int NOT NULL AUTO_INCREMENT,
  `foodName` varchar(255) NOT NULL,
  `foodCategory` varchar(255) NOT NULL,
  `expireDate` date NOT NULL,
  `quantity` varchar(255) NOT NULL,
  `note` varchar(255) NOT NULL,
  `address` varchar(100) NOT NULL,
  `city` varchar(20) NOT NULL,
  `state` varchar(20) NOT NULL,
  `zipCode` int NOT NULL,
  `pickUpTime` date NOT NULL,
  `donorID` int NOT NULL,
  `status` varchar(100) NOT NULL,
  `timestamp` date NOT NULL,
  PRIMARY KEY (id)
); 

-- Create Table [orderAssociate]
DROP TABLE IF EXISTS `foodApp`.`orderAssociate`;
CREATE TABLE `foodApp`.`orderAssociate` (
  `orderID` int NOT NULL, 
  `driverID` int,  
  `donorID` int NOT NULL,  
  `recipientID` int NOT NULL,  
  `timestamp` date NOT NULL,
   PRIMARY KEY (orderID, donorID, recipientID)
); 