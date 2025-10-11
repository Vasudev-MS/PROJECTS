Select *
From PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--select *
--From PortfolioProject..CovidVaccinations
--order by 3,4
 
--Select Data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, Population
From PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where location like '%states%'
and continent is not null
order by 1,2

--Looking at Total Cases vs Population
--Shows what percentage of population got Covid

Select Location, Population, max(total_cases), (total_cases/Population)*100 as PercentagePopulationInfected
From PortfolioProject..CovidDeaths
--where location like '%states%'
order by 1,2

--Looking at Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectCount, max((total_cases/Population))*100 as PercentagePopulationInfected
From PortfolioProject..CovidDeaths
--where location like '%states%'
group by Location, Population
order by PercentagePopulationInfected desc

--Showing Countries with Highest Death Count per Population

Select Location, max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
Group by continent
order by TotalDeathCount desc

--BREAKING THINGS DOWN BY CONTINENT


--Showing Continents with the Highest Death Count per Population

Select continent, max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
Group by continent
order by TotalDeathCount desc

--GLOBAL NUMBERS


Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where location like '%states%'
and continent is not null
--group by date
order by 1,2

--Looking at Total Population vs Vaccinations

Select dea.continent, dea.location,dea.date, population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) OVER(Partition by  dea.Location order by dea.Location,dea.Date ) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	On dea.Location = vac.Location
	and dea.Date = vac.Date
where dea.continent is not null
--order by 2,3

--USE CTE


with PopvsVac (continent, location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) 
as
(
Select dea.continent, dea.location,dea.date, population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) over(partition by  dea.location order by dea.location,dea.date ) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac

-- TEMP TABLE


DROP TABLE IF EXISTS #PercentPopulationVaccinated;
create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime, 
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
);

insert into #PercentPopulationVaccinated
select dea.continent, dea.location,dea.date, population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over(partition by  dea.location order by dea.location,dea.date ) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated


--Creating View to store data for later visualizations

DROP VIEW PercentPopulationVaccinated;
GO
Create View PercentPopulationVaccinated AS
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER(Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated
