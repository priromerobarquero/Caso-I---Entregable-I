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
