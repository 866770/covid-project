------------------------------------------
select location,date,total_cases,new_cases,total_deaths,population
from portofolioproject..CovidDeaths$
order by 1,2
----------------------------------
select * 
from portofolioproject..CovidDeaths$
----------------------------------------------------

-- looking at total cases vs total deaths--------------------
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from portofolioproject..CovidDeaths$
where location like '%states%'
order by 1,2

-- % of population got covid---------------------------------
select location,date,population,total_cases,(total_cases/population)*100 as Percentage
from portofolioproject..CovidDeaths$
order by 1,2

-- % of highest infection rate  country------------------
select location,population,max(total_cases) as highestinfection ,max(total_cases/population)*100 as Percentage
from portofolioproject..CovidDeaths$
group by location,population
order by Percentage desc


-- Number of deaths in each country--------------------
select location,max(cast(total_deaths as int )) as Deaths
from portofolioproject..CovidDeaths$
where continent is not null
group by location
order by Deaths desc


-- Number of deaths in each country-------------------
select location,max(cast(total_deaths as int )) as Deaths
from portofolioproject..CovidDeaths$
where continent is not null
group by location
order by Deaths desc

-- By continent------------------------
select continent,max(cast(total_deaths as int )) as Deaths
from portofolioproject..CovidDeaths$
where continent is not null
group by continent
order by Deaths desc

-- null continent---------------------
select location,max(cast(total_deaths as int )) as Deaths
from portofolioproject..CovidDeaths$
where continent is  null
group by location
order by Deaths desc

-- highest deaths continents

select continent,max(cast(total_deaths as int )) as Deaths
from portofolioproject..CovidDeaths$
where continent is not null
group by continent
order by Deaths desc


-- global numbers and %

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
from portofolioproject..CovidDeaths$
where continent is not null 
order by 1,2
-----select date ,sum(new_cases),sum(cast(new_deaths as int)),sum(new_deaths)/sum(new_cases) * 100 as deaths%

select dth.continent,dth.location,dth.date,dth.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dth.location order by dth.location,dth.date) as rollingpeoplevaccinated
from portofolioproject..CovidDeaths$ dth
join  portofolioproject..vaccinations vac
on dth.location = vac.location 
and dth.location = vac.location
where dth.continent is not null
order by 1,2,3
-------------------

--ctc
with popvsvac (continent,location,date,population,new_vaccinations,rollingpeoplevaccinated)
as
(
select dth.continent,dth.location,dth.date,dth.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dth.location order by dth.location,dth.date) as rollingpeoplevaccinated
from portofolioproject..CovidDeaths$ dth
join  portofolioproject..vaccinations vac
on dth.location = vac.location 
and dth.location = vac.location
where dth.continent is not null
)
select* ,(rollingpeoplevaccinated / population)*100
from popvsvac

--temp table 

drop table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
)
insert into #percentpopulationvaccinated
select dth.continent,dth.location,dth.date,dth.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dth.location order by dth.location,dth.date) as rollingpeoplevaccinated
from portofolioproject..CovidDeaths$ dth
join  portofolioproject..vaccinations vac
on dth.location = vac.location 
and dth.location = vac.location
where dth.continent is not null

--select* ,(rollingpeoplevaccinated / population)*100
--from #percentpopulationvaccinated


create view percentagepeoplevaccinated as
select dth.continent,dth.location,dth.date,dth.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dth.location order by dth.location,dth.date) as rollingpeoplevaccinated
from portofolioproject..CovidDeaths$ dth
join  portofolioproject..vaccinations vac
on dth.location = vac.location 
and dth.location = vac.location
where dth.continent is not null
Select *
from percentagepeoplevaccinated