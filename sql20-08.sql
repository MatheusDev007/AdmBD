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

-----------------------------------------------
---CADASTAR CINCO VENDEDORES - INSERT NA TABELA VENDEDORES
----------------------------------------------
INSERT INTO Vendedores (pessoaId, salario)
values(2,1500.00)
go

INSERT INTO Vendedores 
VALUES (4, 2000.00),
	   (6, 2500.00),
	   (8, 1000.00),
	   (10, 5500.00)
go

select p.idPessoa Cod_Vendedor, p.nome Vendedor,
	   p.cpf CPF_Vendedor, p.status Situacao,
	   v.salario Salario
from
	Pessoas p, Vendedores v
where
	p.idPessoa = v.pessoaId
go

select p.idPessoa Cod_Vendedor, p.nome Vendedor,
	   p.cpf CPF_Vendedor, p.status Situacao,
	   v.salario Salario
from Pessoas p
INNER JOIN Vendedores v ON v.pessoaId = p.idPessoa
go

create table Pedidos
(
	idPedido int not null primary key identity,
	data datetime not null,
	valor money null,
	status int null,
	vendedorId int not null,
	clienteId int not null
	-- chave estrangeira Fk
	foreign key(vendedorId) references Vendedores(pessoaId),
	foreign key(clienteId) references Clientes(pessoaId),
	--restrições
	check (status between 1 and 3),
)
go

---------------
---Cadastrar pedidos
---------------
INSERT INTO Pedidos(data, status, vendedorId, clienteId)
Values ('2023-25-12', 1, 2, 1)
go

insert into Pedidos(data, status, vendedorId, clienteId) 
values (GETDATE(), 1, 4, 1),
	   (GETDATE(), 2, 6, 5),
	   ('2024-17-04', 1, 8, 7),
	   ('2023-04-10', 3, 6, 1)
go

select * from Pedidos
go

----consultar todos os clientes que fizeram pedidos

select p.idPessoa Cod_Cliente, p.nome Cliente,
	   p.cpf CPF, p.status Situacao,
	   c.renda Renda_Cliente, c.credito credito_cliente,
	   pe.idPedido NumeroPedido, pe.data Datapedido,
	   pe.status SituacaoPedido, pe.vendedorId CodVendedor
from Pessoas p, Clientes c, Pedidos pe
where p.idPessoa = c.pessoaId and c.pessoaId = pe.clienteId
go
