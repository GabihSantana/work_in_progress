-- Explorando a Tabela CID
use cid10;

select * from cid_capitulo limit 5;
SELECT COUNT(id)qtd from cid_capitulo; -- 22

select * from cid_categoria limit 5;
SELECT COUNT(id)qtd from cid_categoria limit 5; -- 1.775

select * from cid_grupo limit 5;
SELECT COUNT(id)qtd from cid_grupo limit 5; -- 275

select * from cid_sub_categoria limit 5;
SELECT COUNT(id)qtd from cid_sub_categoria limit 5; -- 8.350

SHOW INDEXES FROM cid_capitulo;

CREATE INDEX id_cid ON cid_capitulo(id);
CREATE INDEX id_cat ON cid_capitulo(cat_inicio);

select * from cid_capitulo where cat_inicio = 'F00';

-- SIM DATA
USE sim_data;
SELECT * FROM Mortalidade_Geral_2012 LIMIT 10;
CREATE INDEX cid_obito ON Mortalidade_Geral_2012(LINHAA(100));
SHOW INDEXES FROM Mortalidade_Geral_2012;

SELECT * FROM Mortalidade_Geral_2013 LIMIT 10;
CREATE INDEX cid_obito ON Mortalidade_Geral_2013(LINHAA(100));
SHOW INDEXES FROM Mortalidade_Geral_2013;

SELECT * FROM Mortalidade_Geral_2014 LIMIT 10;
CREATE INDEX cid_obito ON Mortalidade_Geral_2014(LINHAA(100));
SHOW INDEXES FROM Mortalidade_Geral_2014;

SELECT * FROM Mortalidade_Geral_2012 LIMIT 10;
CREATE INDEX cid_obito ON Mortalidade_Geral_2015(LINHAA(100));
SHOW INDEXES FROM Mortalidade_Geral_2015;

SELECT * FROM Mortalidade_Geral_2016 LIMIT 10;
CREATE INDEX cid_obito ON Mortalidade_Geral_2016(LINHAA(100));
SHOW INDEXES FROM Mortalidade_Geral_2016;

SELECT * FROM Mortalidade_Geral_2017 LIMIT 10;
CREATE INDEX cid_obito ON Mortalidade_Geral_2017(LINHAA(100));
SHOW INDEXES FROM Mortalidade_Geral_2017;

SELECT * FROM Mortalidade_Geral_2018 LIMIT 10;
CREATE INDEX cid_obito ON Mortalidade_Geral_2018(LINHAA(100));
SHOW INDEXES FROM Mortalidade_Geral_2018;

SELECT * FROM Mortalidade_Geral_2019 LIMIT 10;
CREATE INDEX cid_obito ON Mortalidade_Geral_2019(LINHAA(100));
SHOW INDEXES FROM Mortalidade_Geral_2019;

SELECT * FROM Mortalidade_Geral_2020 LIMIT 10;
CREATE INDEX cid_obito ON Mortalidade_Geral_2020(LINHAA(100));
SHOW INDEXES FROM Mortalidade_Geral_2020;

SELECT * FROM Mortalidade_Geral_2021 LIMIT 10;
CREATE INDEX cid_obito ON Mortalidade_Geral_2021(LINHAA(100));
SHOW INDEXES FROM Mortalidade_Geral_2021;

SELECT * FROM Mortalidade_Geral_2022 LIMIT 10;
CREATE INDEX cid_obito ON Mortalidade_Geral_2022(LINHAA(100));
SHOW INDEXES FROM Mortalidade_Geral_2022;

SELECT * from Mortalidade_Geral_2012 where LINHAA IN ('*F000','*F001','*F002', '*F009','*G300','*G301','*G308','*G309');

select count(*) from Mortalidade_Geral_2012;
SELECT * from Mortalidade_Geral_2022 WHERE DTOBITO = 21042022;

select * from Nacionalidade;
select * from Ocupacao;

