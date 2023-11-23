-- 
SELECT * FROM get_entry_stock_movement_summary('2018-01-01', '2018-03-01', '%', '%');

-- 
SELECT * FROM get_stock_outflow_summary('2018-01-01', '2018-03-01', '%', '%');

--
SELECT * FROM get_stock_state('2018-02-10', '%', '%');

-- 
select * from stock_state('2018-01-01', '2018-02-11', '%', '%');
-- Stock state per article BETWEEN 2 dates and specific articles
SELECT * FROM stock_state_avg('2018-01-01', '2018-02-06', 'M%', 'V%');

-- Latest REP for an article and per unit_price
SELECT * FROM get_latest_rep('M_TANA_0', 'V_F010', 600);
