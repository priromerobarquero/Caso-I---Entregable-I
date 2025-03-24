SELECT 
    errorDescripcion, 
    COUNT(*) AS cantidadErrores
FROM appassistant.apperroresia
WHERE DATE(helpNotificationId) BETWEEN '2024-03-01' AND '2024-03-23'  -- Rango de fechas ajustable
GROUP BY errorDescripcion
ORDER BY cantidadErrores DESC;
