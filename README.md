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

<!-- informando da rota localhost:3000/tests que exibe todos os registros médicos, que são 3900 atualmente -->
### Rotas
- `localhost:3000/tests` - Retorna todos os registros medicos em formato JSON. Atualmente contém 3900 registros.

<!-- teste é tests no compose -->
## Testes

### Rodar os testes
```bash
docker compose run --rm tests
```

Por enquanto, é necessário fechar o server manualmente após rodar os testes. Os resultados são exibidos logo em seguida.