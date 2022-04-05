--Question 1. What is the earliest and latest date of transactions for all members?
select min(txn_date), max(txn_date) from trading.transactions

--Question 2. What is the range of market_date values available in the prices data?
select min(market_date), max(market_date) from trading.prices

--Question 3. Which top 3 mentors have the most Bitcoin quantity as of the 29th of August?
select m.first_name, sum(
case 
when t.txn_type = 'BUY' then t.quantity 
when t.txn_type = 'SELL' then -t.quantity end) as btc_quantity 
from trading.members m
join trading.transactions t on m.member_id = t.member_id
where t.ticker = 'BTC' 
group by m.first_name
order by btc_quantity desc limit 3

