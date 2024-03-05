# Rebase Labs

### Executando o Servidor (PostgreSQL)
```bash
docker compose run --rm database
```

### Preparando o Banco de Dados
Para preparar o banco de dados, o servidor precisa estar em execução.
```bash
docker compose run --rm prepare_database
```
Este comando irá ler o arquivo CSV `data/data.csv` e popular o banco de dados.

Em toda execução deste comando, a tabela do banco será apagada e criada novamente, e isso pode levar alguns segundos.