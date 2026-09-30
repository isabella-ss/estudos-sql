-- Aula de revisão 
-- 23-09-2026

-- DDL
-- DML

-- criar o banco de dados bd_revisao_0302
-- 1

create database bd_revisao_0302; 

-- 2 usar o banco de dados 
use bd_revisao_0302; 

-- criar as tabelas 
-- 3 tb_cliente
create table tb_cliente 
(cd_cliente int not null primary key, 
cliente char(50)); 

-- 4 tb_vendedor 
create table tb_vendedor 
(cd_vendedor int not null primary key, 
vendedor char(50)); 

-- 5 tb_veiculo 
create table tb_veiculo
(cd_veiculo int not null primary key, 
veiculo char(50), 
valor_veiculo decimal(12,2)); 

-- 6 tb_pedido 
-- Chave composta
create table tb_pedido 
(dt_pedido date not null, 
cd_veiculo int not null, 
cd_cliente int not null, 
cd_vendedor int not null, 
nr_pedido int not null, 
valor_pedido decimal(12,2), 
comissao decimal(12,2), 
primary key ( dt_pedido, cd_veiculo, cd_cliente, cd_vendedor)); 

-- fazer o relacionamento
-- 7 tb_pedido x tb_cliente
alter table tb_pedido 
add constraint fk_cliente foreign key (cd_cliente) 
references tb_cliente (cd_cliente); 


-- 8 tb_pedido x tb_vendedor 
alter table tb_pedido 
add constraint fk_vendedor foreign key (cd_vendedor) 
references tb_vendedor (cd_vendedor); 


-- 9 tb_pedido x tb_veiculo 
alter table tb_pedido 
add constraint fk_veiculo foreign key (cd_veiculo) 
references tb_veiculo (cd_veiculo); 


-- popular o banco de dados 

-- vendedor slide 18

select * from tb_vendedor;

Insert into tb_vendedor
(cd_vendedor, vendedor)
Values
(1, 'Anibal'),
(2, 'Antonio de Moraes'), 
(3, 'Barbara Alcantara'), 
(4, 'Deise Castro'),
(5, 'Eider Nascimento');


-- cliente slide 19
select * from tb_cliente; 

Insert into tb_cliente
(cd_cliente, cliente) 
Values 
(1, 'Vallu Nascimento'),
(2, 'Rogeria Negreti'),
(3, 'Henrique Silva'),
(4, 'Wellington Alves'),
(5, 'Jose Pereira');

-- veiculo slide 20
select * from tb_veiculo; 

Insert into tb_veiculo
(cd_veiculo, veiculo, valor_veiculo) 
Values
(1, 'Onix', 52000),
(2, 'Prisma', 49000),
(3, 'S10', 109000),
(4, 'Cruze', 101000),
(5, 'Spin', 69000),
(6, 'Cobalt', 63000);


-- Pedido  slide 21

select * from tb_pedido;

insert into tb_pedido
(nr_pedido, dt_pedido, cd_veiculo, cd_cliente, cd_vendedor, valor_pedido,comissao)
values
(1,'2019-01-10',1,2,3,52000,0),
(2,'2019-02-20',2,3,4,49000,0),
(3,'2019-03-30',3,4,5,109000,0),
(4,'2019-04-10',4,5,1,101000,0),
(5,'2019-05-20',5,5,1,69000,0),
(6,'2019-06-30',6,1,2,63000,0),
(7,'2019-07-10',1,4,5,52000,0),
(8,'2019-08-20',1,4,5,52000,0),
(9,'2019-09-30',1,4,5,52000,0),
(10,'2019-10-10',1,4,5,52000,0);

-- Comandos ddl 
-- criar uma tabela 
create table tb_teste
(cd_teste int not null primary key, 
teste char(30)); 

-- adicionar um campo 
alter table tb_teste 
add nota int; 

-- alterar o tipo de dados do campo nota
alter table tb_teste
modify column nota char(50); 

-- dropar o campo nota
alter table tb_teste
drop column nota; 

-- dropar a tabela tb_teste
drop table tb_teste; 


-- dropar o relacionamento entre tb_pedido x tb_veiculo

ALTER TABLE tb_pedido
DROP FOREIGN KEY fk_veiculo;

-- 9 tb_pedido x tb_veiculo 

alter table tb_pedido 
add constraint fk_veiculo foreign key (cd_veiculo) 
references tb_veiculo (cd_veiculo); 

-- exercicio 
-- 1 Incluir cliente Pedro Nóbrega
select * from tb_cliente; 
-- 6 Pedro Nobrega

insert into tb_cliente 
(cd_cliente, cliente) 
values 
(6,'Pedro Nobrega');

select * from tb_cliente; 

-- 2 Alterar cliente Vallu Nascimento para Carlos Nascimento na tabela cliente
select * from tb_cliente; 
-- cd_cliente = 1 Vallu Nascimento

update tb_cliente 
set cliente = 'Carlos Nascimento' 
where cd_cliente = 1; 

-- 3 Alterar vendedor Anibal para Anibal Santoro
select * from tb_vendedor ; 
-- cd_vendedor = 1 - passar anibal para anibal santoro

update tb_vendedor 
set vendedor = 'Anibal Santoro' 
where cd_vendedor = 1; 



-- 4 Alterar o valor do Pedido 1 parar cd_veiculo 4 e valor R$101.000,00
select * from tb_pedido; 
-- nr_pedido = 1 
-- alterar 2 campos 
-- cd_veiculo 1 para 4 
-- valor_pedido 52000 101000

update tb_pedido 
set cd_veiculo = 4, valor_pedido = 101000 
where nr_pedido = 1 and cd_veiculo = 1 and cd_vendedor = 3; 

update tb_pedido 
set cd_veiculo = 4, valor_pedido = 101000 
where nr_pedido = 1; 


-- 5 Excluir Cliente quando o cd_cliente = 1  (vê se é possível ? Explique ? )
select * from tb_cliente; 

delete from tb_cliente 
where cd_cliente = 1; 

-- esta correto 
-- erro de integridade referencial 

use bd_revisao_0302; 
-- 6 Atualizar o valor da comissão em 10% do valor da venda
select * from tb_pedido; 

update tb_pedido 
set comissao = valor_pedido * 0.1 
where cd_cliente != 50; 

-- 7 lista os nr_pedido, dt_pedido, ( Cliente ), valor_pedido, comissao

select P.nr_pedido, P.dt_pedido, C.cliente, 
       P.valor_pedido as Valor, 
       P.comissao 
from tb_pedido P inner join tb_cliente C 
on P.cd_cliente = C.cd_cliente; 
