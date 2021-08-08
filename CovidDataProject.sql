Select *
From CovidDataProject..CovidDeaths
ORDER BY 3,4

Select *
From CovidDataProject..CovidVaccinations
ORDER BY 3,4

Select Location,date, total_cases, new_cases, total_deaths, population
FROM CovidDataProject..CovidDeaths
ORDER BY 1,2

Select Location,date, population
FROM CovidDataProject..CovidDeaths
WHERE Location Like 'Nigeria'
ORDER BY 1,2

--Looking at Total cases vs total Deaths and the percentage of Deaths to cases

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
FROM CovidDataProject..CovidDeaths
ORDER BY 1,2

--Looking at Total cases vs Total Deaths in the US

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
FROM CovidDataProject..CovidDeaths
WHERE Location like 'United States'
ORDER BY 1,2

--Looking at Total cases vs Total Deaths in Nigeria
--Likelihood of dying if you contract Covid in Nigeria

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
FROM CovidDataProject..CovidDeaths
WHERE Location like 'Nigeria'
ORDER BY 1,2

--Looking at Cases vs Population, percentage of Cases

Select Location, date, total_cases, population, (total_cases/population)*100 As CasesPercentage
FROM CovidDataProject..CovidDeaths
ORDER BY 1,2

--Looking into Total cases vs Population in Nigeria
--Shows Percentage of covid contraction vs Population in Nigeria

Select Location, date, total_cases, population, (total_cases/population)*100 As PercentageInNigeria
FROM CovidDataProject..CovidDeaths
WHERE Location Like 'Nigeria'
ORDER BY 1,2

-- countries with highest infection rates vs Population

Select Location, MAX(total_cases) As HighestInfectionCount, population, MAX((total_cases/population))*100 As PercentageInfectedRate
FROM CovidDataProject..CovidDeaths
GROUP BY location, population
ORDER BY PercentageInfectedRate DESC

--infection rate for nigeria

Select Location,MAX(total_cases) AS Infections, population, MAX((total_cases/Population))*100 As PercentageOfInfection
FROM CovidDataProject..CovidDeaths
WHERE Location like 'Nigeria'
GROUP BY Location, Population
ORDER BY 1,2

--highest Death Count per population by Country

Select Location, MAX(cast(Total_deaths as int)) As TotalDeaths, MAX(population) As Population
FROM CovidDataProject..CovidDeaths
WHERE continent is not null
GROUP BY location,population
ORDER BY TotalDeaths DESC

--Death Count by Continent

Select location, MAX(cast(Total_deaths as int)) As TotalDeaths
FROM CovidDataProject..CovidDeaths
WHERE continent is null
GROUP BY location
ORDER BY TotalDeaths DESC

Select continent, MAX(cast(Total_deaths as int)) As TotalDeaths
FROM CovidDataProject..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeaths DESC

-------------------------------------------------------------------
---to see other countries in other continents, just change the 'Africa' in the WHERE statement to your desired continent

---countries in Africa Highest infections

Select Location,MAX(total_cases) AS Infections, population
FROM CovidDataProject..CovidDeaths
WHERE continent like 'Africa' 
GROUP BY Location, Population
ORDER BY Infections DESC

--Highest Deaths in Africa

Select Location,MAX(total_deaths) AS Deaths, population
FROM CovidDataProject..CovidDeaths
WHERE continent like 'Africa'
GROUP BY Location, Population
ORDER BY Deaths DESC

---Total cases Globally in a day by day case

Select date, SUM(new_cases) as totalCases, SUM(cast(new_deaths as int)) as total_deaths,
SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as DeathPercentages
FROM CovidDataProject..CovidDeaths
Where continent is not null
GROUP BY date
ORDER BY 1,2

--cases Globally in Total
--GLOBAL

Select SUM(new_cases) as totalCases, SUM(cast(new_deaths as int)) as total_deaths,
SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as DeathPercentages
FROM CovidDataProject..CovidDeaths
Where continent is not null
ORDER BY 1,2

--Population vs Vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM CovidDataProject..CovidDeaths dea JOIN CovidDataProject..CovidVaccinations vac
ON dea.location = vac.location and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 1,2

--Population vs vaccination in Africa

Select dea.location,dea.population, vac.new_vaccinations
FROM CovidDataProject..CovidDeaths dea JOIN CovidDataProject..CovidVaccinations vac
ON dea.location = vac.location and dea.date = vac.date
WHERE dea.continent is not null AND dea.continent like 'Africa'
ORDER BY 1,2

--new vaccination accumlated by the days

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location ORDER BY dea.location,dea.date) as AccumlatedVac
FROM CovidDataProject..CovidDeaths dea JOIN CovidDataProject..CovidVaccinations vac
ON dea.location = vac.location and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 1,2

--Total population vs Total vaccination by country in Africa

Select dea.location, MAX(dea.population) as population, MAX(dea.total_cases) AS Infections,MAX(vac.new_vaccinations) as vaccinations
FROM CovidDataProject..CovidDeaths dea JOIN CovidDataProject..CovidVaccinations vac
ON dea.location = vac.location
WHERE dea.continent is not null AND dea.continent like 'Africa'
GROUP BY dea.location,dea.population
ORDER BY 1,2

--new vaccination accumlated by the days in Nigeria

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location ORDER BY dea.location,dea.date) as AccumlatedVac
FROM CovidDataProject..CovidDeaths dea JOIN CovidDataProject..CovidVaccinations vac
ON dea.location = vac.location and dea.date = vac.date
WHERE dea.continent is not null AND dea.location like 'Nigeria'
ORDER BY 1,2

--new vaccination accumlated by the days in Africa

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location ORDER BY dea.location,dea.date) as AccumlatedVac
FROM CovidDataProject..CovidDeaths dea JOIN CovidDataProject..CovidVaccinations vac
ON dea.location = vac.location and dea.date = vac.date
WHERE dea.continent is not null AND dea.continent like 'Africa'
ORDER BY 1,2

--percentage rate of the accumlated vaccines vs population in Africa
-- i use CTE to use the alias in a simple calculation

WITH PopvsVac (continent, location, date, population, new_vaccinations,AccumlatedVac)
AS
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (partition by dea.location ORDER BY dea.location,dea.date) as AccumlatedVac
FROM CovidDataProject..CovidDeaths dea JOIN CovidDataProject..CovidVaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is not null
)
SELECT *, (AccumlatedVac/population)*100 as PercentageVacvsPop
FROM PopvsVac
WHERE continent like 'Africa'

--USE TEMP TABLE

DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
AccumlatedVac numeric
)

INSERT INTO #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (partition by dea.location ORDER BY dea.location,dea.date) as AccumlatedVac
FROM CovidDataProject..CovidDeaths dea JOIN CovidDataProject..CovidVaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is not null

SELECT *, (AccumlatedVac/Population)*100
FROM #PercentPopulationVaccinated

--------------------------------------------------

--CREATE A VIEW

CREATE VIEW PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (partition by dea.location ORDER BY dea.location,dea.date) as AccumlatedVac
FROM CovidDataProject..CovidDeaths dea JOIN CovidDataProject..CovidVaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is not null


