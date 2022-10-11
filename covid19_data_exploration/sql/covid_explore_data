SELECT * 
From coviddeaths
order by 3,4

SELECT * from coviddeaths


-- Select data that we are going to be using
SELECT location, date, total_cases, new_cases, total_deaths, population 
From coviddeaths
order by 1,2

-- Looking at total cases vs total deaths of a country
SELECT location, date, total_cases, total_deaths, 
CAST((CAST(total_deaths as REAL)/CAST(total_cases as REAL))*100 as DECIMAL(4,2)) as DeathPercentage 
From coviddeaths
where location like '%States%'
order by 1,2


-- Looking at total cases vs population
-- Shows what percentage of population got covid
SELECT location, date, total_cases, population, 
CAST((CAST(total_cases as REAL)/CAST(population as REAL))*100 as DECIMAL(4,2)) as TotalCasesPercentage 
From coviddeaths
where location like '%States%'
order by 1,2


-- Looking at countries with Highest Infection Rate compared to population
SELECT location, population, MAX(total_cases) as HighestInfectionCount, 
CAST(MAX((CAST(total_cases as REAL)/CAST(population as REAL))*100) as DECIMAL(4,2)) as TotalCasesPercentage 
From coviddeaths
--where location like '%Bangladesh%'
Group by location, population
--order by TotalCasesPercentage desc
order by TotalCasesPercentage asc

-- Showing countries with highest death count per population using percentage
SELECT location, population, MAX(total_deaths) as HighestDeathCount, 
CAST(MAX((CAST(total_deaths as REAL)/CAST(population as REAL))*100) as DECIMAL(4,2)) as DeathPercentage 
From coviddeaths
Group by location, population
order by HighestDeathCount asc

-- Showing countries with total death count
SELECT location, population, MAX(total_deaths) as TotalDeathCount
From coviddeaths
Where total_deaths is not null and continent is not null
Group by location, population
order by TotalDeathCount desc

-- Lets break down the previous query(total death count) by continents
SELECT continent, MAX(total_deaths) as TotalDeathCount
From coviddeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc


-- Showing continents with the highest death count per population
SELECT continent, MAX(total_deaths) as TotalDeathCount, MAX(population) as ContinentalPopulation, 
CAST(CAST(MAX(total_deaths) as REAL)/CAST(MAX(population) as REAL)*100 as DECIMAL(4,2)) as DeathPercentage
From coviddeaths
Where continent is not null
Group by continent
order by DeathPercentage desc


--new_vaccinations
SELECT * From CovidVaccinations

-- Join two tables CovidDeaths and CovidVaccinations
SELECT * 
FROM CovidDeaths death
JOIN CovidVaccinations vaccine
    ON death.location = vaccine.location
    AND death.date = vaccine.date

-- Global Numbers
SELECT SUM(new_cases) AS total_cases,  SUM(new_deaths) AS total_deaths
, CAST(SUM(new_deaths) AS REAL)/CAST(SUM(new_cases) AS REAL)*100 AS DeathPercentage
FROM CovidDeaths death
WHERE death.continent IS NOT null
ORDER BY 1,2    


-- Looking at total population vs vaccinations
SELECT death.continent, death.location, death.date, death.population, vaccine.new_vaccinations
, SUM(vaccine.new_vaccinations) OVER (PARTITION BY death.location ORDER BY death.location, death.date) as CumulativeVaccinatedPeople
FROM CovidDeaths death
JOIN CovidVaccinations vaccine
    ON death.location = vaccine.location
    AND death.date = vaccine.date
WHERE death.continent IS NOT null
ORDER BY 2,3    


--Use CTE
WITH PopvsVac (continent, location, date, population, new_vaccinations, CumulativeVaccinatedPeople)
AS
(
    SELECT death.continent, death.location, death.date, death.population, vaccine.new_vaccinations
    , SUM(vaccine.new_vaccinations) OVER (PARTITION BY death.location ORDER BY death.location, death.date) as CumulativeVaccinatedPeople
    FROM CovidDeaths death
    JOIN CovidVaccinations vaccine
        ON death.location = vaccine.location
        AND death.date = vaccine.date
    WHERE death.continent IS NOT null
)
SELECT *, (CAST(CumulativeVaccinatedPeople AS REAL)/CAST(population AS REAL))*100 AS CumuVacPercentage 
FROM PopvsVac
WHERE location LIKE '%Canada%'


-- Create temporary table
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated(
    continent TEXT, 
    location TEXT, 
    date DATE, 
    population BIGINT, 
    new_vaccinations INTEGER, 
    CumulativeVaccinatedPeople REAL
)

INSERT INTO #PercentPopulationVaccinated
SELECT death.continent, death.location, death.date, death.population, vaccine.new_vaccinations
, SUM(vaccine.new_vaccinations) OVER (PARTITION BY death.location ORDER BY death.location, death.date) as CumulativeVaccinatedPeople
FROM CovidDeaths death
JOIN CovidVaccinations vaccine
    ON death.location = vaccine.location
    AND death.date = vaccine.date
WHERE death.continent IS NOT null

SELECT *, (CAST(CumulativeVaccinatedPeople AS REAL)/CAST(population AS REAL))*100 AS CumuVacPercentage 
FROM #PercentPopulationVaccinated


--Create view
CREATE VIEW PercentPopulationVaccinated AS
SELECT death.continent, death.location, death.date, death.population, vaccine.new_vaccinations
, SUM(vaccine.new_vaccinations) OVER (PARTITION BY death.location ORDER BY death.location, death.date) as CumulativeVaccinatedPeople
FROM CovidDeaths death
JOIN CovidVaccinations vaccine
    ON death.location = vaccine.location
    AND death.date = vaccine.date
WHERE death.continent IS NOT null


SELECT * FROM percentpopulationvaccinated

