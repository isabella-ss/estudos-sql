# >> Revisão de Banco de Dados – Stored Procedure e Function <<

Este material apresenta uma revisão dos principais conceitos de **Stored Procedure** e **Function** no MySQL, com explicações, sintaxes, exemplos de códigos e exercícios resolvidos.

---

## Sumário

1. [O que é Stored Procedure?](#1-o-que-é-stored-procedure)
2. [Vantagens da Stored Procedure](#2-vantagens-da-stored-procedure)
3. [Stored Procedure sem Parâmetros](#3-stored-procedure-sem-parâmetros)
4. [Stored Procedure com Parâmetro IN](#4-stored-procedure-com-parâmetro-in)
5. [Stored Procedure com Múltiplos Parâmetros](#5-stored-procedure-com-múltiplos-parâmetros)
6. [Exercícios – Stored Procedure](#6-exercícios--stored-procedure)
7. [O que é Function?](#7-o-que-é-function)
8. [Deterministic](#8-deterministic)
9. [Function sem Parâmetro](#9-function-sem-parâmetro)
10. [Function com Parâmetros](#10-function-com-parâmetros)
11. [Exercícios – Function](#11-exercícios--function)
12. [Resumo Geral](#12-resumo-geral)

---

## 1. O que é Stored Procedure?

Uma **Stored Procedure** (Procedimento Armazenado) é um conjunto de comandos SQL armazenados dentro do banco de dados, que podem ser executados sempre que necessário.

Ela serve para automatizar tarefas, realizar consultas, inserir, atualizar e excluir dados.

### Exemplo de tabela

```sql
CREATE TABLE alunos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    idade INT,
    nota DECIMAL(4,2)
);
```

Inserindo alguns dados:

```sql
INSERT INTO alunos (nome, idade, nota)
VALUES
('João', 20, 8.5),
('Maria', 22, 9.0),
('Pedro', 19, 6.5);
```

### Criando uma Stored Procedure

```sql
DELIMITER //

CREATE PROCEDURE listar_alunos()
BEGIN
    SELECT * FROM alunos;
END //

DELIMITER ;
```

### Executando a Procedure

```sql
CALL listar_alunos();
```

### Entendendo os comandos

- `DELIMITER //`: altera temporariamente o delimitador de comandos.
- `CREATE PROCEDURE`: cria uma procedure.
- `BEGIN`: inicia o bloco de comandos.
- `SELECT`: realiza uma consulta.
- `END`: finaliza a procedure.
- `CALL`: executa a procedure.

---

## 2. Vantagens da Stored Procedure

As principais vantagens são:

- **Reutilização:** permite utilizar o mesmo código várias vezes.
- **Organização:** mantém os comandos SQL organizados.
- **Segurança:** permite controlar o acesso às operações do banco.
- **Manutenção:** facilita alterações em operações utilizadas frequentemente.
- **Desempenho:** pode reduzir a comunicação entre aplicação e banco de dados.
- **Automatização:** permite executar vários comandos SQL de uma só vez.

**Exemplo:**

Em vez de escrever a consulta toda vez, basta executar:

```sql
CALL listar_alunos();
```

---

## 3. Stored Procedure sem Parâmetros

É uma procedure que **não recebe nenhuma informação externa**.

Ela executa os comandos que foram programados dentro dela.

### Exemplo 1 – Listar todos os alunos

```sql
DELIMITER //

CREATE PROCEDURE mostrar_alunos()
BEGIN
    SELECT * FROM alunos;
END //

DELIMITER ;
```

Executando:

```sql
CALL mostrar_alunos();
```

### Exemplo 2 – Mostrar alunos aprovados

```sql
DELIMITER //

CREATE PROCEDURE alunos_aprovados()
BEGIN
    SELECT *
    FROM alunos
    WHERE nota >= 7;
END //

DELIMITER ;
```

Executando:

```sql
CALL alunos_aprovados();
```

> **Importante:** uma procedure sem parâmetros utiliza parênteses vazios `()`.

---

## 4. Stored Procedure com Parâmetro IN

O parâmetro `IN` serve para **enviar uma informação para dentro** da Stored Procedure.

Ou seja, você informa um valor e a procedure utiliza esse valor para executar uma consulta.

### Exemplo 1 – Buscar aluno pelo ID

```sql
DELIMITER //

CREATE PROCEDURE buscar_aluno(IN codigo INT)
BEGIN
    SELECT *
    FROM alunos
    WHERE id = codigo;
END //

DELIMITER ;
```

Executando:

```sql
CALL buscar_aluno(1);
```

**Explicação:**

- `IN`: indica que o parâmetro recebe um valor.
- `codigo`: nome do parâmetro.
- `INT`: tipo de dado.
- `1`: valor enviado durante a execução.

### Exemplo 2 – Buscar aluno pelo nome

```sql
DELIMITER //

CREATE PROCEDURE buscar_nome(IN nome_aluno VARCHAR(100))
BEGIN
    SELECT *
    FROM alunos
    WHERE nome = nome_aluno;
END //

DELIMITER ;
```

Executando:

```sql
CALL buscar_nome('Maria');
```

**Resultado:** apresenta os dados da aluna Maria.

---

## 5. Stored Procedure com Múltiplos Parâmetros

Uma procedure pode receber dois ou mais parâmetros.

Basta separar os parâmetros por vírgula.

### Exemplo – Buscar alunos por idade e nota

```sql
DELIMITER //

CREATE PROCEDURE buscar_alunos(
    IN idade_minima INT,
    IN nota_minima DECIMAL(4,2)
)
BEGIN
    SELECT *
    FROM alunos
    WHERE idade >= idade_minima
    AND nota >= nota_minima;
END //

DELIMITER ;
```

Executando:

```sql
CALL buscar_alunos(20, 7);
```

**Explicação:**

- `20`: idade mínima.
- `7`: nota mínima.
- A consulta retorna alunos com idade maior ou igual a 20 **e** nota maior ou igual a 7.

### Exemplo – Buscar por nome e idade

```sql
DELIMITER //

CREATE PROCEDURE buscar_por_nome_idade(
    IN p_nome VARCHAR(100),
    IN p_idade INT
)
BEGIN
    SELECT *
    FROM alunos
    WHERE nome = p_nome
    AND idade = p_idade;
END //

DELIMITER ;
```

Executando:

```sql
CALL buscar_por_nome_idade('João', 20);
```

> **Dica:** os valores informados no `CALL` devem respeitar a **mesma ordem** dos parâmetros definidos na procedure.

---

## 6. Exercícios – Stored Procedure

Vamos utilizar a tabela `produtos`.

### Criando a tabela

```sql
CREATE TABLE produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    preco DECIMAL(10,2),
    quantidade INT
);
```

### Inserindo dados

```sql
INSERT INTO produtos (nome, preco, quantidade)
VALUES
('Notebook', 3000.00, 5),
('Mouse', 50.00, 20),
('Teclado', 120.00, 10),
('Monitor', 900.00, 8);
```

### Exercício 1 – Listar todos os produtos

Crie uma Stored Procedure **sem parâmetros** que mostre todos os produtos.

**Resolução:**

```sql
DELIMITER //

CREATE PROCEDURE listar_produtos()
BEGIN
    SELECT * FROM produtos;
END //

DELIMITER ;
```

**Execução:**

```sql
CALL listar_produtos();
```

### Exercício 2 – Buscar produtos pelo preço

Crie uma Stored Procedure que receba um preço mínimo e mostre os produtos com preço maior ou igual ao informado.

**Resolução:**

```sql
DELIMITER //

CREATE PROCEDURE buscar_preco(
    IN p_preco DECIMAL(10,2)
)
BEGIN
    SELECT *
    FROM produtos
    WHERE preco >= p_preco;
END //

DELIMITER ;
```

**Execução:**

```sql
CALL buscar_preco(100);
```

### Exercício 3 – Buscar produtos por preço e quantidade

Crie uma Stored Procedure que receba dois parâmetros: preço mínimo e quantidade mínima.

**Resolução:**

```sql
DELIMITER //

CREATE PROCEDURE filtrar_produtos(
    IN p_preco DECIMAL(10,2),
    IN p_quantidade INT
)
BEGIN
    SELECT *
    FROM produtos
    WHERE preco >= p_preco
    AND quantidade >= p_quantidade;
END //

DELIMITER ;
```

**Execução:**

```sql
CALL filtrar_produtos(100, 5);
```

---

## 7. O que é Function?

Uma **Function** (Função) é um bloco de código armazenado no banco de dados que executa uma operação e **retorna um resultado**.

A principal diferença entre Function e Stored Procedure é a maneira como são executadas e retornam resultados.

| Stored Procedure                        | Function                                    |
| --------------------------------------- | ------------------------------------------- |
| Executada com `CALL`                    | Utilizada em expressões SQL                 |
| Pode executar várias instruções         | Deve retornar um valor                      |
| Pode realizar consultas e alterações    | Pode realizar cálculos e retornar resultados |
| Pode receber parâmetros                 | Pode receber parâmetros                     |

### Exemplo – Somar dois números

```sql
DELIMITER //

CREATE FUNCTION somar(
    a INT,
    b INT
)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN a + b;
END //

DELIMITER ;
```

Executando:

```sql
SELECT somar(10, 20);
```

Resultado:

```text
30
```

### Entendendo os comandos

- `CREATE FUNCTION`: cria uma função.
- `RETURNS INT`: informa o tipo de dado que será retornado.
- `DETERMINISTIC`: indica que as mesmas entradas produzem o mesmo resultado.
- `RETURN`: devolve o resultado da função.

---

## 8. Deterministic

O `DETERMINISTIC` é uma característica utilizada na criação de funções.

Significa que, quando a função recebe os **mesmos parâmetros**, ela **sempre retorna o mesmo resultado**.

### Exemplo – Função Deterministic

```sql
DELIMITER //

CREATE FUNCTION dobro(numero INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN numero * 2;
END //

DELIMITER ;
```

Executando:

```sql
SELECT dobro(5);
```

Resultado:

```text
10
```

Se executar novamente:

```sql
SELECT dobro(5);
```

Resultado:

```text
10
```

O resultado será sempre o mesmo porque a função realiza uma operação matemática fixa.

### Exemplo – Função NOT DETERMINISTIC

```sql
DELIMITER //

CREATE FUNCTION numero_aleatorio()
RETURNS INT
NOT DETERMINISTIC
BEGIN
    RETURN FLOOR(RAND() * 100);
END //

DELIMITER ;
```

Executando:

```sql
SELECT numero_aleatorio();
```

O resultado pode mudar a cada execução.

### Diferença

| Tipo                | Significado                                   |
| ------------------- | --------------------------------------------- |
| `DETERMINISTIC`     | Mesmas entradas produzem o mesmo resultado    |
| `NOT DETERMINISTIC` | O resultado pode mudar entre execuções        |

---

## 9. Function sem Parâmetro

É uma função que **não recebe valores externos**, mas retorna um resultado.

### Exemplo 1 – Retornar o número 100

```sql
DELIMITER //

CREATE FUNCTION valor_fixo()
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN 100;
END //

DELIMITER ;
```

Executando:

```sql
SELECT valor_fixo();
```

Resultado:

```text
100
```

### Exemplo 2 – Retornar uma mensagem

```sql
DELIMITER //

CREATE FUNCTION mensagem()
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    RETURN 'Bem-vindo ao banco de dados!';
END //

DELIMITER ;
```

Executando:

```sql
SELECT mensagem();
```

Resultado:

```text
Bem-vindo ao banco de dados!
```

> **Importante:** uma função sem parâmetros utiliza parênteses vazios `()`.

---

## 10. Function com Parâmetros

Uma função pode receber parâmetros para realizar cálculos ou consultas.

No MySQL, os parâmetros de uma Function são de entrada por padrão. Portanto, **não é necessário declarar `IN`** na assinatura, como acontece nas Stored Procedures.

### Exemplo 1 – Calcular a média de duas notas

```sql
DELIMITER //

CREATE FUNCTION calcular_media(
    nota1 DECIMAL(4,2),
    nota2 DECIMAL(4,2)
)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    RETURN (nota1 + nota2) / 2;
END //

DELIMITER ;
```

Executando:

```sql
SELECT calcular_media(8, 10);
```

Resultado:

```text
9.00
```

### Exemplo 2 – Calcular desconto de um produto

```sql
DELIMITER //

CREATE FUNCTION calcular_desconto(
    preco DECIMAL(10,2),
    percentual DECIMAL(5,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN preco - (preco * percentual / 100);
END //

DELIMITER ;
```

Executando:

```sql
SELECT calcular_desconto(200, 10);
```

Resultado:

```text
180.00
```

**Explicação:**

- Preço original: R$ 200.
- Desconto: 10%.
- Valor descontado: R$ 20.
- Resultado final: R$ 180.

### Exemplo 3 – Verificar aprovação

```sql
DELIMITER //

CREATE FUNCTION verificar_aprovacao(
    nota DECIMAL(4,2)
)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    IF nota >= 7 THEN
        RETURN 'Aprovado';
    ELSE
        RETURN 'Reprovado';
    END IF;
END //

DELIMITER ;
```

Executando:

```sql
SELECT verificar_aprovacao(8);
```

Resultado:

```text
Aprovado
```

---

## 11. Exercícios – Function

Vamos praticar com alguns exercícios resolvidos.

### Exercício 1 – Function sem parâmetros

Crie uma função que retorne o número 50.

**Resolução:**

```sql
DELIMITER //

CREATE FUNCTION retornar_valor()
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN 50;
END //

DELIMITER ;
```

**Execução:**

```sql
SELECT retornar_valor();
```

### Exercício 2 – Function com parâmetro

Crie uma função que receba um número e retorne o seu triplo.

**Resolução:**

```sql
DELIMITER //

CREATE FUNCTION triplo(numero INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN numero * 3;
END //

DELIMITER ;
```

**Execução:**

```sql
SELECT triplo(10);
```

**Resultado:** `30`.

### Exercício 3 – Function com dois parâmetros

Crie uma função que receba o preço e a quantidade de um produto e retorne o valor total.

**Resolução:**

```sql
DELIMITER //

CREATE FUNCTION calcular_total(
    preco DECIMAL(10,2),
    quantidade INT
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN preco * quantidade;
END //

DELIMITER ;
```

**Execução:**

```sql
SELECT calcular_total(50, 3);
```

**Resultado:** `150.00`.

### Exercício 4 – Function com IF

Crie uma função que receba uma idade e informe se a pessoa é maior ou menor de idade.

**Resolução:**

```sql
DELIMITER //

CREATE FUNCTION verificar_idade(idade INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    IF idade >= 18 THEN
        RETURN 'Maior de idade';
    ELSE
        RETURN 'Menor de idade';
    END IF;
END //

DELIMITER ;
```

**Execução:**

```sql
SELECT verificar_idade(20);
```

**Resultado:** `Maior de idade`.

---

## 12. Resumo Geral

Esta é uma parte importante para memorizar antes da prova.

| Conteúdo                          | Comando principal |
| --------------------------------- | ----------------- |
| Criar Procedure                   | `CREATE PROCEDURE` |
| Executar Procedure                | `CALL`            |
| Criar Function                    | `CREATE FUNCTION` |
| Executar Function                 | `SELECT`          |
| Parâmetro de entrada na Procedure | `IN`              |
| Tipo de retorno da Function       | `RETURNS`         |
| Retornar resultado                | `RETURN`          |
| Iniciar comandos                  | `BEGIN`           |
| Finalizar comandos                | `END`             |
| Função determinística             | `DETERMINISTIC`   |

### Diferenças que não podem ser confundidas

#### Stored Procedure

```sql
DELIMITER //

CREATE PROCEDURE teste()
BEGIN
    SELECT * FROM alunos;
END //

DELIMITER ;
```

**Execução:**

```sql
CALL teste();
```

#### Function

```sql
DELIMITER //

CREATE FUNCTION teste()
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN 10;
END //

DELIMITER ;
```

**Execução:**

```sql
SELECT teste();
```

---

## 💡 Dicas finais para a prova

Memorize estas quatro estruturas:

**1. Procedure sem parâmetro**

```sql
CREATE PROCEDURE nome()
BEGIN
    -- comandos SQL
END;
```

**2. Procedure com parâmetro**

```sql
CREATE PROCEDURE nome(IN parametro TIPO)
BEGIN
    -- comandos SQL
END;
```

**3. Function sem parâmetro**

```sql
CREATE FUNCTION nome()
RETURNS TIPO
DETERMINISTIC
BEGIN
    RETURN valor;
END;
```

**4. Function com parâmetro**

```sql
CREATE FUNCTION nome(parametro TIPO)
RETURNS TIPO
DETERMINISTIC
BEGIN
    RETURN valor;
END;
```

### O que mais merece atenção?

- `CALL` executa uma Stored Procedure.
- `SELECT` pode executar uma Function.
- `IN` recebe valores de entrada na Stored Procedure.
- `RETURNS` define o tipo de retorno da Function.
- `RETURN` devolve o resultado da Function.
- `DETERMINISTIC` indica que as mesmas entradas produzem o mesmo resultado.

---

**Fim da revisão! Bons estudos!**
