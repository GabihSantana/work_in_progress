-- Configuração do schema

-- SCHEMA CID
USE cid10;

-- Tabela de Capitulo CID *************************************************************************************
SELECT * 
	FROM cid_capitulo 
    LIMIT 5;
    
SELECT COUNT(id)qtd 
	FROM cid_capitulo; 
-- 22
    
-- A ferramenta Explain Analyze analisa o plano de execução de uma consulta SQL
-- Executa a consulta e retorna estatísticas detalhadas sobre tempo de execução e uso de recursos
-- Essa análise ajuda a identificar gargalos e otimizar consultas

EXPLAIN ANALYZE 
	SELECT * 
		FROM cid_capitulo 
		WHERE cat_inicio = 'F00';
-- O Explain Analyze nessa busca retornou uma execução rápida e pouco loops. Como a tabela é pequena, o index não será necessário.


-- Tabela de Categoria dos CIDs **************************************************************************************
SELECT * 
	FROM cid_categoria 
    LIMIT 5;
    
SELECT COUNT(id)qtd 
	FROM cid_categoria 
    LIMIT 5; 
-- 1.775
    
EXPLAIN ANALYZE 
	SELECT * FROM cid_categoria 
		WHERE id = 'F00';
-- O resultado com o Explain Analyze também mostrou-se rápido, não necessitando index.


-- Tabela de Grupo dos CIDs ****************************************************************************************
SELECT * 
	FROM cid_grupo 
	LIMIT 5;
    
SELECT COUNT(id)qtd 
	FROM cid_grupo 
    LIMIT 5; 
-- 275

EXPLAIN ANALYZE 
	SELECT * 
		FROM cid_grupo 
        WHERE cat_inicio = 'F00';
-- O retorno dessa consulta mostrou-se eficiênte devido ao tamanho da tabela, não necessitando index.

-- Tabela de Sub Categoria dos CIDs ************************************************************************************
SELECT * 
	FROM cid_sub_categoria 
	LIMIT 5;
    
SELECT COUNT(id)qtd 
	FROM cid_sub_categoria 
    LIMIT 5; 
-- 8.350

EXPLAIN ANALYZE 
	SELECT * 
		FROM cid_sub_categoria 
        WHERE id = 'F000';
-- Como a tabela possui uma volumetria pouco maior que as outras, o desempenho não foi tão satisfatório, demorando
-- poucos milissegundos, além de ter escaneado a tabela toda para encontrar o resultado. Entretando, não estarei criando index agora


-- SCHEMA SIM DATA ****************************************************************************************************
USE sim_data;

SELECT COUNT(1) 
	FROM Mortalidade_Geral_2012;
-- 1.181.167

SELECT * 
	FROM Mortalidade_Geral_2012 
    LIMIT 10;

EXPLAIN ANALYZE 
	SELECT * 
		FROM Mortalidade_Geral_2012 
        WHERE LINHAA = '*C61X';
-- Diferentemente do comportamento do schema de CIDs, essa consulta necessitou de um custo maior, além de ser executado
-- em mais tempo, sendo necessário criar index, uma vez que será uma tabela muito utilizada para futuras análises.

-- Os indexs serao criados de acordo com a necessidade dos campos para análise    
CREATE INDEX cid_obito 
	ON Mortalidade_Geral_2012(LINHAA(100));

CREATE INDEX cid_obit_B 
	ON Mortalidade_Geral_2012(LINHAB(100));
    
CREATE INDEX cid_obit_C 
	ON Mortalidade_Geral_2012(LINHAC(100));
    
CREATE INDEX cid_obit_D
	ON Mortalidade_Geral_2012(LINHAD(100));
    
CREATE INDEX cid_causa_basica_obito 
	ON Mortalidade_Geral_2012(CAUSABAS(100));

CREATE INDEX idade 
	ON Mortalidade_Geral_2012(IDADE(100));
    
