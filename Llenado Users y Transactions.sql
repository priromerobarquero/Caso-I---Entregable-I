use appAsistant;

-- LLENADO DE BASE DE DATOS 
-- Priscilla Romero Barquero | 2023332718  
-- Elias Ramirez Hernandez | 2024090300

-- ----------------- Tablas relacionadas a monedas -------------------------

INSERT INTO appAsistant.appCurrencySymbol
VALUES
(1, 'Dollar', 'US','$'),
(2, 'Euro', 'EU', '€'),
(3, 'Colón Costarricense', 'CR', '₡'),
(4, 'Pound Sterling', 'UK', '£'),
(5, 'Yen', 'JP', '¥'),
(6, 'Canadian Dollar', 'CA', 'C$'),
(7, 'Swiss Franc', 'CH', 'CHF'),
(8, 'Mexican Peso', 'MX', '$'),
(9, 'Argentine Peso', 'AR', '$'),
(10, 'Brazilian Real', 'BR', 'R$');

ALTER TABLE appAsistant.appCurrencyExchangeRate 
MODIFY COLUMN endDate DATETIME NULL;

INSERT INTO appAsistant.appCurrencyExchangeRate
VALUES
(1, '2024-02-03 10:07:06', '2024-05-10 21:15:06', 541.39, FALSE, 3),
(2, '2024-04-04 09:30:00', NULL, 1.08, TRUE, 2),  
(3, '2024-05-12 14:15:30', '2024-05-13 14:15:30', 620 , FALSE, 3),  
(4, '2024-06-02 08:00:00', '2024-05-09 18:00:00', 6.98, FALSE, 6),  
(5, '2024-05-14 12:00:00', NULL, 524.50, TRUE, 3),
(6, '2024-06-03 07:45:00', NULL, 8.32, TRUE, 6), 
(7, '2024-04-04 11:10:00', '2024-05-11 23:59:00', 5.23, FALSE, 10);




-- --------------- Tablas relacionadas a informacion de contacto ------------------------

INSERT INTO appAsistant.appContactInfoType
VALUES
(1, 'Phone Number'),
(2, 'Email'),
(3, 'Telegram');


-- --------------- Tablas relacionadas al ususario ------------------------

ALTER TABLE appUsers
ADD COLUMN contact VARCHAR(80) NOT NULL;


DROP PROCEDURE LlenarUsers;

DELIMITER //

CREATE PROCEDURE LlenarUsers()
BEGIN
	SET @countUsers = 40;

	WHILE @countUsers > 0 DO
		
        -- agrego el ID
		SET @appUserid = @countUsers;

		-- Agregamos nombre y apellido
        SET @firstName = "";
        SET @lastName = "";
        
        SET @firstName = ELT(FLOOR(1 + RAND() * 20), 'Alejandro', 'Mariana', 'Carlos', 'Fernanda', 'Javier', 
			'Lucía', 'Daniel', 'Gabriela', 'Ricardo', 'Andrea', 'Sergio', 'Valeria', 'Hugo', 'Patricia', 'Diego', 
			'Isabela', 'Fernando', 'Natalia', 'Manuel', 'Camila');
            
        SET @lastName = ELT(FLOOR(1 + RAND() * 40), 'Gómez', 'López', 'Ramírez', 'Torres', 'Mendoza', 'Fernández', 'Rojas', 'Muñoz', 'Salazar', 'Castillo', 
			'Pineda', 'Ortega', 'Sánchez', 'Navarro', 'Vargas', 'Reyes', 'Herrera', 'Cruz', 'Duarte', 'Estrada', 'Pérez',
			'Gutiérrez', 'Morales', 'Suárez', 'Delgado', 'Silva', 'Romero', 'Álvarez', 'Jiménez', 'Molina', 
			'Rivas', 'Peña', 'Acosta', 'Blanco', 'Cárdenas', 'Domínguez', 'Fuentes', 'Guerrero', 'Ibarra', 'Lara');
            
		-- Agregamos email
        SET @contact = CONCAT(@firstName, "_", "@gmail.com");
        
        -- Agregamos fecha de nacimiento 
        SET @fechaNacimiento = DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 10950) DAY);
        
        INSERT INTO AppUsers (appUsersid, firstName, lastName, `password`, fechaNacimiento, enabled, empresaId, appCountryId, contact)
        VALUES
			(@appUserid, @firstName, @lastName, "NA", @fechaNacimiento, FLOOR(RAND() * 2), NULL, FLOOR(1 + (RAND() * 4)) , @contact);
            
		SET @countUsers = @countUsers - 1;
        
	END WHILE;
END//

DELIMITER ;


call LlenarUsers();


-- --------------- Tablas relacionadas a Direcciones ---------------

INSERT INTO appAsistant.appCountries
VALUES
(1, 'Costa Rica', 'CRC', '₡', 'ES'),
(2, 'México', 'MEX', '$', 'ES'),
(3, 'Estados Unidos', 'USA', '$', 'EN'),
(4, 'Argentina', 'ARG', '$', 'ES');

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