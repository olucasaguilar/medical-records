# Rebase Labs

### Executando o Banco de Dados (PostgreSQL)
```bash
docker compose run --rm database
```

### Preparando o Banco de Dados
Para preparar o banco de dados, o comando acima precisa estar em execução.
```bash
docker compose run --rm prepare_database
```
Este comando irá ler o arquivo CSV `data/data.csv` e popular o banco de dados.

Em toda execução deste comando, a tabela do banco será apagada e criada novamente.

### Executando o Servidor
```bash
docker compose run --rm --service-ports server
```
Para iniciar o servidor, o banco de dados deve estar populado e em execução.