CREATE INDEX nacionalidade 
	ON Mortalidade_Geral_2012(NATURAL0(100));
    
CREATE INDEX ocupacao 
	ON Mortalidade_Geral_2012(OCUP(100));
    
CREATE INDEX raca 
	ON Mortalidade_Geral_2012(RACACOR(100));
    
CREATE INDEX estado_civil 
	ON Mortalidade_Geral_2012(ESTCIV(100));
    
CREATE INDEX sexo 
	ON Mortalidade_Geral_2012(SEXO(1));
    
SHOW INDEXES 
	FROM Mortalidade_Geral_2012;

SELECT COUNT(1) 
	FROM Mortalidade_Geral_2013;
-- 1.206.736

-- Como observado, as tabelas com registros sobre mortalidade possuem uma volumetria maior.
-- A utilizacao de index em todas irá facilitiar a acelerar as consultas durante futuras análises.

SELECT * 
	FROM Mortalidade_Geral_2013 
    LIMIT 10;
    
EXPLAIN ANALYZE 
	SELECT * 
		FROM Mortalidade_Geral_2013 
        WHERE LINHAA = '*C61X';

-- Assim como visto anteriormente, o comportamento é custoso devido a volumetria da tabela. Essa busca
-- durou cerca de 4s para percorrer todas as linhas. Por conta disso, os indexes serao utilizados visando
-- otimizar o tempo de execucao.

CREATE INDEX cid_obito 
	ON Mortalidade_Geral_2013(LINHAA(100));

CREATE INDEX cid_obit_B 
	ON Mortalidade_Geral_2013(LINHAB(100));
    
CREATE INDEX cid_obit_C 
	ON Mortalidade_Geral_2013(LINHAC(100));
    
CREATE INDEX cid_obit_D
	ON Mortalidade_Geral_2013(LINHAD(100));
    
CREATE INDEX cid_causa_basica_obito 
	ON Mortalidade_Geral_2013(CAUSABAS(100));
    
CREATE INDEX idade 
	ON Mortalidade_Geral_2013(IDADE(100));
    
CREATE INDEX nacionalidade 
	ON Mortalidade_Geral_2013(NATURAL0(100));
    
CREATE INDEX ocupacao 
	ON Mortalidade_Geral_2013(OCUP(100));
    
CREATE INDEX raca 
	ON Mortalidade_Geral_2013(RACACOR(100));
    
CREATE INDEX estado_civil 
	ON Mortalidade_Geral_2013(ESTCIV(100));
    
CREATE INDEX sexo 
	ON Mortalidade_Geral_2013(SEXO(1));
    
EXPLAIN ANALYZE 
	SELECT * 
		FROM Mortalidade_Geral_2013 
        WHERE LINHAA = '*C61X';
        
-- Como retornado, o custo foi menor, tornando a busca mais eficiente. O tempo de execucao reduziu para cerca de 0,5s
-- uma melhoria comparado a tabela sem index. Essas pequenas melhorias irao otimizar na analise, visto que
-- LINHAA sera um campo frequentemente utilizado.
    
SHOW INDEXES 
	FROM Mortalidade_Geral_2013;




SELECT * 
	FROM Mortalidade_Geral_2014 
	LIMIT 10;
    
CREATE 
	INDEX cid_obito 
    ON Mortalidade_Geral_2014(LINHAA(100));
    
CREATE INDEX cid_obit_B 
	ON Mortalidade_Geral_2014(LINHAB(100));
    
CREATE INDEX cid_obit_C 
	ON Mortalidade_Geral_2014(LINHAC(100));
    
CREATE INDEX cid_obit_D
	ON Mortalidade_Geral_2014(LINHAD(100));
    
CREATE INDEX cid_causa_basica_obito 
	ON Mortalidade_Geral_2014(CAUSABAS(100));
    
CREATE INDEX idade 
	ON Mortalidade_Geral_2014(IDADE(100));
    
CREATE INDEX nacionalidade 
	ON Mortalidade_Geral_2014(NATURAL0(100));
    
