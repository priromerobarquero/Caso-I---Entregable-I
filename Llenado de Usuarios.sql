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
(6, '2024-06-03 07:45:00', NULL, 8.32, FALSE, 6), 
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
		SET @appUserid = CONCAT(
			FLOOR(0 + RAND() * 8),  -- Primer dígito aleatorio entre 0 y 7
			FLOOR(0 + RAND() * 8),  
			FLOOR(0 + RAND() * 8),  
			FLOOR(0 + RAND() * 8),  
			FLOOR(0 + RAND() * 8),  
			FLOOR(0 + RAND() * 8),  
			FLOOR(0 + RAND() * 8),  
			FLOOR(0 + RAND() * 8), 
			FLOOR(0 + RAND() * 8));

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
        
        INSERT INTO AppUsers (appUsersid, firstName, lastName, `password`, fechaNacimiento, enabled, empresaId, contact)
        VALUES
			(@appUserid, @firstName, @lastName, "NA", @fechaNacimiento, 1, NULL, @contact);
            
		SET @countUsers = @countUsers - 1;
        
	END WHILE;
END//

DELIMITER ;

call LlenarUsers();

-- Agregando países
SET SQL_SAFE_UPDATES = 0;

UPDATE appUsers 
SET appCountryId = FLOOR(1 + (RAND() * 4));

SET SQL_SAFE_UPDATES = 1;

-- --------------- Tablas relacionadas a Direcciones ---------------

INSERT INTO appAsistant.appCountries
VALUES
(1, 'Costa Rica', 'CRC', '₡', 'ES'),
(2, 'México', 'MEX', '$', 'ES'),
(3, 'Estados Unidos', 'USA', '$', 'EN'),
(4, 'Argentina', 'ARG', '$', 'ES');






