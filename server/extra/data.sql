insert into method values ('FIFO'), ('LIFO');


insert into unit values 
('unit'),
('kg'),
('l'),
('m'),
('kapoaka'),
('gony'),
('tavoangy');


insert into unit_conversion values
('kg', 'kapoaka', 3), -- 1 kg -> 3 kapoaka
('gony', 'kg', 50), -- 1 gony -> 50 kg
('tavoangy', 'l', 1.5); -- 1 tavoangy -> 1.5 l


insert into article values
-- Vary
---- Vary fotsy
('V_F010', 'Vary makalioka', 'kg', 'LIFO'),
('V_F011', 'Vary tsipala', 'kg', 'LIFO'),
---- Vary mena
('V_F110', 'Vary gasy', 'kg', 'LIFO'),
('V_F111', 'Vary mena', 'kg', 'LIFO'),

-- Menaka
('ME_010', 'Menaka madio', 'l', 'FIFO'),
('ME_011', 'Menaka mandry', 'l', 'FIFO');


insert into article_valid_unit values
('V_F010', 'kapoaka'),
('V_F010', 'gony'),
('V_F011', 'kapoaka'),
('V_F011', 'gony'),
('V_F110', 'kapoaka'),
('V_F110', 'gony'),
('V_F111', 'kapoaka'),
('V_F111', 'gony'),
('ME_010', 'tavoangy'),
('ME_011', 'tavoangy');


insert into store values 
('M_TANA_0', 'Analakely'),
('M_TANA_1', 'Behoririka'),
('M_JANGA_0', 'Bord');


-- IN
insert into validated_stock_transaction (id, action_date, action_type, store_code, article_code, quantity, unit_price) values
  (1,'2018-01-01', 'IN', 'M_TANA_0', 'V_F010', 100, 600), -- Incoming stock of 'Vary makalioka' - 100 kg at unit price AR600
  (2,'2018-01-02', 'IN', 'M_TANA_0', 'V_F011', 50, 550),  -- Incoming stock of 'Vary tsipala' - 50 kg at unit price AR550
  (3,'2018-01-03', 'IN', 'M_TANA_0', 'V_F110', 80, 620),  -- Incoming stock of 'Vary gasy' - 80 kg at unit price AR620
  (4,'2018-01-04', 'IN', 'M_TANA_1', 'V_F110', 60, 620), -- Incoming stock of 'Vary mena' - 60 kg at unit price AR620
  (5,'2018-01-05', 'IN', 'M_JANGA_0', 'ME_010', 20, 3000), -- Incoming stock of 'Menaka madio' - 20 liters at unit price AR3000
  (6,'2018-01-05', 'IN', 'M_JANGA_0', 'ME_011', 20, 2500), -- Incoming stock of 'Menaka mandry' - 20 liters at unit price AR2500
  (7,'2018-02-06', 'IN', 'M_TANA_0', 'V_F010', 150, 650), -- Incoming stock of 'Vary makalioka' - 150 kg at unit price AR650
  (8,'2018-02-06', 'IN', 'M_TANA_0', 'V_F011', 50, 550); -- Incoming stock of 'Vary tsipala' - 50 kg at unit price AR550

-- OUT
insert into validated_stock_transaction (source_id, action_date, action_type, store_code, article_code, quantity) values
  (1, '2018-01-03', 'OUT', 'M_TANA_0', 'V_F010', 25), -- Outgoing stock of 'Vary makalioka' - 25 kg at unit price AR600
  (1, '2018-02-10', 'OUT', 'M_TANA_0', 'V_F010', 60); -- Outgoing stock of 'Vary makalioka' - 60 kg at unit price AR650