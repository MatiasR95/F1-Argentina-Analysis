--Which season had the most races?
SELECT TOP 1 r.year AS Season, COUNT(*) AS TotalRaces
FROM races r
GROUP BY r.year
ORDER BY TotalRaces DESC;

--Top teams with the most wins
SELECT TOP 5 c.name AS Constructor, COUNT(*) AS TotalWins
FROM results r
JOIN constructors c ON c.constructorId = r.constructorId
WHERE r.position = 1
GROUP BY c.name
ORDER BY TotalWins DESC;

--Which circuits have hosted the most races?
SELECT c.name AS Circuit, COUNT(*) AS TotalRaces
FROM races r
JOIN circuits c ON c.circuitId = r.circuitId
GROUP BY c.name
ORDER BY TotalRaces DESC;
