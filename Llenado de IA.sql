use appAsistant;

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

DELIMITER ;

CALL LlenarEventos();










