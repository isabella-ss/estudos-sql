DROP DATABASE IF EXISTS db_biblioteca;
CREATE DATABASE db_biblioteca;
USE db_biblioteca;
 
-- -----------------------------------------------------
-- 1) TABELAS (só com as PKs)
-- -----------------------------------------------------
CREATE TABLE tb_categoria (
    cd_categoria INT NOT NULL PRIMARY KEY,
    categoria VARCHAR(40) NOT NULL
);
 
CREATE TABLE tb_livro (
    cd_livro INT NOT NULL PRIMARY KEY,
    titulo VARCHAR(80) NOT NULL,
    isbn CHAR(13) NOT NULL,
    cd_categoria INT
);
 
CREATE TABLE tb_aluno (
    matricula INT NOT NULL PRIMARY KEY,
    aluno VARCHAR(60) NOT NULL,
    cpf CHAR(11) NOT NULL,
    email VARCHAR(60)
);
 
CREATE TABLE tb_emprestimo (
    matricula INT NOT NULL,
    cd_livro INT NOT NULL,
    dt_emprestimo DATE NOT NULL,
    dt_devolucao DATE,
    PRIMARY KEY (matricula, cd_livro, dt_emprestimo)
);
 
-- -----------------------------------------------------
-- 2) RELACIONAMENTOS (depois das tabelas, como o professor pede)
-- -----------------------------------------------------
-- tb_livro x tb_categoria (1:N) -> FK na filha (tb_livro)
ALTER TABLE tb_livro
ADD CONSTRAINT fk_livro_categoria FOREIGN KEY (cd_categoria)
REFERENCES tb_categoria (cd_categoria);
 
-- tb_emprestimo x tb_aluno (N:N resolvido pela tabela associativa)
ALTER TABLE tb_emprestimo
ADD CONSTRAINT fk_emprestimo_aluno FOREIGN KEY (matricula)
REFERENCES tb_aluno (matricula);
 
-- tb_emprestimo x tb_livro
ALTER TABLE tb_emprestimo
ADD CONSTRAINT fk_emprestimo_livro FOREIGN KEY (cd_livro)
REFERENCES tb_livro (cd_livro);
 
-- Chaves candidatas (regra 4)
ALTER TABLE tb_livro ADD CONSTRAINT uq_livro_isbn UNIQUE (isbn);
ALTER TABLE tb_aluno ADD CONSTRAINT uq_aluno_cpf UNIQUE (cpf);
ALTER TABLE tb_aluno ADD CONSTRAINT uq_aluno_email UNIQUE (email);
 
-- -----------------------------------------------------
-- 3) POPULANDO
--    Ordem: 1º tabelas sem FK (categoria, aluno)
--           2º tb_livro (depende de categoria)
--           3º tb_emprestimo (depende de aluno e livro)
-- -----------------------------------------------------
INSERT INTO tb_categoria (cd_categoria, categoria) VALUES
(1, 'Romance'),
(2, 'Tecnologia'),
(3, 'Historia'),
(4, 'Poesia');          
 
INSERT INTO tb_aluno (matricula, aluno, cpf, email) VALUES
(1, 'Ana Lima',    '11111111111', 'ana@escola.com'),
(2, 'Bruno Costa', '22222222222', 'bruno@escola.com'),
(3, 'Carla Dias',  '33333333333', 'carla@escola.com');
 
INSERT INTO tb_livro (cd_livro, titulo, isbn, cd_categoria) VALUES
(1, 'Dom Casmurro',    '9780000000011', 1),
(2, 'Banco de Dados',  '9780000000028', 2),
(3, 'Sapiens',         '9780000000035', 3),
(4, 'Clean Code',      '9780000000042', 2);
 
INSERT INTO tb_emprestimo (matricula, cd_livro, dt_emprestimo, dt_devolucao) VALUES
(1, 1, '2024-03-01', '2024-03-15'),
(1, 2, '2024-03-10', NULL),            
(2, 2, '2024-03-12', '2024-03-20'),
(1, 1, '2024-05-02', NULL);            
 
-- -----------------------------------------------------
-- 4) INTEGRIDADE REFERENCIAL (item 6) - comandos de teste
-- -----------------------------------------------------
-- a) Inserir empréstimo de livro inexistente -> ERRO (fk_emprestimo_livro)
-- INSERT INTO tb_emprestimo (matricula, cd_livro, dt_emprestimo) VALUES (1, 99, '2024-06-01');
 
-- b) Excluir livro já emprestado -> ERRO (o livro 1 tem empréstimos)
-- DELETE FROM tb_livro WHERE cd_livro = 1;
--    Para conseguir: DELETE FROM tb_emprestimo WHERE cd_livro = 1;
--    e depois:       DELETE FROM tb_livro WHERE cd_livro = 1;
--    (o livro 3, Sapiens, nunca foi emprestado e pode ser excluído direto)
 
-- c) Excluir categoria sem livros -> PERMITIDO
DELETE FROM tb_categoria WHERE cd_categoria = 4;
 
-- -----------------------------------------------------
-- 5) JOIN
-- -----------------------------------------------------
-- Aluno, título, categoria e data do empréstimo
SELECT
    a.aluno,
    l.titulo,
    c.categoria,
    e.dt_emprestimo
FROM tb_emprestimo e
JOIN tb_aluno a ON a.matricula = e.matricula
JOIN tb_livro l ON l.cd_livro = e.cd_livro
LEFT JOIN tb_categoria c ON c.cd_categoria = l.cd_categoria
ORDER BY e.dt_emprestimo;
 
-- Extra: livros ainda não devolvidos
SELECT a.aluno, l.titulo, e.dt_emprestimo
FROM tb_emprestimo e
JOIN tb_aluno a ON a.matricula = e.matricula
JOIN tb_livro l ON l.cd_livro = e.cd_livro
WHERE e.dt_devolucao IS NULL;
