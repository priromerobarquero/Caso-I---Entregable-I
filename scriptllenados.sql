use appAssistant;

-- LLENADO DE BASE DE DATOS 
-- Priscilla Romero Barquero | 2023332718  
-- Elias Ramirez Hernandez | 2024090300

-- ----------------- Tablas relacionadas a monedas -------------------------

INSERT INTO appAssistant.appCurrencySymbol
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

ALTER TABLE appAssistant.appCurrencyExchangeRate 
MODIFY COLUMN endDate DATETIME NULL;

INSERT INTO appAssistant.appCurrencyExchangeRate
VALUES
(1, '2024-02-03 10:07:06', '2024-05-10 21:15:06', 541.39, FALSE, 3),
(2, '2024-04-04 09:30:00', NULL, 1.08, TRUE, 2),  
(3, '2024-05-12 14:15:30', '2024-05-13 14:15:30', 620 , FALSE, 3),  
(4, '2024-06-02 08:00:00', '2024-05-09 18:00:00', 6.98, FALSE, 6),  
(5, '2024-05-14 12:00:00', NULL, 524.50, TRUE, 3),
(6, '2024-06-03 07:45:00', NULL, 8.32, FALSE, 6), 
(7, '2024-04-04 11:10:00', '2024-05-11 23:59:00', 5.23, FALSE, 10);


-- --------------- Tablas relacionadas a informacion de contacto ------------------------

INSERT INTO appAssistant.appContactInfoType
VALUES
(1, 'Phone Number'),
(2, 'Email'),
(3, 'Telegram');


-- --------------- Tablas relacionadas al ususario ------------------------

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

INSERT INTO appAssistant.appCountries
VALUES
(1, 'Costa Rica', 'CRC', '₡', 'ES'),
(2, 'México', 'MEX', '$', 'ES'),
(3, 'Estados Unidos', 'USA', '$', 'EN'),
(4, 'Argentina', 'ARG', '$', 'ES');
-- --------------- Tablas relacionadas a Pagos ---------------------

INSERT INTO appAssistant.appTransactionSubType
VALUES
(1, 'Suscripcion'),
(2, 'CashBack'),
(3, 'Pago Denegado'),
(4, 'Pago Aceptado');

INSERT INTO appAssistant.appTransactionType
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
    SELECT COUNT(*) INTO transactionTypeCount FROM appAssistant.appTransactionType;
    SELECT COUNT(*) INTO transactionSubTypeCount FROM appAssistant.appTransactionSubType;
    SELECT COUNT(*) INTO currencyCount FROM appAssistant.appCurrencySymbol;
    SELECT COUNT(*) INTO methodCount FROM appAssistant.appMetodosPago;

    -- Llenar la tabla appTransactionType con datos aleatorios si no hay registros
    IF transactionTypeCount = 0 THEN
        INSERT INTO appAssistant.appTransactionType (name) VALUES ('Purchase'), ('Refund'), ('Transfer');
    END IF;

    -- Llenar la tabla appTransactionSubType con datos aleatorios si no hay registros
    IF transactionSubTypeCount = 0 THEN
        INSERT INTO appAssistant.appTransactionSubType (name) VALUES ('Online'), ('Offline'), ('Recurring');
    END IF;

    -- Llenar la tabla appCurrencyExchangeRate con datos aleatorios
    IF currencyCount > 0 THEN
        SET i = 0;
        WHILE i < 5 DO  -- Número de tasas de cambio a insertar, ajusta según sea necesario
            SET randomCurrencyId = FLOOR(1 + (RAND() * currencyCount));
            SET randomExchangeRate = ROUND(1 + (RAND() * 100), 2);
            SET randomFecha = NOW();
            INSERT INTO appAssistant.appCurrencyExchangeRate (
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

        INSERT INTO appAssistant.appPagos (
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

        INSERT INTO appAssistant.appTransactions (
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


CREATE PROCEDURE FillAppSchedulesAndDetails()
BEGIN
    DECLARE i INT DEFAULT 0;

    -- Insertar datos en appSchedules
    WHILE i < 30 DO
        INSERT INTO appAssistant.appSchedules (name, recurrentType, repetition, endType, endDate)
        VALUES (
            CONCAT('Schedule_', i),
            ELT(FLOOR(1 + (RAND() * 3)), 'Daily', 'Weekly', 'Monthly'), -- Tipo recurrente aleatorio
            FLOOR(1 + (RAND() * 10)), -- Repetición entre 1 y 10
            ELT(FLOOR(1 + (RAND() * 3)), 'By Date', 'By Occurrences', 'No End'), -- Tipo de finalización aleatorio
            IF(RAND() > 0.5, DATE_ADD(NOW(), INTERVAL FLOOR(RAND() * 365) DAY), NULL) -- Algunas fechas nulas
        );
        SET i = i + 1;
    END WHILE;

    -- Insertar datos en appScheduleDetails
    SET i = 0;
    WHILE i < 30 DO
        INSERT INTO appAssistant.appScheduleDetails (deleted, baseDate, datepart, lastexecution, nextExecution, scheduleId)
        VALUES (
            0, -- No eliminado
            DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 365) DAY), -- Fecha base aleatoria en el último año
            FLOOR(RAND() * 100), -- Parte de la fecha aleatoria
            DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 30) DAY), -- Última ejecución en el último mes
            DATE_ADD(NOW(), INTERVAL FLOOR(RAND() * 30) DAY), -- Próxima ejecución en el próximo mes
            (SELECT scheduleId FROM appAssistant.appSchedules ORDER BY RAND() LIMIT 1) -- ID aleatorio de appSchedules
        );
        SET i = i + 1;
    END WHILE;
