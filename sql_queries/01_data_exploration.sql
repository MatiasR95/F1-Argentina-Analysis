--How many circuits have been used in F1 history?
SELECT COUNT(DISTINCT circuitId) AS TotalCircuits FROM circuits;

--List all F1 seasons from 1950 to today
SELECT s.year AS Year,
       RANK() OVER (ORDER BY s.year ASC) AS SeasonNumber
FROM seasons s;

--In which circuits has the Argentine GP been held?
SELECT c.name AS Circuit, c.location AS Location
FROM circuits c
WHERE c.country LIKE 'Arg%';

--Who is the youngest driver to debut in F1?
SELECT TOP 1 d.dob AS DateOfBirth, d.surname AS Driver
FROM drivers d
ORDER BY d.dob DESC;

--How many races have been held per year?
SELECT r.year AS Year, COUNT(r.raceId) AS TotalRaces
FROM races r
GROUP BY r.year
ORDER BY r.year DESC;
