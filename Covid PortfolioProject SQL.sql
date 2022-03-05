--select *from portfolioproject..CovidDeaths$
--order by 3,4

--select * from portfolioproject..CovidVaccinations$
--order by 3,4


--Select Location, Date, total_cases, new_cases, total_deaths, population
--from PortfolioProject..CovidDeaths$
--order by 1,2

-- Total Cases vs Total Deaths in India
Select Location, Date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where Location = 'India'
order by 1,2

--Total Cases vs Population in India
Select Location, Date, Population,total_cases, (total_deaths/Population)*100 as PercentPopulationInfected 
from PortfolioProject..CovidDeaths$
where Location = 'India'
order by 1,2

-- Countries with Highest Infection rate compared to Population
select location, population, max(total_cases) as totalcasescount, max(total_cases/population)*100 as PercentPopulationInfected from PortfolioProject..CovidDeaths$
where continent is not null
group by location,population
order by PercentPopulationInfected desc

-- Countries with Highest Death count per Population

select location,max(cast(total_deaths as int)) as totaldeathcount from PortfolioProject..CovidDeaths$
where continent is not null
group by location
order by totaldeathcount desc

--Deaths by Continent

select continent,max(cast(total_deaths as int)) as totaldeathcount from PortfolioProject..CovidDeaths$
where continent is not null
group by continent
order by totaldeathcount desc

--Global Numbers
Select  Date, sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercent
from PortfolioProject..CovidDeaths$
where continent is not null
group by date
order by 1,2


select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, 
sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3


-- Temp table

Create Table #PercentPeopleVaccinated
(Continent nvarchar(255), Location nvarchar(255), Date datetime, Population numeric, new_vaccinations numeric, RollingPeopleVaccinated numeric)

Insert into #PercentPeopleVaccinated

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, 
sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPeopleVaccinated

-- Create view for later visualization

Create view PercentPeopleVaccinated as 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, 
sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
--order by 2,3



