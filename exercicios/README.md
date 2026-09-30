# 🗄️ Meus Estudos de SQL - Parte EXERCICIOS
 
> Caderno pessoal de estudos: anotações, scripts e exercícios para dominar SQL e bancos de dados relacionais.

 <div align="center">
  <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS26ltSlJF9w5o7Wi5_YnlptbwaG5lDGGPXCqDyaT0U2g&s=10" width="600" alt="Banner do projeto">


<div align="center">
  <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRC2-Ae0W6bNDCaLHnZOTvgLK6JM04t6MChFiInZeIojw&s=10" width="600" alt="Banner do projeto">

 </div>
---
 
## 🎯 Objetivo
 
Consolidar meu aprendizado em SQL, do básico ao intermediário, com **prática constante**. Aqui eu guardo o que aprendo, os erros que cometo e as soluções que encontro, para revisar rápido antes de provas e projetos.
 
## 📚 Conteúdo
 
| # | Tema | Status |
|---|------|--------|
| 01 | Conceitos: SGBD, DBA, ACID | ✅ |
| 02 | DDL: `CREATE`, `ALTER`, `DROP` | ✅ |
| 03 | DML: `INSERT`, `UPDATE`, `DELETE` | ✅ |
| 04 | DQL: `SELECT`, `WHERE`, `ORDER BY`, `LIMIT` | ✅ |
| 05 | Funções de agregação e `GROUP BY` / `HAVING` | 🔄 |
| 06 | Chaves e relacionamentos (PK, FK, candidata) | 🔄 |
| 07 | `JOIN` (INNER, LEFT, RIGHT, FULL) | 🔄 |
| 08 | Subconsultas | ⏳ |
| 09 | DCL: `GRANT`, `REVOKE` | ⏳ |
| 10 | Views, índices e transações | ⏳ |
 
✅ concluído · 🔄 estudando · ⏳ a fazer
 

## 🧠 Resumos rápidos
 
### Categorias de comandos
 
| Sigla | Nome | Comandos |
|-------|------|----------|
| DDL | Definição de dados | `CREATE`, `ALTER`, `DROP` |
| DML | Manipulação de dados | `INSERT`, `UPDATE`, `DELETE` |
| DQL | Consulta de dados | `SELECT` |
| DCL | Controle de acesso | `GRANT`, `REVOKE` |
| TCL | Controle de transação | `COMMIT`, `ROLLBACK` |
 
### ACID
 
- **A**tomicidade: tudo ou nada
- **C**onsistência: o banco sai de um estado válido para outro válido
- **I**solamento: transações não interferem entre si
- **D**urabilidade: o que foi confirmado permanece

  
### Tipos de chave
 
- **Primária (PK):** identifica cada linha de forma única
- **Candidata:** qualquer coluna (ou conjunto) que poderia ser a PK
- **Estrangeira (FK):** referencia a PK de outra tabela e garante integridade referencial
## 💻 Exemplos que uso como referência
 
### Criando tabelas e relacionamentos
 
Primeiro crio as tabelas, depois adiciono as restrições com `ALTER TABLE`:
 
```sql
CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY,
    nome       VARCHAR(100) NOT NULL
);
 
CREATE TABLE pedido (
    id_pedido  INT PRIMARY KEY,
    data_pedido DATE NOT NULL,
    id_cliente INT NOT NULL
);
 
ALTER TABLE pedido
    ADD CONSTRAINT fk_pedido_cliente
    FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente);
```
 
### Consulta com JOIN e agregação
 
```sql
SELECT c.nome,
       COUNT(p.id_pedido) AS total_pedidos
FROM cliente c
LEFT JOIN pedido p ON p.id_cliente = c.id_cliente
GROUP BY c.nome
HAVING COUNT(p.id_pedido) > 0
ORDER BY total_pedidos DESC;
```
 
## 🧭 Checklist para modelar relacionamentos
 
- [ ] Cada tabela tem uma chave primária?
- [ ] O relacionamento é 1:1, 1:N ou N:N?
- [ ] Em 1:N, a FK fica na tabela do lado "N"
- [ ] Em N:N, criei uma tabela associativa?
- [ ] A FK aponta para uma PK (ou coluna única)?
- [ ] Defini o comportamento de `ON DELETE` / `ON UPDATE`?

## 🐞 Erros comuns (e como evitar)
 
| Erro | Causa provável | Solução |
|------|----------------|---------|
| `cannot add foreign key constraint` | Tipos diferentes entre FK e PK, ou tabela referenciada inexistente | Conferir tipos e ordem de criação |
| `WHERE` com agregação | Agregação só vale em `HAVING` | Usar `HAVING` após o `GROUP BY` |
| Linhas sumindo no `JOIN` | Usei `INNER` em vez de `LEFT` | Escolher o tipo de JOIN conforme a necessidade |
| `UPDATE`/`DELETE` sem `WHERE` | Esquecimento | Testar antes com um `SELECT` |
 
## 🛠️ Ferramentas
 
- SGBD: MySQL 
- Cliente: MySQL Workbench 
- Modelagem: brModelo
  
## 🔗 Referências
 
- Anotações e slides das aulas
- Documentação oficial do SGBD utilizado
- [SQLBolt](https://sqlbolt.com/) e [SQL Zoo](https://sqlzoo.net/) para praticar

 
<div align="center">
📝 *Atualizado conforme eu avanço nos estudos.*
 
</div>
 
