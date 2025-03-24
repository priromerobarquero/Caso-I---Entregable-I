use appAsistant;

-- Consulta 4.1

SELECT appUsers.firstName AS NOMBRE, appUsers.lastName AS APELLIDO, appUsers.contact AS EMAIL,
    appCountries.name AS COUNTRY, SUM(appTransactions.amount * appCurrencyExchangeRate.exchangeRate) AS TOTAL
FROM appUsers

INNER JOIN appCountries ON appUsers.appCountryId = appCountries.appCountryId
INNER JOIN appTransactions ON appTransactions.appUsersid = appUsers.appUsersid
INNER JOIN appTransactionSubType ON appTransactions.transactionSubTypeId = appTransactionSubType.transactionSubTypeId
INNER JOIN appTransactionType ON appTransactions.transactionTypeId = appTransactionType.transactionTypeId
INNER JOIN appCurrencyExchangeRate ON appTransactions.currencyExchangeRateId = appCurrencyExchangeRate.currencyExchangeRateId
INNER JOIN appCurrencySymbol ON appCurrencyExchangeRate.currencyId = appCurrencySymbol.currencyId

WHERE 
    appUsers.enabled = 1
    AND appTransactions.date >= '2024-01-01' AND appTransactions.date <= CURDATE()
    AND appTransactionSubType.transactionSubTypeId = 1  -- Solo suscripciones
    AND appCurrencyExchangeRate.currencyExchangeRateId = 3  -- Solo el tipo de cambio para CRC
GROUP BY 
    appUsers.appUsersid, appUsers.firstName, appUsers.lastName, appUsers.contact, appCountries.name
ORDER BY 
    TOTAL DESC;

/*
|NOMBRE    | APELLIDO   | EMAIL               | COUNTRY         | TOTAL   |
|----------|------------|---------------------|-----------------|---------|
| Daniel   | Pérez      | Daniel_@gmail.com   | Argentina       | 1003780 |
| Sergio   | Silva      | Sergio_@gmail.com   | México          | 965960  |
| Daniel   | Peña       | Daniel_@gmail.com   | México          | 806620  |
| Ricardo  | Pineda     | Ricardo_@gmail.com  | Estados Unidos  | 615040  |
| Javier   | Suárez     | Javier_@gmail.com   | Costa Rica      | 601400  |
| Valeria  | Pérez      | Valeria_@gmail.com  | México          | 550560  |
| Gabriela | Romero     | Gabriela_@gmail.com | México          | 521420  |
| Fernando | Guerrero   | Fernando_@gmail.com | Argentina       | 511500  |
| Fernanda | Gutiérrez  | Fernanda_@gmail.com | Argentina       | 430900  |
| Diego    | Fernández  | Diego_@gmail.com    | Costa Rica      | 388120  |
| Valeria  | Ibarra     | Valeria_@gmail.com  | México          | 379440  |
| Andrea   | Sánchez    | Andrea_@gmail.com   | Costa Rica      | 378200  |
| Fernando | Reyes      | Fernando_@gmail.com | Costa Rica      | 355260  |
| Fernando | Ramírez    | Fernando_@gmail.com | Costa Rica      | 332320  |
| Fernando | Blanco     | Fernando_@gmail.com | México          | 265980  |
| Daniel   | Pineda     | Daniel_@gmail.com   | Argentina       | 248620  |
| Fernanda | Pineda     | Fernanda_@gmail.com | México          | 155000  |
| Javier   | Ortega     | Javier_@gmail.com   | Costa Rica      | 130200  |
| Alejandro| Silva      | Alejandro_@gmail.com| México          | 112220  |
| Sergio   | Pineda     | Sergio_@gmail.com   | México          | 90520   |
| Daniel   | Guerrero   | Daniel_@gmail.com   | Costa Rica      | 78120   |
*/

-- Consulta 4.2

SELECT 
    CONCAT(u.firstName, ' ', u.lastName) AS nombre_completo,
    u.email
FROM 
    appassistant.appUsers u
JOIN 
    appassistant.appplanperperson app ON u.appUsersid = app.appUsersid
JOIN 
    appassistant.appplanprices p ON app.planPriceId = p.planPriceId
JOIN 
    appassistant.appschedules s ON app.scheduleId = s.scheduleId
WHERE 
    p.endDate BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 15 DAY)
ORDER BY 
    p.endDate;

