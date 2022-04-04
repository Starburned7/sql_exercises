--Question 1. How many total records do we have in the trading.prices table?
select count(*) from trading.prices

--Question 2. How many records are there per ticker value?
select ticker, count(*) from trading.prices
group by ticker

--Question 3.What is the minimum and maximum market_date values?
select min(market_date), max(market_date) from trading.prices

--Question 4.Are there differences in the minimum and maximum market_date values for each ticker?
select ticker, min(market_date), max(market_date) from trading.prices
group by ticker

-- Question 5. What is the average of the price column for Bitcoin records during the year 2020?
select avg(price) from trading.prices
where ticker='BTC' and 
market_date between '2020-01-01' and '2020-12-31'

--Question 6. What is the monthly average of the price column for Ethereum in 2020?
-- Sort the output in chronological order and also round the average price value to 2 decimal places
select DATE_TRUNC('MON', market_date) as month, ROUND(AVG(price)::NUMERIC, 2) from trading.prices
where ticker='ETH' 
--and market_date between '2020-01-01' and '2020-12-31' 
and EXTRACT(YEAR FROM market_date) = 2020
group by month
order by month;

--Question 7. Are there any duplicate market_date values for any ticker value in our table?
select ticker, count(market_date) as total_count,
count(distinct market_date) as unique_count from trading.prices
group by ticker

--Question 8. How many days from the trading.prices table exist where the high price of Bitcoin is over $30,000?
select count(*) from trading.prices
where ticker = 'BTC'
and high > 30000  

--Question 9. How many "breakout" days were there in 2020 where the price column is greater than the open column for each ticker?
select ticker, count(*) from trading.prices
where price > open and EXTRACT(YEAR FROM market_date) = 2020
group by ticker

--Question 10. How many "non_breakout" days were there in 2020 where the price column is less than the open column for each ticker?
select ticker, count(*) from trading.prices
where price < open and EXTRACT(YEAR FROM market_date) = 2020
group by ticker;

--Question 11. What percentage of days in 2020 were breakout days vs non-breakout days? Round the percentages to 2 decimal places
SELECT
  ticker,
  ROUND(SUM(CASE WHEN price > open THEN 1 ELSE 0 END) / COUNT(*)::NUMERIC, 2)  AS breakout_days ,
  ROUND(SUM(CASE WHEN price < open THEN 1 ELSE 0 END) /  COUNT(*)::NUMERIC, 2)  AS non_breakout_days
FROM trading.prices
WHERE EXTRACT(YEAR FROM market_date) = 2020
GROUP BY ticker;
