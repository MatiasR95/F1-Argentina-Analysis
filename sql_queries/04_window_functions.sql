--Rank the top 3 Argentine drivers with the most podiums per season  
WITH Podiums AS (  
    SELECT d.surname AS Driver,  
           CASE WHEN r.position <= 3 THEN 1 ELSE 0 END AS Podium  
    FROM results r  
    JOIN drivers d ON d.driverId = r.driverId  
    WHERE d.nationality LIKE 'Arg%'  
)  
SELECT Driver,  
       SUM(Podium) AS TotalPodiums,  
       DENSE_RANK() OVER (ORDER BY SUM(Podium) DESC) AS RANK  
FROM Podiums  
GROUP BY Driver  
ORDER BY TotalPodiums DESC;  

--Compare the first 10 races of Argentine drivers  
WITH ArgentinianRaces AS (  
    SELECT d.surname AS Driver,  
           r.points AS Points,  
           r.positionOrder AS Position,  
           ra.round AS Round,  
           ra.year AS Season,  
           SUM(CAST(r.points AS FLOAT)) OVER(PARTITION BY d.surname, ra.year ORDER BY ra.round ASC) AS TotalPoints,  
           ROW_NUMBER() OVER(PARTITION BY d.surname ORDER BY ra.year ASC, ra.round ASC) AS RaceN  
    FROM results r  
    JOIN drivers d ON d.driverId = r.driverId  
    JOIN races ra ON ra.raceId = r.raceId  
    WHERE d.nationality LIKE 'Arg%'  
)  
SELECT *  
FROM ArgentinianRaces  
WHERE RaceN <= 10  
ORDER BY Season DESC, Round ASC;