CREATE INDEX ocupacao 
	ON Mortalidade_Geral_2014(OCUP(100));
    
CREATE INDEX raca 
	ON Mortalidade_Geral_2014(RACACOR(100));
    
CREATE INDEX estado_civil 
	ON Mortalidade_Geral_2014(ESTCIV(100));
    
CREATE INDEX sexo 
	ON Mortalidade_Geral_2014(SEXO(1));
    
SHOW INDEXES 
	FROM Mortalidade_Geral_2014;





SELECT * 
	FROM Mortalidade_Geral_2015 
    LIMIT 10;
    
CREATE INDEX cid_obito 
	ON Mortalidade_Geral_2015(LINHAA(100));

CREATE INDEX cid_obit_B 
	ON Mortalidade_Geral_2015(LINHAB(100));
    
CREATE INDEX cid_obit_C 
	ON Mortalidade_Geral_2015(LINHAC(100));
    
CREATE INDEX cid_obit_D
	ON Mortalidade_Geral_2015(LINHAD(100));
    
CREATE INDEX cid_causa_basica_obito 
	ON Mortalidade_Geral_2015(CAUSABAS(100));
    
CREATE INDEX idade 
	ON Mortalidade_Geral_2015(IDADE(100));
    
CREATE INDEX nacionalidade 
	ON Mortalidade_Geral_2015(NATURAL0(100));
    
CREATE INDEX ocupacao 
	ON Mortalidade_Geral_2015(OCUP(100));
    
CREATE INDEX raca 
	ON Mortalidade_Geral_2015(RACACOR(100));
    
CREATE INDEX estado_civil 
	ON Mortalidade_Geral_2015(ESTCIV(100));

CREATE INDEX sexo 
	ON Mortalidade_Geral_2015(SEXO(1));    

SHOW INDEXES 
	FROM Mortalidade_Geral_2015;





SELECT * 
	FROM Mortalidade_Geral_2016 
    LIMIT 10;
    
CREATE INDEX cid_obito 
	ON Mortalidade_Geral_2016(LINHAA(100));
    
CREATE INDEX cid_obit_B 
	ON Mortalidade_Geral_2016(LINHAB(100));
    
CREATE INDEX cid_obit_C 
	ON Mortalidade_Geral_2016(LINHAC(100));
    
CREATE INDEX cid_obit_D
	ON Mortalidade_Geral_2016(LINHAD(100));
    
CREATE INDEX cid_causa_basica_obito 
	ON Mortalidade_Geral_2016(CAUSABAS(100));
    
CREATE INDEX idade 
	ON Mortalidade_Geral_2016(IDADE(100));
    
CREATE INDEX nacionalidade 
	ON Mortalidade_Geral_2016(NATURAL0(100));
    
CREATE INDEX ocupacao 
	ON Mortalidade_Geral_2016(OCUP(100));
    
CREATE INDEX raca 
	ON Mortalidade_Geral_2016(RACACOR(100));
    
CREATE INDEX estado_civil 
	ON Mortalidade_Geral_2016(ESTCIV(100));
    
CREATE INDEX sexo 
	ON Mortalidade_Geral_2016(SEXO(1));
    
SHOW INDEXES 
	FROM Mortalidade_Geral_2016;





SELECT * 
	FROM Mortalidade_Geral_2017 
	LIMIT 10;
    
CREATE INDEX cid_obito 
	ON Mortalidade_Geral_2017(LINHAA(100));
    
CREATE INDEX cid_obit_B 
	ON Mortalidade_Geral_2017(LINHAB(100));
    
CREATE INDEX cid_obit_C 
	ON Mortalidade_Geral_2017(LINHAC(100));
    
CREATE INDEX cid_obit_D
	ON Mortalidade_Geral_2017(LINHAD(100));
    
CREATE INDEX cid_causa_basica_obito 
	ON Mortalidade_Geral_2017(CAUSABAS(100));
    
