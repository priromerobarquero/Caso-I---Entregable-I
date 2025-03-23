use appAsistant;

-- --------------- Tablas relacionadas a Pagos ---------------------

INSERT INTO appAsistant.appTransactionSubType
VALUES
(1, 'Suscripcion'),
(2, 'CashBack'),
(3, 'Pago Denegado'),
(4, 'Pago Aceptado');

INSERT INTO appAsistant.appTransactionType
VALUES
(1, 'Credit'),
(2, 'Debit'),
(3, 'Cancelation'),
(4, 'Refund'),
(5, 'Manual Adjustment');

-- Llenado de transacciones
DROP PROCEDURE LlenarTransacciones;
DELIMITER // 
CREATE PROCEDURE LlenarTransacciones()
BEGIN
	SET @countUsers = 0;

	WHILE @countUsers <= 40 DO
		
        SET @i = 0;
			SET @appUsersid = 1;
            SELECT appUsersid INTO @appUsersid FROM appUsers WHERE appUsersid = @countUsers;
            
            WHILE @i <= 10 DO
		
				SET @amount = FLOOR(50 + (RAND() * (500 - 50 + 1)));  -- Agregamos amount
				SET @dia = DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 730) DAY); -- Agregamos fechas
				SET @hora = DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 60) MINUTE); -- Agregamos Tiempo de transaccion
				-- Agregamos refNumber
				SET @refNumber = CONCAT(
					FLOOR(0 + RAND() * 8), 
					FLOOR(0 + RAND() * 8),  
					FLOOR(0 + RAND() * 8));
				-- Agregamos cedula
				SET @checksSum = SHA2(CONCAT(@dia, @hora, @refNumber,'EsTauk', @amount), 512);
				
				SET @currency = FLOOR(1 + RAND() * 10);
				SET @tranSub = FLOOR(1 + RAND() * 4);
				SET @tranType = FLOOR(1 + RAND() * 5);
				
                -- ID autoincrementado
				INSERT INTO appTransactions(amount, `description`, `date`, postTime, refNumber, `checksum`, appUsersid, transactionTypeId, transactionSubTypeId, currencyId, currencyExchangeRateId)
				VALUES
				(@amount, 'Descripcion', @dia, @hora, @refNumber, @checksSum, @appUsersid, @tranType, @tranSub, @currency, 3);
                
                SET @i = @i + 1;
			END WHILE;
		SET @countUsers = @countUsers + 1;
        
        END WHILE;
END //

DELIMITER ;

Call LlenarTransacciones();