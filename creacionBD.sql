-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema appassistant
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema appassistant
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `appassistant` DEFAULT CHARACTER SET utf8mb3 ;
USE `appassistant` ;

-- -----------------------------------------------------
-- Table `appassistant`.`appcountries`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appcountries` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appcountries` (
  `appCountriesid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(60) NOT NULL,
  `currency` VARCHAR(30) NOT NULL,
  `currencySymbol` VARCHAR(3) NOT NULL,
  `language` VARCHAR(7) NOT NULL,
  PRIMARY KEY (`appCountriesid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appstates`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appstates` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appstates` (
  `appStatesID` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(40) NULL DEFAULT NULL,
  `appCountriesid` INT NOT NULL,
  PRIMARY KEY (`appStatesID`),
  INDEX `fk_appStates_appCountries1_idx` (`appCountriesid` ASC) VISIBLE,
  CONSTRAINT `fk_appStates_appCountries1`
    FOREIGN KEY (`appCountriesid`)
    REFERENCES `appassistant`.`appcountries` (`appCountriesid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appcities`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appcities` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appcities` (
  `appCitiesid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NULL DEFAULT NULL,
  `appStatesID` INT NOT NULL,
  PRIMARY KEY (`appCitiesid`),
  INDEX `fk_appCities_appStates1_idx` (`appStatesID` ASC) VISIBLE,
  CONSTRAINT `fk_appCities_appStates1`
    FOREIGN KEY (`appStatesID`)
    REFERENCES `appassistant`.`appstates` (`appStatesID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appaddresses`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appaddresses` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appaddresses` (
  `appAddressesid` INT NOT NULL AUTO_INCREMENT,
  `line1` VARCHAR(200) NOT NULL,
  `line2` VARCHAR(200) NOT NULL,
  `zipcode` VARCHAR(9) NULL DEFAULT NULL,
  `location` POINT NULL DEFAULT NULL,
  `appCitiesid` INT NOT NULL,
  PRIMARY KEY (`appAddressesid`),
  INDEX `fk_appAddresses_appCities1_idx` (`appCitiesid` ASC) VISIBLE,
  CONSTRAINT `fk_appAddresses_appCities1`
    FOREIGN KEY (`appCitiesid`)
    REFERENCES `appassistant`.`appcities` (`appCitiesid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appnotificationstatus`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appnotificationstatus` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appnotificationstatus` (
  `notificationStatusId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `enabled` BIT(1) NOT NULL,
  PRIMARY KEY (`notificationStatusId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`apphelpnotification`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`apphelpnotification` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`apphelpnotification` (
  `helpNotificationId` INT NOT NULL AUTO_INCREMENT,
  `creationDate` DATETIME NOT NULL,
  `tittle` VARCHAR(30) NOT NULL,
  `message` VARCHAR(100) NOT NULL,
  `notificationStatusId` INT NOT NULL,
  `apperroresiaid` INT NULL,
  PRIMARY KEY (`helpNotificationId`),
  INDEX `fk_appHelpNotification_appNotificationStatus1_idx` (`notificationStatusId` ASC) VISIBLE,
  CONSTRAINT `fk_appHelpNotification_appNotificationStatus1`
    FOREIGN KEY (`notificationStatusId`)
    REFERENCES `appassistant`.`appnotificationstatus` (`notificationStatusId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appchatstatus`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appchatstatus` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appchatstatus` (
  `chatStatusId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`chatStatusId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appiamodels`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appiamodels` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appiamodels` (
  `modelIAId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `enable` BIT(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`modelIAId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appiaroles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appiaroles` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appiaroles` (
  `rolesIAId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `description` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`rolesIAId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appmodalities`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appmodalities` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appmodalities` (
  `modalityId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `enabled` BIT(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`modalityId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appchatapi`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appchatapi` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appchatapi` (
  `chatAPIId` INT NOT NULL AUTO_INCREMENT,
  `token` VARBINARY(256) NOT NULL,
  `returnedObject` JSON NOT NULL,
  `apiKey` VARCHAR(256) NOT NULL,
  `responseFormat` VARCHAR(50) NOT NULL,
  `finished` BIT(1) NOT NULL,
  `maxTokens` INT NOT NULL,
  `context` VARCHAR(100) NULL DEFAULT NULL,
  `chatStatusId` INT NOT NULL,
  `modalityId` INT NOT NULL,
  `modelIAId` INT NOT NULL,
  `rolesIAId` INT NOT NULL,
  PRIMARY KEY (`chatAPIId`),
  INDEX `fk_appChatAPI_appChatStatus1_idx` (`chatStatusId` ASC) VISIBLE,
  INDEX `fk_appChatAPI_appModalities1_idx` (`modalityId` ASC) VISIBLE,
  INDEX `fk_appChatAPI_appIAmodels1_idx` (`modelIAId` ASC) VISIBLE,
  INDEX `fk_appChatAPI_appIAroles1_idx` (`rolesIAId` ASC) VISIBLE,
  CONSTRAINT `fk_appChatAPI_appChatStatus1`
    FOREIGN KEY (`chatStatusId`)
    REFERENCES `appassistant`.`appchatstatus` (`chatStatusId`),
  CONSTRAINT `fk_appChatAPI_appIAmodels1`
    FOREIGN KEY (`modelIAId`)
    REFERENCES `appassistant`.`appiamodels` (`modelIAId`),
  CONSTRAINT `fk_appChatAPI_appIAroles1`
    FOREIGN KEY (`rolesIAId`)
    REFERENCES `appassistant`.`appiaroles` (`rolesIAId`),
  CONSTRAINT `fk_appChatAPI_appModalities1`
    FOREIGN KEY (`modalityId`)
    REFERENCES `appassistant`.`appmodalities` (`modalityId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appanalysisia`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appanalysisia` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appanalysisia` (
  `AnalysisIAId` INT NOT NULL AUTO_INCREMENT,
  `output` VARCHAR(1000) NOT NULL,
  `creationDate` DATETIME NOT NULL,
  `chatAPIId` INT NOT NULL,
  `helpNotificationId` INT NOT NULL,
  PRIMARY KEY (`AnalysisIAId`),
  INDEX `fk_appAnalysisIA_appChatAPI1_idx` (`chatAPIId` ASC) VISIBLE,
  INDEX `appHelpNotification1_idx` (`helpNotificationId` ASC) VISIBLE,
  CONSTRAINT `appHelpNotification1`
    FOREIGN KEY (`helpNotificationId`)
    REFERENCES `appassistant`.`apphelpnotification` (`helpNotificationId`),
  CONSTRAINT `fk_appAnalysisIA_appChatAPI1`
    FOREIGN KEY (`chatAPIId`)
    REFERENCES `appassistant`.`appchatapi` (`chatAPIId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appmediatypes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appmediatypes` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appmediatypes` (
  `mediaTypeID` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(90) NOT NULL,
  `playerImpl` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`mediaTypeID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appmetodospago`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appmetodospago` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appmetodospago` (
  `metodoId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `apiURL` VARCHAR(200) NOT NULL,
  `secretKey` VARBINARY(50) NOT NULL,
  `key` VARBINARY(50) NOT NULL,
  `enable` BIT(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`metodoId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appmodules`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appmodules` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appmodules` (
  `appModulesid` INT NOT NULL,
  `name` VARCHAR(40) NULL DEFAULT NULL,
  PRIMARY KEY (`appModulesid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appmediafiles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appmediafiles` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appmediafiles` (
  `mediaFileId` INT NOT NULL AUTO_INCREMENT,
  `documentURL` VARCHAR(200) NOT NULL,
  `lastUpdate` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted` BIT(1) NOT NULL DEFAULT b'0',
  `mediaTypeID` INT NOT NULL,
  `appModulesid` INT NOT NULL,
  `metodoId` INT NOT NULL,
  PRIMARY KEY (`mediaFileId`),
  INDEX `fk_appMediaFiles_appMediaTypes1_idx` (`mediaTypeID` ASC) VISIBLE,
  INDEX `fk_appMediaFiles_appModules1_idx` (`appModulesid` ASC) VISIBLE,
  INDEX `fk_appMediaFiles_appMetodosPago1_idx` (`metodoId` ASC) VISIBLE,
  CONSTRAINT `fk_appMediaFiles_appMediaTypes1`
    FOREIGN KEY (`mediaTypeID`)
    REFERENCES `appassistant`.`appmediatypes` (`mediaTypeID`),
  CONSTRAINT `fk_appMediaFiles_appMetodosPago1`
    FOREIGN KEY (`metodoId`)
    REFERENCES `appassistant`.`appmetodospago` (`metodoId`),
  CONSTRAINT `fk_appMediaFiles_appModules1`
    FOREIGN KEY (`appModulesid`)
    REFERENCES `appassistant`.`appmodules` (`appModulesid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`applanguages`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`applanguages` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`applanguages` (
  `appLanguagesid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  `culture` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`appLanguagesid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`apptranslations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`apptranslations` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`apptranslations` (
  `appTranslationsid` INT NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(45) NULL DEFAULT NULL,
  `caption` VARCHAR(45) NULL DEFAULT NULL,
  `enabled` BIT(1) NULL DEFAULT NULL,
  `appLanguagesid` INT NOT NULL,
  `appModulesid` INT NOT NULL,
  PRIMARY KEY (`appTranslationsid`),
  INDEX `fk_appTranslations_appLanguages1_idx` (`appLanguagesid` ASC) VISIBLE,
  INDEX `fk_appTranslations_appModules1_idx` (`appModulesid` ASC) VISIBLE,
  CONSTRAINT `fk_appTranslations_appLanguages1`
    FOREIGN KEY (`appLanguagesid`)
    REFERENCES `appassistant`.`applanguages` (`appLanguagesid`),
  CONSTRAINT `fk_appTranslations_appModules1`
    FOREIGN KEY (`appModulesid`)
    REFERENCES `appassistant`.`appmodules` (`appModulesid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appaudioatranscripcionapi`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appaudioatranscripcionapi` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appaudioatranscripcionapi` (
  `audioAtranscripcionId` INT NOT NULL AUTO_INCREMENT,
  `token` VARBINARY(256) NOT NULL,
  `apiKey` VARCHAR(256) NOT NULL,
  `include` VARCHAR(50) NULL DEFAULT NULL,
  `stream` BIT(1) NULL DEFAULT b'1',
  `responseFormat` JSON NOT NULL,
  `mediaFileId` INT NOT NULL,
  `appTranslationsid` INT NOT NULL,
  `modelIAId` INT NOT NULL,
  PRIMARY KEY (`audioAtranscripcionId`),
  INDEX `fk_appAudioAtranscripcionAPI_appMediaFiles1_idx` (`mediaFileId` ASC) VISIBLE,
  INDEX `fk_appAudioAtranscripcionAPI_appTranslations1_idx` (`appTranslationsid` ASC) VISIBLE,
  INDEX `fk_appAudioAtranscripcionAPI_appIAmodels1_idx` (`modelIAId` ASC) VISIBLE,
  CONSTRAINT `fk_appAudioAtranscripcionAPI_appIAmodels1`
    FOREIGN KEY (`modelIAId`)
    REFERENCES `appassistant`.`appiamodels` (`modelIAId`),
  CONSTRAINT `fk_appAudioAtranscripcionAPI_appMediaFiles1`
    FOREIGN KEY (`mediaFileId`)
    REFERENCES `appassistant`.`appmediafiles` (`mediaFileId`),
  CONSTRAINT `fk_appAudioAtranscripcionAPI_appTranslations1`
    FOREIGN KEY (`appTranslationsid`)
    REFERENCES `appassistant`.`apptranslations` (`appTranslationsid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appempresas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appempresas` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appempresas` (
  `empresaId` INT NOT NULL AUTO_INCREMENT,
  `companyName` VARCHAR(50) NOT NULL,
  `signInDate` DATETIME NOT NULL,
  `enabled` BIT(1) NOT NULL DEFAULT b'1',
  `deleted` BIT(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`empresaId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appusers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appusers` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appusers` (
  `appUsersid` INT NOT NULL,
  `firstName` VARCHAR(50) NOT NULL,
  `lastName` VARCHAR(50) NOT NULL,
  `password` VARBINARY(64) NOT NULL,
  `fechaNacimiento` DATE NOT NULL,
  `enabled` BIT(1) NOT NULL DEFAULT b'1',
  `empresaId` INT NULL DEFAULT NULL,
  `contact` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`appUsersid`),
  INDEX `fk_appUsers_appEmpresas1_idx` (`empresaId` ASC) VISIBLE,
  CONSTRAINT `fk_appUsers_appEmpresas1`
    FOREIGN KEY (`empresaId`)
    REFERENCES `appassistant`.`appempresas` (`empresaId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appcapturaapirequest`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appcapturaapirequest` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appcapturaapirequest` (
  `capturaPantallaId` INT NOT NULL AUTO_INCREMENT,
  `token` VARBINARY(256) NOT NULL,
  `timestamp` DATETIME NOT NULL,
  `source` VARCHAR(100) NOT NULL,
  `captureArea` JSON NOT NULL,
  `resolution` JSON NOT NULL,
  `URL` VARCHAR(200) NOT NULL,
  `appTapsPantallaid` INT NOT NULL,
  `appUsersid` INT NOT NULL,
  PRIMARY KEY (`capturaPantallaId`),
  INDEX `appUsers1_idx` (`appUsersid` ASC) VISIBLE,
  CONSTRAINT `appUsers1`
    FOREIGN KEY (`appUsersid`)
    REFERENCES `appassistant`.`appusers` (`appUsersid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appcategories`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appcategories` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appcategories` (
  `categoryId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `description` VARCHAR(500) NOT NULL,
  `deleted` BIT(1) NOT NULL DEFAULT b'0',
  `creationDate` DATETIME NOT NULL,
  PRIMARY KEY (`categoryId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appcontactinfotype`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appcontactinfotype` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appcontactinfotype` (
  `contactInfoTypeId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`contactInfoTypeId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appcontactinfoempresas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appcontactinfoempresas` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appcontactinfoempresas` (
  `contactInfoId` INT NOT NULL AUTO_INCREMENT,
  `valorContacto` VARCHAR(255) NOT NULL,
  `enable` BIT(1) NOT NULL DEFAULT b'1',
  `lastUpdate` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `empresaId` INT NOT NULL,
  `contactInfoTypeId` INT NOT NULL,
  PRIMARY KEY (`contactInfoId`),
  INDEX `fk_appContactInfoEmpresas_appEmpresas1_idx` (`empresaId` ASC) VISIBLE,
  INDEX `fk_appContactInfoEmpresas_appContactInfoType1_idx` (`contactInfoTypeId` ASC) VISIBLE,
  CONSTRAINT `fk_appContactInfoEmpresas_appContactInfoType1`
    FOREIGN KEY (`contactInfoTypeId`)
    REFERENCES `appassistant`.`appcontactinfotype` (`contactInfoTypeId`),
  CONSTRAINT `fk_appContactInfoEmpresas_appEmpresas1`
    FOREIGN KEY (`empresaId`)
    REFERENCES `appassistant`.`appempresas` (`empresaId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appcontactinfouser`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appcontactinfouser` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appcontactinfouser` (
  `valueContact` VARCHAR(100) NOT NULL,
  `enable` BIT(1) NOT NULL DEFAULT b'1',
  `lastupdate` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `appUsersid` INT NOT NULL,
  `contactInfoID` INT NOT NULL,
  PRIMARY KEY (`valueContact`),
  INDEX `fk_appContactInfo_appUsers1_idx` (`appUsersid` ASC) VISIBLE,
  INDEX `fk_appContactInfo_appContactInfoType1_idx` (`contactInfoID` ASC) VISIBLE,
  CONSTRAINT `fk_appContactInfo_appContactInfoType1`
    FOREIGN KEY (`contactInfoID`)
    REFERENCES `appassistant`.`appcontactinfotype` (`contactInfoTypeId`),
  CONSTRAINT `fk_appContactInfo_appUsers1`
    FOREIGN KEY (`appUsersid`)
    REFERENCES `appassistant`.`appusers` (`appUsersid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appcurrencysymbol`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appcurrencysymbol` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appcurrencysymbol` (
  `currencyId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `acronym` VARCHAR(10) NOT NULL,
  `symbol` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`currencyId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appcurrencyexchangerate`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appcurrencyexchangerate` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appcurrencyexchangerate` (
  `currencyExchangeRateId` INT NOT NULL AUTO_INCREMENT,
  `startDate` DATETIME NOT NULL,
  `endDate` DATETIME NOT NULL,
  `exchangeRate` FLOAT NOT NULL,
  `enabled` BIT(1) NOT NULL DEFAULT b'0',
  `currencyId` INT NOT NULL,
  PRIMARY KEY (`currencyExchangeRateId`),
  INDEX `fk_appCurrencyExchangeRate_appCurrencySymbol1_idx` (`currencyId` ASC) VISIBLE,
  CONSTRAINT `fk_appCurrencyExchangeRate_appCurrencySymbol1`
    FOREIGN KEY (`currencyId`)
    REFERENCES `appassistant`.`appcurrencysymbol` (`currencyId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`apptranscripcionia`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`apptranscripcionia` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`apptranscripcionia` (
  `transcripcionAIId` INT NOT NULL AUTO_INCREMENT,
  `enabled` BIT(1) NOT NULL DEFAULT b'1',
  `deleted` BIT(1) NOT NULL DEFAULT b'0',
  `creationDate` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `data` JSON NOT NULL,
  `tamaño` FLOAT NOT NULL,
  `finished` BIT(1) NOT NULL DEFAULT b'0',
  `mediaFileId` INT NOT NULL,
  `chatAnalysisId` INT NULL,
  PRIMARY KEY (`transcripcionAIId`),
  INDEX `fk_appTranscripcionIA_appMediaFiles1_idx` (`mediaFileId` ASC) VISIBLE,
  INDEX `fk_appTranscripcionIA_appIAFoundData1_idx` (`chatAnalysisId` ASC) VISIBLE,
  CONSTRAINT `fk_appTranscripcionIA_appIAFoundData1`
    FOREIGN KEY (`chatAnalysisId`)
    REFERENCES `appassistant`.`appanalysisia` (`AnalysisIAId`),
  CONSTRAINT `fk_appTranscripcionIA_appMediaFiles1`
    FOREIGN KEY (`mediaFileId`)
    REFERENCES `appassistant`.`appmediafiles` (`mediaFileId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appeventtypesia`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appeventtypesia` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appeventtypesia` (
  `eventTypeId` INT NOT NULL AUTO_INCREMENT,
  `typeName` VARCHAR(60) NOT NULL,
  `creationDate` DATETIME NOT NULL,
  `description` VARCHAR(50) NULL DEFAULT NULL,
  `ocurrenciasCount` SMALLINT NOT NULL,
  `accuracy` VARCHAR(30) NOT NULL,
  `finishedReason` VARCHAR(30) NOT NULL,
  `chatAPIId` INT NOT NULL,
  `transcripcionAIId` INT NOT NULL,
  PRIMARY KEY (`eventTypeId`),
  INDEX `fk_appEventTypesIA_appChatAPI1_idx` (`chatAPIId` ASC) VISIBLE,
  INDEX `fk_appEventTypesIA_appTranscripcionIA1_idx` (`transcripcionAIId` ASC) VISIBLE,
  CONSTRAINT `fk_appEventTypesIA_appChatAPI1`
    FOREIGN KEY (`chatAPIId`)
    REFERENCES `appassistant`.`appchatapi` (`chatAPIId`),
  CONSTRAINT `fk_appEventTypesIA_appTranscripcionIA1`
    FOREIGN KEY (`transcripcionAIId`)
    REFERENCES `appassistant`.`apptranscripcionia` (`transcripcionAIId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appplanfeatures`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appplanfeatures` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appplanfeatures` (
  `planFeaturesId` INT NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(200) NOT NULL,
  `enabled` BIT(1) NOT NULL DEFAULT b'0',
  `datatype` VARCHAR(30) NULL DEFAULT NULL,
  PRIMARY KEY (`planFeaturesId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appsubscriptions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appsubscriptions` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appsubscriptions` (
  `subscriptionId` INT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`subscriptionId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appfeatureperplan`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appfeatureperplan` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appfeatureperplan` (
  `featurePerPlanId` INT NOT NULL AUTO_INCREMENT,
  `value` VARCHAR(50) NOT NULL,
  `enabled` BIT(1) NOT NULL DEFAULT b'0',
  `subscriptionId` INT NOT NULL,
  `planFeaturesId` INT NOT NULL,
  PRIMARY KEY (`featurePerPlanId`),
  INDEX `fk_appFeaturePerPlan_appSubscriptions1_idx` (`subscriptionId` ASC) VISIBLE,
  INDEX `fk_appFeaturePerPlan_appPlanFeatures1_idx` (`planFeaturesId` ASC) VISIBLE,
  CONSTRAINT `fk_appFeaturePerPlan_appPlanFeatures1`
    FOREIGN KEY (`planFeaturesId`)
    REFERENCES `appassistant`.`appplanfeatures` (`planFeaturesId`),
  CONSTRAINT `fk_appFeaturePerPlan_appSubscriptions1`
    FOREIGN KEY (`subscriptionId`)
    REFERENCES `appassistant`.`appsubscriptions` (`subscriptionId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`applogseverity`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`applogseverity` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`applogseverity` (
  `appLogSeverityid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`appLogSeverityid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`applogsources`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`applogsources` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`applogsources` (
  `appLogSourcesid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`appLogSourcesid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`applogtypes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`applogtypes` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`applogtypes` (
  `appLogTypesid` INT NOT NULL AUTO_INCREMENT,
  `name` ENUM('login', 'logout', 'loginFailed', 'changePass', 'viewSales', 'enablePerm', 'cancelOrder', 'other') NOT NULL,
  `ref1Desc` VARCHAR(45) NOT NULL,
  `ref2Desc` VARCHAR(45) NOT NULL,
  `val1Desc` VARCHAR(45) NOT NULL,
  `val2Desc` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`appLogTypesid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`applogs`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`applogs` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`applogs` (
  `appLogsid` INT NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(45) NOT NULL,
  `postTime` VARCHAR(45) NOT NULL,
  `computer` VARCHAR(45) NOT NULL,
  `username` VARCHAR(45) NOT NULL,
  `trace` VARCHAR(45) NOT NULL,
  `appLogscol` VARCHAR(45) NOT NULL,
  `referenceID1` BIGINT NOT NULL,
  `referneceID2` BIGINT NOT NULL,
  `value1` VARCHAR(45) NOT NULL,
  `value2` VARCHAR(45) NOT NULL,
  `checksum` VARBINARY(250) NOT NULL,
  `appLogTypesid` INT NOT NULL,
  `appLogSourcesid` INT NOT NULL,
  `appLogSeverityid` INT NOT NULL,
  PRIMARY KEY (`appLogsid`),
  INDEX `appLogTypes1_idx` (`appLogTypesid` ASC) VISIBLE,
  INDEX `appLogSources1_idx` (`appLogSourcesid` ASC) VISIBLE,
  INDEX `appLogSeverity1_idx` (`appLogSeverityid` ASC) VISIBLE,
  CONSTRAINT `appLogSeverity1`
    FOREIGN KEY (`appLogSeverityid`)
    REFERENCES `appassistant`.`applogseverity` (`appLogSeverityid`),
  CONSTRAINT `appLogSources1`
    FOREIGN KEY (`appLogSourcesid`)
    REFERENCES `appassistant`.`applogsources` (`appLogSourcesid`),
  CONSTRAINT `appLogTypes1`
    FOREIGN KEY (`appLogTypesid`)
    REFERENCES `appassistant`.`applogtypes` (`appLogTypesid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appmediafilecapture`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appmediafilecapture` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appmediafilecapture` (
  `capturaPantallaId` INT NOT NULL AUTO_INCREMENT,
  `mediaFileId` INT NOT NULL,
  INDEX `fk_appMediaFileCapture_appCapturaPantallaAPI1_idx` (`capturaPantallaId` ASC) VISIBLE,
  INDEX `fk_appMediaFileCapture_appMediaFiles1_idx` (`mediaFileId` ASC) VISIBLE,
  CONSTRAINT `fk_appMediaFileCapture_appCapturaPantallaAPI1`
    FOREIGN KEY (`capturaPantallaId`)
    REFERENCES `appassistant`.`appcapturaapirequest` (`capturaPantallaId`),
  CONSTRAINT `fk_appMediaFileCapture_appMediaFiles1`
    FOREIGN KEY (`mediaFileId`)
    REFERENCES `appassistant`.`appmediafiles` (`mediaFileId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appmediafilescompanies`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appmediafilescompanies` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appmediafilescompanies` (
  `mediaFileId` INT NOT NULL,
  `empresaId` INT NOT NULL,
  `deleted` BIT(1) NOT NULL DEFAULT b'1',
  INDEX `appMediaFiles3_idx` (`mediaFileId` ASC) VISIBLE,
  INDEX `appEmpresas1_idx` (`empresaId` ASC) VISIBLE,
  CONSTRAINT `appEmpresas1`
    FOREIGN KEY (`empresaId`)
    REFERENCES `appassistant`.`appempresas` (`empresaId`),
  CONSTRAINT `appMediaFiles3`
    FOREIGN KEY (`mediaFileId`)
    REFERENCES `appassistant`.`appmediafiles` (`mediaFileId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appmediafilessubscriptions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appmediafilessubscriptions` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appmediafilessubscriptions` (
  `mediaFileId` INT NOT NULL,
  `subscriptionId` INT NOT NULL,
  `deleted` BIT(1) NOT NULL DEFAULT b'0',
  INDEX `appMediaFiles2_idx` (`mediaFileId` ASC) VISIBLE,
  INDEX `appSubscriptions1_idx` (`subscriptionId` ASC) VISIBLE,
  CONSTRAINT `appMediaFiles2`
    FOREIGN KEY (`mediaFileId`)
    REFERENCES `appassistant`.`appmediafiles` (`mediaFileId`),
  CONSTRAINT `appSubscriptions1`
    FOREIGN KEY (`subscriptionId`)
    REFERENCES `appassistant`.`appsubscriptions` (`subscriptionId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appmediafilesusers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appmediafilesusers` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appmediafilesusers` (
  `mediaFileId` INT NOT NULL,
  `appUsersid` INT NOT NULL,
  `deleted` BIT(1) NOT NULL DEFAULT b'0',
  INDEX `appMediaFiles1_idx` (`mediaFileId` ASC) VISIBLE,
  INDEX `appUsers3_idx` (`appUsersid` ASC) VISIBLE,
  CONSTRAINT `appMediaFiles1`
    FOREIGN KEY (`mediaFileId`)
    REFERENCES `appassistant`.`appmediafiles` (`mediaFileId`),
  CONSTRAINT `appUsers3`
    FOREIGN KEY (`appUsersid`)
    REFERENCES `appassistant`.`appusers` (`appUsersid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appmetodosdisponibles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appmetodosdisponibles` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appmetodosdisponibles` (
  `metodoDisponibleId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `configuracionDetalles` JSON NOT NULL,
  `refreshToken` VARCHAR(255) NOT NULL,
  `token` VARBINARY(120) NOT NULL,
  `expToken` DATETIME NOT NULL,
  `maskAccount` VARCHAR(45) NOT NULL,
  `appUsersid` INT NOT NULL,
  `metodoId` INT NOT NULL,
  PRIMARY KEY (`metodoDisponibleId`),
  INDEX `fk_appMetodosDisponibles_appUsers1_idx` (`appUsersid` ASC) VISIBLE,
  INDEX `fk_appMetodosDisponibles_appMetodosPago1_idx` (`metodoId` ASC) VISIBLE,
  CONSTRAINT `fk_appMetodosDisponibles_appMetodosPago1`
    FOREIGN KEY (`metodoId`)
    REFERENCES `appassistant`.`appmetodospago` (`metodoId`),
  CONSTRAINT `fk_appMetodosDisponibles_appUsers1`
    FOREIGN KEY (`appUsersid`)
    REFERENCES `appassistant`.`appusers` (`appUsersid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`apppagos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`apppagos` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`apppagos` (
  `pagoId` BIGINT NOT NULL AUTO_INCREMENT,
  `monto` FLOAT NOT NULL,
  `actualMonto` FLOAT NOT NULL,
  `result` VARCHAR(500) NOT NULL,
  `authnumber` VARCHAR(30) NOT NULL,
  `reference` VARCHAR(500) NOT NULL,
  `chargeToken` VARBINARY(256) NOT NULL,
  `description` VARCHAR(100) NOT NULL,
  `error` VARCHAR(100) NOT NULL,
  `fecha` DATETIME NOT NULL,
  `checksum` VARBINARY(50) NOT NULL,
  `metodoPagoId` INT NOT NULL,
  `metodoId` INT NOT NULL,
  `appUsersid` INT NOT NULL,
  `appModulesid` INT NOT NULL,
  `currencyId` INT NOT NULL,
  PRIMARY KEY (`pagoId`),
  INDEX `fk_appPagos_appMetodosDisponibles1_idx` (`metodoPagoId` ASC) VISIBLE,
  INDEX `fk_appPagos_appMetodosPago1_idx` (`metodoId` ASC) VISIBLE,
  INDEX `fk_appPagos_appUsers1_idx` (`appUsersid` ASC) VISIBLE,
  INDEX `fk_appPagos_appModules1_idx` (`appModulesid` ASC) VISIBLE,
  INDEX `fk_appPagos_appCurrencySymbol1_idx` (`currencyId` ASC) VISIBLE,
  CONSTRAINT `fk_appPagos_appCurrencySymbol1`
    FOREIGN KEY (`currencyId`)
    REFERENCES `appassistant`.`appcurrencysymbol` (`currencyId`),
  CONSTRAINT `fk_appPagos_appMetodosDisponibles1`
    FOREIGN KEY (`metodoPagoId`)
    REFERENCES `appassistant`.`appmetodosdisponibles` (`metodoDisponibleId`),
  CONSTRAINT `fk_appPagos_appMetodosPago1`
    FOREIGN KEY (`metodoId`)
    REFERENCES `appassistant`.`appmetodospago` (`metodoId`),
  CONSTRAINT `fk_appPagos_appModules1`
    FOREIGN KEY (`appModulesid`)
    REFERENCES `appassistant`.`appmodules` (`appModulesid`),
  CONSTRAINT `fk_appPagos_appUsers1`
    FOREIGN KEY (`appUsersid`)
    REFERENCES `appassistant`.`appusers` (`appUsersid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`apppermissions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`apppermissions` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`apppermissions` (
  `appPermissionsid` INT NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(60) NOT NULL,
  `code` VARCHAR(10) NOT NULL,
  `appModulesid` INT NOT NULL,
  PRIMARY KEY (`appPermissionsid`),
  INDEX `appModules1_idx` (`appModulesid` ASC) VISIBLE,
  CONSTRAINT `appModules1`
    FOREIGN KEY (`appModulesid`)
    REFERENCES `appassistant`.`appmodules` (`appModulesid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appschedules`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appschedules` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appschedules` (
  `scheduleId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NULL DEFAULT NULL,
  `recurrentType` VARCHAR(20) NULL DEFAULT NULL,
  `repetition` INT NOT NULL,
  `endType` VARCHAR(30) NOT NULL,
  `endDate` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`scheduleId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appplanprices`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appplanprices` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appplanprices` (
  `planPriceId` INT NOT NULL AUTO_INCREMENT,
  `amount` FLOAT NOT NULL,
  `postTime` DATETIME NOT NULL,
  `enable` BIT(1) NOT NULL DEFAULT b'0',
  `endDate` DATETIME NOT NULL,
  `subscriptionId` INT NOT NULL,
  `scheduleId` INT NOT NULL,
  `currencyId` INT NOT NULL,
  PRIMARY KEY (`planPriceId`),
  INDEX `fk_appPlanPrices_appSubscriptions1_idx` (`subscriptionId` ASC) VISIBLE,
  INDEX `fk_appPlanPrices_appSchedules1_idx` (`scheduleId` ASC) VISIBLE,
  INDEX `fk_appPlanPrices_appCurrencySymbol1_idx` (`currencyId` ASC) VISIBLE,
  CONSTRAINT `fk_appPlanPrices_appCurrencySymbol1`
    FOREIGN KEY (`currencyId`)
    REFERENCES `appassistant`.`appcurrencysymbol` (`currencyId`),
  CONSTRAINT `fk_appPlanPrices_appSchedules1`
    FOREIGN KEY (`scheduleId`)
    REFERENCES `appassistant`.`appschedules` (`scheduleId`),
  CONSTRAINT `fk_appPlanPrices_appSubscriptions1`
    FOREIGN KEY (`subscriptionId`)
    REFERENCES `appassistant`.`appsubscriptions` (`subscriptionId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appplanperperson`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appplanperperson` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appplanperperson` (
  `planPerPersonId` INT NOT NULL AUTO_INCREMENT,
  `addDate` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `enabled` BIT(1) NOT NULL DEFAULT b'1',
  `appUsersid` INT NOT NULL,
  `scheduleId` INT NOT NULL,
  `planPriceId` INT NOT NULL,
  PRIMARY KEY (`planPerPersonId`),
  INDEX `fk_appPlanPerPerson_appUsers1_idx` (`appUsersid` ASC) VISIBLE,
  INDEX `fk_appPlanPerPerson_appSchedules1_idx` (`scheduleId` ASC) VISIBLE,
  INDEX `fk_appPlanPerPerson_appPlanPrices1_idx` (`planPriceId` ASC) VISIBLE,
  CONSTRAINT `fk_appPlanPerPerson_appPlanPrices1`
    FOREIGN KEY (`planPriceId`)
    REFERENCES `appassistant`.`appplanprices` (`planPriceId`),
  CONSTRAINT `fk_appPlanPerPerson_appSchedules1`
    FOREIGN KEY (`scheduleId`)
    REFERENCES `appassistant`.`appschedules` (`scheduleId`),
  CONSTRAINT `fk_appPlanPerPerson_appUsers1`
    FOREIGN KEY (`appUsersid`)
    REFERENCES `appassistant`.`appusers` (`appUsersid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`apppersonplanlimits`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`apppersonplanlimits` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`apppersonplanlimits` (
  `planId` INT NOT NULL AUTO_INCREMENT,
  `limit` VARCHAR(120) NOT NULL,
  `planFeaturesId` INT NOT NULL,
  `planPerPersonId` INT NOT NULL,
  PRIMARY KEY (`planId`),
  INDEX `fk_appPersonPlanLimits_appPlanFeatures1_idx` (`planFeaturesId` ASC) VISIBLE,
  INDEX `fk_appPersonPlanLimits_appPlanPerPerson1_idx` (`planPerPersonId` ASC) VISIBLE,
  CONSTRAINT `fk_appPersonPlanLimits_appPlanFeatures1`
    FOREIGN KEY (`planFeaturesId`)
    REFERENCES `appassistant`.`appplanfeatures` (`planFeaturesId`),
  CONSTRAINT `fk_appPersonPlanLimits_appPlanPerPerson1`
    FOREIGN KEY (`planPerPersonId`)
    REFERENCES `appassistant`.`appplanperperson` (`planPerPersonId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`approles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`approles` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`approles` (
  `roleID` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `enabled` BIT(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`roleID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`approlespermissions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`approlespermissions` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`approlespermissions` (
  `appRolesPermissionsid` INT NOT NULL AUTO_INCREMENT,
  `enabled` BIT(1) NOT NULL DEFAULT b'1',
  `deleted` BIT(1) NOT NULL,
  `lastUpdate` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `username` VARCHAR(50) NOT NULL,
  `checksum` VARBINARY(250) NOT NULL,
  `roleID` INT NOT NULL,
  `appPermissionsid` INT NOT NULL,
  PRIMARY KEY (`appRolesPermissionsid`),
  INDEX `appRoles2_idx` (`roleID` ASC) VISIBLE,
  INDEX `appPermissions1_idx` (`appPermissionsid` ASC) VISIBLE,
  CONSTRAINT `appPermissions1`
    FOREIGN KEY (`appPermissionsid`)
    REFERENCES `appassistant`.`apppermissions` (`appPermissionsid`),
  CONSTRAINT `appRoles2`
    FOREIGN KEY (`roleID`)
    REFERENCES `appassistant`.`approles` (`roleID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appscheduledetails`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appscheduledetails` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appscheduledetails` (
  `schedulesDetailsId` INT NOT NULL AUTO_INCREMENT,
  `deleted` BIT(1) NOT NULL DEFAULT b'0',
  `baseDate` DATETIME NOT NULL,
  `datepart` INT NOT NULL,
  `lastexecution` DATETIME NOT NULL,
  `nextExecution` DATETIME NOT NULL,
  `scheduleId` INT NOT NULL,
  PRIMARY KEY (`schedulesDetailsId`),
  INDEX `fk_appScheduleDetails_appSchedules1_idx` (`scheduleId` ASC) VISIBLE,
  CONSTRAINT `fk_appScheduleDetails_appSchedules1`
    FOREIGN KEY (`scheduleId`)
    REFERENCES `appassistant`.`appschedules` (`scheduleId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`apptapspantalla`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`apptapspantalla` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`apptapspantalla` (
  `appTapsPantallaid` INT NOT NULL AUTO_INCREMENT,
  `timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `coordenadaX` INT NOT NULL,
  `coordenadaY` INT NOT NULL,
  `duration` INT NULL DEFAULT NULL,
  `tipoEvento` ENUM('tap', 'long_press', 'swipe') NOT NULL,
  `transcripcionAIId` INT NOT NULL,
  PRIMARY KEY (`appTapsPantallaid`),
  INDEX `appTranscripcionIA1_idx` (`transcripcionAIId` ASC) VISIBLE,
  CONSTRAINT `appTranscripcionIA1`
    FOREIGN KEY (`transcripcionAIId`)
    REFERENCES `appassistant`.`apptranscripcionia` (`transcripcionAIId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`apptareasdata`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`apptareasdata` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`apptareasdata` (
  `tareasDataId` INT NOT NULL AUTO_INCREMENT,
  `taskName` VARCHAR(45) NOT NULL,
  `app` VARCHAR(45) NOT NULL,
  `description` VARCHAR(45) NOT NULL,
  `AnalysisIAId` INT NOT NULL,
  PRIMARY KEY (`tareasDataId`),
  INDEX `fk_appTareasData_appAnalysisIA1_idx` (`AnalysisIAId` ASC) VISIBLE,
  CONSTRAINT `fk_appTareasData_appAnalysisIA1`
    FOREIGN KEY (`AnalysisIAId`)
    REFERENCES `appassistant`.`appanalysisia` (`AnalysisIAId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`apptareaslimit`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`apptareaslimit` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`apptareaslimit` (
  `tareasLimitId` INT NOT NULL AUTO_INCREMENT,
  `limit` VARCHAR(120) NOT NULL,
  `planPerPersonId` INT NOT NULL,
  PRIMARY KEY (`tareasLimitId`),
  INDEX `fk_appTareasLimit_appPlanPerPerson1_idx` (`planPerPersonId` ASC) VISIBLE,
  CONSTRAINT `fk_appTareasLimit_appPlanPerPerson1`
    FOREIGN KEY (`planPerPersonId`)
    REFERENCES `appassistant`.`appplanperperson` (`planPerPersonId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`apptareas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`apptareas` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`apptareas` (
  `tareaId` INT NOT NULL AUTO_INCREMENT,
  `cratedDate` DATETIME NOT NULL,
  `deleted` BIT(1) NOT NULL,
  `webSiteURL` VARCHAR(200) NULL DEFAULT NULL,
  `appName` VARCHAR(50) NOT NULL,
  `description` VARCHAR(1000) NOT NULL,
  `lastUpdate` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `categoryId` INT NOT NULL,
  `tareasLimitId` INT NOT NULL,
  `appTareasData_tareasDataId` INT NOT NULL,
  PRIMARY KEY (`tareaId`),
  INDEX `fk_appTareas_appCategories1_idx` (`categoryId` ASC) VISIBLE,
  INDEX `fk_appTareas_appTareasLimit1_idx` (`tareasLimitId` ASC) VISIBLE,
  INDEX `fk_appTareas_appTareasData1_idx` (`appTareasData_tareasDataId` ASC) VISIBLE,
  CONSTRAINT `fk_appTareas_appCategories1`
    FOREIGN KEY (`categoryId`)
    REFERENCES `appassistant`.`appcategories` (`categoryId`),
  CONSTRAINT `fk_appTareas_appTareasData1`
    FOREIGN KEY (`appTareasData_tareasDataId`)
    REFERENCES `appassistant`.`apptareasdata` (`tareasDataId`),
  CONSTRAINT `fk_appTareas_appTareasLimit1`
    FOREIGN KEY (`tareasLimitId`)
    REFERENCES `appassistant`.`apptareaslimit` (`tareasLimitId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`apptransactionsubtype`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`apptransactionsubtype` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`apptransactionsubtype` (
  `transactionSubTypeId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`transactionSubTypeId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`apptransactiontype`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`apptransactiontype` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`apptransactiontype` (
  `transactionTypeId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`transactionTypeId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`apptransactions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`apptransactions` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`apptransactions` (
  `transactionID` BIGINT NOT NULL AUTO_INCREMENT,
  `amount` FLOAT NOT NULL,
  `description` VARCHAR(200) NOT NULL,
  `date` DATETIME NOT NULL,
  `postTime` TIME NOT NULL,
  `refNumber` VARCHAR(50) NOT NULL,
  `checksum` VARBINARY(64) NOT NULL,
  `convertedAmount` FLOAT NOT NULL,
  `appUsersid` INT NOT NULL,
  `appPagos_pagoId` BIGINT NOT NULL,
  `transactionTypeId` INT NOT NULL,
  `transactionSubTypeId` INT NOT NULL,
  `currencyExchangeRateId` INT NOT NULL,
  PRIMARY KEY (`transactionID`),
  INDEX `fk_appTransactions_appUsers1_idx` (`appUsersid` ASC) VISIBLE,
  INDEX `fk_appTransactions_appPagos1_idx` (`appPagos_pagoId` ASC) VISIBLE,
  INDEX `fk_appTransactions_appTransactionType1_idx` (`transactionTypeId` ASC) VISIBLE,
  INDEX `fk_appTransactions_appTransactionSubType1_idx` (`transactionSubTypeId` ASC) VISIBLE,
  INDEX `appcurrencyexchangerate1_idx` (`currencyExchangeRateId` ASC) VISIBLE,
  CONSTRAINT `fk_appTransactions_appPagos1`
    FOREIGN KEY (`appPagos_pagoId`)
    REFERENCES `appassistant`.`apppagos` (`pagoId`),
  CONSTRAINT `fk_appTransactions_appTransactionSubType1`
    FOREIGN KEY (`transactionSubTypeId`)
    REFERENCES `appassistant`.`apptransactionsubtype` (`transactionSubTypeId`),
  CONSTRAINT `fk_appTransactions_appTransactionType1`
    FOREIGN KEY (`transactionTypeId`)
    REFERENCES `appassistant`.`apptransactiontype` (`transactionTypeId`),
  CONSTRAINT `fk_appTransactions_appUsers1`
    FOREIGN KEY (`appUsersid`)
    REFERENCES `appassistant`.`appusers` (`appUsersid`),
  CONSTRAINT `appcurrencyexchangerate1`
    FOREIGN KEY (`currencyExchangeRateId`)
    REFERENCES `appassistant`.`appcurrencyexchangerate` (`currencyExchangeRateId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appuseradresses`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appuseradresses` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appuseradresses` (
  `userAdressId` INT NOT NULL AUTO_INCREMENT,
  `enable` BIT(1) NULL DEFAULT b'1',
  `appUsersid` INT NOT NULL,
  `appAddressesid` INT NOT NULL,
  PRIMARY KEY (`userAdressId`),
  INDEX `fk_appUserAdresses_appUsers1_idx` (`appUsersid` ASC) VISIBLE,
  INDEX `fk_appUserAdresses_appAddresses1_idx` (`appAddressesid` ASC) VISIBLE,
  CONSTRAINT `fk_appUserAdresses_appAddresses1`
    FOREIGN KEY (`appAddressesid`)
    REFERENCES `appassistant`.`appaddresses` (`appAddressesid`),
  CONSTRAINT `fk_appUserAdresses_appUsers1`
    FOREIGN KEY (`appUsersid`)
    REFERENCES `appassistant`.`appusers` (`appUsersid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appuserspermissions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appuserspermissions` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appuserspermissions` (
  `rolePermissionsID` INT NOT NULL AUTO_INCREMENT,
  `enabled` BIT(1) NOT NULL DEFAULT b'1',
  `deleted` BIT(1) NOT NULL DEFAULT b'0',
  `lastUpdate` DATETIME NOT NULL,
  `username` VARCHAR(50) NOT NULL,
  `checksum` VARBINARY(250) NOT NULL,
  `appUsersid` INT NOT NULL,
  `appPermissionsid` INT NOT NULL,
  PRIMARY KEY (`rolePermissionsID`),
  INDEX `appUsers2_idx` (`appUsersid` ASC) VISIBLE,
  INDEX `appPermissions2_idx` (`appPermissionsid` ASC) VISIBLE,
  CONSTRAINT `appPermissions2`
    FOREIGN KEY (`appPermissionsid`)
    REFERENCES `appassistant`.`apppermissions` (`appPermissionsid`),
  CONSTRAINT `appUsers2`
    FOREIGN KEY (`appUsersid`)
    REFERENCES `appassistant`.`appusers` (`appUsersid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appusersroles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appusersroles` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appusersroles` (
  `userRoleID` INT NOT NULL AUTO_INCREMENT,
  `lastUpdate` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `username` VARCHAR(50) NOT NULL,
  `checksum` VARCHAR(250) NOT NULL,
  `enabled` BIT(1) NOT NULL DEFAULT b'1',
  `deleted` BIT(1) NOT NULL,
  `appUsersid` INT NOT NULL,
  PRIMARY KEY (`userRoleID`),
  INDEX `appRoles1_idx` (`userRoleID` ASC) VISIBLE,
  INDEX `fk_appUsersRoles_appUsers1_idx` (`appUsersid` ASC) VISIBLE,
  CONSTRAINT `appRoles1`
    FOREIGN KEY (`userRoleID`)
    REFERENCES `appassistant`.`approles` (`roleID`),
  CONSTRAINT `fk_appUsersRoles_appUsers1`
    FOREIGN KEY (`appUsersid`)
    REFERENCES `appassistant`.`appusers` (`appUsersid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `appassistant`.`appvisionapirequest`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `appassistant`.`appvisionapirequest` ;

CREATE TABLE IF NOT EXISTS `appassistant`.`appvisionapirequest` (
  `visionAPIrequestId` INT NOT NULL AUTO_INCREMENT,
  `token` VARBINARY(256) NOT NULL,
  `analysisType` VARCHAR(50) NOT NULL,
  `features` JSON NOT NULL,
  `imageContext` JSON NOT NULL,
  `capturaPantallaId` INT NOT NULL,
  PRIMARY KEY (`visionAPIrequestId`),
  INDEX `fk_appVisionAPIrequest_appCapturaAPIRequest1_idx` (`capturaPantallaId` ASC) VISIBLE,
  CONSTRAINT `fk_appVisionAPIrequest_appCapturaAPIRequest1`
    FOREIGN KEY (`capturaPantallaId`)
    REFERENCES `appassistant`.`appcapturaapirequest` (`capturaPantallaId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
