insert into article values
('RR', 'Riz Rouge', 'kg', 'LIFO'),
('RBS', 'Riz Blanc Stock', 'kg', 'LIFO');

insert into store values
('M1', 'Magasin 1');

insert into validated_stock_transaction (id, action_date, action_type, store_code, article_code, quantity, unit_price) values
(1,'2020-09-01', 'IN', 'M1', 'RR', 1000, 2000),
(2, '2021-11-01', 'IN', 'M1', 'RR', 500, 2300),
(4, '2021-11-01', 'IN', 'M1', 'RBS', 500, 1500),
(5, '2021-11-01', 'IN', 'M1', 'RBS', 1400, 1700),
(6, '2021-11-01', 'IN', 'M1', 'RBS', 1000, 2000),
(3, '2021-12-03', 'IN', 'M1', 'RR', 200, 2500);

insert into validated_stock_transaction (id, source_id, action_date, action_type, store_code, article_code, quantity) values
  (7, 1, '2021-12-02', 'OUT', 'M1', 'RR', 1000), 
  (8, 2, '2021-12-02', 'OUT', 'M1', 'RR', 200),
  (9, 2, '2021-12-04', 'OUT', 'M1', 'RR', 300),
  (10, 3, '2021-12-04', 'OUT', 'M1', 'RR', 100);
