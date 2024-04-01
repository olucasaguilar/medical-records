# Rebase Labs

## Cabeçalho

Em manutenção...

<!-- - [Executando o Banco de Dados (PostgreSQL)](#executando-o-banco-de-dados-postgresql)
- [Executando os Servidores](#executando-os-servidores)
- [Exeutando os Jobs](#executando-os-jobs)
- [Populando o Banco de Dados](#populando-o-banco-de-dados)
- [Testes](#testes)

### Nota

- Ao executar um comando pela primeira vez, pode levar alguns segundos a mais devido ao download das gems necessárias.

### Resumo de Comandos

- `bin/database` - Executa o banco de dados
- `bin/server_front` - Executa o servidor front-end
- `bin/server_back` - Executa o servidor back-end
- `bin/populate_database` - Popula o banco de dados pela primeira vez
- `bin/tests_back` - Executa os testes

### Sugestão de primeiros passos

#### 1- Execute os testes:
   - `bin/tests_back`
#### 2- Se abituando com a interface sem o banco populado:
   - Execute o Banco de Dados e Servidores ao mesmo tempo:
      - `bin/database`
      - `bin/server_back`
      - `bin/server_front`
   - Entre na rota `localhost:3000/`
#### 3- Visualizando interface com dados populados:
   - Feche o que foi aberto anteriormente
   - Popule o Banco de Dados
      - `bin/populate_database`
   - Refaça os comandos do passo 2
#### 4- Inserindo dados manuelmente através de UPLOAD na página HTML
   - Feche o que foi aberto anteriormente
   - Resete o Banco de Dados
      - `docker volume rm relabs_back_database`
   - Execute os comandos do passo 2
   - Execute os jobs
      - `bin/jobs`
   - Entre na rota principal da aplicação front-end
      - `:3000/`
   - Faça upload de um arquivo CSV manualmente através do botão na página
   - Recarregue a página e procure pelo exame na listagem. -->

## Informações gerais

Em manutenção...

## Pré-requisitos

Em manutenção...

## Configuração

Em manutenção...

## Executando o Back-End

```bash
docker compose up
```

Este comando vai executar todos os serviços docker abaixo, que são responsáveis pelo back-end da aplicação:
- database (banco de dados PostgreSQL)
- server (servidor back-end)
- redis (sistema de armazenamento em memória)
- sidekiq (sistema de gerenciamento de filas de trabalhos em Ruby)

### Populando o Banco de Dados

Para popular o banco de dados execute o comando a seguir. 

Atenção: o comando anterior de execução do Back-End deve ter sido executado.

```bash
docker exec server ruby utils/import_from_csv.rb
```

Este comando irá ler o arquivo CSV `backend/data/data.csv` e popular o banco de dados.

Atenção: Em toda execução deste comando, a tabela do banco será apagada e criada novamente. Para evitar esse comportamento, defina a variável `reset_table` como `false` no arquivo `backend/utils/import_from_csv_to_db.rb`.

### Testes

Para executar os testes, execute o comando a seguir. 

Atenção: o comando anterior de execução do Back-End deve ter sido executado.

```bash
docker exec server rspec
```

<!-- ### Back-end

```bash
bin/server_back
```

Após subir o servidor back-end, para ele funcionar corretamente, o Banco de Dados deve estar e em execução (e de preferencia populado). -->

### Rotas API

#### Retorna todos os registros médicos em formato JSON:
- **GET** → `localhost:3001/tests`

#### Retorna um registro médico em formato JSON com base no token:
- **GET** → `localhost:3001/tests/search?token=ABC123`

#### Recebe um arquivo CSV de exames e grava no banco de dados:
- **POST** → `localhost:3001/tests`

Corpo da requisição: 
```json
{ 
  "csv_file": "file.csv" 
}
```

## Executando o Front-end

```bash
bin/server_front
```

Após subir o servidor front-end, para ele funcionar corretamente, o servidor back-end deve estar e em execução.

### Rotas

- `localhost:3000` - Exibe o resultado da consulta da API do back-end.

## Fechando a aplicação

```bash
docker compose down
```
