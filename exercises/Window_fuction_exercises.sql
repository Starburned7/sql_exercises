--1. What are the market_date, price and volume and price_rank values for each tickers in the trading.prices table?
select ticker, market_date, price, volume, RANK() OVER (
    PARTITION BY ticker
    ORDER BY price DESC
  ) AS price_rank
  from trading.prices

--2. What are the market_date, price and volume and price_rank values for the days with the top 5 highest price values for each tickers in the trading.prices table?
with cte_rank as(select ticker, market_date, price, volume, RANK() OVER (
    PARTITION BY ticker
    ORDER BY price DESC
  ) AS price_rank
  from trading.prices)
  
  select * from cte_rank
  where price_rank <=5
  order by ticker, price_rank
  
-- 3. Calculate a 7 day rolling average for the price and column in the trading.prices table for each ticker.

with cte_moving_averages as(select ticker,market_date, price, AVG(price) OVER (
  PARTITION BY ticker
  ORDER BY market_date
  RANGE BETWEEN '7 DAYS' PRECEDING AND CURRENT ROW
) AS moving_avg_price

from trading.prices)

select * from cte_moving_averages
where market_date between '2021-08-01' and '2021-08-10'
order by ticker, moving_avg_price
