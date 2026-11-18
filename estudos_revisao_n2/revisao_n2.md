\# Revisão de Banco de Dados – Stored Procedure e Function



Este material apresenta uma revisão dos principais conceitos de \*\*Stored Procedure\*\* e \*\*Function\*\* no MySQL, com explicações, sintaxes, exemplos de códigos e exercícios resolvidos.



\---



\## Sumário (para se localizar)



1\. \[O que é Stored Procedure?](#1-o-que-é-stored-procedure)

2\. \[Vantagens da Stored Procedure](#2-vantagens-da-stored-procedure)

3\. \[Stored Procedure sem Parâmetros](#3-stored-procedure-sem-parâmetros)

4\. \[Stored Procedure com Parâmetro IN](#4-stored-procedure-com-parâmetro-in)

5\. \[Stored Procedure com Múltiplos Parâmetros](#5-stored-procedure-com-múltiplos-parâmetros)

6\. \[Exercícios – Stored Procedure](#6-exercícios--stored-procedure)

7\. \[O que é Function?](#7-o-que-é-function)

8\. \[Deterministic](#8-deterministic)

9\. \[Function sem Parâmetro](#9-function-sem-parâmetro)

10\. \[Function com Parâmetros](#10-function-com-parâmetros)

11\. \[Exercícios – Function](#11-exercícios--function)

12\. \[Resumo Geral](#12-resumo-geral)



\---



\## 1. O que é Stored Procedure?



Uma \*\*Stored Procedure\*\* (Procedimento Armazenado) é um conjunto de comandos SQL armazenados dentro do banco de dados, que podem ser executados sempre que necessário.



Ela serve para automatizar tarefas, realizar consultas, inserir, atualizar e excluir dados.



\### Exemplo de tabela



```sql

CREATE TABLE alunos (

&#x20;   id INT AUTO\_INCREMENT PRIMARY KEY,

&#x20;   nome VARCHAR(100),

&#x20;   idade INT,

&#x20;   nota DECIMAL(4,2)

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



\### Criando uma Stored Procedure



```sql

DELIMITER //



CREATE PROCEDURE listar\_alunos()

BEGIN

&#x20;   SELECT \* FROM alunos;

END //



DELIMITER ;

```



\### Executando a Procedure



```sql

CALL listar\_alunos();

```



\### Entendendo os comandos



\- `DELIMITER //`: altera temporariamente o delimitador de comandos.

\- `CREATE PROCEDURE`: cria uma procedure.

\- `BEGIN`: inicia o bloco de comandos.

\- `SELECT`: realiza uma consulta.

\- `END`: finaliza a procedure.

\- `CALL`: executa a procedure.



\---



\## 2. Vantagens da Stored Procedure



As principais vantagens são:



\- \*\*Reutilização:\*\* permite utilizar o mesmo código várias vezes.

\- \*\*Organização:\*\* mantém os comandos SQL organizados.

\- \*\*Segurança:\*\* permite controlar o acesso às operações do banco.

\- \*\*Manutenção:\*\* facilita alterações em operações utilizadas frequentemente.

\- \*\*Desempenho:\*\* pode reduzir a comunicação entre aplicação e banco de dados.

\- \*\*Automatização:\*\* permite executar vários comandos SQL de uma só vez.



\*\*Exemplo:\*\*



Em vez de escrever a consulta toda vez, basta executar:



```sql

CALL listar\_alunos();

```



\---



\## 3. Stored Procedure sem Parâmetros



É uma procedure que \*\*não recebe nenhuma informação externa\*\*.



Ela executa os comandos que foram programados dentro dela.



\### Exemplo 1 – Listar todos os alunos



```sql

DELIMITER //



CREATE PROCEDURE mostrar\_alunos()

BEGIN

&#x20;   SELECT \* FROM alunos;

END //



DELIMITER ;

```



Executando:



```sql

CALL mostrar\_alunos();

```



\### Exemplo 2 – Mostrar alunos aprovados



```sql

DELIMITER //



CREATE PROCEDURE alunos\_aprovados()

BEGIN

&#x20;   SELECT \*

&#x20;   FROM alunos

&#x20;   WHERE nota >= 7;

END //



DELIMITER ;

```



Executando:



```sql

CALL alunos\_aprovados();

```



> \*\*Importante:\*\* uma procedure sem parâmetros utiliza parênteses vazios `()`.



\---



\## 4. Stored Procedure com Parâmetro IN



O parâmetro `IN` serve para \*\*enviar uma informação para dentro\*\* da Stored Procedure.



Ou seja, você informa um valor e a procedure utiliza esse valor para executar uma consulta.



\### Exemplo 1 – Buscar aluno pelo ID



```sql

DELIMITER //



CREATE PROCEDURE buscar\_aluno(IN codigo INT)

BEGIN

&#x20;   SELECT \*

&#x20;   FROM alunos

&#x20;   WHERE id = codigo;

END //



DELIMITER ;

```



Executando:



```sql

CALL buscar\_aluno(1);

```



\*\*Explicação:\*\*



\- `IN`: indica que o parâmetro recebe um valor.

\- `codigo`: nome do parâmetro.

\- `INT`: tipo de dado.

\- `1`: valor enviado durante a execução.



\### Exemplo 2 – Buscar aluno pelo nome



```sql

DELIMITER //



CREATE PROCEDURE buscar\_nome(IN nome\_aluno VARCHAR(100))

BEGIN

&#x20;   SELECT \*

&#x20;   FROM alunos

&#x20;   WHERE nome = nome\_aluno;

END //



DELIMITER ;

```



Executando:



```sql

CALL buscar\_nome('Maria');

```



\*\*Resultado:\*\* apresenta os dados da aluna Maria.



\---



\## 5. Stored Procedure com Múltiplos Parâmetros



Uma procedure pode receber dois ou mais parâmetros.



Basta separar os parâmetros por vírgula.



\### Exemplo – Buscar alunos por idade e nota



```sql

DELIMITER //



CREATE PROCEDURE buscar\_alunos(

&#x20;   IN idade\_minima INT,

&#x20;   IN nota\_minima DECIMAL(4,2)

)

BEGIN

&#x20;   SELECT \*

&#x20;   FROM alunos

&#x20;   WHERE idade >= idade\_minima

&#x20;   AND nota >= nota\_minima;

END //



DELIMITER ;

```



Executando:



```sql

CALL buscar\_alunos(20, 7);

```



\*\*Explicação:\*\*



\- `20`: idade mínima.

\- `7`: nota mínima.

\- A consulta retorna alunos com idade maior ou igual a 20 \*\*e\*\* nota maior ou igual a 7.



\### Exemplo – Buscar por nome e idade



```sql

DELIMITER //



CREATE PROCEDURE buscar\_por\_nome\_idade(

&#x20;   IN p\_nome VARCHAR(100),

&#x20;   IN p\_idade INT

)

BEGIN

&#x20;   SELECT \*

&#x20;   FROM alunos

&#x20;   WHERE nome = p\_nome

&#x20;   AND idade = p\_idade;

END //



DELIMITER ;

```



Executando:



```sql

CALL buscar\_por\_nome\_idade('João', 20);

```



> \*\*Dica:\*\* os valores informados no `CALL` devem respeitar a \*\*mesma ordem\*\* dos parâmetros definidos na procedure.



\---



\## 6. Exercícios – Stored Procedure



Vamos utilizar a tabela `produtos`.



\### Criando a tabela



```sql

CREATE TABLE produtos (

&#x20;   id INT AUTO\_INCREMENT PRIMARY KEY,

&#x20;   nome VARCHAR(100),

&#x20;   preco DECIMAL(10,2),

&#x20;   quantidade INT

);

```



\### Inserindo dados



```sql

INSERT INTO produtos (nome, preco, quantidade)

VALUES

('Notebook', 3000.00, 5),

('Mouse', 50.00, 20),

('Teclado', 120.00, 10),

('Monitor', 900.00, 8);

```



\### Exercício 1 – Listar todos os produtos



Crie uma Stored Procedure \*\*sem parâmetros\*\* que mostre todos os produtos.



\*\*Resolução:\*\*



```sql

DELIMITER //



CREATE PROCEDURE listar\_produtos()

BEGIN

&#x20;   SELECT \* FROM produtos;

END //



DELIMITER ;

```



\*\*Execução:\*\*



```sql

CALL listar\_produtos();

```



\### Exercício 2 – Buscar produtos pelo preço



Crie uma Stored Procedure que receba um preço mínimo e mostre os produtos com preço maior ou igual ao informado.



\*\*Resolução:\*\*



```sql

DELIMITER //



CREATE PROCEDURE buscar\_preco(

&#x20;   IN p\_preco DECIMAL(10,2)

)

BEGIN

&#x20;   SELECT \*

&#x20;   FROM produtos

&#x20;   WHERE preco >= p\_preco;

END //



DELIMITER ;

```



\*\*Execução:\*\*



```sql

CALL buscar\_preco(100);

```



\### Exercício 3 – Buscar produtos por preço e quantidade



Crie uma Stored Procedure que receba dois parâmetros: preço mínimo e quantidade mínima.



\*\*Resolução:\*\*



```sql

DELIMITER //



CREATE PROCEDURE filtrar\_produtos(

&#x20;   IN p\_preco DECIMAL(10,2),

&#x20;   IN p\_quantidade INT

)

BEGIN

&#x20;   SELECT \*

&#x20;   FROM produtos

&#x20;   WHERE preco >= p\_preco

&#x20;   AND quantidade >= p\_quantidade;

END //



DELIMITER ;

```



\*\*Execução:\*\*



```sql

CALL filtrar\_produtos(100, 5);

```



\---



\## 7. O que é Function?



Uma \*\*Function\*\* (Função) é um bloco de código armazenado no banco de dados que executa uma operação e \*\*retorna um resultado\*\*.



A principal diferença entre Function e Stored Procedure é a maneira como são executadas e retornam resultados.



| Stored Procedure                        | Function                                    |

| --------------------------------------- | ------------------------------------------- |

| Executada com `CALL`                    | Utilizada em expressões SQL                 |

| Pode executar várias instruções         | Deve retornar um valor                      |

| Pode realizar consultas e alterações    | Pode realizar cálculos e retornar resultados |

| Pode receber parâmetros                 | Pode receber parâmetros                     |



\### Exemplo – Somar dois números



```sql

DELIMITER //



CREATE FUNCTION somar(

&#x20;   a INT,

&#x20;   b INT

)

RETURNS INT

DETERMINISTIC

BEGIN

&#x20;   RETURN a + b;

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



\### Entendendo os comandos



\- `CREATE FUNCTION`: cria uma função.

\- `RETURNS INT`: informa o tipo de dado que será retornado.

\- `DETERMINISTIC`: indica que as mesmas entradas produzem o mesmo resultado.

\- `RETURN`: devolve o resultado da função.



\---



\## 8. Deterministic



O `DETERMINISTIC` é uma característica utilizada na criação de funções.



Significa que, quando a função recebe os \*\*mesmos parâmetros\*\*, ela \*\*sempre retorna o mesmo resultado\*\*.



\### Exemplo – Função Deterministic



```sql

DELIMITER //



CREATE FUNCTION dobro(numero INT)

RETURNS INT

DETERMINISTIC

BEGIN

&#x20;   RETURN numero \* 2;

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



\### Exemplo – Função NOT DETERMINISTIC



```sql

DELIMITER //



CREATE FUNCTION numero\_aleatorio()

RETURNS INT

NOT DETERMINISTIC

BEGIN

&#x20;   RETURN FLOOR(RAND() \* 100);

END //



DELIMITER ;

```



Executando:



```sql

SELECT numero\_aleatorio();

```



O resultado pode mudar a cada execução.



\### Diferença



| Tipo                | Significado                                   |

| ------------------- | --------------------------------------------- |

| `DETERMINISTIC`     | Mesmas entradas produzem o mesmo resultado    |

| `NOT DETERMINISTIC` | O resultado pode mudar entre execuções        |



\---



\## 9. Function sem Parâmetro



É uma função que \*\*não recebe valores externos\*\*, mas retorna um resultado.



\### Exemplo 1 – Retornar o número 100



```sql

DELIMITER //



CREATE FUNCTION valor\_fixo()

RETURNS INT

DETERMINISTIC

BEGIN

&#x20;   RETURN 100;

END //



DELIMITER ;

```



Executando:



```sql

SELECT valor\_fixo();

```



Resultado:



```text

100

```



\### Exemplo 2 – Retornar uma mensagem



```sql

DELIMITER //



CREATE FUNCTION mensagem()

RETURNS VARCHAR(50)

DETERMINISTIC

BEGIN

&#x20;   RETURN 'Bem-vindo ao banco de dados!';

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



> \*\*Importante:\*\* uma função sem parâmetros utiliza parênteses vazios `()`.



\---



\## 10. Function com Parâmetros



Uma função pode receber parâmetros para realizar cálculos ou consultas.



No MySQL, os parâmetros de uma Function são de entrada por padrão. Portanto, \*\*não é necessário declarar `IN`\*\* na assinatura, como acontece nas Stored Procedures.



\### Exemplo 1 – Calcular a média de duas notas



```sql

DELIMITER //



CREATE FUNCTION calcular\_media(

&#x20;   nota1 DECIMAL(4,2),

&#x20;   nota2 DECIMAL(4,2)

)

RETURNS DECIMAL(5,2)

DETERMINISTIC

BEGIN

&#x20;   RETURN (nota1 + nota2) / 2;

END //



DELIMITER ;

```



Executando:



```sql

SELECT calcular\_media(8, 10);

```



Resultado:



```text

9.00

```



\### Exemplo 2 – Calcular desconto de um produto



```sql

DELIMITER //



CREATE FUNCTION calcular\_desconto(

&#x20;   preco DECIMAL(10,2),

&#x20;   percentual DECIMAL(5,2)

)

RETURNS DECIMAL(10,2)

DETERMINISTIC

BEGIN

&#x20;   RETURN preco - (preco \* percentual / 100);

END //



DELIMITER ;

```



Executando:



```sql

SELECT calcular\_desconto(200, 10);

```



Resultado:



```text

180.00

```



\*\*Explicação:\*\*



\- Preço original: R$ 200.

\- Desconto: 10%.

\- Valor descontado: R$ 20.

\- Resultado final: R$ 180.



\### Exemplo 3 – Verificar aprovação



```sql

DELIMITER //



CREATE FUNCTION verificar\_aprovacao(

&#x20;   nota DECIMAL(4,2)

)

RETURNS VARCHAR(20)

DETERMINISTIC

BEGIN

&#x20;   IF nota >= 7 THEN

&#x20;       RETURN 'Aprovado';

&#x20;   ELSE

&#x20;       RETURN 'Reprovado';

&#x20;   END IF;

END //



DELIMITER ;

```



Executando:



```sql

SELECT verificar\_aprovacao(8);

```



Resultado:



```text

Aprovado

```



\---



\## 11. Exercícios – Function



Vamos praticar com alguns exercícios resolvidos.



\### Exercício 1 – Function sem parâmetros



Crie uma função que retorne o número 50.



\*\*Resolução:\*\*



```sql

DELIMITER //



CREATE FUNCTION retornar\_valor()

RETURNS INT

DETERMINISTIC

BEGIN

&#x20;   RETURN 50;

END //



DELIMITER ;

```



\*\*Execução:\*\*



```sql

SELECT retornar\_valor();

```



\### Exercício 2 – Function com parâmetro



Crie uma função que receba um número e retorne o seu triplo.



\*\*Resolução:\*\*



```sql

DELIMITER //



CREATE FUNCTION triplo(numero INT)

RETURNS INT

DETERMINISTIC

BEGIN

&#x20;   RETURN numero \* 3;

END //



DELIMITER ;

```



\*\*Execução:\*\*



```sql

SELECT triplo(10);

```



\*\*Resultado:\*\* `30`.



\### Exercício 3 – Function com dois parâmetros



Crie uma função que receba o preço e a quantidade de um produto e retorne o valor total.



\*\*Resolução:\*\*



```sql

DELIMITER //



CREATE FUNCTION calcular\_total(

&#x20;   preco DECIMAL(10,2),

&#x20;   quantidade INT

)

RETURNS DECIMAL(10,2)

DETERMINISTIC

BEGIN

&#x20;   RETURN preco \* quantidade;

END //



DELIMITER ;

```



\*\*Execução:\*\*



```sql

SELECT calcular\_total(50, 3);

```



\*\*Resultado:\*\* `150.00`.



\### Exercício 4 – Function com IF



Crie uma função que receba uma idade e informe se a pessoa é maior ou menor de idade.



\*\*Resolução:\*\*



```sql

DELIMITER //



CREATE FUNCTION verificar\_idade(idade INT)

RETURNS VARCHAR(20)

DETERMINISTIC

BEGIN

&#x20;   IF idade >= 18 THEN

&#x20;       RETURN 'Maior de idade';

&#x20;   ELSE

&#x20;       RETURN 'Menor de idade';

&#x20;   END IF;

END //



DELIMITER ;

```



\*\*Execução:\*\*



```sql

SELECT verificar\_idade(20);

```



\*\*Resultado:\*\* `Maior de idade`.



\---



\## 12. Resumo Geral



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



\### Diferenças que não podem ser confundidas



\#### Stored Procedure



```sql

DELIMITER //



CREATE PROCEDURE teste()

BEGIN

&#x20;   SELECT \* FROM alunos;

END //



DELIMITER ;

```



\*\*Execução:\*\*



```sql

CALL teste();

```



\#### Function



```sql

DELIMITER //



CREATE FUNCTION teste()

RETURNS INT

DETERMINISTIC

BEGIN

&#x20;   RETURN 10;

END //



DELIMITER ;

```



\*\*Execução:\*\*



```sql

SELECT teste();

```



\---



\## Dicas finais para a prova



Memorize estas quatro estruturas:



\*\*1. Procedure sem parâmetro\*\*



```sql

CREATE PROCEDURE nome()

BEGIN

&#x20;   -- comandos SQL

END;

```



\*\*2. Procedure com parâmetro\*\*



```sql

CREATE PROCEDURE nome(IN parametro TIPO)

BEGIN

&#x20;   -- comandos SQL

END;

```



\*\*3. Function sem parâmetro\*\*



```sql

CREATE FUNCTION nome()

RETURNS TIPO

DETERMINISTIC

BEGIN

&#x20;   RETURN valor;

END;

```



\*\*4. Function com parâmetro\*\*



```sql

CREATE FUNCTION nome(parametro TIPO)

RETURNS TIPO

DETERMINISTIC

BEGIN

&#x20;   RETURN valor;

END;

```



\### O que mais merece atenção?



\- `CALL` executa uma Stored Procedure.

\- `SELECT` pode executar uma Function.

\- `IN` recebe valores de entrada na Stored Procedure.

\- `RETURNS` define o tipo de retorno da Function.

\- `RETURN` devolve o resultado da Function.

\- `DETERMINISTIC` indica que as mesmas entradas produzem o mesmo resultado.



\---



\*\*Fim da revisão! Bons estudos!\*\*

