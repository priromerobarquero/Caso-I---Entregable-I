-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`appEmpresas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appEmpresas` (
  `empresaId` INT NOT NULL AUTO_INCREMENT,
  `companyName` VARCHAR(50) NOT NULL,
  `signInDate` DATETIME NOT NULL,
  `enabled` BIT(1) NOT NULL DEFAULT 1,
  `deleted` BIT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`empresaId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appUsers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appUsers` (
  `appUsersid` INT NOT NULL,
  `firstName` VARCHAR(50) NOT NULL,
  `lastName` VARCHAR(50) NOT NULL,
  `password` VARBINARY(64) NOT NULL,
  `fechaNacimiento` DATE NOT NULL,
  `enabled` BIT(1) NOT NULL DEFAULT 1,
  `empresaId` INT NULL,
  PRIMARY KEY (`appUsersid`),
  INDEX `fk_appUsers_appEmpresas1_idx` (`empresaId` ASC) VISIBLE,
  CONSTRAINT `fk_appUsers_appEmpresas1`
    FOREIGN KEY (`empresaId`)
    REFERENCES `mydb`.`appEmpresas` (`empresaId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appRoles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appRoles` (
  `roleID` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `enabled` BIT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`roleID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appUsersRoles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appUsersRoles` (
  `lastUpdate` DATETIME NOT NULL DEFAULT now(),
  `username` VARCHAR(50) NOT NULL,
  `checksum` VARCHAR(250) NOT NULL,
  `enabled` BIT(1) NOT NULL DEFAULT 1,
  `deleted` BIT(1) NOT NULL,
  `roleID` INT NOT NULL,
  `appUsersid` INT NOT NULL,
  PRIMARY KEY (`roleID`),
  INDEX `appRoles1_idx` (`roleID` ASC) VISIBLE,
  INDEX `fk_appUsersRoles_appUsers1_idx` (`appUsersid` ASC) VISIBLE,
  CONSTRAINT `appRoles1`
    FOREIGN KEY (`roleID`)
    REFERENCES `mydb`.`appRoles` (`roleID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_appUsersRoles_appUsers1`
    FOREIGN KEY (`appUsersid`)
    REFERENCES `mydb`.`appUsers` (`appUsersid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appModules`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appModules` (
  `appModulesid` INT NOT NULL,
  `name` VARCHAR(40) NULL,
  PRIMARY KEY (`appModulesid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appPermissions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appPermissions` (
  `appPermissionsid` INT NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(60) NOT NULL,
  `code` VARCHAR(10) NOT NULL,
  `appModulesid` INT NOT NULL,
  PRIMARY KEY (`appPermissionsid`),
  INDEX `appModules1_idx` (`appModulesid` ASC) VISIBLE,
  CONSTRAINT `appModules1`
    FOREIGN KEY (`appModulesid`)
    REFERENCES `mydb`.`appModules` (`appModulesid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appRolesPermissions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appRolesPermissions` (
  `appRolesPermissionsid` INT NOT NULL AUTO_INCREMENT,
  `enabled` BIT(1) NOT NULL DEFAULT 1,
  `deleted` BIT(1) NOT NULL,
  `lastUpdate` DATETIME NOT NULL DEFAULT now(),
  `username` VARCHAR(50) NOT NULL,
  `checksum` VARBINARY(250) NOT NULL,
  `roleID` INT NOT NULL,
  `appPermissionsid` INT NOT NULL,
  PRIMARY KEY (`appRolesPermissionsid`),
  INDEX `appRoles2_idx` (`roleID` ASC) VISIBLE,
  INDEX `appPermissions1_idx` (`appPermissionsid` ASC) VISIBLE,
  CONSTRAINT `appRoles2`
    FOREIGN KEY (`roleID`)
    REFERENCES `mydb`.`appRoles` (`roleID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `appPermissions1`
    FOREIGN KEY (`appPermissionsid`)
    REFERENCES `mydb`.`appPermissions` (`appPermissionsid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appUsersPermissions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appUsersPermissions` (
  `rolePermissionsID` INT NOT NULL,
  `enabled` BIT(1) NOT NULL DEFAULT 1,
  `deleted` BIT(1) NOT NULL DEFAULT 0,
  `lastUpdate` DATETIME NOT NULL,
  `username` VARCHAR(50) NOT NULL,
  `checksum` VARBINARY(250) NOT NULL,
  `appUsersid` INT NOT NULL,
  `appPermissionsid` INT NOT NULL,
  PRIMARY KEY (`rolePermissionsID`),
  INDEX `appUsers2_idx` (`appUsersid` ASC) VISIBLE,
  INDEX `appPermissions2_idx` (`appPermissionsid` ASC) VISIBLE,
  CONSTRAINT `appUsers2`
    FOREIGN KEY (`appUsersid`)
    REFERENCES `mydb`.`appUsers` (`appUsersid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `appPermissions2`
    FOREIGN KEY (`appPermissionsid`)
    REFERENCES `mydb`.`appPermissions` (`appPermissionsid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appCountries`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appCountries` (
  `appCountriesid` INT NOT NULL,
  `name` VARCHAR(60) NOT NULL,
  `currency` VARCHAR(30) NOT NULL,
  `currencySymbol` VARCHAR(3) NOT NULL,
  `language` VARCHAR(7) NOT NULL,
  PRIMARY KEY (`appCountriesid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appStates`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appStates` (
  `appStatesID` INT NOT NULL,
  `name` VARCHAR(40) NULL,
  `appCountriesid` INT NOT NULL,
  PRIMARY KEY (`appStatesID`),
  INDEX `fk_appStates_appCountries1_idx` (`appCountriesid` ASC) VISIBLE,
  CONSTRAINT `fk_appStates_appCountries1`
    FOREIGN KEY (`appCountriesid`)
    REFERENCES `mydb`.`appCountries` (`appCountriesid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appCities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appCities` (
  `appCitiesid` INT NOT NULL,
  `name` VARCHAR(30) NULL,
  `appStatesID` INT NOT NULL,
  PRIMARY KEY (`appCitiesid`),
  INDEX `fk_appCities_appStates1_idx` (`appStatesID` ASC) VISIBLE,
  CONSTRAINT `fk_appCities_appStates1`
    FOREIGN KEY (`appStatesID`)
    REFERENCES `mydb`.`appStates` (`appStatesID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appAddresses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appAddresses` (
  `appAddressesid` INT NOT NULL,
  `line1` VARCHAR(200) NOT NULL,
  `line2` VARCHAR(200) NOT NULL,
  `zipcode` VARCHAR(9) NULL,
  `location` POINT NULL,
  `appCitiesid` INT NOT NULL,
  PRIMARY KEY (`appAddressesid`),
  INDEX `fk_appAddresses_appCities1_idx` (`appCitiesid` ASC) VISIBLE,
  CONSTRAINT `fk_appAddresses_appCities1`
    FOREIGN KEY (`appCitiesid`)
    REFERENCES `mydb`.`appCities` (`appCitiesid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appContactInfoType`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appContactInfoType` (
  `contactInfoTypeId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`contactInfoTypeId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appContactInfoUser`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appContactInfoUser` (
  `valueContact` VARCHAR(100) NOT NULL,
  `enable` BIT(1) NOT NULL DEFAULT 1,
  `lastupdate` DATETIME NULL DEFAULT now(),
  `appUsersid` INT NOT NULL,
  `contactInfoID` INT NOT NULL,
  PRIMARY KEY (`valueContact`),
  INDEX `fk_appContactInfo_appUsers1_idx` (`appUsersid` ASC) VISIBLE,
  INDEX `fk_appContactInfo_appContactInfoType1_idx` (`contactInfoID` ASC) VISIBLE,
  CONSTRAINT `fk_appContactInfo_appUsers1`
    FOREIGN KEY (`appUsersid`)
    REFERENCES `mydb`.`appUsers` (`appUsersid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_appContactInfo_appContactInfoType1`
    FOREIGN KEY (`contactInfoID`)
    REFERENCES `mydb`.`appContactInfoType` (`contactInfoTypeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appUserAdresses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appUserAdresses` (
  `userAdressId` INT NOT NULL AUTO_INCREMENT,
  `enable` BIT(1) NULL DEFAULT 1,
  `appUsersid` INT NOT NULL,
  `appAddressesid` INT NOT NULL,
  PRIMARY KEY (`userAdressId`),
  INDEX `fk_appUserAdresses_appUsers1_idx` (`appUsersid` ASC) VISIBLE,
  INDEX `fk_appUserAdresses_appAddresses1_idx` (`appAddressesid` ASC) VISIBLE,
  CONSTRAINT `fk_appUserAdresses_appUsers1`
    FOREIGN KEY (`appUsersid`)
    REFERENCES `mydb`.`appUsers` (`appUsersid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_appUserAdresses_appAddresses1`
    FOREIGN KEY (`appAddressesid`)
    REFERENCES `mydb`.`appAddresses` (`appAddressesid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appMetodosPago`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appMetodosPago` (
  `metodoId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `apiURL` VARCHAR(200) NOT NULL,
  `secretKey` VARBINARY(50) NOT NULL,
  `key` VARBINARY(50) NOT NULL,
  `enable` BIT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`metodoId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appMetodosDisponibles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appMetodosDisponibles` (
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
  CONSTRAINT `fk_appMetodosDisponibles_appUsers1`
    FOREIGN KEY (`appUsersid`)
    REFERENCES `mydb`.`appUsers` (`appUsersid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_appMetodosDisponibles_appMetodosPago1`
    FOREIGN KEY (`metodoId`)
    REFERENCES `mydb`.`appMetodosPago` (`metodoId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appCurrencySymbol`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appCurrencySymbol` (
  `currencyId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `acronym` VARCHAR(10) NOT NULL,
  `symbol` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`currencyId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appPagos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appPagos` (
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
  CONSTRAINT `fk_appPagos_appMetodosDisponibles1`
    FOREIGN KEY (`metodoPagoId`)
    REFERENCES `mydb`.`appMetodosDisponibles` (`metodoDisponibleId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_appPagos_appMetodosPago1`
    FOREIGN KEY (`metodoId`)
    REFERENCES `mydb`.`appMetodosPago` (`metodoId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_appPagos_appUsers1`
    FOREIGN KEY (`appUsersid`)
    REFERENCES `mydb`.`appUsers` (`appUsersid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_appPagos_appModules1`
    FOREIGN KEY (`appModulesid`)
    REFERENCES `mydb`.`appModules` (`appModulesid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_appPagos_appCurrencySymbol1`
    FOREIGN KEY (`currencyId`)
    REFERENCES `mydb`.`appCurrencySymbol` (`currencyId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appMediaTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appMediaTypes` (
  `mediaTypeID` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(90) NOT NULL,
  `playerImpl` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`mediaTypeID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appMediaFiles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appMediaFiles` (
  `mediaFileId` INT NOT NULL AUTO_INCREMENT,
  `documentURL` VARCHAR(200) NOT NULL,
  `lastUpdate` DATETIME NOT NULL DEFAULT now(),
  `deleted` BIT(1) NOT NULL DEFAULT 0,
  `mediaTypeID` INT NOT NULL,
  `appModulesid` INT NOT NULL,
  `metodoId` INT NOT NULL,
  PRIMARY KEY (`mediaFileId`),
  INDEX `fk_appMediaFiles_appMediaTypes1_idx` (`mediaTypeID` ASC) VISIBLE,
  INDEX `fk_appMediaFiles_appModules1_idx` (`appModulesid` ASC) VISIBLE,
  INDEX `fk_appMediaFiles_appMetodosPago1_idx` (`metodoId` ASC) VISIBLE,
  CONSTRAINT `fk_appMediaFiles_appMediaTypes1`
    FOREIGN KEY (`mediaTypeID`)
    REFERENCES `mydb`.`appMediaTypes` (`mediaTypeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_appMediaFiles_appModules1`
    FOREIGN KEY (`appModulesid`)
    REFERENCES `mydb`.`appModules` (`appModulesid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_appMediaFiles_appMetodosPago1`
    FOREIGN KEY (`metodoId`)
    REFERENCES `mydb`.`appMetodosPago` (`metodoId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appLogTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appLogTypes` (
  `appLogTypesid` INT NOT NULL AUTO_INCREMENT,
  `name` ENUM("login", "logout", "loginFailed", "changePass", "viewSales", "enablePerm", "cancelOrder", "other") NOT NULL,
  `ref1Desc` VARCHAR(45) NOT NULL,
  `ref2Desc` VARCHAR(45) NOT NULL,
  `val1Desc` VARCHAR(45) NOT NULL,
  `val2Desc` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`appLogTypesid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appLogSources`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appLogSources` (
  `appLogSourcesid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`appLogSourcesid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appLogSeverity`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appLogSeverity` (
  `appLogSeverityid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`appLogSeverityid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appLogs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appLogs` (
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
  CONSTRAINT `appLogTypes1`
    FOREIGN KEY (`appLogTypesid`)
    REFERENCES `mydb`.`appLogTypes` (`appLogTypesid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `appLogSources1`
    FOREIGN KEY (`appLogSourcesid`)
    REFERENCES `mydb`.`appLogSources` (`appLogSourcesid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `appLogSeverity1`
    FOREIGN KEY (`appLogSeverityid`)
    REFERENCES `mydb`.`appLogSeverity` (`appLogSeverityid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appLanguages`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appLanguages` (
  `appLanguagesid` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  `culture` VARCHAR(45) NULL,
  PRIMARY KEY (`appLanguagesid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appTranslations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appTranslations` (
  `appTranslationsid` INT NOT NULL,
  `code` VARCHAR(45) NULL,
  `caption` VARCHAR(45) NULL,
  `enabled` BIT(1) NULL,
  `appLanguagesid` INT NOT NULL,
  `appModulesid` INT NOT NULL,
  PRIMARY KEY (`appTranslationsid`),
  INDEX `fk_appTranslations_appLanguages1_idx` (`appLanguagesid` ASC) VISIBLE,
  INDEX `fk_appTranslations_appModules1_idx` (`appModulesid` ASC) VISIBLE,
  CONSTRAINT `fk_appTranslations_appLanguages1`
    FOREIGN KEY (`appLanguagesid`)
    REFERENCES `mydb`.`appLanguages` (`appLanguagesid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_appTranslations_appModules1`
    FOREIGN KEY (`appModulesid`)
    REFERENCES `mydb`.`appModules` (`appModulesid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appTransactionType`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appTransactionType` (
  `transactionTypeId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`transactionTypeId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appTransactionSubType`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appTransactionSubType` (
  `transactionSubTypeId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`transactionSubTypeId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appTransactions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appTransactions` (
  `transactionID` BIGINT NOT NULL AUTO_INCREMENT,
  `amount` FLOAT NOT NULL,
  `description` VARCHAR(200) NOT NULL,
  `date` DATETIME NOT NULL,
  `postTime` TIME NOT NULL,
  `refNumber` VARCHAR(50) NOT NULL,
  `checksum` VARBINARY(50) NOT NULL,
  `convertedAmount` FLOAT NOT NULL,
  `appUsersid` INT NOT NULL,
  `appPagos_pagoId` BIGINT NOT NULL,
  `transactionTypeId` INT NOT NULL,
  `transactionSubTypeId` INT NOT NULL,
  PRIMARY KEY (`transactionID`),
  INDEX `fk_appTransactions_appUsers1_idx` (`appUsersid` ASC) VISIBLE,
  INDEX `fk_appTransactions_appPagos1_idx` (`appPagos_pagoId` ASC) VISIBLE,
  INDEX `fk_appTransactions_appTransactionType1_idx` (`transactionTypeId` ASC) VISIBLE,
  INDEX `fk_appTransactions_appTransactionSubType1_idx` (`transactionSubTypeId` ASC) VISIBLE,
  CONSTRAINT `fk_appTransactions_appUsers1`
    FOREIGN KEY (`appUsersid`)
    REFERENCES `mydb`.`appUsers` (`appUsersid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_appTransactions_appPagos1`
    FOREIGN KEY (`appPagos_pagoId`)
    REFERENCES `mydb`.`appPagos` (`pagoId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_appTransactions_appTransactionType1`
    FOREIGN KEY (`transactionTypeId`)
    REFERENCES `mydb`.`appTransactionType` (`transactionTypeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_appTransactions_appTransactionSubType1`
    FOREIGN KEY (`transactionSubTypeId`)
    REFERENCES `mydb`.`appTransactionSubType` (`transactionSubTypeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appCurrencyExchangeRate`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appCurrencyExchangeRate` (
  `currencyExchangeRateId` INT NOT NULL AUTO_INCREMENT,
  `startDate` DATETIME NOT NULL,
  `endDate` DATETIME NOT NULL,
  `exchangeRate` FLOAT NOT NULL,
  `enabled` BIT NOT NULL DEFAULT 0,
  `currencyId` INT NOT NULL,
  PRIMARY KEY (`currencyExchangeRateId`),
  INDEX `fk_appCurrencyExchangeRate_appCurrencySymbol1_idx` (`currencyId` ASC) VISIBLE,
  CONSTRAINT `fk_appCurrencyExchangeRate_appCurrencySymbol1`
    FOREIGN KEY (`currencyId`)
    REFERENCES `mydb`.`appCurrencySymbol` (`currencyId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appSchedules`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appSchedules` (
  `scheduleId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NULL,
  `recurrentType` VARCHAR(20) NULL,
  `repetition` INT NOT NULL,
  `endType` VARCHAR(30) NOT NULL,
  `endDate` DATETIME NULL,
  PRIMARY KEY (`scheduleId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appScheduleDetails`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appScheduleDetails` (
  `schedulesDetailsId` INT NOT NULL AUTO_INCREMENT,
  `deleted` BIT NOT NULL DEFAULT 0,
  `baseDate` DATETIME NOT NULL,
  `datepart` INT NOT NULL,
  `lastexecution` DATETIME NOT NULL,
  `nextExecution` DATETIME NOT NULL,
  `scheduleId` INT NOT NULL,
  PRIMARY KEY (`schedulesDetailsId`),
  INDEX `fk_appScheduleDetails_appSchedules1_idx` (`scheduleId` ASC) VISIBLE,
  CONSTRAINT `fk_appScheduleDetails_appSchedules1`
    FOREIGN KEY (`scheduleId`)
    REFERENCES `mydb`.`appSchedules` (`scheduleId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appSubscriptions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appSubscriptions` (
  `subscriptionId` INT NOT NULL,
  `estado` ENUM('active', 'inactive', 'cancelled', 'suspended') NOT NULL,
  `precio` FLOAT(10,2) NOT NULL,
  `cicloBilling` ENUM('monthly', 'annual', 'one-time') NOT NULL,
  `fechaInicio` DATETIME NOT NULL,
  `fechaFin` DATETIME NULL,
  `proximoBilling` DATETIME NULL,
  `metodoId` INT NOT NULL,
  PRIMARY KEY (`subscriptionId`),
  INDEX `appMetodosPago1_idx` (`metodoId` ASC) VISIBLE,
  CONSTRAINT `appMetodosPago1`
    FOREIGN KEY (`metodoId`)
    REFERENCES `mydb`.`appMetodosPago` (`metodoId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appPlanPrices`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appPlanPrices` (
  `planPriceId` INT NOT NULL AUTO_INCREMENT,
  `amount` FLOAT NOT NULL,
  `postTime` DATETIME NOT NULL,
  `enable` BIT NOT NULL DEFAULT 0,
  `endDate` DATETIME NOT NULL,
  `subscriptionId` INT NOT NULL,
  `scheduleId` INT NOT NULL,
  `currencyId` INT NOT NULL,
  PRIMARY KEY (`planPriceId`),
  INDEX `fk_appPlanPrices_appSubscriptions1_idx` (`subscriptionId` ASC) VISIBLE,
  INDEX `fk_appPlanPrices_appSchedules1_idx` (`scheduleId` ASC) VISIBLE,
  INDEX `fk_appPlanPrices_appCurrencySymbol1_idx` (`currencyId` ASC) VISIBLE,
  CONSTRAINT `fk_appPlanPrices_appSubscriptions1`
    FOREIGN KEY (`subscriptionId`)
    REFERENCES `mydb`.`appSubscriptions` (`subscriptionId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_appPlanPrices_appSchedules1`
    FOREIGN KEY (`scheduleId`)
    REFERENCES `mydb`.`appSchedules` (`scheduleId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_appPlanPrices_appCurrencySymbol1`
    FOREIGN KEY (`currencyId`)
    REFERENCES `mydb`.`appCurrencySymbol` (`currencyId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appPlanFeatures`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appPlanFeatures` (
  `planFeaturesId` INT NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(200) NOT NULL,
  `enabled` BIT NOT NULL DEFAULT 0,
  `datatype` VARCHAR(30) NULL,
  PRIMARY KEY (`planFeaturesId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appFeaturePerPlan`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appFeaturePerPlan` (
  `featurePerPlanId` INT NOT NULL AUTO_INCREMENT,
  `value` VARCHAR(50) NOT NULL,
  `enabled` BIT NOT NULL DEFAULT 0,
  `subscriptionId` INT NOT NULL,
  `planFeaturesId` INT NOT NULL,
  PRIMARY KEY (`featurePerPlanId`),
  INDEX `fk_appFeaturePerPlan_appSubscriptions1_idx` (`subscriptionId` ASC) VISIBLE,
  INDEX `fk_appFeaturePerPlan_appPlanFeatures1_idx` (`planFeaturesId` ASC) VISIBLE,
  CONSTRAINT `fk_appFeaturePerPlan_appSubscriptions1`
    FOREIGN KEY (`subscriptionId`)
    REFERENCES `mydb`.`appSubscriptions` (`subscriptionId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_appFeaturePerPlan_appPlanFeatures1`
    FOREIGN KEY (`planFeaturesId`)
    REFERENCES `mydb`.`appPlanFeatures` (`planFeaturesId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appPlanPerPerson`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appPlanPerPerson` (
  `planPerPersonId` INT NOT NULL AUTO_INCREMENT,
  `addDate` DATETIME NOT NULL DEFAULT now(),
  `enabled` BIT NOT NULL DEFAULT 1,
  `appUsersid` INT NOT NULL,
  `scheduleId` INT NOT NULL,
  `planPriceId` INT NOT NULL,
  PRIMARY KEY (`planPerPersonId`),
  INDEX `fk_appPlanPerPerson_appUsers1_idx` (`appUsersid` ASC) VISIBLE,
  INDEX `fk_appPlanPerPerson_appSchedules1_idx` (`scheduleId` ASC) VISIBLE,
  INDEX `fk_appPlanPerPerson_appPlanPrices1_idx` (`planPriceId` ASC) VISIBLE,
  CONSTRAINT `fk_appPlanPerPerson_appUsers1`
    FOREIGN KEY (`appUsersid`)
    REFERENCES `mydb`.`appUsers` (`appUsersid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_appPlanPerPerson_appSchedules1`
    FOREIGN KEY (`scheduleId`)
    REFERENCES `mydb`.`appSchedules` (`scheduleId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_appPlanPerPerson_appPlanPrices1`
    FOREIGN KEY (`planPriceId`)
    REFERENCES `mydb`.`appPlanPrices` (`planPriceId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appPersonPlanLimits`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appPersonPlanLimits` (
  `planId` INT NOT NULL AUTO_INCREMENT,
  `limit` VARCHAR(120) NOT NULL,
  `planFeaturesId` INT NOT NULL,
  `planPerPersonId` INT NOT NULL,
  PRIMARY KEY (`planId`),
  INDEX `fk_appPersonPlanLimits_appPlanFeatures1_idx` (`planFeaturesId` ASC) VISIBLE,
  INDEX `fk_appPersonPlanLimits_appPlanPerPerson1_idx` (`planPerPersonId` ASC) VISIBLE,
  CONSTRAINT `fk_appPersonPlanLimits_appPlanFeatures1`
    FOREIGN KEY (`planFeaturesId`)
    REFERENCES `mydb`.`appPlanFeatures` (`planFeaturesId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_appPersonPlanLimits_appPlanPerPerson1`
    FOREIGN KEY (`planPerPersonId`)
    REFERENCES `mydb`.`appPlanPerPerson` (`planPerPersonId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appTareasLimit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appTareasLimit` (
  `tareasLimitId` INT NOT NULL AUTO_INCREMENT,
  `limit` VARCHAR(120) NOT NULL,
  `planPerPersonId` INT NOT NULL,
  PRIMARY KEY (`tareasLimitId`),
  INDEX `fk_appTareasLimit_appPlanPerPerson1_idx` (`planPerPersonId` ASC) VISIBLE,
  CONSTRAINT `fk_appTareasLimit_appPlanPerPerson1`
    FOREIGN KEY (`planPerPersonId`)
    REFERENCES `mydb`.`appPlanPerPerson` (`planPerPersonId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appContactInfoEmpresas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appContactInfoEmpresas` (
  `contactInfoId` INT NOT NULL AUTO_INCREMENT,
  `valorContacto` VARCHAR(255) NOT NULL,
  `enable` BIT(1) NOT NULL DEFAULT 1,
  `lastUpdate` DATETIME NOT NULL DEFAULT now(),
  `empresaId` INT NOT NULL,
  `contactInfoTypeId` INT NOT NULL,
  PRIMARY KEY (`contactInfoId`),
  INDEX `fk_appContactInfoEmpresas_appEmpresas1_idx` (`empresaId` ASC) VISIBLE,
  INDEX `fk_appContactInfoEmpresas_appContactInfoType1_idx` (`contactInfoTypeId` ASC) VISIBLE,
  CONSTRAINT `fk_appContactInfoEmpresas_appEmpresas1`
    FOREIGN KEY (`empresaId`)
    REFERENCES `mydb`.`appEmpresas` (`empresaId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_appContactInfoEmpresas_appContactInfoType1`
    FOREIGN KEY (`contactInfoTypeId`)
    REFERENCES `mydb`.`appContactInfoType` (`contactInfoTypeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appMediaFilesUsers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appMediaFilesUsers` (
  `mediaFileId` INT NOT NULL,
  `appUsersid` INT NOT NULL,
  `deleted` BIT(1) NOT NULL DEFAULT 0,
  INDEX `appMediaFiles1_idx` (`mediaFileId` ASC) VISIBLE,
  INDEX `appUsers3_idx` (`appUsersid` ASC) VISIBLE,
  CONSTRAINT `appMediaFiles1`
    FOREIGN KEY (`mediaFileId`)
    REFERENCES `mydb`.`appMediaFiles` (`mediaFileId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `appUsers3`
    FOREIGN KEY (`appUsersid`)
    REFERENCES `mydb`.`appUsers` (`appUsersid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appMediaFilesSubscriptions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appMediaFilesSubscriptions` (
  `mediaFileId` INT NOT NULL,
  `subscriptionId` INT NOT NULL,
  `deleted` BIT(1) NOT NULL DEFAULT 0,
  INDEX `appMediaFiles2_idx` (`mediaFileId` ASC) VISIBLE,
  INDEX `appSubscriptions1_idx` (`subscriptionId` ASC) VISIBLE,
  CONSTRAINT `appMediaFiles2`
    FOREIGN KEY (`mediaFileId`)
    REFERENCES `mydb`.`appMediaFiles` (`mediaFileId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `appSubscriptions1`
    FOREIGN KEY (`subscriptionId`)
    REFERENCES `mydb`.`appSubscriptions` (`subscriptionId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appMediaFilesCompanies`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appMediaFilesCompanies` (
  `mediaFileId` INT NOT NULL,
  `empresaId` INT NOT NULL,
  `deleted` BIT(1) NOT NULL DEFAULT 1,
  INDEX `appMediaFiles3_idx` (`mediaFileId` ASC) VISIBLE,
  INDEX `appEmpresas1_idx` (`empresaId` ASC) VISIBLE,
  CONSTRAINT `appMediaFiles3`
    FOREIGN KEY (`mediaFileId`)
    REFERENCES `mydb`.`appMediaFiles` (`mediaFileId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `appEmpresas1`
    FOREIGN KEY (`empresaId`)
    REFERENCES `mydb`.`appEmpresas` (`empresaId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appIAmodels`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appIAmodels` (
  `modelIAId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `enable` BIT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`modelIAId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appAudioAtranscripcionAPI`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appAudioAtranscripcionAPI` (
  `audioAtranscripcionId` INT NOT NULL AUTO_INCREMENT,
  `token` VARBINARY(256) NOT NULL,
  `apiKey` VARCHAR(256) NOT NULL,
  `include` VARCHAR(50) NULL,
  `stream` BIT(1) NULL DEFAULT 1,
  `responseFormat` JSON NOT NULL,
  `mediaFileId` INT NOT NULL,
  `appTranslationsid` INT NOT NULL,
  `modelIAId` INT NOT NULL,
  PRIMARY KEY (`audioAtranscripcionId`),
  INDEX `fk_appAudioAtranscripcionAPI_appMediaFiles1_idx` (`mediaFileId` ASC) VISIBLE,
  INDEX `fk_appAudioAtranscripcionAPI_appTranslations1_idx` (`appTranslationsid` ASC) VISIBLE,
  INDEX `fk_appAudioAtranscripcionAPI_appIAmodels1_idx` (`modelIAId` ASC) VISIBLE,
  CONSTRAINT `fk_appAudioAtranscripcionAPI_appMediaFiles1`
    FOREIGN KEY (`mediaFileId`)
    REFERENCES `mydb`.`appMediaFiles` (`mediaFileId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_appAudioAtranscripcionAPI_appTranslations1`
    FOREIGN KEY (`appTranslationsid`)
    REFERENCES `mydb`.`appTranslations` (`appTranslationsid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_appAudioAtranscripcionAPI_appIAmodels1`
    FOREIGN KEY (`modelIAId`)
    REFERENCES `mydb`.`appIAmodels` (`modelIAId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appIAroles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appIAroles` (
  `rolesIAId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `description` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`rolesIAId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appModalities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appModalities` (
  `modalityId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `enabled` BIT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`modalityId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appChatStatus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appChatStatus` (
  `chatStatusId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`chatStatusId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appChatAPI`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appChatAPI` (
  `chatAPIId` INT NOT NULL AUTO_INCREMENT,
  `token` VARBINARY(256) NOT NULL,
  `returnedObject` JSON NOT NULL,
  `apiKey` VARCHAR(256) NOT NULL,
  `responseFormat` VARCHAR(50) NOT NULL,
  `finished` BIT(1) NOT NULL,
  `maxTokens` INT NOT NULL,
  `context` VARCHAR(100) NULL,
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
    REFERENCES `mydb`.`appChatStatus` (`chatStatusId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_appChatAPI_appModalities1`
    FOREIGN KEY (`modalityId`)
    REFERENCES `mydb`.`appModalities` (`modalityId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_appChatAPI_appIAmodels1`
    FOREIGN KEY (`modelIAId`)
    REFERENCES `mydb`.`appIAmodels` (`modelIAId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_appChatAPI_appIAroles1`
    FOREIGN KEY (`rolesIAId`)
    REFERENCES `mydb`.`appIAroles` (`rolesIAId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appNotificationStatus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appNotificationStatus` (
  `notificationStatusId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `enabled` BIT(1) NOT NULL,
  PRIMARY KEY (`notificationStatusId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appHelpNotification`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appHelpNotification` (
  `helpNotificationId` INT NOT NULL AUTO_INCREMENT,
  `creationDate` DATETIME NOT NULL,
  `tittle` VARCHAR(30) NOT NULL,
  `message` VARCHAR(100) NOT NULL,
  `notificationStatusId` INT NOT NULL,
  PRIMARY KEY (`helpNotificationId`),
  INDEX `fk_appHelpNotification_appNotificationStatus1_idx` (`notificationStatusId` ASC) VISIBLE,
  CONSTRAINT `fk_appHelpNotification_appNotificationStatus1`
    FOREIGN KEY (`notificationStatusId`)
    REFERENCES `mydb`.`appNotificationStatus` (`notificationStatusId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appAnalysisIA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appAnalysisIA` (
  `AnalysisIAId` INT NOT NULL AUTO_INCREMENT,
  `output` VARCHAR(1000) NOT NULL,
  `creationDate` DATETIME NOT NULL,
  `chatAPIId` INT NOT NULL,
  `helpNotificationId` INT NOT NULL,
  PRIMARY KEY (`AnalysisIAId`),
  INDEX `fk_appAnalysisIA_appChatAPI1_idx` (`chatAPIId` ASC) VISIBLE,
  INDEX `appHelpNotification1_idx` (`helpNotificationId` ASC) VISIBLE,
  CONSTRAINT `fk_appAnalysisIA_appChatAPI1`
    FOREIGN KEY (`chatAPIId`)
    REFERENCES `mydb`.`appChatAPI` (`chatAPIId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `appHelpNotification1`
    FOREIGN KEY (`helpNotificationId`)
    REFERENCES `mydb`.`appHelpNotification` (`helpNotificationId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appTranscripcionIA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appTranscripcionIA` (
  `transcripcionAIId` INT NOT NULL AUTO_INCREMENT,
  `enabled` BIT(1) NOT NULL DEFAULT 1,
  `deleted` BIT(1) NOT NULL DEFAULT 0,
  `creationDate` DATETIME NOT NULL DEFAULT now(),
  `data` JSON NOT NULL,
  `tamaño` FLOAT NOT NULL,
  `finished` BIT(1) NOT NULL DEFAULT 0,
  `mediaFileId` INT NOT NULL,
  `chatAnalysisId` INT NOT NULL,
  PRIMARY KEY (`transcripcionAIId`),
  INDEX `fk_appTranscripcionIA_appMediaFiles1_idx` (`mediaFileId` ASC) VISIBLE,
  INDEX `fk_appTranscripcionIA_appIAFoundData1_idx` (`chatAnalysisId` ASC) VISIBLE,
  CONSTRAINT `fk_appTranscripcionIA_appMediaFiles1`
    FOREIGN KEY (`mediaFileId`)
    REFERENCES `mydb`.`appMediaFiles` (`mediaFileId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_appTranscripcionIA_appIAFoundData1`
    FOREIGN KEY (`chatAnalysisId`)
    REFERENCES `mydb`.`appAnalysisIA` (`AnalysisIAId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appCapturaAPIRequest`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appCapturaAPIRequest` (
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
    REFERENCES `mydb`.`appUsers` (`appUsersid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appMediaFileCapture`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appMediaFileCapture` (
  `capturaPantallaId` INT NOT NULL,
  `mediaFileId` INT NOT NULL,
  INDEX `fk_appMediaFileCapture_appCapturaPantallaAPI1_idx` (`capturaPantallaId` ASC) VISIBLE,
  INDEX `fk_appMediaFileCapture_appMediaFiles1_idx` (`mediaFileId` ASC) VISIBLE,
  CONSTRAINT `fk_appMediaFileCapture_appCapturaPantallaAPI1`
    FOREIGN KEY (`capturaPantallaId`)
    REFERENCES `mydb`.`appCapturaAPIRequest` (`capturaPantallaId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_appMediaFileCapture_appMediaFiles1`
    FOREIGN KEY (`mediaFileId`)
    REFERENCES `mydb`.`appMediaFiles` (`mediaFileId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appVisionAPIrequest`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appVisionAPIrequest` (
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
    REFERENCES `mydb`.`appCapturaAPIRequest` (`capturaPantallaId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appCategories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appCategories` (
  `categoryId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `description` VARCHAR(500) NOT NULL,
  `deleted` BIT(1) NOT NULL DEFAULT 0,
  `creationDate` DATETIME NOT NULL,
  PRIMARY KEY (`categoryId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appTareasData`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appTareasData` (
  `tareasDataId` INT NOT NULL AUTO_INCREMENT,
  `taskName` VARCHAR(45) NOT NULL,
  `app` VARCHAR(45) NOT NULL,
  `description` VARCHAR(45) NOT NULL,
  `AnalysisIAId` INT NOT NULL,
  PRIMARY KEY (`tareasDataId`),
  INDEX `fk_appTareasData_appAnalysisIA1_idx` (`AnalysisIAId` ASC) VISIBLE,
  CONSTRAINT `fk_appTareasData_appAnalysisIA1`
    FOREIGN KEY (`AnalysisIAId`)
    REFERENCES `mydb`.`appAnalysisIA` (`AnalysisIAId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appTareas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appTareas` (
  `tareaId` INT NOT NULL AUTO_INCREMENT,
  `cratedDate` DATETIME NOT NULL,
  `deleted` BIT(1) NOT NULL,
  `webSiteURL` VARCHAR(200) NULL,
  `appName` VARCHAR(50) NOT NULL,
  `description` VARCHAR(1000) NOT NULL,
  `lastUpdate` DATETIME NOT NULL DEFAULT now(),
  `categoryId` INT NOT NULL,
  `tareasLimitId` INT NOT NULL,
  `appTareasData_tareasDataId` INT NOT NULL,
  PRIMARY KEY (`tareaId`),
  INDEX `fk_appTareas_appCategories1_idx` (`categoryId` ASC) VISIBLE,
  INDEX `fk_appTareas_appTareasLimit1_idx` (`tareasLimitId` ASC) VISIBLE,
  INDEX `fk_appTareas_appTareasData1_idx` (`appTareasData_tareasDataId` ASC) VISIBLE,
  CONSTRAINT `fk_appTareas_appCategories1`
    FOREIGN KEY (`categoryId`)
    REFERENCES `mydb`.`appCategories` (`categoryId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_appTareas_appTareasLimit1`
    FOREIGN KEY (`tareasLimitId`)
    REFERENCES `mydb`.`appTareasLimit` (`tareasLimitId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_appTareas_appTareasData1`
    FOREIGN KEY (`appTareasData_tareasDataId`)
    REFERENCES `mydb`.`appTareasData` (`tareasDataId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appEventTypesIA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appEventTypesIA` (
  `eventTypeId` INT NOT NULL AUTO_INCREMENT,
  `typeName` VARCHAR(60) NOT NULL,
  `creationDate` DATETIME NOT NULL,
  `description` VARCHAR(50) NULL,
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
    REFERENCES `mydb`.`appChatAPI` (`chatAPIId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_appEventTypesIA_appTranscripcionIA1`
    FOREIGN KEY (`transcripcionAIId`)
    REFERENCES `mydb`.`appTranscripcionIA` (`transcripcionAIId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`appTapsPantalla`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`appTapsPantalla` (
  `appTapsPantallaid` INT NOT NULL,
  `timestamp` DATETIME NOT NULL DEFAULT now(),
  `coordenadaX` INT NOT NULL,
  `coordenadaY` INT NOT NULL,
  `duration` INT NULL,
  `tipoEvento` ENUM('tap', 'long_press', 'swipe') NOT NULL,
  `transcripcionAIId` INT NOT NULL,
  PRIMARY KEY (`appTapsPantallaid`),
  INDEX `appTranscripcionIA1_idx` (`transcripcionAIId` ASC) VISIBLE,
  CONSTRAINT `appTranscripcionIA1`
    FOREIGN KEY (`transcripcionAIId`)
    REFERENCES `mydb`.`appTranscripcionIA` (`transcripcionAIId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
