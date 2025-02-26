--How many Argentine drivers have competed in F1?  
SELECT d.forename + ' ' + d.surname AS Driver,  
       YEAR(GETDATE()) - YEAR(d.dob) AS Age,  
       ROW_NUMBER() OVER(ORDER BY d.driverId) AS TotalArgentinians  
FROM drivers d  
WHERE nationality LIKE 'Arg%';  

--What was the best & worst finish for each Argentine driver?  
WITH ArgentinianRaces AS (  
    SELECT d.surname AS Driver,  
           r.positionOrder AS Position  
    FROM results r  
    JOIN drivers d ON d.driverId = r.driverId  
    WHERE d.nationality LIKE 'Arg%' AND r.positionOrder IS NOT NULL AND r.positionOrder > 0  
)  
SELECT Driver,  
       MIN(Position) AS BestFinish,  
       MAX(Position) AS WorstFinish  
FROM ArgentinianRaces  
GROUP BY Driver  
ORDER BY BestFinish ASC;  

--Which constructor has scored the most points with Argentine drivers?  
SELECT c.name AS Constructor,  
       SUM(CAST(r.points AS FLOAT)) AS TotalPoints  
FROM results r  
JOIN constructors c ON c.constructorId = r.constructorId  
JOIN drivers d ON d.driverId = r.driverId  
WHERE d.nationality LIKE 'Arg%'  
GROUP BY c.name  
ORDER BY TotalPoints DESC;  

--How many total races have Argentine drivers competed in?  
WITH EachArgRace AS (  
    SELECT d.surname AS Driver,  
           COUNT(DISTINCT r.raceId) AS TotalRaces  
    FROM results r  
    JOIN drivers d ON d.driverId = r.driverId  
    WHERE d.nationality LIKE 'Arg%'  
    GROUP BY d.surname  
)  
SELECT SUM(TotalRaces) AS ArgentiniansRaces  
FROM EachArgRace;  

--Which season had the highest participation of Argentine drivers?  
SELECT r.year AS Season,  
       COUNT(DISTINCT re.driverId) AS TotalArgentinians  
FROM races r  
JOIN results re ON re.raceId = r.raceId  
JOIN drivers d ON d.driverId = re.driverId  
WHERE d.nationality LIKE 'Arg%'  
GROUP BY r.year  
ORDER BY TotalArgentinians DESC;  

--Which circuits have been the best for Argentine drivers?  
SELECT c.name AS Circuit,  
       ROUND(AVG(CAST(r.positionOrder AS NUMERIC)), 1) AS AvgPosition  
FROM results r  
JOIN drivers d ON d.driverId = r.driverId  
JOIN races ra ON ra.raceId = r.raceId  
JOIN circuits c ON c.circuitId = ra.circuitId  
WHERE d.nationality LIKE 'Arg%'  
GROUP BY c.name  
ORDER BY AvgPosition ASC;  

--What is the podium distribution of Argentine drivers?  
WITH ArgentinianPodiums AS (  
    SELECT d.surname AS Driver,  
           CASE WHEN r.position <= 3 THEN 1 ELSE 0 END AS Podium  
    FROM results r  
    JOIN drivers d ON d.driverId = r.driverId  
    WHERE d.nationality LIKE 'Arg%'  
)  
SELECT Driver,  
       SUM(Podium) AS TotalPodiums  
FROM ArgentinianPodiums  
GROUP BY Driver  
ORDER BY TotalPodiums DESC;  

--How often have Argentine drivers finished in the points?  
WITH RacesWithPoints AS (  
    SELECT d.surname AS Driver,  
           CASE WHEN CAST(r.points AS FLOAT) > 0 THEN 1 ELSE 0 END AS RaceWithPoints  
    FROM results r  
    JOIN drivers d ON d.driverId = r.driverId  
    WHERE d.nationality LIKE 'Arg%'  
)  
SELECT Driver,  
       SUM(RaceWithPoints) AS TotalRacesWithPoints  
FROM RacesWithPoints  
GROUP BY Driver  
ORDER BY TotalRacesWithPoints DESC;  

--Which Argentine driver has the best qualifying average?  
WITH QPosition AS (  
    SELECT d.surname AS Driver,  
           CAST(q.position AS FLOAT) AS QPosition  
    FROM qualifying q  
    JOIN drivers d ON d.driverId = q.driverId  
    WHERE d.nationality LIKE 'Arg%'  
)  
SELECT Driver,  
       ROUND(AVG(QPosition), 1) AS AvgQualifyingPosition  
FROM QPosition  
GROUP BY Driver  
ORDER BY AvgQualifyingPosition ASC;

--How many different constructors have worked with Argentine drivers?
WITH ARGConstructors AS (
    SELECT DISTINCT c.name AS Constructor,
                    d.surname AS Driver
    FROM constructors c
    JOIN results r ON r.constructorId = c.constructorId
    JOIN drivers d ON d.driverId = r.driverId
    WHERE d.nationality LIKE 'Arg%'
)
SELECT COUNT(DISTINCT Constructor) AS TotalConstructors
FROM ARGConstructors;

--Compare Argentine drivers' average points with their teammates
WITH DriverPoints AS (
    SELECT d.driverId,
           d.surname AS Driver,
           r.constructorId,
           CAST(AVG(CAST(r.points AS FLOAT)) AS FLOAT) AS AvgPoints,
           ra.year AS Season
    FROM results r 
    JOIN drivers d ON d.driverId = r.driverId
    JOIN races ra ON ra.raceId = r.raceId
    GROUP BY d.driverId, d.surname, r.constructorId, ra.year
),
ArgentineDrivers AS (
    SELECT dp.Driver,
           dp.Season,
           dp.AvgPoints,
           dp.constructorId
    FROM DriverPoints dp
    JOIN drivers d ON dp.driverId = d.driverId
    WHERE d.nationality LIKE 'Arg%'
)
SELECT ad.Driver AS ArgentineDriver,
       ad.Season,
       ad.AvgPoints AS ArgentineAvgPoints,
       dp.Driver AS Teammate,
       dp.AvgPoints AS TeammateAvgPoints
FROM ArgentineDrivers ad
JOIN DriverPoints dp 
  ON ad.Season = dp.Season 
 AND ad.constructorId = dp.constructorId 
 AND ad.Driver <> dp.Driver
ORDER BY ad.Season, ad.Driver, dp.Driver;

--What was the most successful season for Argentine drivers?
SELECT ra.year AS Season,
       SUM(CAST(r.points AS FLOAT)) AS TotalPoints
FROM results r
JOIN drivers d ON d.driverId = r.driverId
JOIN races ra ON ra.raceId = r.raceId
WHERE d.nationality LIKE 'Arg%'
GROUP BY ra.year
ORDER BY TotalPoints DESC;
