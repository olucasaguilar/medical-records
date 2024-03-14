# Rebase Labs

## Cabeçalho

- [Executando o Banco de Dados (PostgreSQL)](#executando-o-banco-de-dados-postgresql)
- [Executando os Servidores](#executando-os-servidores)
- [Populando o Banco de Dados](#populando-o-banco-de-dados)
- [Testes](#testes)

### Nota

- Ao executar um comando pela primeira vez, pode levar alguns segundos a mais devido ao download das gems necessárias.

### Resumo de Comandos

- `bin/database` - Executa o banco de dados
- `bin/server_front` - Executa o servidor front-end
- `bin/server_back` - Executa o servidor back-end
- `bin/populate_database` - Popula o banco de dados pela primeira vez
- `bin/run_tests` - Executa os testes

## Executando o Banco de Dados (PostgreSQL)

```bash
bin/database
```

Este comando deixa o Banco de Dados no ar para ser acessado pelo Servidor.

## Executando os Servidores

### Back-end

```bash
bin/server_back
```

Após subir o servidor back-end, para ele funcionar corretamente, o Banco de Dados deve estar e em execução (e de preferencia populado).

#### Rotas API

##### Retorna todos os registros médicos em formato JSON:
- **GET** → `localhost:3001/tests`

##### Retorna um registro médico em formato JSON com base no token:
- **GET** → `localhost:3001/tests/search?token=ABC123`

##### Recebe um arquivo CSV de exames e grava no banco de dados:
- **POST** → `localhost:3001/tests`

Corpo da requisição: 
```json
{ 
  "csv_file": "file.csv" 
}
```

### Front-end

```bash
bin/server_front
```

Após subir o servidor front-end, para ele funcionar corretamente, o servidor back-end deve estar e em execução.

#### Rotas

- `localhost:3000` - Exibe o resultado da consulta da API do back-end.

## Populando o Banco de Dados

Para popular o banco de dados execute o comando a seguir. 

Atenção: o Banco de Dados e os servidores NÃO devem estar em execução.

```bash
bin/populate_database
```

Este comando irá ler o arquivo CSV `data/data.csv` e popular o banco de dados.

Atenção: Em toda execução deste comando, a tabela do banco será apagada e criada novamente. Para evitar esse comportamento, defina a variável `reset_table` como `false` no arquivo `utils/import_from_csv_to_db.rb`.

## Testes

Para executar os testes, execute o comando a seguir. 

Atenção: o Banco de Dados e os servidores NÃO devem estar em execução.

```bash
bin/run_tests
```