-- Consulta 4.1



-- Consulta 4.3

SELECT 
	username, 
	COUNT(*) AS cantidad_uso
FROM appassistant.applogs
GROUP BY username
ORDER BY cantidad_uso DESC
LIMIT 15;

SELECT 
	username, 
	COUNT(*) AS cantidad_uso
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
