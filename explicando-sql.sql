/* =====================================================================
   1) CRIAR O BANCO DE DADOS   (DDL - Data Definition Language)
   ===================================================================== */
 
-- Apaga o banco se ele já existir, para começar sempre do zero.
DROP DATABASE IF EXISTS db_biblioteca;
 
-- Cria o banco de dados.
CREATE DATABASE db_biblioteca;
 
-- Diz ao SGBD que os próximos comandos são dentro desse banco.
USE db_biblioteca;
 
 
/* =====================================================================
   2) CRIAR AS TABELAS   (DDL)
 
   Regra do professor: primeiro criamos as tabelas SÓ com colunas e chave
   primária (PK). Os relacionamentos vêm depois, na seção 3.
 
   Modelo:
     tb_categoria  1 ---- N  tb_livro
     tb_aluno      1 ---- N  tb_emprestimo  N ---- 1  tb_livro
     (aluno x livro é N:N, resolvido pela tabela associativa tb_emprestimo)
   ===================================================================== */
 
-- Tabela PAI. Não depende de nenhuma outra.
-- PK: cd_categoria (identifica cada categoria de forma única).
CREATE TABLE tb_categoria (
    cd_categoria INT NOT NULL PRIMARY KEY,
    categoria    VARCHAR(40) NOT NULL
);
 
-- Tabela FILHA de tb_categoria.
-- PK: cd_livro.
-- cd_categoria será FK (seção 3). Aceita NULL: um livro pode estar sem categoria.
-- isbn será chave candidata (seção 3): também identifica o livro sozinho.
CREATE TABLE tb_livro (
    cd_livro     INT NOT NULL PRIMARY KEY,
    titulo       VARCHAR(80) NOT NULL,
    isbn         CHAR(13) NOT NULL,
    cd_categoria INT
);
 
-- Tabela PAI. Não depende de nenhuma outra.
-- PK: matricula.
-- cpf e email serão chaves candidatas (seção 3).
CREATE TABLE tb_aluno (
    matricula INT NOT NULL PRIMARY KEY,
    aluno     VARCHAR(60) NOT NULL,
    cpf       CHAR(11) NOT NULL,
    email     VARCHAR(60)
);
 
-- Tabela ASSOCIATIVA (resolve o relacionamento N:N entre aluno e livro).
-- PK COMPOSTA: (matricula, cd_livro, dt_emprestimo)
--   -> dt_emprestimo entra na PK porque o mesmo aluno pode pegar o mesmo
--      livro mais de uma vez, em datas diferentes.
-- matricula e cd_livro serão FKs (seção 3) e também fazem parte da PK.
-- dt_devolucao aceita NULL: NULL significa "ainda não devolvido".
CREATE TABLE tb_emprestimo (
    matricula     INT NOT NULL,
    cd_livro      INT NOT NULL,
    dt_emprestimo DATE NOT NULL,
    dt_devolucao  DATE,
    PRIMARY KEY (matricula, cd_livro, dt_emprestimo)
);
 
 
/* =====================================================================
   3) CRIAR OS RELACIONAMENTOS   (DDL - ALTER TABLE)
 
   COMO DECIDIR ONDE VAI A CHAVE ESTRANGEIRA (FK):
     a) A coluna é a PK de OUTRA tabela?        -> então ela é FK.
     b) A FK fica na tabela FILHA (lado N).
     c) O REFERENCES aponta para a tabela PAI (lado 1).
     d) Leia sempre como: "FILHA referencia PAI".
     e) A coluna da FK precisa EXISTIR na tabela do ALTER TABLE.
 
   Estrutura do comando:
     ALTER TABLE <filha>
     ADD CONSTRAINT <nome_da_fk> FOREIGN KEY (<coluna_na_filha>)
     REFERENCES <pai> (<pk_do_pai>);
   ===================================================================== */
 
-- 3.1) tb_livro x tb_categoria  (1:N)
--      Filha: tb_livro | Pai: tb_categoria | Coluna: cd_categoria
ALTER TABLE tb_livro
ADD CONSTRAINT fk_livro_categoria FOREIGN KEY (cd_categoria)
REFERENCES tb_categoria (cd_categoria);
 
