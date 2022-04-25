--Step 1. Create a base table that has each mentor's name, region and end of year total quantity for each ticker

DROP TABLE IF EXISTS temp_portfolio_base;
CREATE TEMP TABLE temp_portfolio_base AS
WITH cte_joined_data AS (
  SELECT
    members.first_name,
    members.region,
    transactions.txn_date,
    transactions.ticker,
    CASE
      WHEN transactions.txn_type = 'SELL' THEN -transactions.quantity
      ELSE transactions.quantity
    END AS adjusted_quantity
  FROM trading.transactions
  INNER JOIN trading.members
    ON transactions.member_id = members.member_id
  WHERE transactions.txn_date <= '2020-12-31'
)
SELECT
  first_name,
  region,
  (DATE_TRUNC('YEAR', txn_date) + INTERVAL '12 MONTHS' - INTERVAL '1 DAY')::DATE AS year_end,
  ticker,
  SUM(adjusted_quantity) AS yearly_quantity
FROM cte_joined_data
GROUP BY first_name, region, year_end, ticker;

--Step 2. Inspect the year_end, ticker and yearly_quantity values from our new temp table temp_portfolio_base for Mentor Abe only.
select year_end, ticker, yearly_quantity from temp_portfolio_base
where first_name = 'Abe'
order by ticker;

--Step 3. Create a cumulative sum for Abe which has an independent value for each ticker

select year_end, ticker, yearly_quantity, 
SUM(yearly_quantity) OVER(partition by ticker order by year_end rows between unbounded preceding and current row) as cumulative_sum
from temp_portfolio_base
where first_name = 'Abe'
order by ticker, year_end;

--Step 4. Generate an additional cumulative_quantity column for the temp_portfolio_base temp table
--incorrect
alter table temp_portfolio_base
add cumulative_sum numeric;

update temp_portfolio_base
set(cumulative_sum) = (select SUM(yearly_quantity) over (partition by first_name, ticker order by year_end rows between unbounded preceding and current row));

select year_end, ticker, yearly_quantity, cumulative_sum from temp_portfolio_base
where first_name = 'Abe'
order by ticker, year_end;

