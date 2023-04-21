Select *
From PortfolioProject..CovidDeathss
Where continent is not null
Order by 3,4


--Select * 
--From PortfolioProject..CovidVaccinations
--Order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeathss
Where continent is not null
Order by 1, 2

--Total cases vs Total Deaths in Africa
--Percentage of cases of dying of Covid in Africa
Select Location, date, total_cases, total_deaths,ROUND((Total_deaths/Total_cases)*100, 2) AS DeathPercentage
From PortfolioProject..CovidDeathss
Where location = 'Africa' 
Order by 1, 2

--Total Cases vs Population
--Percentage of population that had Covid in Africa
Select Location, date, total_cases, population,ROUND((total_cases/population)*100, 2) AS DeathPercentage
From PortfolioProject..CovidDeathss
--Where location = 'Africa'
Where continent is not null
Order by 1, 2

--Highest infection rate Compared to Population
Select Location, Population, MAX(total_cases) AS HighestInfestionCount,ROUND(MAX((total_cases/population))*100, 2) AS PercentPopulationInfected
From PortfolioProject..CovidDeathss
--Where location = 'Africa'
Where continent is not null
Group by Location, Population
Order by PercentPopulationInfected DESC


--Highest death Count per Location
Select Location, MAX(cast(total_deaths as int)) AS TotalDeathCount
From PortfolioProject..CovidDeathss
--Where location = 'Africa'
Where continent is not null
Group by Location
Order by TotalDeathCount DESC

--Highest death Count per Continent
Select continent, MAX(cast(total_deaths as int)) AS TotalDeathCount
From PortfolioProject..CovidDeathss
--Where location = 'Africa'
Where continent is not null
Group by continent 
Order by TotalDeathCount DESC

Select location, MAX(cast(total_deaths as int)) AS TotalDeathCount
From PortfolioProject..CovidDeathss
--Where location = 'Africa'
Where continent is null
Group by location 
Order by TotalDeathCount DESC

--Global Numbers

Select SUM(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_deaths,
ROUND(SUM(cast(new_deaths as int))/SUM(new_cases)*100, 2) AS DeathPercentage
From PortfolioProject..CovidDeathss
--Where location = 'Africa'
Where continent is not null
--Group By date
Order by 1, 2


--Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
dea.date) as peoplevaccinated
From PortfolioProject..CovidDeathss dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.Location = vac.location
	and dea.date = Vac.date
Where dea.continent is not null
order by 2,3


With PopvsVac(Continent, Location, Data, Population, new_vaccinations, PeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
dea.date) as peopleVaccinated
From PortfolioProject..CovidDeathss dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.Location = vac.location
	and dea.date = Vac.date
Where dea.continent is not null
--order by 2,3
)

Select *, (PeopleVaccinated/Population)*100
From PopvsVac

--CTE

With PopvsVac(Continent, Location, Data, Population, new_vaccinations, PeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
dea.date) as peopleVaccinated
From PortfolioProject..CovidDeathss dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.Location = vac.location
	and dea.date = Vac.date
Where dea.continent is not null
--order by 2,3
)

Select *, (PeopleVaccinated/Population)*100
From PopvsVac

--Temp Table

DROP TABLE IF EXISTS #PercentpopulationVaccinated
Create table #PercentpopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date Datetime,
Population numeric,
New_Vaccinations numeric,
PeopleVaccinated numeric
)

Insert into #PercentpopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
dea.date) as peopleVaccinated
From PortfolioProject..CovidDeathss dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.Location = vac.location
	and dea.date = Vac.date
Where dea.continent is not null
--order by 2,3

Select *, (PeopleVaccinated/population)*100 AS Percentpopulation
From #PercentpopulationVaccinated
--Select *
--From #PercentpopulationVaccinated


--View for later visualizations
--Global Numbers
--PercentPopulationVaccinated

Create View GlobalNumbers as
Select SUM(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_deaths,
ROUND(SUM(cast(new_deaths as int))/SUM(new_cases)*100, 2) AS DeathPercentage
From PortfolioProject..CovidDeathss
--Where location = 'Africa'
Where continent is not null
--Group By date
--Order by 1, 2

Create View PercentpopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
dea.date) as peopleVaccinated
From PortfolioProject..CovidDeathss dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.Location = vac.location
	and dea.date = Vac.date
Where dea.continent is not null