-- 3.2) tb_emprestimo x tb_aluno  (lado "aluno" do N:N)
--      Filha: tb_emprestimo | Pai: tb_aluno | Coluna: matricula
ALTER TABLE tb_emprestimo
ADD CONSTRAINT fk_emprestimo_aluno FOREIGN KEY (matricula)
REFERENCES tb_aluno (matricula);
 
-- 3.3) tb_emprestimo x tb_livro  (lado "livro" do N:N)
--      Filha: tb_emprestimo | Pai: tb_livro | Coluna: cd_livro
ALTER TABLE tb_emprestimo
ADD CONSTRAINT fk_emprestimo_livro FOREIGN KEY (cd_livro)
REFERENCES tb_livro (cd_livro);
 
-- 3.4) CHAVES CANDIDATAS (regra 4: ISBN, CPF e e-mail são únicos)
--      Chave candidata = poderia ser a PK, mas não foi escolhida.
--      Garantimos que não se repete com a constraint UNIQUE.
ALTER TABLE tb_livro
ADD CONSTRAINT uq_livro_isbn UNIQUE (isbn);
 
ALTER TABLE tb_aluno
ADD CONSTRAINT uq_aluno_cpf UNIQUE (cpf);
 
ALTER TABLE tb_aluno
ADD CONSTRAINT uq_aluno_email UNIQUE (email);
 
 
/* =====================================================================
   4) CONFERIR A ESTRUTURA
   ===================================================================== */
 
-- Lista as colunas, tipos e chaves da tabela.
DESCRIBE tb_emprestimo;
 
-- Mostra o comando completo de criação, incluindo as FKs criadas acima.
SHOW CREATE TABLE tb_emprestimo;
 
 
/* =====================================================================
   5) INCLUIR DADOS   (DML - Data Manipulation Language: INSERT)
 
   ORDEM OBRIGATÓRIA: PAIS PRIMEIRO, FILHAS DEPOIS.
   A FK só aceita valores que já existem na tabela pai.
     1º tb_categoria e tb_aluno  (não dependem de ninguém)
     2º tb_livro                 (depende de categoria)
     3º tb_emprestimo            (depende de aluno e livro)
   ===================================================================== */
 
-- 5.1) Categorias
INSERT INTO tb_categoria (cd_categoria, categoria) VALUES
(1, 'Romance'),
(2, 'Tecnologia'),
(3, 'Historia'),
(4, 'Poesia');                 -- ficará sem livros (usada na seção 10)
 
-- 5.2) Alunos
INSERT INTO tb_aluno (matricula, aluno, cpf, email) VALUES
(1, 'Ana Lima',     '11111111111', 'ana@escola.com'),
(2, 'Bruno Costa',  '22222222222', 'bruno@escola.com'),
(3, 'Carla Dias',   '33333333333', 'carla@escola.com'),   -- nunca pegará livro
(4, 'Daniel Souza', '44444444444', 'daniel@escola.com');  -- usado na seção 10
 
-- 5.3) Livros (a categoria já existe, então a FK aceita)
INSERT INTO tb_livro (cd_livro, titulo, isbn, cd_categoria) VALUES
(1, 'Dom Casmurro',   '9780000000011', 1),
(2, 'Banco de Dados', '9780000000028', 2),
(3, 'Sapiens',        '9780000000035', 3),      -- nunca será emprestado
(4, 'Clean Code',     '9780000000042', 2),
(5, 'Poemas Avulsos', '9780000000059', NULL);   -- SEM categoria (NULL é permitido)
 
-- 5.4) Empréstimos (aluno e livro já existem)
INSERT INTO tb_emprestimo (matricula, cd_livro, dt_emprestimo, dt_devolucao) VALUES
(1, 1, '2024-03-01', '2024-03-15'),
(1, 2, '2024-03-10', NULL),            -- NULL = ainda não devolvido
(2, 2, '2024-03-12', '2024-03-20'),
(1, 1, '2024-05-02', NULL),            -- mesmo aluno + mesmo livro, outra data (permitido pela PK)
(2, 5, '2024-06-01', NULL),            -- livro sem categoria
(4, 4, '2024-06-10', '2024-06-20');
 
-- 5.5) TESTES DE ERRO (integridade referencial na inclusão) - comentados
 
-- ERRO: o livro 99 não existe em tb_livro (viola fk_emprestimo_livro).
-- INSERT INTO tb_emprestimo (matricula, cd_livro, dt_emprestimo) VALUES (1, 99, '2024-07-01');
 
