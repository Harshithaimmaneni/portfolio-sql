use [indian census]

select * from Data1
select * from Data2

select count(*) from Data1
select count(*) from Data2

select * from Data1 where State in ('Karnataka','Gujarat')

--Total population of india--
select sum(Population)as Population from Data2
--- Avg pop in india---
select AVG(Population) as Avg_pop from Data2
-- Avg growth in india--
select AVG(Growth)*100 as Avg_growth from Data1
---- Avg growth by state--
select State,AVG(Growth)*100 as avg_growth from Data1 group by State
----avg sex ratio by state
select State, round(avg(Sex_Ratio),0) as avg_gender_pop from Data1 group by State order by avg_gender_pop desc
-- avg literacy rates--
select State, round(avg(Literacy),0) as avg_Literacy from Data1 group by State
having round(avg(Literacy),0)>80 order by avg_Literacy desc
--- Top 3 sates showing higher growth ratio---
select top 3 State,avg(Growth) as avg_growth from Data1 group by State
-- lowest 5 literacy states---
select top 5 State,avg(Literacy) as avg_literacy from Data1 group by State order by avg_literacy asc
---select top 7 growth rate ---
select top 1 Growth from (select distinct top 7 Growth from Data1 order by Growth desc) as temp order by Growth
---select 3rd lowest growth rate---
SELECT TOP 1 State, MAX(Growth) AS max_growth
FROM (
  SELECT DISTINCT TOP 7 State, Growth
  FROM Data1
  ORDER BY Growth DESC
) AS temp
GROUP BY State
ORDER BY max_growth DESC;
---------wildards---------------
--Find all districts in the state of 'Maharashtra'
select * from Data1 where State ='Maharashtra'
--List all districts that start with 'N'
select * from Data1 where District like 'N%_'
select * from Data1 where District like 'N_%'
--List all districts that ends with 'N'
select * from Data1 where District like '_%n'
--find districts with exactly 10 characters in their names--
select District from Data1 where LEN(District)=10;
--Find states with a specific population range--
select District,Population from Data2 where Population Between 2741239 and 3673889
--
select * from Data1 where Sex_Ratio like '6__'
---Retrieve the districts with the highest population:
select District, Population from Data2 where Population= (select max(Population) from Data2)
------------joins---------------------

--total males and females
select d.state,sum(d.males) total_males,sum(d.females) total_females from
(select c.district,c.state state,round(c.population/(c.sex_ratio+1),0) males, round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females from
(select a.district,a.state,a.sex_ratio/1000 sex_ratio,b.population from Data1 a inner join Data2 b on a.district=b.district ) c) d
group by d.state;
-- total literacy rate-----------
select c.state,sum(literate_people) total_literate_pop,sum(illiterate_people) total_lliterate_pop from 
(select d.district,d.state,round(d.literacy_ratio*d.population,0) literate_people,
round((1-d.literacy_ratio)* d.population,0) illiterate_people from
(select a.district,a.state,a.literacy/100 literacy_ratio,b.population from Data1 a 
inner join Data2 b on a.district=b.district) d) c
group by c.state
-- population in previous census
select (g.total_area/g.previous_census_population)  as previous_census_population_vs_area, (g.total_area/g.current_census_population) as 
current_census_population_vs_area from
(select q.*,r.total_area from (

select '1' as keyy,n.* from
(select sum(m.previous_census_population) previous_census_population,sum(m.current_census_population) current_census_population from(
select e.state,sum(e.previous_census_population) previous_census_population,sum(e.current_census_population) current_census_population from
(select d.district,d.state,round(d.population/(1+d.growth),0) previous_census_population,d.population current_census_population from
(select a.district,a.state,a.growth growth,b.population from Data1 a inner join Data2 b on a.district=b.district) d) e
group by e.state)m) n) q inner join (

select '1' as keyy,z.* from (
select sum(area_km2) total_area from Data2)z) r on q.keyy=r.keyy)g


--window 

---output top 3 districts from each state with highest literacy rate


select a.* from
(select District,State,Literacy,rank() over(partition by state order by literacy desc) rnk from Data1) a

where a.rnk in (1,2,3) order by State








