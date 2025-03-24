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