END $$

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

    SELECT COUNT(*) INTO logTypesCount FROM appAssistant.appLogTypes;
    SELECT COUNT(*) INTO logSourcesCount FROM appAssistant.appLogSources;
    SELECT COUNT(*) INTO logSeverityCount FROM appAssistant.appLogSeverity;

    WHILE i < 100 DO  
        SET randomLogTypeId = FLOOR(1 + (RAND() * logTypesCount));
        SET randomLogSourceId = FLOOR(1 + (RAND() * logSourcesCount));
        SET randomLogSeverityId = FLOOR(1 + (RAND() * logSeverityCount));

        SET randomReferenceId1 = FLOOR(100000 + (RAND() * 999999));
        SET randomReferenceId2 = FLOOR(100000 + (RAND() * 999999));

        INSERT INTO appAssistant.appLogs (
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

-- ----------------TABLAS DE FILES-----------------------
INSERT INTO appMediaTypes (mediaTypeID, name, playerImpl)
VALUES
(1, 'Audio', 'MP3'),
(2, 'Texto', 'TXT');

INSERT INTO appMediaFiles (mediaFileId, documentURL, lastUpdate, deleted, mediaTypeID, appModulesid, metodoId)
VALUES
(1, "https://example.com/files/HacerPresentacion.txt", NOW(), 0, 2, NULL, NULL),
(2, "https://example.com/files/ModificarContraseña.txt", NOW(), 0, 2, NULL, NULL),
(3, "https://example.com/files/CrearNuevoUsuario.txt", NOW(), 0, 2, NULL, NULL),
(4, "https://example.com/files/EnviarEmailRecuperacion.txt", NOW(), 0, 2, NULL, NULL),
(5, "https://example.com/files/ConfigurarNotificaciones.txt", NOW(), 0, 2, NULL, NULL),
(6, "https://example.com/files/AgregarAmigosFB.txt", NOW(), 0, 2, NULL, NULL),
(7, "https://example.com/files/VerNotificacionesFB.txt", NOW(), 0, 2, NULL, NULL),
(8, "https://example.com/files/InicioSesionFB.mp3", NOW(), 0, 1, NULL, NULL),
(9, "https://example.com/files/ConfigurarCorreoMP3.mp3", NOW(), 0, 1, NULL, NULL),
(10, "https://example.com/files/VerificarCuentaFB.mp3", NOW(), 0, 1, NULL, NULL),
(11, "https://example.com/files/ResetearContraseñaFB.mp3", NOW(), 0, 1, NULL, NULL),
(12, "https://example.com/files/ActualizarFotoPerfil.mp3", NOW(), 0, 1, NULL, NULL),
(13, "https://example.com/files/VerMensajesDirectosFB.mp3", NOW(), 0, 1, NULL, NULL),
(14, "https://example.com/files/PublicarEnMuroFB.mp3", NOW(), 0, 1, NULL, NULL),
(15, "https://example.com/files/CambiarConfiguracionPrivacidad.mp3", NOW(), 0, 1, NULL, NULL);



-- ----------------TABLAS DE IA ---------------------------

-- Models
INSERT INTO appIAmodels (modelIAId, name, enable) VALUES
(1, 'GPT-4', 1),
(2, 'GPT-3.5', 1),
(3, 'DALL-E', 1);

-- Roles
INSERT INTO appIAroles (rolesIAId, name, description) VALUES
(1, 'system', 'NA'),
(2, 'user', 'NA'),
(3, 'assistant', 'NA');

-- Modalities
INSERT INTO appModalities (name, enabled) VALUES
('audio', 1),
('texto', 1);

-- Chat Status
INSERT INTO appChatStatus (chatStatusId, name) VALUES
(1, 'En espera'),
(2, 'Aprobado'),
(3, 'Rechazado'),
(4, 'Cerrado');

-- Help Notifications
INSERT INTO appHelpNotification (helpNotificationId, creationDate, tittle, message) VALUES
(1, NOW(), 'Help Center', '¿Cómo puedo ayudarte?'),
(2, NOW(), 'Help Center', '¿Necesitas asistencia?'),
(3, NOW(), 'Help Center', 'Estamos aquí para ayudar.'),
(4, NOW(), 'Help Center', '¿Pudiste registrar la tarea?'),
(5, NOW(), 'Help Center', 'Verificando información...'),
(6, NOW(), 'Help Center', 'Estamos trabajando en eso.'),
(7, NOW(), 'Help Center', 'Un momento, por favor.'),
(8, NOW(), 'Help Center', 'Tu solicitud ha sido recibida.'),
(9, NOW(), 'Help Center', 'Intentemos otra solución.'),
(10, NOW(), 'Help Center', 'Gracias por tu paciencia.');


-- API de Chat

DROP PROCEDURE LlenarChatAPI;

DELIMITER //

CREATE PROCEDURE LlenarChatAPI()
BEGIN
	SET @countChats = 200;

	WHILE @countChats > 0 DO
        
        -- Objetos JSON
        SET @object = "";
        SET @object = ELT(FLOOR(1 + RAND() * 4), '{"Tarea": "1", "Desc":"Iniciar Sesion en Intagram"}', '{"Tarea": "2", "Desc": "Subir foto en Facebook"}',
			'{"Tarea": "2", "Desc": "Pagar factura de teléfono móvil"}', '{"Tarea": "3", "Desc": "Actualizar estado en WhatsApp"}');
        
        SET @apiKey = FLOOR(1 + (RAND() * 1000000)); -- API KEY
        SET @finished = FLOOR(RAND() * 2); -- Estado de la conversacion
        SET @maxToken =FLOOR(1 + (RAND() * 60)); -- Cantidad Maximas de tokens
        SET @mcontext = 'Estás tratando de conseguir todo lo relacionado a una tarea'; -- Qué trata de hacer el chat
        SET @chatSt = FLOOR(1 + (RAND() * 4)); -- 4 tipos de chat status
        SET @modality = FLOOR(1 + (RAND() * 2)); -- 2 modelos
        SET @roles = FLOOR(1 + (RAND() * 3)); -- 3 rloes
        SET @models = FLOOR(1 + (RAND() * 3)); -- 3 modelos
        SET @helpNoti = FLOOR(1 + (RAND() * 10)); -- 10 tipos de notificacion
		SET @token = SHA2(CONCAT(@object, @apiKey, @maxToken,'CLARAMENTE NO ES', @mcontext), 512);
        
        INSERT INTO appChatAPI (token, returnedObject, apiKey, responseFormat, finished, maxTokens,
			`context`, chatStatusId, modalityId, modelIAId, rolesIAId, helpNotificationId)
        VALUES
			(@token, @object, @apiKey, 'response format', @finished, @maxToken, @mcontext , @chatSt,
				@modality, @models, @roles, @helpNoti);
            
		SET @countChats = @countChats - 1;
        
	END WHILE;
END//

DELIMITER ;

Call LlenarChatAPI();


--  Audio a Transcripcion

DROP PROCEDURE LlenarTranscripciones;

DELIMITER //

CREATE PROCEDURE LlenarTranscripciones()
BEGIN
	SET @count = 300;

	WHILE @count > 0 DO
		
        
		-- Agregamos nombre y apellido
        SET @enabled = FLOOR(RAND() * 2);
		
        -- Fijamos fechas random
        SET @creationDate = DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 365) DAY); -- Fecha aleatoria en los últimos 365 días (aproximadamente 1 año)
		SET @creationDate = DATE_ADD(DATE(@creationDate), INTERVAL FLOOR(RAND() * 24) HOUR); -- Hora aleatoria entre 00:00 y 23:00
		SET @creationDate = DATE_ADD(@creationDate, INTERVAL FLOOR(RAND() * 60) MINUTE); -- Minutos aleatorios (0-59)
		
        -- Insertamos algunas transcripciones
        SET @object = ELT(FLOOR(1 + RAND() * 6),'{"text": "Quiero agregar una columna en Excel"}', 
            '{"text": "Quiero saber cómo hacer un sinpe"}',
            '{"text": "Como contratar el servicio de Netflix"}', 
            '{"text": "Cómo reiniciar mi computadora"}', 
            '{"text": "Abrir un contenedor en Docker"}',
            '{"text": "Como hacer limites al infinito"}');
		SET @tamano = FLOOR(500 + (RAND() * 500));
		SET @finished = FLOOR(RAND() * 2); -- Terminada o no
        SET @media = FLOOR(1 + (RAND() * 7)); -- Files txt
        
        
        INSERT INTO appTranscripcionIA (enabled, deleted, creationDate, `data`, tamaño, finished, 
        mediaFileId, chatAnalysisId)
        VALUES
			(@enabled, 0, @creationDate, @object, @tamano, @finished, @media , NULL);
            
		SET @count = @count - 1;
        
	END WHILE;