-- ERRO: a categoria 50 não existe em tb_categoria (viola fk_livro_categoria).
-- INSERT INTO tb_livro (cd_livro, titulo, isbn, cd_categoria) VALUES (6, 'Teste', '9780000000066', 50);
 
-- ERRO: CPF repetido (viola a chave candidata uq_aluno_cpf).
-- INSERT INTO tb_aluno (matricula, aluno, cpf, email) VALUES (5, 'Eva', '11111111111', 'eva@escola.com');
 
-- ERRO: PK repetida (mesmo aluno, mesmo livro, mesma data).
-- INSERT INTO tb_emprestimo (matricula, cd_livro, dt_emprestimo) VALUES (1, 1, '2024-03-01');
 
 
/* =====================================================================
   6) ALTERAR DADOS   (DML: UPDATE)
 
   REGRA DE OURO: SEMPRE use WHERE. Sem WHERE, o UPDATE altera TODAS as linhas.
   Dica: teste o WHERE antes com um SELECT.
   ===================================================================== */
 
-- 6.1) Registrar a devolução do empréstimo da Ana (livro 2, dia 10/03).
--      A linha é localizada pela PK completa (matricula + cd_livro + dt_emprestimo).
UPDATE tb_emprestimo
SET dt_devolucao = '2024-03-25'
WHERE matricula = 1
  AND cd_livro = 2
  AND dt_emprestimo = '2024-03-10';
 
-- 6.2) Corrigir o e-mail de um aluno.
UPDATE tb_aluno
SET email = 'ana.lima@escola.com'
WHERE matricula = 1;
 
-- 6.3) Alterar duas colunas ao mesmo tempo (separadas por vírgula).
UPDATE tb_livro
SET titulo = 'Poemas Avulsos - Edição 2',
    cd_categoria = 3                     -- passa a ter a categoria 3 (Historia) só para exemplo
WHERE cd_livro = 5;
 
-- Voltando o livro 5 para "sem categoria" (NULL), para os exemplos de JOIN seguintes.
UPDATE tb_livro
SET titulo = 'Poemas Avulsos',
    cd_categoria = NULL
WHERE cd_livro = 5;
 
-- PERIGO (não execute): sem WHERE, TODOS os alunos ficariam com o mesmo e-mail.
-- UPDATE tb_aluno SET email = 'teste@escola.com';
 
 
/* =====================================================================
   7) CONSULTAS SIMPLES   (DML: SELECT)
   ===================================================================== */
 
-- 7.1) Todas as colunas e linhas de uma tabela.
SELECT * FROM tb_aluno;
 
-- 7.2) Só algumas colunas.
SELECT titulo, isbn FROM tb_livro;
 
-- 7.3) Com filtro (WHERE): livros da categoria 2 (Tecnologia).
SELECT * FROM tb_livro WHERE cd_categoria = 2;
 
-- 7.4) Empréstimos ainda não devolvidos. Atenção: é IS NULL, nunca "= NULL".
SELECT * FROM tb_emprestimo WHERE dt_devolucao IS NULL;
 
-- Problema desta consulta: só aparecem NÚMEROS (matricula, cd_livro).
-- Para ver NOMES e TÍTULOS, precisamos juntar as tabelas: seção 8.
 
 
/* =====================================================================
   8) JOINs   (juntar tabelas usando as FKs como ponte)
 
   REGRA: o ON sempre compara FK = PK.
   - JOIN (INNER JOIN): só traz linhas com correspondência nas duas tabelas.
   - LEFT JOIN: traz TODAS as linhas da tabela da esquerda; onde não houver
     correspondência na direita, preenche com NULL.
   ===================================================================== */
 
-- 8.1) JOIN completo: aluno, título, categoria e data do empréstimo.
--      Parte de tb_emprestimo (é ela que tem as FKs para as outras).
SELECT
    a.aluno,                  -- vem de tb_aluno (apelido a)
    l.titulo,                 -- vem de tb_livro (apelido l)
    c.categoria,              -- vem de tb_categoria (apelido c)
    e.dt_emprestimo           -- vem de tb_emprestimo (apelido e)
