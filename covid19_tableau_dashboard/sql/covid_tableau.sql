
-- Global Numbers
SELECT SUM(new_cases) AS total_cases,  SUM(new_deaths) AS total_deaths
, CAST(SUM(new_deaths) AS REAL)/CAST(SUM(new_cases) AS REAL)*100 AS DeathPercentage
FROM CovidDeaths death
WHERE death.continent IS NOT null
ORDER BY 1,2  


-- Total death count by continents
SELECT continent, MAX(total_deaths) as TotalDeathCount
FROM coviddeaths
WHERE continent IS NOT null
GROUP BY continent
ORDER BY TotalDeathCount DESC


-- Showing countries with infected people count per population using percentage
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, 
CAST(MAX((CAST(total_cases AS REAL)/CAST(population AS REAL))*100) AS DECIMAL(4,2)) AS InfectedPercentage 
FROM coviddeaths
GROUP BY location, population
ORDER BY InfectedPercentage ASC


-- Showing countries with infected people count with data per population using percentage
SELECT location, population, date, MAX(total_cases) AS HighestInfectionCount, 
CAST(MAX((CAST(total_cases AS REAL)/CAST(population AS REAL))*100) AS DECIMAL(4,2)) AS InfectedPercentage 
FROM coviddeaths
WHERE population IS NOT null and total_cases IS NOT null
GROUP BY location, population, date 
ORDER BY InfectedPercentage DESC