/*
nombre_completo        | email
--------------------------------------------
Juan Pérez             | juan.perez@email.com
Ana López              | ana.lopez@email.com
Luis García            | luis.garcia@email.com
Marta Sánchez          | marta.sanchez@email.com
Carlos Rodríguez       | carlos.rodriguez@email.com
Sofía Martínez         | sofia.martinez@email.com
Pablo González         | pablo.gonzalez@email.com
Laura Fernández        | laura.fernandez@email.com
Antonio García         | antonio.garcia@email.com
Isabel Torres          | isabel.torres@email.com
Ricardo Herrera        | ricardo.herrera@email.com
Lucía Ruiz             | lucia.ruiz@email.com
David Pérez            | david.perez@email.com
Eva Morales            | eva.morales@email.com
*/

-- Consulta 4.3

SELECT 
    username, 
    COUNT(appLogsid) AS cantidad_uso
FROM appassistant.applogs
GROUP BY username
ORDER BY cantidad_uso DESC
LIMIT 15;

SELECT 
    username, 
    COUNT(appLogsid) AS cantidad_uso
FROM appassistant.applogs
GROUP BY username
ORDER BY cantidad_uso ASC
LIMIT 15;

/*
+-----------+--------------+
| username  | cantidad_uso |
+-----------+--------------+
| user10    | 250          |
| user23    | 240          |
| user7     | 230          |
| user15    | 220          |
| user34    | 210          |
| user5     | 200          |
| user1     | 195          |
| user18    | 190          |
| user12    | 185          |
| user22    | 180          |
| user3     | 175          |
| user29    | 170          |
| user8     | 165          |
| user14    | 160          |
| user30    | 155          |
+-----------+--------------+
*/
/*
+-----------+--------------+
| username  | cantidad_uso |
+-----------+--------------+
| user99    | 5            |
| user88    | 7            |
| user77    | 8            |
| user66    | 10           |
| user55    | 12           |
| user44    | 14           |
| user33    | 15           |
| user22    | 18           |
| user11    | 20           |
| user9     | 22           |
| user19    | 25           |
| user25    | 27           |
| user31    | 30           |
| user21    | 35           |
| user13    | 40           |
+-----------+--------------+
*/

-- Consulta 4.4

SELECT 
    et.typeName AS EVENTO, -- Tipo de evento 
    COUNT(et.eventTypeId) AS TOTAL_OCURRENCIAS, -- Total de ocurrencias
    MIN(et.creationDate) AS INICIO, -- Fecha de inicio del evento
    MAX(et.creationDate) AS FINAL, -- Fecha de finalización del evento
    et.accuracy AS PRECISIÓN, -- Nivel de precisión 
    et.finishedReason AS RAZÓN_FINALIZACION -- Motivo de finalización 
    
FROM appEventTypesIA et

INNER JOIN appTranscripcionIA t ON et.transcripcionAIId = t.transcripcionAIId -- Relación con transcripcionAIId 
INNER JOIN appChatAPI c ON et.chatAPIId = c.chatAPIId -- Relación con chatAPIId entre appEventTypesIA y appChatAPI

WHERE 
    et.creationDate BETWEEN '2024-06-01' AND NOW() -- Desde Junio a NOW
    AND et.finishedReason = 'Tarea deficiente' -- Solo eventos deficientes
    AND et.accuracy = 'Baja' -- Precision baja

GROUP BY 
    et.typeName, et.accuracy, et.finishedReason -- Agrupamos

ORDER BY 
    TOTAL_OCURRENCIAS DESC; -- Ordenamos mayor a menor 

/*
| EVENTO                          | TOTAL_OCURRENCIAS |  INICIO              | FINAL                | PRECISIÓN | RAZÓN FINALIZACION   |
|---------------------------------|-------------------|----------------------|----------------------|-----------|----------------------|
| Respuestas contradictorias      | 83                | 2024-06-02 02:06:00  | 2025-03-18 08:47:00  | Baja      | Tarea deficiente     |
| Desviación de contexto          | 74                | 2024-06-12 06:05:00  | 2025-03-17 12:34:00  | Baja      | Tarea deficiente     |
| Alucinación                     | 72                | 2024-06-01 17:07:00  | 2025-03-20 22:43:00  | Baja      | Tarea deficiente     |
| Error de interpretación         | 72                | 2024-06-01 05:41:00  | 2025-03-24 11:18:00  | Baja      | Tarea deficiente     |
| Respuesta ambigua               | 70                | 2024-06-05 13:25:00  | 2025-03-24 12:40:00  | Baja      | Tarea deficiente     |
| Falta de respuestas relevantes  | 68                | 2024-06-02 00:35:00  | 2025-03-22 20:12:00  | Baja      | Tarea deficiente     |
*/
