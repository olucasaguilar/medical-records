# Rebase Labs

### Executando o Banco de Dados (PostgreSQL)

```bash
docker compose run --rm database
```

Este comando deixa o Banco de Dados no ar para ser acessado pelo Servidor.

### Executando o Servidor

```bash
docker compose run --rm --service-ports server
```

Após subir o servidor, para conseguir acessar as funcionalidades corretamente, o Banco de Dados deve estar e em execução (e de preferencia populado).

#### Rotas

- `localhost:3000/tests` - Retorna todos os registros medicos em formato JSON. Atualmente contém 3900 registros.

### Populando o Banco de Dados

Para popular o banco de dados execute o comando a seguir. 

*Atenção, o Banco de Dados NÃO precisa estar em execução, portanto, apenas o comando abaixo ja basta.

```bash
docker compose run --rm prepare_database && docker compose -f docker-compose.yml down --remove-orphans
```

Este comando irá ler o arquivo CSV `data/data.csv` e popular o banco de dados.

Em toda execução deste comando, a tabela do banco será apagada e criada novamente.

## Testes

### Rodar os testes

Para executar os testes, execute o comando a seguir. 

*Atenção, o Banco de Dados NÃO precisa estar em execução, portanto, apenas o comando abaixo ja basta.

```bash
docker compose run --rm tests && docker compose -f docker-compose.yml down --remove-orphans
```

Por enquanto após executar o comando de testes, é necessário fechar o server manualmente no teminal. Os resultados são exibidos logo em seguida.