CREATE INDEX idade 
	ON Mortalidade_Geral_2017(IDADE(100));
    
CREATE INDEX nacionalidade 
	ON Mortalidade_Geral_2017(NATURAL0(100));
    
CREATE INDEX ocupacao 
	ON Mortalidade_Geral_2017(OCUP(100));
    
CREATE INDEX raca 
	ON Mortalidade_Geral_2017(RACACOR(100));
    
CREATE INDEX estado_civil 
	ON Mortalidade_Geral_2017(ESTCIV(100));
    
CREATE INDEX sexo 
	ON Mortalidade_Geral_2017(SEXO(1));
    
SHOW INDEXES 
	FROM Mortalidade_Geral_2017;





SELECT * 
	FROM Mortalidade_Geral_2018 
    LIMIT 10;
    
CREATE INDEX cid_obito 	
	ON Mortalidade_Geral_2018(LINHAA(100));
    
CREATE INDEX cid_obit_B 
	ON Mortalidade_Geral_2018(LINHAB(100));
    
CREATE INDEX cid_obit_C 
	ON Mortalidade_Geral_2018(LINHAC(100));
    
CREATE INDEX cid_obit_D
	ON Mortalidade_Geral_2018(LINHAD(100));
    
CREATE INDEX cid_causa_basica_obito 
	ON Mortalidade_Geral_2018(CAUSABAS(100));
    
CREATE INDEX idade 
	ON Mortalidade_Geral_2018(IDADE(100));
    
CREATE INDEX nacionalidade 
	ON Mortalidade_Geral_2018(NATURAL0(100));
    
CREATE INDEX ocupacao 
	ON Mortalidade_Geral_2018(OCUP(100));
    
CREATE INDEX raca 
	ON Mortalidade_Geral_2018(RACACOR(100));
    
CREATE INDEX estado_civil 
	ON Mortalidade_Geral_2018(ESTCIV(100));
    
CREATE INDEX sexo 
	ON Mortalidade_Geral_2018(SEXO(1));
    
SHOW INDEXES 
	FROM Mortalidade_Geral_2018;





SELECT * 
	FROM Mortalidade_Geral_2019 
    LIMIT 10;
    
CREATE INDEX cid_obito 
	ON Mortalidade_Geral_2019(LINHAA(100));
    
CREATE INDEX cid_obit_B 
	ON Mortalidade_Geral_2019(LINHAB(100));
    
CREATE INDEX cid_obit_C 
	ON Mortalidade_Geral_2019(LINHAC(100));
    
CREATE INDEX cid_obit_D
	ON Mortalidade_Geral_2019(LINHAD(100));
    
CREATE INDEX cid_causa_basica_obito 
	ON Mortalidade_Geral_2019(CAUSABAS(100));
    
CREATE INDEX idade 
	ON Mortalidade_Geral_2019(IDADE(100));
    
CREATE INDEX nacionalidade 
	ON Mortalidade_Geral_2019(NATURAL0(100));

CREATE INDEX ocupacao 
	ON Mortalidade_Geral_2019(OCUP(100));
    
CREATE INDEX raca 
	ON Mortalidade_Geral_2019(RACACOR(100));
    
CREATE INDEX estado_civil 
	ON Mortalidade_Geral_2019(ESTCIV(100));
    
CREATE INDEX sexo 
	ON Mortalidade_Geral_2019(SEXO(1));
    
SHOW INDEXES 
	FROM Mortalidade_Geral_2019;





SELECT * 
	FROM Mortalidade_Geral_2020 
		LIMIT 10;
        
CREATE INDEX cid_obito 
	ON Mortalidade_Geral_2020(LINHAA(100));
    
CREATE INDEX cid_obit_B 
	ON Mortalidade_Geral_2020(LINHAB(100));
    
CREATE INDEX cid_obit_C 
	ON Mortalidade_Geral_2020(LINHAC(100));
    
