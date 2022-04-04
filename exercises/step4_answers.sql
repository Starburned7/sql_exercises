--Question 1. How many records are there in the trading.transactions table?
select count(*) from trading.transactions

--Question 2. How many unique transactions are there?
select count(distinct txn_id) from trading.transactions

--Question 3.How many buy and sell transactions are there for Bitcoin?
select txn_type, count(txn_id) from trading.transactions
where ticker= 'BTC'
group by txn_type

/*Question 4
For each year, calculate the following buy and sell metrics for Bitcoin:
total transaction count
total quantity
average quantity per transaction
Also round the quantity columns to 2 decimal places.*/
select extract(year from txn_date) as year, txn_type, count(txn_id), 
round(sum(quantity):: numeric,2) as total_transactions, 
round(avg(quantity):: numeric,2) as average_quantity  
from trading.transactions
group by year, txn_type
order by year

--Question 5. What was the monthly total quantity purchased and sold for Ethereum in 2020?
select extract(month from txn_date) as month,
sum(case when txn_type='BUY' then quantity else 0 end) as quantity_purchased,
sum(case when txn_type='SELL'then quantity else 0 end) as quantity_sold
from trading.transactions
where ticker = 'ETH' and extract(year from txn_date)= 2020
group by month

--Question 6. Summarise all buy and sell transactions for each member_id by generating 1 row for each member with the following additional columns:

/*Bitcoin buy quantity
Bitcoin sell quantity
Ethereum buy quantity
Ethereum sell quantity*/
select member_id, 
sum(case when txn_type='BUY' and ticker= 'BTC' then quantity else 0 end) as bth_buy_quantity,
sum(case when txn_type='SELL' and ticker= 'BTC' then quantity else 0 end) as bth_sell_quantity,
sum(case when txn_type='BUY' and ticker= 'ETH' then quantity else 0 end) as eth_buy_quantity,
sum(case when txn_type='SELL' and ticker= 'ETH' then quantity else 0 end) as eth_sell_quantity
from trading.transactions
group by member_id

--Question 7. What was the final quantity holding of Bitcoin for each member? Sort the output from the highest BTC holding to lowest
select member_id, 
sum(case 
when txn_type ='BUY' then quantity 
when txn_type ='SELL' then -quantity
else 0 end) as final_btc_amount
from trading.transactions
where ticker = 'BTC'
group by member_id
order by final_btc_amount desc
