#!/bin/bash


echo "===============TRANSFORM================"
./csvtosql/csvtosql-bin  ./utf8/Mortalidade_Geral_2012.csv > ./sql/Mortalidade_Geral_2012.sql

echo "================LOADER=================="
mysql -u developer --password=ifsp@123 cid10  < ./sql/Mortalidade_Geral_2012.sql

echo "================ CONTAGEM VALIDAÇÃO ARQUIVOS =================="

echo "Mortalidade_Geral_2012.csv"
wc -l Mortalidade_Geral_2012.csv
wc -l ./sql/Mortalidade_Geral_2012.sql

echo "================ CONTAGEM VALIDAÇÃO BANCO =================="

# Definir variáveis para conexão com o banco
DB_HOST="localhost"
DB_USER="developer"
DB_PASS="ifsp@123"
DB_NAME="sim_data"

# Consulta SQL
QUERY="SELECT 2012 AS ANO, COUNT(*) AS qtdLines FROM Mortalidade_Geral_2012;"

# Executar consulta e mostrar resultado
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -e "$QUERY"

sleep 10

