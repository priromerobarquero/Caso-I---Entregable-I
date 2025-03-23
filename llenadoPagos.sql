DELIMITER $$

CREATE PROCEDURE FillPaymentsWithRandomData()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE transactionTypeCount INT;
    DECLARE transactionSubTypeCount INT;
    DECLARE currencyCount INT;
    DECLARE methodCount INT;
    DECLARE randomTransactionTypeId INT;
    DECLARE randomTransactionSubTypeId INT;
    DECLARE randomCurrencyId INT;
    DECLARE randomMetodoPagoId INT;
    DECLARE randomAppUserId INT;
    DECLARE randomAppModuleId INT;
    DECLARE randomAmount FLOAT;
    DECLARE randomFecha DATETIME;
    DECLARE randomExchangeRate FLOAT;

    -- Contamos cuántos tipos de transacciones, subtipos, monedas y métodos de pago existen
    SELECT COUNT(*) INTO transactionTypeCount FROM mydb.appTransactionType;
    SELECT COUNT(*) INTO transactionSubTypeCount FROM mydb.appTransactionSubType;
    SELECT COUNT(*) INTO currencyCount FROM mydb.appCurrencySymbol;
    SELECT COUNT(*) INTO methodCount FROM mydb.appMetodosPago;

    -- Llenar la tabla appTransactionType con datos aleatorios si no hay registros
    IF transactionTypeCount = 0 THEN
        INSERT INTO mydb.appTransactionType (name) VALUES ('Purchase'), ('Refund'), ('Transfer');
    END IF;

    -- Llenar la tabla appTransactionSubType con datos aleatorios si no hay registros
    IF transactionSubTypeCount = 0 THEN
        INSERT INTO mydb.appTransactionSubType (name) VALUES ('Online'), ('Offline'), ('Recurring');
    END IF;

    -- Llenar la tabla appCurrencyExchangeRate con datos aleatorios
    IF currencyCount > 0 THEN
        SET i = 0;
        WHILE i < 5 DO  -- Número de tasas de cambio a insertar, ajusta según sea necesario
            SET randomCurrencyId = FLOOR(1 + (RAND() * currencyCount));
            SET randomExchangeRate = ROUND(1 + (RAND() * 100), 2);
            SET randomFecha = NOW();
            INSERT INTO mydb.appCurrencyExchangeRate (
                startDate, endDate, exchangeRate, enabled, currencyId
            )
            VALUES (
                randomFecha,
                DATE_ADD(randomFecha, INTERVAL 1 MONTH),
                randomExchangeRate,
                1,
                randomCurrencyId
            );
            SET i = i + 1;
        END WHILE;
    END IF;

    -- Llenar las tablas de pagos y transacciones
    SET i = 0;
    WHILE i < 100 DO  -- Número de pagos y transacciones a insertar, ajusta según sea necesario
        -- Elegir valores aleatorios para los campos
        SET randomTransactionTypeId = FLOOR(1 + (RAND() * transactionTypeCount));
        SET randomTransactionSubTypeId = FLOOR(1 + (RAND() * transactionSubTypeCount));
        SET randomCurrencyId = FLOOR(1 + (RAND() * currencyCount));
        SET randomMetodoPagoId = FLOOR(1 + (RAND() * methodCount));
        SET randomAppUserId = FLOOR(1 + (RAND() * 100)); 
        SET randomAppModuleId = FLOOR(1 + (RAND() * 10));  
        SET randomAmount = ROUND(RAND() * 1000, 2);  
        SET randomFecha = NOW();

        INSERT INTO mydb.appPagos (
            monto, actualMonto, result, authnumber, reference, chargeToken,
            description, error, fecha, checksum, metodoPagoId, metodoId,
            appUsersid, appModulesid, currencyId
        )
        VALUES (
            randomAmount, randomAmount, 'Success', CONCAT('Auth-', i), CONCAT('Ref-', i),
            UNHEX(SHA2(CONCAT('ChargeToken-', i), 256)), 'Pago de prueba', 'None', randomFecha,
            UNHEX(SHA2(CONCAT('Checksum-', i), 256)), randomMetodoPagoId, randomMetodoPagoId,
            randomAppUserId, randomAppModuleId, randomCurrencyId
        );

        INSERT INTO mydb.appTransactions (
            amount, description, date, postTime, refNumber, checksum,
            convertedAmount, appUsersid, appPagos_pagoId, transactionTypeId, transactionSubTypeId
        )
        VALUES (
            randomAmount, CONCAT('Transacción para pago #', i), randomFecha,
            DATE_FORMAT(randomFecha, '%H:%i:%s'), CONCAT('TxnRef-', i),
            UNHEX(SHA2(CONCAT('TxnChecksum-', i), 256)), randomAmount * 1.05, randomAppUserId,
            LAST_INSERT_ID(), randomTransactionTypeId, randomTransactionSubTypeId
        );

        -- Incrementar el contador de registros
        SET i = i + 1;
    END WHILE;
END $$

DELIMITER ;