FROM tb_emprestimo e
JOIN tb_aluno a  ON a.matricula = e.matricula           -- FK matricula = PK do aluno
JOIN tb_livro l  ON l.cd_livro  = e.cd_livro            -- FK cd_livro  = PK do livro
LEFT JOIN tb_categoria c ON c.cd_categoria = l.cd_categoria  -- LEFT: livro pode não ter categoria
ORDER BY e.dt_emprestimo;
/* Resultado esperado (6 linhas):
   Ana Lima     | Dom Casmurro   | Romance    | 2024-03-01
   Ana Lima     | Banco de Dados | Tecnologia | 2024-03-10
   Bruno Costa  | Banco de Dados | Tecnologia | 2024-03-12
   Ana Lima     | Dom Casmurro   | Romance    | 2024-05-02
   Bruno Costa  | Poemas Avulsos | NULL       | 2024-06-01
   Daniel Souza | Clean Code     | Tecnologia | 2024-06-10   */
 
-- 8.2) A MESMA consulta, mas com JOIN comum na categoria: mostra a diferença.
--      O livro "Poemas Avulsos" (sem categoria) SOME do resultado (5 linhas).
SELECT a.aluno, l.titulo, c.categoria, e.dt_emprestimo
FROM tb_emprestimo e
JOIN tb_aluno a     ON a.matricula = e.matricula
JOIN tb_livro l     ON l.cd_livro = e.cd_livro
JOIN tb_categoria c ON c.cd_categoria = l.cd_categoria   -- JOIN comum: perde livro sem categoria
ORDER BY e.dt_emprestimo;
 
-- 8.3) JOIN + WHERE: livros ainda não devolvidos.
--      ON diz COMO ligar as tabelas; WHERE diz QUAIS linhas ficam.
SELECT a.aluno, l.titulo, e.dt_emprestimo
FROM tb_emprestimo e
JOIN tb_aluno a ON a.matricula = e.matricula
JOIN tb_livro l ON l.cd_livro  = e.cd_livro
WHERE e.dt_devolucao IS NULL;
/* Resultado esperado:
   Ana Lima    | Dom Casmurro   | 2024-05-02
   Bruno Costa | Poemas Avulsos | 2024-06-01   */
 
-- 8.4) LEFT JOIN partindo do ALUNO: todos os alunos, mesmo os sem empréstimo.
--      A tabela que deve aparecer por inteiro fica na ESQUERDA (FROM).
SELECT a.aluno, l.titulo
FROM tb_aluno a
LEFT JOIN tb_emprestimo e ON e.matricula = a.matricula
LEFT JOIN tb_livro l      ON l.cd_livro = e.cd_livro
ORDER BY a.aluno;
-- Carla Dias aparece com titulo = NULL, pois nunca pegou livro.
 
-- 8.5) Só os alunos que NUNCA pegaram livro (LEFT JOIN + IS NULL).
--      Se não houve correspondência, as colunas de "e" vêm NULL.
SELECT a.aluno
FROM tb_aluno a
LEFT JOIN tb_emprestimo e ON e.matricula = a.matricula
WHERE e.matricula IS NULL;
-- Resultado esperado: Carla Dias
 
-- 8.6) Só os livros que NUNCA foram emprestados (mesma técnica).
SELECT l.titulo
FROM tb_livro l
LEFT JOIN tb_emprestimo e ON e.cd_livro = l.cd_livro
WHERE e.cd_livro IS NULL;
-- Resultado esperado: Sapiens
 
 
/* =====================================================================
   9) VIEWS   (DDL: CREATE VIEW)
 
   View = consulta salva com um nome. Ela NÃO guarda dados; guarda o SELECT.
   Toda vez que você consulta a view, o SELECT roda e mostra os dados
   atuais. Serve para:
     - não reescrever JOINs grandes toda hora;
     - mostrar ao usuário só as colunas que ele pode ver (nível externo
       da arquitetura em três níveis).
   ===================================================================== */
 
-- 9.1) View com o JOIN completo. CREATE OR REPLACE recria se já existir.
CREATE OR REPLACE VIEW vw_emprestimo_detalhe AS
SELECT
    a.matricula,
    a.aluno,
    l.titulo,
    c.categoria,
    e.dt_emprestimo,
    e.dt_devolucao,
    -- CASE cria uma coluna calculada: texto conforme a condição.
    CASE
        WHEN e.dt_devolucao IS NULL THEN 'Em aberto'
        ELSE 'Devolvido'
    END AS situacao
FROM tb_emprestimo e
JOIN tb_aluno a  ON a.matricula = e.matricula
JOIN tb_livro l  ON l.cd_livro  = e.cd_livro
LEFT JOIN tb_categoria c ON c.cd_categoria = l.cd_categoria;
 
