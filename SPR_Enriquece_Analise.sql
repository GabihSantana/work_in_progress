-- DROP PROCEDURE sim_data.SPR_Analise_Exploratoria_Alzheimer;

DELIMITER $$
CREATE PROCEDURE sim_data.SPR_Enriquece_Analise(IN tabela VARCHAR(100))
BEGIN 
    DECLARE CIDs VARCHAR(100);
    DECLARE TabelaTemp VARCHAR(100);
    DECLARE nomeTabelaFinal VARCHAR(100);
    
    SET CIDs := '''F000'', ''F001'', ''F002'', ''F009'', ''G300'', ''G301'', ''G308'', ''G309''';
	SET TabelaTemp := CONCAT(tabela, '_temp');
    SET nomeTabelaFinal := CONCAT(tabela, '_analise');
    

	-- Dropar as tabelas se já existir
    SET @cleanQueryTemp = Concat('DROP TABLE IF EXISTS ', TabelaTemp, ';');
    PREPARE clear FROM @cleanQueryTemp;
	EXECUTE clear;
	DEALLOCATE PREPARE clear;
    
	SET @cleanQueryFinal = Concat('DROP TABLE IF EXISTS ', nomeTabelaFinal, ';');
    PREPARE clear2 FROM @cleanQueryFinal;
	EXECUTE clear2;
	DEALLOCATE PREPARE clear2;

	-- Criar tabela temporária com os casos de Alzheimer - Extrair dados da tabela principal
    SET @query1 = CONCAT('
		CREATE TABLE IF NOT EXISTS ', TabelaTemp, ' AS
	SELECT DISTINCT CONTADOR,
		ORIGEM,
		TIPOBITO,
		CODMUNCART,
		NUMREGCART,
		DTREGCART,
		DTOBITO,
		HORAOBITO,
		NATURAL0,
		DTNASC,
		IDADE,
		SEXO,
		RACACOR,
		ESTCIV,
		ESC,
		SERIESCFAL,
		ESCMAEAGR1,
		ESCFALAGR1,
		OCUP,
		CODMUNRES,
		LOCOCOR,
		CODESTAB,
		CODMUNOCOR,
		IDADEMAE,
		ESCMAE,
		SERIESCMAE,
		OCUPMAE,
		QTDFILVIVO,
		QTDFILMORT,
		GRAVIDEZ,
		SEMAGESTAC,
		GESTACAO,
		PARTO,
		OBITOPARTO,
		PESO,
		TPMORTEOCO,
		OBITOGRAV,
		OBITOPUERP,
		ASSISTMED,
		EXAME,
		CIRURGIA,
		NECROPSIA,
		REPLACE(LINHAA, ''*'', '''') AS LINHAA,
		REPLACE(LINHAB, ''*'', '''') AS LINHAB,
		REPLACE(LINHAC, ''*'', '''') AS LINHAC,
		REPLACE(LINHAD, ''*'', '''') AS LINHAD,
		LINHAII,
		CAUSABAS,
		COMUNSVOIM,
		DTATESTADO,
		CIRCOBITO,
		ACIDTRAB,
		FONTE,
		TPPOS,
		DTINVESTIG,
		CAUSABAS_O,
		DTCADASTRO,
		ATESTANTE,
		FONTEINV,
		DTRECEBIM,
		DTRECORIG,
		DTRECORIGA,
		CAUSAMAT,
		ESC2010,
		ESCMAE2010,
		EXPDIFDATA,
		DIFDATA,
		STDOEPIDEM,
		STDONOVA,
		DTCADINV,
		TPOBITOCOR,
		DTCONINV,
		DTCADINF,
		MORTEPARTO,
		DTCONCASO,
		NUDIASOBIN
	FROM ', tabela,
    ' WHERE REPLACE(LINHAA, ''*'', '''') IN (', CIDs, ') OR
		REPLACE(LINHAB, ''*'', '''') IN (',  CIDs, ') OR
        REPLACE(LINHAC, ''*'', '''') IN (',  CIDs, ') OR
        REPLACE(LINHAD, ''*'', '''') IN (',  CIDs, ') ;'
    );
    
	PREPARE stmt from @query1;
    EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
    
    -- Enriquecer a tabela temporária com as informações de tabelas externas
    SET @query2 = CONCAT(
			'CREATE TABLE IF NOT EXISTS ', nomeTabelaFinal, ' AS
				SELECT DISTINCT
					a.CONTADOR,
					a.dtnasc as Data_Nascimento, 
					a.idade as Cod_Idade, 
					I.Idade as Idade, 
					a.natural0 as Cod_Naturalidade,
					N.Locais,
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
					O.Profissao, 
					a.assistmed,
					CASE WHEN a.assistmed = 1 THEN ''Sim''
						WHEN a.assistmed = 2 THEN ''Não''
						ELSE ''Ignorado'' END as AssistenciaMedica,
					a.necropsia, 
					CASE WHEN a.necropsia = 1 THEN ''Sim''
						WHEN a.necropsia = 2 THEN ''Não''
						ELSE ''Ignorado'' END AS HouveNecropsia,
					a.linhaa, 
					M.descricao as LinhaA_Cid,
					a.linhab, 
					B.descricao as LinhaB_Cid,
					a.linhac, 
					C.descricao as LinhaC_Cid,
					a.linhad,
					D.descricao as LinhaD_Cid,
					a.causabas
					FROM ', TabelaTemp, ' a
					LEFT JOIN Ocupacao O ON a.ocup = O.Codigo
					LEFT JOIN Idade I ON a.idade = I.Cod_Idade
					LEFT JOIN Nacionalidade N ON a.natural0 = N.Cod_locais
					LEFT JOIN cid10.cid_sub_categoria M ON a.LINHAA = M.id
					LEFT JOIN cid10.cid_sub_categoria B ON a.LINHAB = B.id
					LEFT JOIN cid10.cid_sub_categoria C ON a.LINHAC = C.id
					LEFT JOIN cid10.cid_sub_categoria D ON a.LINHAD = D.id;'
			);
    
	PREPARE stmt from @query2;
    EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
    
    -- Deletar a tabela temporária
    SET @delete = CONCAT('DROP TABLE ', TabelaTemp, ';');
	PREPARE del from @delete;
    EXECUTE del;
	DEALLOCATE PREPARE del;
    
    
    -- Retornar a tabela enriquecida
	SELECT CONCAT(nomeTabelaFinal);
    
END $$
DELIMITER ;