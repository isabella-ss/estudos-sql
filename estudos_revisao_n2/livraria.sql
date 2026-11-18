DROP DATABASE IF EXISTS livraria;

CREATE DATABASE livraria
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE livraria;

CREATE TABLE livros (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    titulo         VARCHAR(150) NOT NULL,
    autor          VARCHAR(100) NOT NULL,
    categoria      VARCHAR(50)  NOT NULL,
    preco          DECIMAL(10,2) NOT NULL CHECK (preco >= 0),
    quantidade     INT NOT NULL DEFAULT 0 CHECK (quantidade >= 0),
    ano_publicacao INT
);

INSERT INTO livros (titulo, autor, categoria, preco, quantidade, ano_publicacao)
VALUES
('Dom Casmurro',                    'Machado de Assis',           'Romance',    39.90,  12, 1899),
('O Cortiço',                       'Aluísio Azevedo',            'Romance',    34.50,   3, 1890),
('Memórias Póstumas de Brás Cubas', 'Machado de Assis',           'Romance',    42.00,   8, 1881),
('Capitães da Areia',               'Jorge Amado',                'Romance',    45.90,   0, 1937),
('Vidas Secas',                     'Graciliano Ramos',           'Romance',    36.00,  15, 1938),
('O Pequeno Príncipe',              'Antoine de Saint-Exupéry',   'Infantil',   29.90,  20, 1943),
('Clean Code',                      'Robert C. Martin',           'Tecnologia', 119.90,  6, 2008),
('The Pragmatic Programmer',        'Andrew Hunt e David Thomas', 'Tecnologia', 134.90,  4, 1999);

SELECT * FROM livros;


-- FUNCTIONS

DROP FUNCTION IF EXISTS calcular_desconto;

DELIMITER //

