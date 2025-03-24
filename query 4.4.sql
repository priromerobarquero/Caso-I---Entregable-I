SELECT 
    errorDescripcion, 
    COUNT(*) AS cantidadErrores
FROM appassistant.apperroresia
WHERE DATE(helpNotificationId) BETWEEN '2024-03-01' AND '2024-03-23'  -- Rango de fechas ajustable
GROUP BY errorDescripcion
ORDER BY cantidadErrores DESC;
/*
| errorDescripcion                        | cantidadErrores |
|-----------------------------------------|-----------------|
| Interpretación Incorrecta               | 15              |
| Halucinación                            | 12              |
| Respuesta Ambigua                       | 10              |
| Error de Cálculo o Lógico               | 8               |
| Falta de Contexto                       | 7               |
| Confusión de Intento                    | 6               |
| Respuesta Irrelevante                   | 5               |
| Error de Traducción                     | 4               |
| Respuesta Demasiado Completa o Técnica  | 3               |
| Limitación de Conocimiento              | 3               |
| Error de Formato                        | 2               |
| Fallo Técnico                           | 1               |
*/
