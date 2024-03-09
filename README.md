# Rebase Labs

## Cabeçalho

- [Executando o Banco de Dados (PostgreSQL)](#executando-o-banco-de-dados-postgresql)
- [Executando o Servidor](#executando-o-servidor)
- [Populando o Banco de Dados](#populando-o-banco-de-dados)
- [Testes](#testes)

### Nota

- Ao executar um comando pela primeira vez, pode levar alguns segundos a mais devido ao download das gems necessárias.

## Executando o Banco de Dados (PostgreSQL)

```bash
bin/database
```

Este comando deixa o Banco de Dados no ar para ser acessado pelo Servidor.


## Executando o Servidor

```bash
bin/server
```

Após subir o servidor, para conseguir acessar as funcionalidades corretamente, o Banco de Dados deve estar e em execução (e de preferencia populado).

### Rotas

- `localhost:3000/tests` - Retorna todos os registros medicos em formato JSON. Atualmente contém 3900 registros.

## Populando o Banco de Dados

Para popular o banco de dados execute o comando a seguir. 

Atenção: o Banco de Dados NÃO deve estar em execução.

```bash
bin/populate_database
```

Este comando irá ler o arquivo CSV `data/data.csv` e popular o banco de dados.

Em toda execução deste comando, a tabela do banco será apagada e criada novamente.

## Testes

Para executar os testes, execute o comando a seguir. 

Atenção: o Banco de Dados NÃO deve estar em execução.

```bash
bin/run_tests
```

Por enquanto após executar o comando de testes, é necessário fechar o `server` manualmente no teminal. Os resultados são exibidos logo em seguida.