CREATE FUNCTION calcular_desconto(
    p_preco DECIMAL(10,2),
    p_percentual DECIMAL(5,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN p_preco - (p_preco * p_percentual / 100);
END //

DELIMITER ;


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


DROP FUNCTION IF EXISTS classificar_estoque;

DELIMITER //

CREATE FUNCTION classificar_estoque(p_quantidade INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    IF p_quantidade = 0 THEN
        RETURN 'Esgotado';
    ELSEIF p_quantidade < 5 THEN
        RETURN 'Estoque baixo';
    ELSEIF p_quantidade < 10 THEN
        RETURN 'Estoque médio';
    ELSE
        RETURN 'Estoque alto';
    END IF;
END //

DELIMITER ;


DROP FUNCTION IF EXISTS valor_estoque_livro;

DELIMITER //

CREATE FUNCTION valor_estoque_livro(p_id INT)
RETURNS DECIMAL(12,2)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(12,2);

    SELECT preco * quantidade
    INTO v_total
    FROM livros
    WHERE id = p_id;

    RETURN IFNULL(v_total, 0);
END //

DELIMITER ;


DROP FUNCTION IF EXISTS gerar_cupom;

DELIMITER //

CREATE FUNCTION gerar_cupom()
RETURNS VARCHAR(10)
NOT DETERMINISTIC
BEGIN
    RETURN CONCAT('LIV', LPAD(FLOOR(RAND() * 10000), 4, '0'));
END //

DELIMITER ;


-- STORED PROCEDURES (CRUD)

DROP PROCEDURE IF EXISTS listar_livros;

DELIMITER //

CREATE PROCEDURE listar_livros()
BEGIN
    SELECT *
    FROM livros
    ORDER BY titulo;
END //

DELIMITER ;


DROP PROCEDURE IF EXISTS buscar_livro;

DELIMITER //

CREATE PROCEDURE buscar_livro(IN p_id INT)
BEGIN
    SELECT *
    FROM livros
    WHERE id = p_id;
END //

DELIMITER ;


DROP PROCEDURE IF EXISTS buscar_por_categoria_preco;

DELIMITER //

CREATE PROCEDURE buscar_por_categoria_preco(
    IN p_categoria VARCHAR(50),
    IN p_preco_max DECIMAL(10,2)
)
BEGIN
    SELECT *
    FROM livros
    WHERE categoria = p_categoria
      AND preco <= p_preco_max;
END //

DELIMITER ;


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
    INSERT INTO livros (titulo, autor, categoria, preco, quantidade, ano_publicacao)
    VALUES (p_titulo, p_autor, p_categoria, p_preco, p_quantidade, p_ano);

    SELECT LAST_INSERT_ID() AS novo_id;
END //

DELIMITER ;


DROP PROCEDURE IF EXISTS atualizar_preco;

DELIMITER //

CREATE PROCEDURE atualizar_preco(
    IN p_id INT,
    IN p_novo_preco DECIMAL(10,2)
)
BEGIN
    UPDATE livros
    SET preco = p_novo_preco
    WHERE id = p_id;

    SELECT ROW_COUNT() AS linhas_afetadas;
END //

DELIMITER ;


DROP PROCEDURE IF EXISTS repor_estoque;

DELIMITER //

CREATE PROCEDURE repor_estoque(
    IN p_id INT,
    IN p_qtd INT
)
BEGIN
    UPDATE livros
    SET quantidade = quantidade + p_qtd
    WHERE id = p_id;
END //

DELIMITER ;


DROP PROCEDURE IF EXISTS excluir_livro;

DELIMITER //

CREATE PROCEDURE excluir_livro(IN p_id INT)
BEGIN
    DELETE FROM livros
    WHERE id = p_id;

    SELECT ROW_COUNT() AS linhas_removidas;
END //

DELIMITER ;


-- PROCEDURES COM OUT E INOUT

DROP PROCEDURE IF EXISTS contar_por_categoria;

DELIMITER //

CREATE PROCEDURE contar_por_categoria(
    IN  p_categoria VARCHAR(50),
    OUT p_total INT
)
BEGIN
    SELECT COUNT(*)
    INTO p_total
    FROM livros
    WHERE categoria = p_categoria;
END //

DELIMITER ;


DROP PROCEDURE IF EXISTS aplicar_reajuste;

DELIMITER //

CREATE PROCEDURE aplicar_reajuste(
    INOUT p_valor DECIMAL(10,2),
    IN    p_percentual DECIMAL(5,2)
)
BEGIN
    SET p_valor = p_valor + (p_valor * p_percentual / 100);
END //

DELIMITER ;


DROP PROCEDURE IF EXISTS vender_livro;

DELIMITER //

CREATE PROCEDURE vender_livro(
    IN  p_id INT,
    IN  p_qtd INT,
    OUT p_mensagem VARCHAR(100)
)
BEGIN
    DECLARE v_estoque INT;
    DECLARE v_preco DECIMAL(10,2);

    SELECT quantidade, preco
    INTO v_estoque, v_preco
    FROM livros
    WHERE id = p_id;

    IF p_qtd <= 0 THEN
        SET p_mensagem = 'Quantidade inválida';

    ELSEIF v_estoque IS NULL THEN
        SET p_mensagem = 'Livro não encontrado';

    ELSEIF v_estoque < p_qtd THEN
        SET p_mensagem = 'Estoque insuficiente';

    ELSE
        UPDATE livros
        SET quantidade = quantidade - p_qtd
        WHERE id = p_id;

        SET p_mensagem = CONCAT('Venda realizada! Total: R$ ', valor_total_item(v_preco, p_qtd));
    END IF;
END //

DELIMITER ;


-- PROCEDURE QUE USA FUNCTIONS

DROP PROCEDURE IF EXISTS relatorio_estoque;

DELIMITER //

CREATE PROCEDURE relatorio_estoque()
BEGIN
    SELECT
        id,
        titulo,
        preco,
        quantidade,
        classificar_estoque(quantidade)     AS situacao,
        valor_total_item(preco, quantidade) AS valor_em_estoque,
        calcular_desconto(preco, 10)        AS preco_promocional
    FROM livros
    ORDER BY titulo;
END //

DELIMITER ;


-- TESTES: FUNCTIONS

SELECT calcular_desconto(100, 15);
SELECT valor_total_item(39.90, 3);

SELECT classificar_estoque(0);
SELECT classificar_estoque(3);
SELECT classificar_estoque(8);
SELECT classificar_estoque(12);

SELECT valor_estoque_livro(1);
SELECT valor_estoque_livro(99);

SELECT gerar_cupom();


-- TESTES: CRUD

CALL listar_livros();
CALL buscar_livro(2);
CALL buscar_por_categoria_preco('Romance', 40);

CALL cadastrar_livro('Grande Sertão: Veredas', 'João Guimarães Rosa', 'Romance', 59.90, 10, 1956);

CALL atualizar_preco(2, 37.00);
CALL repor_estoque(4, 10);
CALL buscar_livro(4);

CALL excluir_livro(9);
CALL buscar_livro(9);


-- TESTES: OUT E INOUT

CALL contar_por_categoria('Romance', @total);
SELECT @total;

CALL contar_por_categoria('Tecnologia', @total);
SELECT @total;

SET @preco = 100.00;
CALL aplicar_reajuste(@preco, 10);
SELECT @preco;


-- TESTES: VENDA

CALL vender_livro(1, 2, @msg);
SELECT @msg;
CALL buscar_livro(1);

CALL vender_livro(2, 50, @msg);
SELECT @msg;

CALL vender_livro(99, 1, @msg);
SELECT @msg;

CALL vender_livro(1, 0, @msg);
SELECT @msg;


-- TESTE: RELATÓRIO

CALL relatorio_estoque();


-- LIMPEZA (opcional)

-- DROP DATABASE IF EXISTS livraria;
