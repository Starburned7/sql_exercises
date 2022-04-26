--Q1. What is the total portfolio value for each mentor at the end of 2020?
select t.first_name,
round(sum(t.cumulative_quantity * prices.price)::NUMERIC, 2) as portfolio_value
from temp_cumulative_portfolio_base t
join trading.prices on t.ticker = prices.ticker
and t.year_end = prices.market_date
where t.year_end = '2020-12-31'
group by t.first_name
order by portfolio_value desc;

--Q2. What is the total portfolio value for each region at the end of 2019?
select t.region,
round(sum(t.cumulative_quantity * prices.price)::NUMERIC, 2) as portfolio_value
from temp_cumulative_portfolio_base t
join trading.prices on t.ticker = prices.ticker
and t.year_end = prices.market_date
where t.year_end = '2019-12-31'
group by t.region
order by portfolio_value desc;

--Q3.What percentage of regional portfolio values does each mentor contribute at the end of 2018?

--Part 1.
with cte_mentor_portfolio as(
select t.region, t.first_name,
round(sum(t.cumulative_quantity * prices.price)::NUMERIC, 2) as portfolio_value
from temp_cumulative_portfolio_base t
join trading.prices on t.ticker = prices.ticker
and t.year_end = prices.market_date
where t.year_end = '2018-12-31'
group by t.first_name, t.region
order by portfolio_value desc, first_name desc)
select * from cte_mentor_portfolio limit 5;

--Part 2.
cte_region_portfolio as(
select region, first_name, portfolio_value,
sum(portfolio_value) over(partition by region) as region_total
from cte_mentor_portfolio)

select * from cte_region_portfolio limit 5;

--Final
select region, first_name,
round((portfolio_value/region_total) *100,2) as contribution_percentage
from cte_region_portfolio
order by region_total desc, contribution_percentage desc;

--Complete query
with cte_mentor_portfolio as(
select t.region, t.first_name,
round(sum(t.cumulative_quantity * prices.price)::NUMERIC, 2) as portfolio_value
from temp_cumulative_portfolio_base t
join trading.prices on t.ticker = prices.ticker
and t.year_end = prices.market_date
where t.year_end = '2018-12-31'
group by t.first_name, t.region
order by portfolio_value desc, first_name desc),

cte_region_portfolio as(
select region, first_name, portfolio_value,
sum(portfolio_value) over(partition by region) as region_total
from cte_mentor_portfolio)

select region, first_name,
round((portfolio_value/region_total) *100,2) as contribution_percentage
from cte_region_portfolio
order by region_total desc, contribution_percentage desc;

----Q4. Does this region contribution percentage change when we look across both Bitcoin and Ethereum portfolios independently at the end of 2017?
with cte_mentor_portfolio as(
select t.region, t.first_name,t.ticker,
round(sum(t.cumulative_quantity * prices.price)::NUMERIC, 2) as portfolio_value
from temp_cumulative_portfolio_base t
join trading.prices on t.ticker = prices.ticker
and t.year_end = prices.market_date
where t.year_end = '2017-12-31'
group by t.ticker,t.first_name, t.region
order by portfolio_value desc, first_name desc),

cte_region_portfolio as(
select region, first_name,ticker, portfolio_value,
sum(portfolio_value) over(partition by region, ticker) as region_total
from cte_mentor_portfolio)

select region, first_name,ticker,
round((portfolio_value/region_total) *100,2) as contribution_percentage
from cte_region_portfolio
order by ticker, region, contribution_percentage desc;

--Q5.Calculate the ranks for each mentor in the US and Australia for each year and ticker
select year_end, region
select year_end, region, first_name, ticker,
rank() over(partition by region, year_end
order by cumulative_quantity desc) as ranking
from temp_cumulative_portfolio_base
where region in('United States', 'Australia')
order by year_end, region, ranking;






