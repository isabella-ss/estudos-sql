# Exercício Completo – Sistema de Livraria (MySQL)

Neste exercício você vai construir um pequeno sistema de controle de estoque de uma livraria, **do zero**, passando por todos os elementos estudados:

- Criação do banco e da tabela
- Inserção de dados (popular)
- CRUD (Create, Read, Update, Delete)
- Functions (`DETERMINISTIC`, `NOT DETERMINISTIC`, com `IF`, com consulta à tabela)
- Stored Procedures (sem parâmetro, `IN`, múltiplos parâmetros, `OUT`, `INOUT`)
- Procedures que usam functions
- Testes e limpeza

> **Dica:** execute os blocos na ordem. Todos os `CREATE` vêm precedidos de `DROP ... IF EXISTS`, então você pode rodar o script várias vezes sem erro.

---

## Sumário

1. [Mapa dos elementos cobertos](#1-mapa-dos-elementos-cobertos)
2. [Parte 1 – Banco e tabela](#2-parte-1--banco-e-tabela)
3. [Parte 2 – Popular a tabela](#3-parte-2--popular-a-tabela)
4. [Parte 3 – Functions](#4-parte-3--functions)
5. [Parte 4 – Stored Procedures (CRUD)](#5-parte-4--stored-procedures-crud)
6. [Parte 5 – Procedures com OUT e INOUT](#6-parte-5--procedures-com-out-e-inout)
7. [Parte 6 – Procedures que usam Functions](#7-parte-6--procedures-que-usam-functions)
8. [Parte 7 – Roteiro de testes](#8-parte-7--roteiro-de-testes)
9. [Parte 8 – Limpeza](#9-parte-8--limpeza)
10. [Desafios extras](#10-desafios-extras)

---

## 1. Mapa dos elementos cobertos

| Elemento                         | Onde aparece                                        |
| -------------------------------- | --------------------------------------------------- |
| `CREATE DATABASE` / `USE`        | Parte 1                                             |
| `CREATE TABLE` com restrições    | Parte 1 (`PRIMARY KEY`, `NOT NULL`, `DEFAULT`, `CHECK`) |
| `INSERT` (popular)               | Parte 2                                             |
| Function sem parâmetro           | `gerar_cupom()`                                     |
| Function com parâmetros          | `calcular_desconto`, `valor_total_item`             |
| Function com `IF / ELSEIF`       | `classificar_estoque`                               |
| Function que consulta a tabela   | `valor_estoque_livro`                               |
| `DETERMINISTIC`                  | `calcular_desconto`, `valor_total_item`, `classificar_estoque` |
| `NOT DETERMINISTIC`              | `gerar_cupom`                                       |
| Procedure sem parâmetro          | `listar_livros`, `relatorio_estoque`                |
| Procedure com `IN`               | `buscar_livro`                                      |
| Procedure com múltiplos `IN`     | `buscar_por_categoria_preco`, `cadastrar_livro`     |
| CRUD – **C**reate                | `cadastrar_livro`                                   |
| CRUD – **R**ead                  | `listar_livros`, `buscar_livro`, `buscar_por_categoria_preco` |
| CRUD – **U**pdate                | `atualizar_preco`, `repor_estoque`                  |
| CRUD – **D**elete                | `excluir_livro`                                     |
| Parâmetro `OUT`                  | `contar_por_categoria`, `vender_livro`              |
| Parâmetro `INOUT`                | `aplicar_reajuste`                                  |
| Variável local (`DECLARE`)       | `valor_estoque_livro`, `vender_livro`               |
| `IF / ELSEIF / ELSE`             | `classificar_estoque`, `vender_livro`               |
| Function dentro de procedure     | `relatorio_estoque`, `vender_livro`                 |
| `CALL` e `SELECT` para executar  | Parte 7                                             |

---

## 2. Parte 1 – Banco e tabela

**Enunciado:** crie o banco `livraria` e a tabela `livros` com os campos: id, título, autor, categoria, preço, quantidade em estoque e ano de publicação. O preço e a quantidade não podem ser negativos.

```sql
-- Apaga o banco caso já exista (permite rodar o script várias vezes)
DROP DATABASE IF EXISTS livraria;

-- Cria o banco com suporte a acentos e caracteres especiais
CREATE DATABASE livraria
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

-- Seleciona o banco: todos os comandos seguintes serão executados nele
USE livraria;

CREATE TABLE livros (
    id             INT AUTO_INCREMENT PRIMARY KEY,           -- chave primária gerada automaticamente
    titulo         VARCHAR(150) NOT NULL,                    -- obrigatório
    autor          VARCHAR(100) NOT NULL,                    -- obrigatório
    categoria      VARCHAR(50)  NOT NULL,                    -- obrigatório
    preco          DECIMAL(10,2) NOT NULL CHECK (preco >= 0),         -- não aceita negativo
    quantidade     INT NOT NULL DEFAULT 0 CHECK (quantidade >= 0),    -- se não informar, assume 0
    ano_publicacao INT                                       -- opcional (aceita NULL)
);
```

> O `CHECK` só é realmente aplicado a partir do **MySQL 8.0.16**. Em versões anteriores ele é aceito, mas ignorado.

---

## 3. Parte 2 – Popular a tabela

**Enunciado:** insira 8 livros, de pelo menos três categorias diferentes. Inclua um livro com estoque zerado para testar as regras depois.

```sql
INSERT INTO livros (titulo, autor, categoria, preco, quantidade, ano_publicacao)
VALUES
('Dom Casmurro',                     'Machado de Assis',          'Romance',    39.90, 12, 1899),
('O Cortiço',                        'Aluísio Azevedo',           'Romance',    34.50,  3, 1890),
('Memórias Póstumas de Brás Cubas',  'Machado de Assis',          'Romance',    42.00,  8, 1881),
('Capitães da Areia',                'Jorge Amado',               'Romance',    45.90,  0, 1937),  -- estoque zerado
('Vidas Secas',                      'Graciliano Ramos',          'Romance',    36.00, 15, 1938),
('O Pequeno Príncipe',               'Antoine de Saint-Exupéry',  'Infantil',   29.90, 20, 1943),
('Clean Code',                       'Robert C. Martin',          'Tecnologia', 119.90, 6, 2008),
('The Pragmatic Programmer',         'Andrew Hunt e David Thomas','Tecnologia', 134.90, 4, 1999);

-- Conferindo
SELECT * FROM livros;
```

---

## 4. Parte 3 – Functions

Lembre-se: **function usa `RETURNS` e `RETURN`, é executada com `SELECT` e não usa `IN`** na assinatura.

> Os parâmetros começam com `p_` para não serem confundidos com os nomes das colunas da tabela.

### 3.1 – Function com 2 parâmetros: preço com desconto

**Enunciado:** receba um preço e um percentual de desconto e retorne o preço final.

```sql
DROP FUNCTION IF EXISTS calcular_desconto;

DELIMITER //

CREATE FUNCTION calcular_desconto(
    p_preco DECIMAL(10,2),
    p_percentual DECIMAL(5,2)
)
RETURNS DECIMAL(10,2)      -- tipo do valor devolvido
DETERMINISTIC              -- mesmas entradas = mesmo resultado
BEGIN
    -- preço menos a parte do desconto
    RETURN p_preco - (p_preco * p_percentual / 100);
END //

DELIMITER ;
```

### 3.2 – Function com 2 parâmetros: valor total de um item

**Enunciado:** receba preço e quantidade e retorne o valor total.

```sql
DROP FUNCTION IF EXISTS valor_total_item;

DELIMITER //

CREATE FUNCTION valor_total_item(
    p_preco DECIMAL(10,2),
    p_quantidade INT
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN p_preco * p_quantidade;
END //

DELIMITER ;
```

### 3.3 – Function com IF / ELSEIF: classificar estoque

**Enunciado:** receba a quantidade em estoque e retorne:

- `'Esgotado'` se for 0
- `'Estoque baixo'` se for menor que 5
- `'Estoque médio'` se for menor que 10
- `'Estoque alto'` nos demais casos

```sql
DROP FUNCTION IF EXISTS classificar_estoque;

DELIMITER //

CREATE FUNCTION classificar_estoque(p_quantidade INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    IF p_quantidade = 0 THEN
        RETURN 'Esgotado';
    ELSEIF p_quantidade < 5 THEN          -- chega aqui só se for maior que 0
        RETURN 'Estoque baixo';
    ELSEIF p_quantidade < 10 THEN         -- chega aqui só se for 5 ou mais
        RETURN 'Estoque médio';
    ELSE                                  -- 10 ou mais
        RETURN 'Estoque alto';
    END IF;
END //

DELIMITER ;
```

### 3.4 – Function que consulta a tabela: valor em estoque de um livro

**Enunciado:** receba o id de um livro e retorne o valor total parado em estoque (preço × quantidade). Se o livro não existir, retorne 0.

```sql
DROP FUNCTION IF EXISTS valor_estoque_livro;

DELIMITER //

CREATE FUNCTION valor_estoque_livro(p_id INT)
RETURNS DECIMAL(12,2)
READS SQL DATA                      -- avisa que a function lê dados de tabelas
BEGIN
    DECLARE v_total DECIMAL(12,2);  -- variável local (DECLARE vem logo após o BEGIN)

    -- SELECT ... INTO guarda o resultado na variável
    SELECT preco * quantidade
    INTO v_total
    FROM livros
    WHERE id = p_id;

    -- Se o id não existir, v_total fica NULL; IFNULL troca por 0
    RETURN IFNULL(v_total, 0);
END //

DELIMITER ;
```

### 3.5 – Function sem parâmetro e NOT DETERMINISTIC: gerar cupom

**Enunciado:** gere um código de cupom aleatório no formato `LIV0000` (4 dígitos aleatórios).

```sql
DROP FUNCTION IF EXISTS gerar_cupom;

DELIMITER //

CREATE FUNCTION gerar_cupom()          -- parênteses vazios: sem parâmetros
RETURNS VARCHAR(10)
NOT DETERMINISTIC                      -- RAND() muda a cada execução
BEGIN
    -- FLOOR(RAND() * 10000) gera de 0 a 9999
    -- LPAD completa com zeros à esquerda até ter 4 dígitos
    RETURN CONCAT('LIV', LPAD(FLOOR(RAND() * 10000), 4, '0'));
END //

DELIMITER ;
```

---

## 5. Parte 4 – Stored Procedures (CRUD)

Lembre-se: **procedure é executada com `CALL` e recebe parâmetros com `IN`**.

### 4.1 – READ: procedure sem parâmetro

**Enunciado:** liste todos os livros ordenados por título.

```sql
DROP PROCEDURE IF EXISTS listar_livros;

DELIMITER //

CREATE PROCEDURE listar_livros()       -- parênteses vazios
BEGIN
    SELECT *
    FROM livros
    ORDER BY titulo;
END //

DELIMITER ;
```

### 4.2 – READ: procedure com 1 parâmetro IN

**Enunciado:** receba o id e mostre apenas aquele livro.

```sql
DROP PROCEDURE IF EXISTS buscar_livro;

DELIMITER //

CREATE PROCEDURE buscar_livro(IN p_id INT)
BEGIN
    SELECT *
    FROM livros
    WHERE id = p_id;
END //

DELIMITER ;
```

### 4.3 – READ: procedure com múltiplos parâmetros IN

**Enunciado:** receba uma categoria e um preço máximo e mostre os livros dessa categoria que custem até esse valor.

```sql
DROP PROCEDURE IF EXISTS buscar_por_categoria_preco;

DELIMITER //

CREATE PROCEDURE buscar_por_categoria_preco(
    IN p_categoria VARCHAR(50),        -- 1º parâmetro
    IN p_preco_max DECIMAL(10,2)       -- 2º parâmetro
)
BEGIN
    SELECT *
    FROM livros
    WHERE categoria = p_categoria
      AND preco <= p_preco_max;        -- as duas condições precisam ser verdadeiras
END //

DELIMITER ;
```

### 4.4 – CREATE: cadastrar um livro

**Enunciado:** receba todos os dados de um livro, insira na tabela e mostre o id gerado.

```sql
DROP PROCEDURE IF EXISTS cadastrar_livro;

DELIMITER //

CREATE PROCEDURE cadastrar_livro(
    IN p_titulo VARCHAR(150),
    IN p_autor VARCHAR(100),
    IN p_categoria VARCHAR(50),
    IN p_preco DECIMAL(10,2),
    IN p_quantidade INT,
    IN p_ano INT
)
BEGIN
    -- O id não é informado: o AUTO_INCREMENT gera sozinho
    INSERT INTO livros (titulo, autor, categoria, preco, quantidade, ano_publicacao)
    VALUES (p_titulo, p_autor, p_categoria, p_preco, p_quantidade, p_ano);

    -- LAST_INSERT_ID() devolve o id que acabou de ser gerado
    SELECT LAST_INSERT_ID() AS novo_id;
END //

DELIMITER ;
```

### 4.5 – UPDATE: atualizar o preço

**Enunciado:** receba o id e o novo preço, atualize o livro e informe quantas linhas foram alteradas.

```sql
DROP PROCEDURE IF EXISTS atualizar_preco;

DELIMITER //

CREATE PROCEDURE atualizar_preco(
    IN p_id INT,
    IN p_novo_preco DECIMAL(10,2)
)
BEGIN
    UPDATE livros
    SET preco = p_novo_preco
    WHERE id = p_id;                   -- sem WHERE, atualizaria TODOS os livros!

    -- ROW_COUNT() informa quantas linhas foram alteradas pelo último comando
    SELECT ROW_COUNT() AS linhas_afetadas;
END //

DELIMITER ;
```

### 4.6 – UPDATE: repor estoque

**Enunciado:** receba o id e a quantidade a adicionar ao estoque.

```sql
DROP PROCEDURE IF EXISTS repor_estoque;

DELIMITER //

CREATE PROCEDURE repor_estoque(
    IN p_id INT,
    IN p_qtd INT
)
BEGIN
    UPDATE livros
    SET quantidade = quantidade + p_qtd   -- soma ao valor que já existe
    WHERE id = p_id;
END //

DELIMITER ;
```

### 4.7 – DELETE: excluir um livro

**Enunciado:** receba o id e exclua o livro, informando quantas linhas foram removidas.

```sql
DROP PROCEDURE IF EXISTS excluir_livro;

DELIMITER //

CREATE PROCEDURE excluir_livro(IN p_id INT)
BEGIN
    DELETE FROM livros
    WHERE id = p_id;                   -- o WHERE é essencial: sem ele, apaga a tabela inteira

    SELECT ROW_COUNT() AS linhas_removidas;
END //

DELIMITER ;
```

---

## 6. Parte 5 – Procedures com OUT e INOUT

| Tipo    | Direção                                                   |
| ------- | --------------------------------------------------------- |
| `IN`    | O valor **entra** na procedure                            |
| `OUT`   | A procedure **devolve** um valor para quem chamou         |
| `INOUT` | O valor **entra**, é modificado e **sai** alterado        |

Para receber valores `OUT` e `INOUT`, usamos **variáveis de sessão** (que começam com `@`) no `CALL`.

### 5.1 – OUT: contar livros de uma categoria

**Enunciado:** receba uma categoria e devolva, por um parâmetro de saída, quantos livros existem nela.

```sql
DROP PROCEDURE IF EXISTS contar_por_categoria;

DELIMITER //

CREATE PROCEDURE contar_por_categoria(
    IN  p_categoria VARCHAR(50),       -- entra
    OUT p_total INT                    -- sai
)
BEGIN
    -- O resultado do COUNT é guardado direto no parâmetro OUT
    SELECT COUNT(*)
    INTO p_total
    FROM livros
    WHERE categoria = p_categoria;
END //

DELIMITER ;
```

### 5.2 – INOUT: aplicar reajuste a um valor

**Enunciado:** receba um valor e um percentual. O mesmo parâmetro que entrou com o valor original deve sair com o valor reajustado.

```sql
DROP PROCEDURE IF EXISTS aplicar_reajuste;

DELIMITER //

CREATE PROCEDURE aplicar_reajuste(
    INOUT p_valor DECIMAL(10,2),       -- entra com o original, sai com o reajustado
    IN    p_percentual DECIMAL(5,2)
)
BEGIN
    SET p_valor = p_valor + (p_valor * p_percentual / 100);
END //

DELIMITER ;
```

### 5.3 – IN + OUT + IF + DECLARE: vender um livro

**Enunciado:** receba o id do livro e a quantidade desejada. A procedure deve:

1. Recusar quantidade menor ou igual a zero.
2. Informar se o livro não existe.
3. Informar se o estoque é insuficiente.
4. Caso contrário, dar baixa no estoque e devolver uma mensagem com o total da venda.

A mensagem sai pelo parâmetro `OUT`.

```sql
DROP PROCEDURE IF EXISTS vender_livro;

DELIMITER //

CREATE PROCEDURE vender_livro(
    IN  p_id INT,
    IN  p_qtd INT,
    OUT p_mensagem VARCHAR(100)
)
BEGIN
    -- Variáveis locais (sempre logo após o BEGIN)
    DECLARE v_estoque INT;
    DECLARE v_preco DECIMAL(10,2);

    -- Busca estoque e preço do livro. Se o id não existir, as variáveis ficam NULL
    SELECT quantidade, preco
    INTO v_estoque, v_preco
    FROM livros
    WHERE id = p_id;

    -- Validações, da mais básica para a mais específica
    IF p_qtd <= 0 THEN
        SET p_mensagem = 'Quantidade inválida';

    ELSEIF v_estoque IS NULL THEN
        SET p_mensagem = 'Livro não encontrado';

    ELSEIF v_estoque < p_qtd THEN
        SET p_mensagem = 'Estoque insuficiente';

    ELSE
        -- Tudo certo: dá baixa no estoque
        UPDATE livros
        SET quantidade = quantidade - p_qtd
        WHERE id = p_id;

        -- Usa a function criada anteriormente para calcular o total
        SET p_mensagem = CONCAT('Venda realizada! Total: R$ ', valor_total_item(v_preco, p_qtd));
    END IF;
END //

DELIMITER ;
```

---

## 7. Parte 6 – Procedures que usam Functions

**Enunciado:** crie um relatório de estoque que mostre, para cada livro: título, preço, quantidade, a classificação do estoque, o valor total parado em estoque e o preço promocional com 10% de desconto.

```sql
DROP PROCEDURE IF EXISTS relatorio_estoque;

DELIMITER //

CREATE PROCEDURE relatorio_estoque()
BEGIN
    SELECT
        id,
        titulo,
        preco,
        quantidade,
        classificar_estoque(quantidade)      AS situacao,           -- function 3.3
        valor_total_item(preco, quantidade)  AS valor_em_estoque,   -- function 3.2
        calcular_desconto(preco, 10)         AS preco_promocional   -- function 3.1
    FROM livros
    ORDER BY titulo;
END //

DELIMITER ;
```

---

## 8. Parte 7 – Roteiro de testes

Execute na ordem e compare com os resultados esperados (considerando os dados da Parte 2).

### Testando as Functions (`SELECT`)

```sql
SELECT calcular_desconto(100, 15);        -- 85.00
SELECT valor_total_item(39.90, 3);        -- 119.70

SELECT classificar_estoque(0);            -- Esgotado
SELECT classificar_estoque(3);            -- Estoque baixo
SELECT classificar_estoque(8);            -- Estoque médio
SELECT classificar_estoque(12);           -- Estoque alto

SELECT valor_estoque_livro(1);            -- 478.80  (39.90 * 12)
SELECT valor_estoque_livro(99);           -- 0.00    (livro inexistente)

SELECT gerar_cupom();                     -- ex.: LIV4821 (execute várias vezes: muda)
```

### Testando o CRUD (`CALL`)

```sql
-- READ
CALL listar_livros();                                -- 8 livros, em ordem alfabética
CALL buscar_livro(2);                                -- O Cortiço
CALL buscar_por_categoria_preco('Romance', 40);      -- Dom Casmurro, O Cortiço e Vidas Secas

-- CREATE
CALL cadastrar_livro('Grande Sertão: Veredas', 'João Guimarães Rosa', 'Romance', 59.90, 10, 1956);
                                                     -- novo_id = 9

-- UPDATE
CALL atualizar_preco(2, 37.00);                      -- linhas_afetadas = 1
CALL repor_estoque(4, 10);                           -- Capitães da Areia passa de 0 para 10
CALL buscar_livro(4);                                -- confira a quantidade 10

-- DELETE
CALL excluir_livro(9);                               -- linhas_removidas = 1
CALL buscar_livro(9);                                -- nenhum resultado
```

### Testando OUT e INOUT

```sql
-- OUT: o resultado vai para a variável @total
CALL contar_por_categoria('Romance', @total);
SELECT @total;                                       -- 5 (já sem o livro 9 excluído)

CALL contar_por_categoria('Tecnologia', @total);
SELECT @total;                                       -- 2

-- INOUT: a variável entra com 100 e sai com 110
SET @preco = 100.00;
CALL aplicar_reajuste(@preco, 10);
SELECT @preco;                                       -- 110.00
```

### Testando a venda (IN + OUT + IF)

```sql
CALL vender_livro(1, 2, @msg);
SELECT @msg;                                         -- Venda realizada! Total: R$ 79.80
CALL buscar_livro(1);                                -- quantidade passou de 12 para 10

CALL vender_livro(2, 50, @msg);
SELECT @msg;                                         -- Estoque insuficiente

CALL vender_livro(99, 1, @msg);
SELECT @msg;                                         -- Livro não encontrado

CALL vender_livro(1, 0, @msg);
SELECT @msg;                                         -- Quantidade inválida
```

### Testando o relatório (procedure usando functions)

```sql
CALL relatorio_estoque();
```

Resultado esperado para algumas linhas (depois dos testes acima):

| titulo             | quantidade | situacao      |
| ------------------ | ---------- | ------------- |
| Capitães da Areia  | 10         | Estoque alto  |
| Dom Casmurro       | 10         | Estoque alto  |
| O Cortiço          | 3          | Estoque baixo |
| Clean Code         | 6          | Estoque médio |

---

## 9. Parte 8 – Limpeza

Quando terminar, remova tudo. Ao apagar o banco, as functions e procedures dele são apagadas junto.

```sql
-- Remove um objeto específico
DROP PROCEDURE IF EXISTS listar_livros;
DROP FUNCTION IF EXISTS gerar_cupom;

-- Remove o banco inteiro (tabela, procedures e functions)
DROP DATABASE IF EXISTS livraria;
```

---

## 10. Desafios extras

Tente resolver sozinho antes de procurar a resposta:

1. **Function:** `classificar_livro(p_ano INT)` que retorne `'Clássico'` se o ano for menor que 1950, `'Moderno'` entre 1950 e 1999 e `'Contemporâneo'` de 2000 em diante.
2. **Procedure com IN:** `livros_por_autor(IN p_autor VARCHAR(100))` que liste os livros de um autor.
3. **Procedure com múltiplos IN:** `buscar_por_ano(IN p_ano_inicial INT, IN p_ano_final INT)` que liste livros publicados nesse intervalo.
4. **Procedure com OUT:** `valor_total_estoque(OUT p_total DECIMAL(12,2))` que devolva a soma de `preco * quantidade` de **todos** os livros.
5. **Procedure com INOUT:** `aplicar_cupom(INOUT p_valor DECIMAL(10,2), IN p_desconto DECIMAL(5,2))` que reduza o valor em um percentual.
6. **Procedure com function:** `relatorio_classicos()` que liste título e ano junto com o resultado da function do desafio 1.
7. **Procedure com validação:** `cadastrar_livro_seguro(...)` que só insira se o preço for maior que zero, devolvendo uma mensagem por parâmetro `OUT`.

---

**Bons estudos!**
