--How did Colapinto perform compared to other Argentine rookies?
WITH ArgPoints AS (
    SELECT d.surname AS Driver,
           CAST(r.points AS FLOAT) AS TotalPoints,
           ra.year AS Season
    FROM results r
    JOIN drivers d ON d.driverId = r.driverId
    JOIN races ra ON ra.raceId = r.raceId
    WHERE d.nationality LIKE 'Arg%'
)
SELECT Driver,
       Season,
       AVG(TotalPoints) OVER(PARTITION BY Driver, Season) AS AVGPoints
FROM ArgPoints
ORDER BY Season ASC;

--What was Colapinto’s best and worst race in 2024?
WITH ColapintoRaces AS (
    SELECT r.positionOrder AS PositionOrder,
           ra.round AS Round
    FROM results r
    JOIN drivers d ON d.driverId = r.driverId
    JOIN races ra ON ra.raceId = r.raceId
    WHERE d.surname = 'Colapinto'
)
SELECT *,
       DENSE_RANK() OVER(ORDER BY CAST(PositionOrder AS INT) ASC) AS Rank
FROM ColapintoRaces;

--Did Colapinto improve his race position compared to qualifying?
SELECT CAST(r.grid AS INT) AS QualyPosition,
       CAST(r.positionOrder AS INT) AS RacePosition,
       (CAST(r.grid AS INT) - CAST(r.positionOrder AS INT)) AS Difference,
       d.surname AS Driver,
       r.raceId
FROM results r
JOIN drivers d ON d.driverId = r.driverId
JOIN qualifying q ON q.raceId = r.raceId
WHERE d.surname = 'Colapinto'
GROUP BY r.raceId, r.grid, d.surname, r.positionOrder;

--How did Colapinto perform against his teammate?
SELECT r.positionOrder AS Finish,
       r.points AS Points,
       d.surname AS Driver,
	   r.raceId
FROM results r
JOIN drivers d ON d.driverId = r.driverId
JOIN constructors c ON c.constructorId = r.constructorId
WHERE c.name = 'Williams' 
  AND d.surname IN ('Colapinto','Albon')
ORDER BY r.raceId ASC;
