-- Procedure para auxiliar na análise

DROP PROCEDURE IF EXISTS SPR_Analise_Exploratoria_Alzheimer;

-- Query precisa ser dinâmica porque a tabela e a coluna vão mudar a cada chamada da proc
DELIMITER $$
CREATE PROCEDURE sim_data.SPR_Analise_Exploratoria_Alzheimer(IN tabela VARCHAR(100), 
															 IN coluna VARCHAR(50))
BEGIN 
	-- variavel p armazenar os resultados do select
	DECLARE linhas INT;

	SET @query1 = CONCAT('SELECT COUNT(*) INTO @linhas FROM ', tabela, ' WHERE ', coluna, ' IN (''*F000'', ''*F001'', ''*F002'', ''*F009'');');
    
    PREPARE stmt from @query1;
    EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
    
    SET linhas = @linhas;
    
    IF linhas > 0 THEN
		SET @query2 = CONCAT(
				'SELECT 
					a.dtnasc as Data_Nascimento, 
					a.idade as Cod_Idade, 
					c.Idade as Idade, 
                    a.natural0 as Cod_Naturalidade,
					e.Locais,
					a.sexo as Cod_Sexo, 
                    CASE WHEN a.sexo = 1 THEN ''Masculino'' 
						ELSE ''Feminino'' END as Sexo,
					a.racacor as Cod_Racacor, 
                    CASE WHEN a.racacor = 1 THEN ''Branca'' 
						WHEN a.racacor = 2 THEN ''Preta''
                        WHEN a.racacor = 3 THEN ''Amarela''
                        WHEN a.racacor = 4 THEN ''Parda''
                        WHEN a.racacor = 5 THEN ''Indígena''
                        ELSE ''Não Identificado'' END as RacaCor,
					a.estciv, 
					CASE WHEN a.estciv = 1 THEN ''Solteiro''
						WHEN a.estciv = 2 THEN ''Casado''
						WHEN a.estciv = 3 THEN ''Viúvo''
						WHEN a.estciv = 4 THEN ''Separado/Divorciado''
						WHEN a.estciv = 5 THEN ''União Estável''
						ELSE ''Ignorado'' END as EstadoCivil,
					a.esc, 
					CASE WHEN a.esc = 1 THEN ''Nenhuma''
						WHEN a.esc = 2 THEN ''de 1 a 3 anos'' 
						WHEN a.esc = 3 THEN ''de 4 a 7 anos''
						WHEN a.esc = 4 THEN ''8 a 11 anos''
						WHEN a.esc = 5 THEN ''12 anos e mais''
						ELSE ''Ignorado'' END as Escolaridade,
					a.ocup, 
					b.Profissao, 
					a.assistmed,
					CASE WHEN a.assistmed = 1 THEN ''Sim''
						WHEN a.assistmed = 2 THEN ''Não''
						ELSE ''Ignorado'' END as AssistenciaMedica,
					a.necropsia, 
					CASE WHEN a.necropsia = 1 THEN ''Sim''
						WHEN a.necropsia = 2 THEN ''Não''
						ELSE ''Ignorado'' END AS Necropsia,
					a.linhaa, 
					a.linhab, 
					a.linhac, 
					d.descricao as LinhaC_Cid,
					a.causabas
				FROM ', tabela, ' a
				LEFT JOIN Ocupacao b ON a.ocup = b.Codigo
				INNER JOIN Idade c ON a.idade = c.Cod_Idade
				INNER JOIN cid10.cid_sub_categoria d ON REPLACE(a.LINHAC, ''*'','''') = d.id
				LEFT JOIN Nacionalidade e ON e.Cod_locais = a.natural0
				WHERE a.LINHAB IN (''*F000'', ''*F001'', ''*F002'', ''*F009'');'
			);
		PREPARE stmt2 FROM @query2;
		EXECUTE stmt2;
		DEALLOCATE PREPARE stmt2;
    
    END IF;
    
END $$
DELIMITER ;