CREATE INDEX cid_obit_D
	ON Mortalidade_Geral_2020(LINHAD(100));
    
CREATE INDEX cid_causa_basica_obito 
	ON Mortalidade_Geral_2020(CAUSABAS(100));
    
CREATE INDEX idade 
	ON Mortalidade_Geral_2020(IDADE(100));
    
CREATE INDEX nacionalidade 
	ON Mortalidade_Geral_2020(NATURAL0(100));
    
CREATE INDEX ocupacao 
	ON Mortalidade_Geral_2020(OCUP(100));
    
CREATE INDEX raca 
	ON Mortalidade_Geral_2020(RACACOR(100));
    
CREATE INDEX estado_civil 
	ON Mortalidade_Geral_2020(ESTCIV(100));
    
CREATE INDEX sexo 
	ON Mortalidade_Geral_2020(SEXO(1));
    
SHOW INDEXES 
	FROM Mortalidade_Geral_2020;





SELECT * 
	FROM Mortalidade_Geral_2021 
    LIMIT 10;
    
CREATE INDEX cid_obito 
	ON Mortalidade_Geral_2021(LINHAA(100));
    
CREATE INDEX cid_obit_B 
	ON Mortalidade_Geral_2021(LINHAB(100));
    
CREATE INDEX cid_obit_C 
	ON Mortalidade_Geral_2021(LINHAC(100));
    
CREATE INDEX cid_obit_D
	ON Mortalidade_Geral_2021(LINHAD(100));
    
CREATE INDEX cid_causa_basica_obito 
	ON Mortalidade_Geral_2021(CAUSABAS(100));
    
CREATE INDEX idade 
	ON Mortalidade_Geral_2021(IDADE(100));
    
CREATE INDEX nacionalidade 
	ON Mortalidade_Geral_2021(NATURAL0(100));
    
CREATE INDEX ocupacao 
	ON Mortalidade_Geral_2021(OCUP(100));
    
CREATE INDEX raca 
	ON Mortalidade_Geral_2021(RACACOR(100));
    
CREATE INDEX estado_civil 
	ON Mortalidade_Geral_2021(ESTCIV(100));
    
CREATE INDEX sexo 
	ON Mortalidade_Geral_2021(SEXO(1));
    
SHOW INDEXES 
	FROM Mortalidade_Geral_2021;





SELECT * 
	FROM Mortalidade_Geral_2022 
    LIMIT 10;
    
CREATE INDEX cid_obito 
	ON Mortalidade_Geral_2022(LINHAA(100));
    
CREATE INDEX cid_obit_B 
	ON Mortalidade_Geral_2022(LINHAB(100));
    
CREATE INDEX cid_obit_C 
	ON Mortalidade_Geral_2022(LINHAC(100));
    
CREATE INDEX cid_obit_D
	ON Mortalidade_Geral_2022(LINHAD(100));
    
CREATE INDEX cid_causa_basica_obito 
	ON Mortalidade_Geral_2022(CAUSABAS(100));
    
CREATE INDEX idade 
	ON Mortalidade_Geral_2022(IDADE(100));
    
CREATE INDEX nacionalidade 
	ON Mortalidade_Geral_2022(NATURAL0(100));
    
CREATE INDEX ocupacao 
	ON Mortalidade_Geral_2022(OCUP(100));
    
CREATE INDEX raca 
	ON Mortalidade_Geral_2022(RACACOR(100));
    
CREATE INDEX estado_civil 
	ON Mortalidade_Geral_2022(ESTCIV(100));
    
CREATE INDEX sexo 
	ON Mortalidade_Geral_2022(SEXO(1));
    
SHOW INDEXES 
	FROM Mortalidade_Geral_2022;

-- Idexes criados nos campos que mais serao utilizados para as analises

SELECT COUNT(1) 
	FROM Nacionalidade; 
-- 69

SELECT COUNT(1) 
	FROM Ocupacao; 
-- 2430



