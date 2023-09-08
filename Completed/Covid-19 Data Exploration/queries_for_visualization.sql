-- Queries to obtain data for dashboard

-- 1. Total Death Rate Worldwide

SELECT SUM(new_cases) AS total_cases, 
       SUM(CAST(new_deaths as int)) AS total_deaths, 
       SUM(CAST(new_deaths AS int))/SUM(New_Cases)*100 AS percent_deaths
FROM `covid.covid_deaths`
WHERE continent IS NOT NULL;


-- 2. Total Deaths by Continent

SELECT location,
       SUM(CAST(new_deaths AS int)) AS total_death_count
FROM `covid.covid_deaths`
WHERE continent IS NULL AND 
      location NOT IN ('World', 'European Union', 'International')
GROUP BY location
ORDER BY total_death_count DESC;


-- 3. Percent Infected by Country

SELECT location,
       population,
       MAX(total_cases) AS highest_infection_count,
       Max((total_cases/population))*100 AS percent_infected
FROM `covid.covid_deaths`
GROUP BY location, population
ORDER BY percent_infected DESC;


-- 4. Percent Infected by Country over Time

SELECT location, 
       population,
       date,
       MAX(total_cases) AS highest_infection_count, 
       Max((total_cases/population))*100 AS percent_infected
FROM `covid.covid_deaths`
GROUP BY location, population, date
ORDER BY percent_infected DESC;
