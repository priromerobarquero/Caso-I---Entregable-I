use appAsistant;

-- CONSULTA #1

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
    
