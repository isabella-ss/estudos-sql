# >>> Exercícios Resolvidos – Stored Procedure e Function <<<

Exercícios com resolução comentada em SQL (MySQL). Para os exercícios de Stored Procedure, use a tabela `produtos`. Os de Function são independentes de tabela, exceto o desafio final e alguns exemplos de uso.

---

## Sumário

**Parte 1 – Stored Procedure**

1. [Sem parâmetros](#exercício-1--sem-parâmetros)
2. [Um parâmetro IN](#exercício-2--um-parâmetro-in)
3. [Múltiplos parâmetros](#exercício-3--múltiplos-parâmetros)
4. [Procedure com INSERT](#exercício-4--procedure-com-insert)
5. [Procedure com UPDATE](#exercício-5--procedure-com-update)
6. [Procedure com DELETE](#exercício-6--procedure-com-delete)

**Parte 2 – Function**

7. [Sem parâmetros](#exercício-7--sem-parâmetros)
8. [Um parâmetro](#exercício-8--um-parâmetro)
9. [Dois parâmetros](#exercício-9--dois-parâmetros)
10. [Function com IF / ELSEIF](#exercício-10--function-com-if--elseif)
11. [NOT DETERMINISTIC](#exercício-11--not-deterministic)
12. [Desafio: Function que consulta a tabela](#exercício-12-desafio--function-que-consulta-a-tabela)

---

## Preparação

```sql
-- Tabela base (se ainda não tiver criado)
CREATE TABLE produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    preco DECIMAL(10,2),
    quantidade INT
);

INSERT INTO produtos (nome, preco, quantidade)
VALUES
('Notebook', 3000.00, 5),
('Mouse', 50.00, 20),
('Teclado', 120.00, 10),
('Monitor', 900.00, 8);
```

---

# Parte 1 – Stored Procedure

## Exercício 1 – Sem parâmetros

Crie uma procedure que mostre os produtos com **estoque baixo** (quantidade menor que 10).

```sql
DELIMITER //

-- Parênteses vazios: não recebe nenhum valor externo
CREATE PROCEDURE estoque_baixo()
BEGIN
    -- Filtra apenas os produtos com menos de 10 unidades
    SELECT *
    FROM produtos
    WHERE quantidade < 10;
END //

DELIMITER ;

-- Execução (procedure usa CALL)
CALL estoque_baixo();
-- Retorna: Notebook (5) e Monitor (8)
```

---

## Exercício 2 – Um parâmetro IN

Crie uma procedure que receba o **id** de um produto e mostre apenas esse produto.

```sql
DELIMITER //

-- IN: valor que entra na procedure
-- Prefixo p_ evita confundir o parâmetro com o nome da coluna
CREATE PROCEDURE buscar_produto(IN p_id INT)
BEGIN
    SELECT *
    FROM produtos
    WHERE id = p_id;   -- coluna id = valor recebido
END //

DELIMITER ;

CALL buscar_produto(2);   -- retorna o Mouse
```

---

## Exercício 3 – Múltiplos parâmetros

Crie uma procedure que receba um **preço mínimo** e um **preço máximo** e mostre os produtos dentro dessa faixa.

```sql
DELIMITER //

CREATE PROCEDURE produtos_faixa_preco(
    IN p_minimo DECIMAL(10,2),   -- 1º parâmetro
    IN p_maximo DECIMAL(10,2)    -- 2º parâmetro
)
BEGIN
    SELECT *
    FROM produtos
    WHERE preco >= p_minimo
      AND preco <= p_maximo;     -- ambas as condições precisam ser verdadeiras
END //

DELIMITER ;

-- A ordem no CALL segue a ordem dos parâmetros: (mínimo, máximo)
CALL produtos_faixa_preco(100, 1000);
-- Retorna: Teclado (120) e Monitor (900)
```

---

## Exercício 4 – Procedure com INSERT

Crie uma procedure para **cadastrar** um novo produto.

```sql
DELIMITER //

CREATE PROCEDURE cadastrar_produto(
    IN p_nome VARCHAR(100),
    IN p_preco DECIMAL(10,2),
    IN p_quantidade INT
)
BEGIN
    -- O id não é informado: AUTO_INCREMENT gera sozinho
    INSERT INTO produtos (nome, preco, quantidade)
    VALUES (p_nome, p_preco, p_quantidade);
END //

DELIMITER ;

CALL cadastrar_produto('Webcam', 250.00, 15);

-- Conferindo se inseriu
SELECT * FROM produtos;
```

---

## Exercício 5 – Procedure com UPDATE

Crie uma procedure que **reponha o estoque**: receba o id do produto e a quantidade a adicionar.

```sql
DELIMITER //

CREATE PROCEDURE repor_estoque(
    IN p_id INT,
    IN p_qtd INT
)
BEGIN
    UPDATE produtos
    SET quantidade = quantidade + p_qtd   -- soma ao valor que já existe
    WHERE id = p_id;                      -- sem WHERE, atualizaria TODOS os produtos!
END //

DELIMITER ;

CALL repor_estoque(1, 10);   -- Notebook passa de 5 para 15

SELECT * FROM produtos WHERE id = 1;
```

---

## Exercício 6 – Procedure com DELETE

Crie uma procedure que **exclua** um produto pelo id.

```sql
DELIMITER //

CREATE PROCEDURE excluir_produto(IN p_id INT)
BEGIN
    DELETE FROM produtos
    WHERE id = p_id;   -- o WHERE é essencial: sem ele, apaga a tabela inteira
END //

DELIMITER ;

CALL excluir_produto(5);   -- remove o produto de id 5 (a Webcam, se você fez o Ex. 4)
```

---

# Parte 2 – Function

## Exercício 7 – Sem parâmetros

Crie uma função que retorne o texto `'Sistema de Estoque'`.

```sql
DELIMITER //

CREATE FUNCTION nome_sistema()
RETURNS VARCHAR(50)    -- obrigatório: define o tipo do retorno
DETERMINISTIC          -- sempre devolve o mesmo texto
BEGIN
    RETURN 'Sistema de Estoque';   -- RETURN devolve o valor
END //

DELIMITER ;

-- Function é usada dentro de um SELECT (não usa CALL)
SELECT nome_sistema();
```

---

## Exercício 8 – Um parâmetro

Crie uma função que receba um número e retorne o seu **quadrado**.

```sql
DELIMITER //

-- Em Function não se escreve IN: o parâmetro já é de entrada por padrão
CREATE FUNCTION quadrado(numero INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN numero * numero;
END //

DELIMITER ;

SELECT quadrado(6);   -- 36
```

---

## Exercício 9 – Dois parâmetros

Crie uma função que receba o **preço** e o **percentual de acréscimo** e retorne o preço final.

```sql
DELIMITER //

CREATE FUNCTION calcular_acrescimo(
    preco DECIMAL(10,2),
    percentual DECIMAL(5,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    -- Preço + (preço * percentual / 100)
    RETURN preco + (preco * percentual / 100);
END //

DELIMITER ;

SELECT calcular_acrescimo(200, 15);   -- 230.00

-- Também funciona usando colunas da tabela:
SELECT nome, preco, calcular_acrescimo(preco, 10) AS preco_com_acrescimo
FROM produtos;
```

---

## Exercício 10 – Function com IF / ELSEIF

Crie uma função que receba uma nota e retorne:

- `'Aprovado'` se nota ≥ 7
- `'Recuperação'` se nota ≥ 5 e < 7
- `'Reprovado'` se nota < 5

```sql
DELIMITER //

CREATE FUNCTION situacao_aluno(nota DECIMAL(4,2))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    IF nota >= 7 THEN
        RETURN 'Aprovado';
    ELSEIF nota >= 5 THEN        -- só chega aqui se nota < 7
        RETURN 'Recuperação';
    ELSE                         -- nota < 5
        RETURN 'Reprovado';
    END IF;
END //

DELIMITER ;

SELECT situacao_aluno(8.5);   -- Aprovado
SELECT situacao_aluno(6);     -- Recuperação
SELECT situacao_aluno(3);     -- Reprovado

-- Usando com a tabela alunos:
SELECT nome, nota, situacao_aluno(nota) AS situacao
FROM alunos;
```

---

## Exercício 11 – NOT DETERMINISTIC

Crie uma função que simule o lançamento de um **dado** (número de 1 a 6).

```sql
DELIMITER //

CREATE FUNCTION lancar_dado()
RETURNS INT
NOT DETERMINISTIC    -- RAND() muda a cada execução, então NÃO é determinística
BEGIN
    -- RAND() gera um decimal entre 0 e 1
    -- * 6 → entre 0 e 5.99 | FLOOR → 0 a 5 | + 1 → 1 a 6
    RETURN FLOOR(RAND() * 6) + 1;
END //

DELIMITER ;

SELECT lancar_dado();   -- execute várias vezes: o resultado varia
```

---

## Exercício 12 (desafio) – Function que consulta a tabela

Crie uma função que receba o id de um produto e retorne o **valor total em estoque** (preço × quantidade).

```sql
DELIMITER //

CREATE FUNCTION valor_estoque(p_id INT)
RETURNS DECIMAL(12,2)
READS SQL DATA          -- avisa que a função lê dados de tabelas
BEGIN
    DECLARE v_total DECIMAL(12,2);   -- variável local (DECLARE vem logo após o BEGIN)

    -- SELECT ... INTO guarda o resultado dentro da variável
    SELECT preco * quantidade
    INTO v_total
    FROM produtos
    WHERE id = p_id;

    RETURN v_total;
END //

DELIMITER ;

SELECT valor_estoque(2);   -- Mouse: 50 * 20 = 1000.00
```

> `READS SQL DATA`, `DECLARE` e `SELECT ... INTO` vão um pouco além do material da revisão, mas aparecem com frequência quando a função precisa consultar uma tabela.

---

## Resumo rápido

| Quero...                         | Uso                                  |
| -------------------------------- | ------------------------------------ |
| Executar uma Stored Procedure    | `CALL nome(valores);`                |
| Executar uma Function            | `SELECT nome(valores);`              |
| Receber valor na Procedure       | `IN parametro TIPO`                  |
| Receber valor na Function        | `parametro TIPO` (sem `IN`)          |
| Definir o tipo de retorno        | `RETURNS TIPO` (somente Function)    |
| Devolver o resultado             | `RETURN valor;` (somente Function)   |
| Mesmo resultado para mesma entrada | `DETERMINISTIC`                    |
| Resultado pode variar            | `NOT DETERMINISTIC`                  |

**Bons estudos!**
