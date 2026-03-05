# ETAPA 7 - ORM acessando o banco de dados do Sistema de Gerenciamento de Frota
Este projeto implementa o mapeamento objeto-relacional (ORM) usando **Python e SQLAlchemy** para o Sistema de Gerenciamento de Frota, desenvolvido na Disciplina de Projeto de Banco de Dados do Curso de Análise e Desenvolvimento de Sistemas da UFCA, ministrada pelo Professor Jayr Alencar Pereira.

## Como configurar e executar o projeto
### Passo 1: Certifique-se que tenha os pré-requisitos:
* Python 3.x;
* Um PostgreSQL rodando localmente.

### Passo 2: Configure o Banco de Dados (.env) e rode o script SQL
Crie um arquivo `.env` na raiz do projeto baseado no `.env.example` e preencha com suas credenciais do PostgreSQL:

```DB_USER=seu usuário
DB_PASSWORD=sua senha
DB_HOST=seu host (ex: localhost)
DB_PORT=sua porta (ex: 5432)
DB_NAME=nome do seu banco de dados
```
Em seguida, rode o script do banco de dados `script_banco.sql` para criar as tabelas e popular o banco.

### Passo 3: Instalar dependências

Abra o terminal na pasta do projeto, ative seu ambiente virtual `venv`se for o caso e instale as bibliotecas:

`pip install -r requirements.txt`

### Passo 5: Execute a aplicação com o comando

`python3 main.py`

## Evidências de funcionamento

### Parte 3 - Operações CRUD

## Create
![alt text](<1. CREATE.jpg>)

## Read
![alt text](<2. READ.jpg>)

## Update
![alt text](<3. UPDATE.jpg>)

## Delete
![alt text](<4. DELETE.jpg>)

### Parte 4 - Consultas com JOIN, Filtros e Ordenação

## Consulta manutenções por veículos (JOIN envolvendo as tabela `veiculo` e `manutencao`)
![alt text](<4.1 Manutenção por veículos.jpg>)

## Consulta abastecimentos por marca de veículo (JOIN envolvendo as tabelas `veiculo` e `abastecimento`)
![alt text](<4.2 Abastecimentos por data2.jpg>)

## Consulta listagem de viagens mais longas concluídas (uso de filtro na coluna data_chegada `IS NOT NULL` e ordenação)
![alt text](<4.3 Viagens longas concluídas.jpg>)