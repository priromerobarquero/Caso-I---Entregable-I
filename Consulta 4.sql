use appAsistant;

-- -------------CONSULTA 4 -------------------
    
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
