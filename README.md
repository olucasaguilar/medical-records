# Rebase Labs

### Executando o Banco de Dados (PostgreSQL)
```bash
docker compose run --rm database
```

### Preparando o Banco de Dados
Para preparar o banco de dados (o comando acima NÃO precisa estar em execução).
```bash
docker compose run --rm prepare_database && docker compose -f docker-compose.yml down --remove-orphans
```
Este comando irá ler o arquivo CSV `data/data.csv` e popular o banco de dados.

Em toda execução deste comando, a tabela do banco será apagada e criada novamente.

### Executando o Servidor
```bash
docker compose run --rm --service-ports server
```
Para iniciar o servidor, o banco de dados deve estar populado e em execução.

### Rotas
- `localhost:3000/tests` - Retorna todos os registros medicos em formato JSON. Atualmente contém 3900 registros.

## Testes

### Rodar os testes
```bash
docker compose run --rm tests
```

Para executar os testes e remover o container orfão logo em seguida:
```bash
docker compose run --rm tests && docker compose -f docker-compose.yml down --remove-orphans
```

Por enquanto em alguns testes, é necessário fechar o server manualmente após rodar os testes. Os resultados são exibidos logo em seguida.