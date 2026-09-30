-- comandos de DDL
-- 05/08/2026

create database bd_rh_0302;

-- usar o db
use bd_rh_0302;

-- criar tabela cargo
create table tb_cargo
(cd_cargo int not null primary key,
cargo char(30));

-- criar tabela setor
create table tb_setor
(cd_setor int not null primary key,
setor char(30));

create table tb_funcionario
(matricula int not null primary key,
funcionario char(30),
dt_nascimento date,
cd_setor int,
cd_cargo int,
salario decimal(12, 2));


-- relacionamentos de tb_funcionario e tb_cargo

alter table tb_funcionario 
add constraint fk_cargo foreign key (cd_cargo)
references tb_cargo (cd_cargo);

-- relacionamentos de tb_funcionario e tb_setor
alter table tb_funcionario 
add constraint fk_setor foreign key (cd_setor)
references tb_setor (cd_setor);

insert into tb_setor (cd_setor, setor) 
values 
(1, 'Enfermaria'),
(2, 'Administracao'),
(3, 'Informatica'),
(4, 'Engenharia'),
(5, 'Juridico'),
(6, 'Logistica'),
(7, 'Presidencia');

select * from tb_setor;


insert into tb_funcionario  
(matricula, funcionario,  dt_nascimento, cd_setor, cd_cargtb_setorcd_setorcd_setorcd_setoro, salario)
Values  
(1,'Ana Clara', '1977-07-05',  5, 1, 3000),
(2,'Patricia Azevedo', '1944-07-04', 1, 1, 4000),
(3,'Jose Maria', '1971-05-10', 3, 1, 6000),
(4,'Sonia Abrantes', '1979-05-29',  4, 1, 7000), 
(5,'Valdir Reinaldo', '1960-09-22',  2, 2, 16000), 
(6,'Jose Alberto', '1955-01-13',  2, 2, 15000);

-- listar 

-- 1)  Listar  a cd_setor = 2  na tabela tb_funcionário
select * from tb_funcionario
where cd_setor = 2; 

-- 2)  Excluir cd_cargo  = 1 na tabela tb_cargo
delete tb_cargo 
where cd_cargo = 1; 