END//

DELIMITER ;

select * from appTranscripcionIA;


call LlenarTranscripciones();

-- Llenado de Eventos

DROP PROCEDURE LlenarEventos;

DELIMITER // 
CREATE PROCEDURE LlenarEventos()
BEGIN
	SET @countChats = 0;

	WHILE @countChats <= 200 DO
		
        SET @i = 0;
			SET @eventId = 1;
            SELECT chatAPIId INTO @eventId FROM appChatAPI WHERE chatAPIId = @countChats;
            
            WHILE @i <= 15 DO
		
				-- Tipos de evento
				SET @nameT = ELT(FLOOR(1 + RAND() * 6),'Alucinacion', 
					'Error de interpretacion',
					'Respuesta ambigua', 
					'Desviacion de contexto', 
					'Falta de respuestas relevantes',
					'Respuestas contradictorias');
				
                -- Fijamos fechas random
				SET @creationDate = DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 365) DAY); -- Fecha aleatoria en los últimos 365 días (aproximadamente 1 año)
				SET @creationDate = DATE_ADD(DATE(@creationDate), INTERVAL FLOOR(RAND() * 24) HOUR); -- Hora aleatoria entre 00:00 y 23:00
				SET @creationDate = DATE_ADD(@creationDate, INTERVAL FLOOR(RAND() * 60) MINUTE); -- Minutos aleatorios (0-59)
				
                SET @ocurrencias = FLOOR(5 + (RAND() * 11)); -- 5 a 15 ocurrencias
                SET @accuracy = ELT(FLOOR(1 + RAND() * 3),'Alta', 'Media', 'Baja'); -- Tipo de acierto
				
                -- Razon de finalizacion
                SET @reason = ELT(FLOOR(1 + RAND() * 2),'Tarea deficiente', 'Tarea Eficiente');
                SET @transcripcion = FLOOR(1 + RAND() * 300);
				
                -- ID autoincrementado
				INSERT INTO appEventTypesIA(typeName, creationDate,`description`, ocurrenciasCount, 
					accuracy, finishedReason, chatAPIId, transcripcionAIID)
				VALUES
				(@nameT, @creationDate, 'descripcion', @ocurrencias, @accuracy, @reason, @eventId, 
					@transcripcion);
                
                SET @i = @i + 1;
			END WHILE;
		SET @countChats = @countChats + 1;
        
        END WHILE;
END //
