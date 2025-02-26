--List drivers with most wins
SELECT COUNT(*) AS TotalWins, d.surname AS Driver
FROM driver_standings ds
JOIN drivers d ON d.driverId = ds.driverId
WHERE ds.position = 1
GROUP BY d.surname
ORDER BY TotalWins DESC;

--List all F1 champions by season
WITH SeasonsPoints AS (
    SELECT d.surname AS Driver, SUM(CAST(r.points AS FLOAT)) AS TotalPoints, ra.year AS Season
    FROM results r
    JOIN drivers d ON d.driverId = r.driverId
    JOIN races ra ON ra.raceId = r.raceId
    GROUP BY d.surname, ra.year
),
RankedSeasonPoints AS (
    SELECT *, RANK() OVER (PARTITION BY Season ORDER BY TotalPoints DESC) AS Rank
    FROM SeasonsPoints
)
SELECT Driver, Season, Rank FROM RankedSeasonPoints WHERE Rank = 1 ORDER

--Find the constructor champion for each season  
WITH TotalPointsConstructors AS (  
    SELECT c.name AS Constructor,  
           SUM(CAST(r.points AS FLOAT)) AS Total_Points,  
           ra.year AS Season  
    FROM results r  
    JOIN constructors c ON c.constructorId = r.constructorId  
    JOIN races ra ON ra.raceId = r.raceId  
    GROUP BY c.name, ra.year  
),  
RANK_Constructors AS (  
    SELECT *,  
           RANK() OVER (PARTITION BY Season ORDER BY Total_Points DESC) AS Position  
    FROM TotalPointsConstructors  
)  
SELECT Season, Constructor  
FROM RANK_Constructors  
WHERE Position = 1  
ORDER BY Season DESC;  

--Link drivers with their teams' nationalities  
SELECT c.name AS Constructor,  
       c.nationality AS Nationality,  
       d.surname AS Driver  
FROM results r  
JOIN drivers d ON d.driverId = r.driverId  
JOIN constructors c ON c.constructorId = r.constructorId;
