DELIMITER $$

CREATE PROCEDURE FillLogsWithRandomData()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE logTypesCount INT;
    DECLARE logSourcesCount INT;
    DECLARE logSeverityCount INT;
    DECLARE randomLogTypeId INT;
    DECLARE randomLogSourceId INT;
    DECLARE randomLogSeverityId INT;
    DECLARE randomReferenceId1 BIGINT;
    DECLARE randomReferenceId2 BIGINT;

    SELECT COUNT(*) INTO logTypesCount FROM mydb.appLogTypes;
    SELECT COUNT(*) INTO logSourcesCount FROM mydb.appLogSources;
    SELECT COUNT(*) INTO logSeverityCount FROM mydb.appLogSeverity;

    WHILE i < 100 DO  
        SET randomLogTypeId = FLOOR(1 + (RAND() * logTypesCount));
        SET randomLogSourceId = FLOOR(1 + (RAND() * logSourcesCount));
        SET randomLogSeverityId = FLOOR(1 + (RAND() * logSeverityCount));

        SET randomReferenceId1 = FLOOR(100000 + (RAND() * 999999));
        SET randomReferenceId2 = FLOOR(100000 + (RAND() * 999999));

        INSERT INTO mydb.appLogs (
            description,
            postTime,
            computer,
            username,
            trace,
            appLogscol,
            referenceID1,
            referneceID2,
            value1,
            value2,
            checksum,
            appLogTypesid,
            appLogSourcesid,
            appLogSeverityid
        )
        VALUES (
            CONCAT('Descripción del log #', i),
            DATE_FORMAT(NOW(), '%H:%i:%s'),
            CONCAT('Computer-', FLOOR(1 + (RAND() * 100))),
            CONCAT('User-', FLOOR(1 + (RAND() * 1000))),
            CONCAT('Trace-', FLOOR(1 + (RAND() * 10000))),
            CONCAT('LogCol-', FLOOR(1 + (RAND() * 10))),
            randomReferenceId1,
            randomReferenceId2,
            CONCAT('Valor1-', FLOOR(1 + (RAND() * 100))),
            CONCAT('Valor2-', FLOOR(1 + (RAND() * 100))),
            UNHEX(SHA2(CONCAT('Checksum-', i), 256)),
            randomLogTypeId,
            randomLogSourceId,
            randomLogSeverityId
        );

        SET i = i + 1;
    END WHILE;
END $$

DELIMITER ;
