-- SQL Portfolio Project: Data Exploration in SQL
-- Using datasets for COVID-19 Vaccinations and Deaths from https://ourworldindata.org/coronavirus


-- Check first to see if the data has been imported correctly
-- Select a short preview of data from both covid_deaths and covid_vaccinations

SELECT *
FROM `covid.covid_deaths`
ORDER BY location,date
LIMIT 10;

SELECT *
FROM `covid.covid_vaccinations`
ORDER BY location,date
LIMIT 10;

SELECT location,
       date,
       total_cases,
       new_cases,
       total_deaths,
       population
FROM `covid.covid_deaths`
ORDER BY location,date;


-- Total Deaths vs Total Cases

SELECT location,
       date,
       total_cases,
       total_deaths,
       (total_deaths/total_cases)*100 AS percent_deaths
FROM `covid.covid_deaths`
WHERE location = 'United States'
ORDER BY location,date;


-- Total Cases vs Population

SELECT location,
       date,
       total_cases,
       population,
       (total_cases/population)*100 AS percent_infected
FROM `covid.covid_deaths`
WHERE location = 'United States'
ORDER BY location,date;


-- Countries with highest infections per population

SELECT location,
       population,
       MAX(total_cases) AS highest_infection_count,
       (MAX(total_cases)/population)*100 AS percent_infected
FROM `covid.covid_deaths`
GROUP BY location, population
ORDER BY percent_infected DESC;


-- Countries with highest deaths per population
-- Note: total_deaths are of nvarchar(255) type. Cast to INT type before aggregating.
-- Note: Continent is only NULL when Location is a continent/group of countries and not a single country

SELECT location,
       MAX(CAST(total_deaths AS INT)) AS total_death_count,
FROM `covid.covid_deaths`
WHERE continent IS NOT NULL 
GROUP BY location
ORDER BY total_death_count DESC;


--  Total Deaths Breakdown by Groups of Countries/Continents

SELECT location,
       MAX(CAST(total_deaths AS INT)) AS total_death_count,
FROM `covid.covid_deaths`
WHERE continent IS NULL 
GROUP BY location
ORDER BY total_death_count DESC;

--  Total Deaths Breakdown by Groups of Countries/Continents per Population


-- Total Percent Deaths Each Day, Worldwide

SELECT date,
       SUM(new_cases) AS total_new_cases,
       SUM(CAST(new_deaths AS INT)) AS total_new_deaths,
       (SUM(CAST(new_deaths AS INT))/SUM(new_cases))*100 AS percent_deaths
FROM `covid.covid_deaths`
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date;


-- Total Population vs Accumulative New Vaccinations per Day

SELECT dea.continent, 
       dea.location,
       dea.date,
       dea.population,
       vac.new_vaccinations AS daily_new_vaccinations,
       SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY 2,3) AS accum_new_vaccinations
FROM `covid.covid_deaths` dea
JOIN `covid.covid_vaccinations` vac
  ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3;


-- CTE for Total Population vs Accumulative New Vaccinations per Day

WITH pop_vs_vac
AS (
       SELECT dea.continent, 
              dea.location,
              dea.date,
              dea.population,
              vac.new_vaccinations AS daily_new_vaccinations,
              SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY 2,3) AS accum_new_vaccinations
       FROM `covid.covid_deaths` dea
       JOIN `covid.covid_vaccinations` vac
         ON dea.location = vac.location AND dea.date = vac.date
       WHERE dea.continent IS NOT NULL
)
SELECT *, (accum_new_vaccinations/population)*100
FROM pop_vs_vac;
