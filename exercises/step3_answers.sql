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
