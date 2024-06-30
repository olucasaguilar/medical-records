# Rebase Labs

## Informações gerais

Essa é uma aplicação de visualização de exames médicos desenvolvida durante o Rebase Labs (2024) da turma 11 do TreinaDev, utilizando Ruby, JavaScript, HTML e CSS

## Configuração

Execute os comandos abaixo para clonar o repositório da aplicação:

```bash
git clone git@github.com:olucasaguilar/medical-records.git
```

```bash
cd medical-records
```

## Executando a aplicação (Back-End e Front-End)

É necessário ter Docker instalado antes de executar a aplicação.

```bash
docker compose up
```

Este comando vai executar todos os serviços docker abaixo, que são responsáveis pelo back-end da aplicação:
- database (banco de dados PostgreSQL)
- server-backend (servidor back-end)
- server-frontend (servidor front-end)
- redis (sistema de armazenamento em memória)
- sidekiq (sistema de gerenciamento de filas de trabalhos em Ruby)

### Populando o Banco de Dados

Para popular o banco de dados execute o comando a seguir. 

Atenção: o comando anterior de execução do Back-End deve ter sido executado.

```bash
docker exec server-backend ruby utils/import_from_csv.rb
```

Este comando irá ler o arquivo CSV `backend/data/data.csv` e popular o banco de dados.

Atenção: Em toda execução deste comando, a tabela do banco será apagada e criada novamente. Para evitar esse comportamento, defina a variável `reset_table` como `false` no arquivo `backend/utils/import_from_csv_to_db.rb`.

### Testes

Para executar os testes, execute o comando a seguir. 

Atenção: o comando de execução da aplicação deve ter sido executado anteriormente

```bash
docker exec server-backend rspec
```

## Rotas

### Front-End

- `localhost:3000` - Exibe o resultado da consulta da API do back-end.

### API Back-End

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

## Fechando a aplicação

```bash
docker compose down
```