-- 9.2) Usando a view como se fosse uma tabela.
SELECT * FROM vw_emprestimo_detalhe ORDER BY dt_emprestimo;
 
-- 9.3) Filtrando a view.
SELECT aluno, titulo FROM vw_emprestimo_detalhe WHERE situacao = 'Em aberto';
 
-- 9.4) View construída em cima de outra view: só empréstimos em aberto.
CREATE OR REPLACE VIEW vw_nao_devolvidos AS
SELECT aluno, titulo, dt_emprestimo
FROM vw_emprestimo_detalhe
WHERE dt_devolucao IS NULL;
 
SELECT * FROM vw_nao_devolvidos;
 
-- 9.5) View de visão restrita: a recepção enxerga só nome e e-mail dos alunos,
--      sem CPF (exemplo de nível externo / segurança).
CREATE OR REPLACE VIEW vw_aluno_contato AS
SELECT matricula, aluno, email
FROM tb_aluno;
 
SELECT * FROM vw_aluno_contato;
 
-- Para apagar uma view (não apaga dados, só a consulta salva):
-- DROP VIEW vw_aluno_contato;
 
 
/* =====================================================================
   10) EXCLUIR DADOS   (DML: DELETE) E INTEGRIDADE REFERENCIAL
 
   REGRA DE OURO: SEMPRE use WHERE. Sem WHERE, o DELETE apaga TUDO.
   REGRA DA FK: não dá para apagar um PAI que ainda tem FILHOS.
                Primeiro apaga-se (ou reatribui-se) os filhos.
   ===================================================================== */
 
-- 10.1) Excluir registro que NINGUÉM referencia: PERMITIDO.
--       A categoria 4 (Poesia) não tem nenhum livro.
DELETE FROM tb_categoria
WHERE cd_categoria = 4;
 
-- 10.2) Outro exemplo permitido: livro 3 (Sapiens) nunca foi emprestado.
DELETE FROM tb_livro
WHERE cd_livro = 3;
 
-- 10.3) Excluir PAI que tem FILHOS: ERRO (comentado).
--       O livro 1 tem empréstimos em tb_emprestimo.
-- DELETE FROM tb_livro WHERE cd_livro = 1;
--   -> erro de chave estrangeira (fk_emprestimo_livro)
 
-- 10.4) Excluir o aluno 4 (Daniel), que tem um empréstimo.
--       Direto, dá ERRO (comentado):
-- DELETE FROM tb_aluno WHERE matricula = 4;
--   -> erro de chave estrangeira (fk_emprestimo_aluno)
--
--       Forma CORRETA: primeiro o FILHO, depois o PAI.
DELETE FROM tb_emprestimo
WHERE matricula = 4;             -- 1º apaga os empréstimos do Daniel (filha)
 
DELETE FROM tb_aluno
WHERE matricula = 4;             -- 2º agora o aluno pode ser apagado (pai)
 
-- 10.5) Conferindo: o empréstimo do Daniel sumiu da view (ela reflete os dados atuais).
SELECT * FROM vw_emprestimo_detalhe ORDER BY dt_emprestimo;
 
-- 10.6) PERIGO (não execute): sem WHERE apaga todos os empréstimos.
-- DELETE FROM tb_emprestimo;
 
 
/* =====================================================================
   11) REMOVER E RECRIAR UM RELACIONAMENTO   (DDL: ALTER TABLE)
 
   DROP FOREIGN KEY remove SÓ a regra de integridade. A coluna e os dados
   continuam. Sem a FK, o banco passa a aceitar valores inexistentes no pai.
   Ao recriar a FK, se algum dado violar a regra, o ALTER TABLE dá erro.
   ===================================================================== */
 
-- 11.1) Remover o relacionamento livro x categoria.
ALTER TABLE tb_livro
DROP FOREIGN KEY fk_livro_categoria;
 
-- 11.2) Recriar o relacionamento (os dados atuais respeitam a regra, então funciona).
ALTER TABLE tb_livro
ADD CONSTRAINT fk_livro_categoria FOREIGN KEY (cd_categoria)
REFERENCES tb_categoria (cd_categoria);
 
-- 11.3) Conferindo que o relacionamento voltou.
SHOW CREATE TABLE tb_livro;
