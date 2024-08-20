-----------------------------------------------------------------------------------------------------------------
--Criando o Banco de Dados
-----------------------------------------------------------------------------------------------------------------
create database VendasInfoM;
go

-----------------------------------------------------------------------------------------------------------------
--Acessar o Banco de Dados
-----------------------------------------------------------------------------------------------------------------
use VendasInfoM
go

-----------------------------------------------------------------------------------------------------------------
--Criar a Tabela Pessoas
-----------------------------------------------------------------------------------------------------------------
create table Pessoas
(
	idPessoa int not null primary key identity,
	nome varchar(50) not null,
	cpf varchar(14) not null unique,
	status int null,
	--restrições
	check(status in (1,2,3))
)
go

-- Consultar informações sobre a tabela
exec sp_help pessoas
go

-----------------------------------------------------------------------------------------------------------------
--Criar a Tabela Cliente
-----------------------------------------------------------------------------------------------------------------
create table Clientes
(
	pessoaId int not null primary key,
	renda decimal(10,2) not null,
	credito decimal(10,2) not null,
	-- chave estrangeira Fk
	foreign key(pessoaID) references Pessoas(idPessoa),
	--restrições
	check (renda >= 700.00),
	check (credito >= 100.00)
)
go
-----------------------------------------------------------------------------------------------------------------
--Criar a Tabela Vendedor
-----------------------------------------------------------------------------------------------------------------
create table Vendedores
(
	pessoaId int not null primary key,
	salario decimal(10,2) not null check (salario >= 1000.00),
	-- chave estrangeira Fk
	foreign key(pessoaID) references Pessoas(idPessoa),
)
go

-----------------------------------------------------------------------------------------------------------------
--Cadastrar 10 Pessoas - Insert na Tabela Pessoas
-----------------------------------------------------------------------------------------------------------------
insert into Pessoas (nome, cpf, status) 
values ( 'Matheus Evangelista Rodrigues', '111.111.111-11',1)
go

insert into Pessoas (nome, cpf) 
values ( 'Renato Vicente Sobrinho', '222.222.222-22')
go

insert into Pessoas 
values ( 'Giuseppe Camole', '333.333.333-33',2)
go

insert into Pessoas 
values ( 'Gustavo Zinatto', '444.444.444-44',3)
go

insert into Pessoas 
values ( 'Maura Frigo', '555.555.555-55',1),
		('Lucimeire Schinelo', '666.666.666-66',2),
		('Adriano Simonato', '777.777.777-77', 1),
		('Adriana Generoso', '888.888.888-88', 1),
		('Claudia Higalgo', '999.999.999-99',2),
		('Luciene Cavalcante', '101.101.101-10', 3)
go

-----------------------------------------------------------------------------------------------------------------
--Cadastrar 5 clientes - Insert na Tabela clientes
-----------------------------------------------------------------------------------------------------------------

insert into Clientes (pessoaId, renda, credito)
values (1, 1500.00, 750.00)
go

insert into Clientes
values (3, 5000.00, 1500.00)
go

insert into Clientes
values (5, 2500.00, 750.00),
	(7, 1700.00, 980.00),
	(9, 1872.00, 258.00)
go

select * from Pessoas
go

select * from Clientes
go


-----------------------------------------------------------------------------------------------------------------
--Consultar todas as pessoas que são clientes
-----------------------------------------------------------------------------------------------------------------

select Pessoas.idPessoa Cod_Cliente, Pessoas.nome Cliente,
	   Pessoas.cpf CPF_Cliente, Pessoas.status Situacao,
	   Clientes.renda Renda_Cliente, Clientes.credito Credito_Cliente
from
	Pessoas, Clientes
where
	Pessoas.idPessoa = Clientes.pessoaId
go

--usando Inner JOIN
select p.idPessoa Cod_Cliente, p.nome Cliente,
	   p.cpf CPF_Cliente, p.status Situacao,
	   c.renda Renda_Cliente, c.credito Credito_Cliente
from
	Pessoas p 
INNER JOIN
	Clientes c on c.pessoaId = p.idPessoa
go
