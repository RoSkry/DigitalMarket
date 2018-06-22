
if not exists(select db.[Name]
			from sys.databases Db
			where Db.[Name] = N'DigitalMarket')

			create database DigitalMarket
else print N'Database has is Existed'
go



use DigitalMarket
go

if not exists(select Name
			from sys.tables Tb
			where Name = N'Category')
begin
	create table Category
	(
	Id tinyint primary key identity,
	Name nvarchar(50) unique not null
	)
end
else print N'table Category is exists'

insert into dbo.Category values ('Mobile phones'),('Computers'),('Laptops')
go

if not exists(select Name
			from sys.tables Tb
			where Name = N'Products')
begin
	create table Products
	(
		Id int primary key identity,
		Cat_id tinyint foreign key references dbo.Category(Id),
		NameProduct nvarchar(100) not null,
		ReleaseDate date not null,
		EndLifeProduct date not null,
		BuyPrice money check(BuyPrice > 0) not null,
		SellPrice money not null,
		StoreCount int check(StoreCount > 0) not null,
		constraint Sell_price_check  check(SellPrice>BuyPrice)
	)
end
else print N'table Product is exists'

insert into dbo.Products values (1,'iPhone 7S','2017-04-15','2022-05-06',25000,35000,15),
(1,'Samsung S8','2016-10-12','2020-09-16',20000,30000,5),
(1,'Xiaomi Mi6','2017-08-15','2021-06-26',15000,18000,30),
(2,'Dell Alienware Aurora R7','2015-12-25','2023-01-21',45000,65000,12),
(2,'Asus Vivo AiO','2016-09-15','2022-06-10',38000,45000,17),
(2,'HP Envy All-in-One 27-b112ur','2016-11-24','2023-04-26',55000,68000,4),
(3,'Apple A1466 MacBook Air','2015-12-05','2023-04-26',35000,42000,14),
(3,'Asus VivoBook Max X541UV','2016-07-08','2023-05-21',29000,34000,23),
(3,'Lenovo IdeaPad 320-15IKB','2016-10-14','2021-03-09',23000,30000,7)

go

if not exists(select Name
			from sys.tables Tb
			where Name = N'RoleEmployees')
begin
	create table RoleEmployees
	(
		Id tinyint primary key identity,
		NameRole nvarchar(100) unique not null
	)
end
else print N'table RoleEmployees is exists'

go

insert into dbo.RoleEmployees values ('Manager'),('Cashier')

if not exists(select Name
			from sys.tables Tb
			where Name = N'Department')
begin
	create table Department
	(
		Id tinyint primary key identity,
		NameDepartment nvarchar(100) unique not null
	)
end
else print N'table Department is exists'

insert into dbo.Department values ('Phones'), ('Personal computrers'), ('Laptops')

go

if not exists(select Name
			from sys.tables Tb
			where Name = N'Employees')
begin
	create table Employees
	(
		Id int primary key identity,
		Role_Id tinyint foreign key references RoleEmployees(Id) not null,
		Department_Id tinyint foreign key references Department(Id) not null,
		FullName nvarchar(100) not null,
		Gender bit not null,
		DateOfBirth date not null,
		StartDate date not null,
		FinishDate date null
	)
end
else print N'table Employees is exists'

insert into dbo.Employees values (1,1,'Ivanov Ivan Ivanovich',1,'1960-11-09','1990-12-12',null),
(1,2,'Sidorova Maria Petrovna',0,'1978-01-29','1997-10-15',null),
(1,3,'Petrov Petr Petrovich',1,'1960-11-09','1990-12-12',null),
(2,1,'Nikolaev Nikolay Nikolaevich',1,'1990-07-19','2014-10-12',null),
(2,2,'Fedorova Nina Ivanovna',0,'1999-05-29','2015-05-22',null)

go

if not exists(select Name
			from sys.tables Tb
			where Name = N'Sale')
begin
	create table Sale
	(
		Id int primary key identity,
		Employes_id int foreign key references Employees(Id) not null,
		Date_Sale date not null
	)
end
else print N'table Sales is exists'

insert into dbo.Sale values (4,'2018-05-05'),(5,'2018-05-01'),(5,'2018-04-29'),(4,'2018-04-27'),(4,'2018-04-25')

go
if not exists(select Name
			from sys.tables Tb
			where Name = N'SaleDetails')
begin
	create table SaleDetails
	(
		Id int primary key identity,
		Sale_Id int foreign key references Sale(Id) not null,
		Product_Id int foreign key references Products(Id) not null,
		CountProduct int check(CountProduct>0) not null
	)
end
else print N'table SaleDetails is exists'

go

insert into dbo.SaleDetails values (1,2,3),(2,3,1),(3,5,2),(4,6,1),(5,8,4)

go
create view ShowProducts 
as 
select P.NameProduct [Название продукта], C.Name [Название категории], P.ReleaseDate [Дата выпуска],P.EndLifeProduct [Срок годности], P.BuyPrice [Закупочная цена], P.SellPrice [Цена продажи], P.StoreCount [Кол-во на складе]
from dbo.Products P join dbo.Category C on P.Cat_id = C.Id

go

Select *
from ShowProducts

go 

create view ShowCashiers
as 
select  E.FullName[Ф.И.О],E.StartDate[Дата начала работы],E.Gender[Пол],E.DateOfBirth[Дата рождения],E.FinishDate[Дата конца работы]
from dbo.Employees E join dbo.RoleEmployees R on R.Id=E.Role_Id
where R.NameRole='Cashier'

go
Select * 
from ShowCashiers

go 

create view ShowManager 
as 
select  E.FullName[Ф.И.О],E.StartDate[Дата начала работы],E.Gender[Пол],E.DateOfBirth[Дата рождения],E.FinishDate[Дата конца работы],D.NameDepartment[Контролируемый раздел]
from dbo.Employees E join dbo.RoleEmployees R on R.Id=E.Role_Id
join dbo.Department D on D.Id=E.Department_Id
where R.NameRole='Manager'

go
Select * 
from ShowManager

go

Create view ShowSales 
as 
select E.FullName[ФИО],S.Date_Sale[Дата продажи],P.NameProduct[Имя товара],SD.CountProduct[Количество товаров]
from dbo.Sale S join dbo.Employees E on E.Id=S.Employes_id 
join dbo.RoleEmployees R on R.Id=E.Role_Id 
join dbo.SaleDetails SD on SD.Sale_Id=S.Id 
join dbo.Products P on SD.Product_Id=P.Id
where R.NameRole='Cashier'

go 

Select * 
from ShowSales

go 
--Вывод товаров определенного раздела, которых осталось меньше десяти упаковок на складе;

Create trigger ShowProductLessTen on dbo.Products
for insert,update,delete 
as 
declare @c int
select @c=i.StoreCount 
from inserted i
where i.StoreCount<10
if(@c<10) 
print 'Tovara menshe 10'

insert into dbo.products values (2,'Intel i5','2016-10-14','2021-03-09',20000,25000,3)

--Добавление, удаление, и изменение товара сделать DDL триггер, который организует  хранение информации о том, кто (ФИО), когда (дата), что(текст запроса) сделал
go

Create table Informtrig 
(
Id int primary key identity,
Post_Time nvarchar(300) not null,
UserName nvarchar(100) ,
EventType nvarchar(50) ,
SQL_command nvarchar(2000) 
)

go

CREATE TRIGGER InformUser
on database
for DDL_TABLE_VIEW_EVENTS
as
declare @data xml

SET @data=EVENTDATA() 

INSERT INTO Informtrig(Post_Time,UserName,EventType,SQL_command)
VALUES (@data.value('(/EVENT_INSTANCE/PostTime)[1]', 'nvarchar(300)'),
		@data.value('(/EVENT_INSTANCE/UserName)[1]', 'nvarchar(100)'),
		@data.value('(/EVENT_INSTANCE/EventType)[1]', 'nvarchar(50)'),
		@data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(300)'))

CREATE TABLE tab
(
id int primary key identity,
Name nvarchar(50) 
)

insert into tab values (N'Rostik')
go

DISABLE TRIGGER InformUser on database

SELECT *
from Informtrig

--За неделю до срока годности выдавать список товаров.
go

CREATE TRIGGER EndProd
on dbo.Products
for update
as
declare @EndProd date
Select @EndProd=p.EndLifeProduct
from dbo.Products P
if (DATEDIFF(day,GETDATE(),@EndProd)<7)
print 'srok deysviya menshe nedeli'

--Хранимые процедуры

go
--Добавление продукта
CREATE PROC AddProd 
@cat_id tinyint,
	@nameNewProduct nvarchar(100),
	@releaseDate date,
	@endLifeProd date,
	@buyPrice money,
	@salePrice money,
	@storeCount int
	as
	BEGIN
	if not exists(select P.NameProduct  
				from dbo.Products P 
				where P.NameProduct = @nameNewProduct)
		insert into dbo.Products values (@cat_id,@nameNewProduct,@releaseDate,@endLifeProd,@buyPrice,@salePrice,@storeCount)
	else print 'Такой товар имеется, введите другой'
END

exec AddProd 1,N'Iphone 8s','2017-04-11','2022-09-21', 18000,250000,8
go
-- Добавление отдела
go
CREATE PROC AddDepartment
	@newDepartmentName nvarchar(50)
AS
BEGIN
	if not exists(select D.NameDepartment  
				from dbo.Department D 
				where D.NameDepartment  = @newDepartmentName )

		insert into dbo.Department values (@newDepartmentName)

	else
		print 'Такая роль уже существует.'
		
END

exec AddDepartment 'Molochniy'

go
--добавление категории
CREATE PROC AddCategory
	@newCatName nvarchar(50)
AS
BEGIN
	if not exists(select C.Name  from dbo.Category C where C.Name = @newCatName)
		insert into dbo.Category values(@newCatName)
	else
		print 'Такая категория уже существует'
END
exec AddCategory N'Mysnaya'
go
--Добавление работника
create PROC AddEmployees
	@role_id int,
	@department_id tinyint,
	@fullName nvarchar(100),
    @gender bit,
	@birthday date,
	@dateStartWork date
	
AS
BEGIN
	if not exists(select *
				  from dbo.Employees E 
				  where E.FullName  = @fullName AND E.DateOfBirth = @birthday)
					insert into dbo.Employees values (@role_id,@department_id,@fullName,@gender,@birthday,@dateStartWork,null)

else
		print 'Такая sotrudnik уже существует.'
END


exec AddEmployees 2,3,N'Nikitina Nina Ivanovna',0,'1995-04-09','1990-02-15'

--добавление продажи 

go
create PROC AddSale 
@EmployeesId int,
@currentDate date,
@productId int,
@count int
as
BEGIN 

if exists(select * from dbo.Products Prod 
	      where @count <= Prod.StoreCount AND Prod.Id = @productId)

		  BEGIN
            insert into dbo.Sale values (@EmployeesId, @currentDate)

			insert into dbo.SaleDetails values ((select MAX(Id) from dbo.Sale), @productId,@count)

			update dbo.Products
			set StoreCount = StoreCount - @count
			where Id = @productId
		END

		else
		print 'Ne prodaetsy'


END

go

declare @date date 

set @date = DATEFROMPARTS(YEAR(GETDATE()), Month(GETDATE()), DAy(GETDATE()));

exec AddSale 5,@date,4,1

--изменение названия продукта 

go
create proc ChangeName 
@prodId int,
@newName varchar (50)
as
BEGIN 
if exists (select * from dbo.Products 
			where Id = @prodId)
			begin 

			update Products
			set NameProduct=@newName 
			where Id=@prodId
			end

	else
		print N'Net takogo'
END
 
 exec ChangeName 8,N'HP 4'

 --изменение названия отдела
 go
 create proc ChangeDep
@DepId int,
@newDep varchar (50)
as
BEGIN 
if exists (select * from dbo.Department
			where Id = @DepId)
			begin 

			update Department
			set NameDepartment=@newDep 
			where Id=@DepId
			end

	else
		print N'Net takogo'
END
 
 --exec ChangeDep 2,N'Household appliances'

 --изменение названия категории

 go
create proc ChangeCat
@CatId int,
@newCat nvarchar (50)
as
BEGIN 
if exists (select * from dbo.Category
			where Id = @CatId)
			begin 

			update Category 
			set Name =@newCat 
			where Id=@CatId
			end

	else
		print N'Net takogo'
END

exec ChangeCat 1,N'Vacuum cleaners'

go

create proc ChangeEmpl
@Id int,
@newEmpl nvarchar (50),
@dateBirth date
as
BEGIN 
if exists (select * from dbo.Employees
			where Id = @Id)
			begin 

			update Employees
			set FullName=@newEmpl ,DateOfBirth=@dateBirth
			where Id=@Id
			end

	else
		print N'Net takogo'
END

exec ChangeEmpl 2,N'Ivanova Ira','1980-12-05'

go
--Вывод самого доходного товара в указанной категории ( у товара естьзакупочная цена и цена продажи, а также хранится информация о проданном товаре );

CREATE proc IncomeProd 
@catId int
as 
begin 

if exists (select * from dbo.Category
			where Id = @catId)
begin
select C.Name,P.NameProduct[Category],(P.SellPrice-P.BuyPrice)*SD.CountProduct[Total sum]
from dbo.Category C join dbo.Products P on P.Cat_id=C.Id
join dbo.SaleDetails SD on SD.Product_Id=P.Id
where  c.Id=@catId and (P.SellPrice-P.BuyPrice)*SD.CountProduct =
(
select max((P.SellPrice-P.BuyPrice)*SD.CountProduct)
from dbo.Category C join dbo.Products P on P.Cat_id=C.Id
join dbo.SaleDetails SD on SD.Product_Id=P.Id
where c.Id=@catId
) 
end
else print'net takoi'
end
exec IncomeProd 2

--Вывод количества каждого товара для определенной категории;

go
create proc CountProducts
@catId int
AS
BEGIN
	if exists(select * 
			from dbo.Category Cat 
			where Cat.Id = @catId)
				
				select C.Name [Category] ,P.NameProduct [Product], P.StoreCount [Quantity]
				from Products P join Category C on P.Cat_id = C.Id
				where P.Cat_id = @catId
	else
		print 'net takoi'
END

exec CountProducts 3

--Вывод всех «Сегодняшних» продаж

go
create proc SaleToday
AS
BEGIN
	if exists(select * 
			from dbo.Sale S 
			where S.Date_Sale = DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), DAY(GETDATE())))
				
				select  P.NameProduct [Name product],Date_Sale [Date of Sale], E.FullName ,  SD.CountProduct [count]
				from dbo.Sale S 
				join dbo.Employees E on E.Id = S.Employes_id
				join dbo.SaleDetails SD on S.Id = SD.Sale_Id
				join dbo.Products P on SD.Product_Id = P.Id
				where S.Date_Sale = DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), DAY(GETDATE()))
	else
		print 'net prodaz'
END

exec SaleToday

--Вывод всех сегодняшних именинников;
go
create PROC Birthday
AS
BEGIN
	if exists(select * 
			from dbo.Employees E 
			where MONTH(E.DateOfBirth) = MONTH(GETDATE()) AND DAY(E.DateOfBirth) = DAY(GETDATE()))
				
			select E.FullName , E.DateofBirth [Date of birth]
			from Employees E
			where MONTH(E.DateOfBirth) = MONTH(GETDATE()) AND DAY(E.DateOfBirth) = DAY(GETDATE())
	else
		print 'net'
END

exec Birthday
go
--Вывод двух лучших кассиров (по количеству чеков).

CREATE PROC TopCashiers
AS
BEGIN
	select TOP(2) E.FullName, COUNT(S.Employes_id) [Quantity] 
	from dbo.Sale S
	join dbo.Employees E on E.Id = S.Employes_id
	group by S.Employes_id,E.FullName
	order by COUNT(S.Employes_id) desc

END
exec TopCashiers 
go
--Вывод количества проданных товаров по каждому разделу за определенный период времени;

CREATE PROC countSales
	@startDate date,
	@endDate date
AS
BEGIN
	if exists(select *
				from dbo.Sale S
				where S.Date_Sale >= @startDate and S.Date_Sale <= @endDate)

	select P.NameProduct [Название продукта], sum(SD.CountProduct) [Кол-во проданных товаров]
	from dbo.Sale S 
	join dbo.SaleDetails SD on S.Id = SD.Sale_Id
	join dbo.Products P on SD.Product_Id = P.Id
	group by S.Date_Sale,P.NameProduct
	having S.Date_Sale >= @startDate AND S.Date_Sale <= @endDate
	
	else
		print N'net'
	
END



exec countSales '2018-04-30','2018-05-05'


--индексы
go

create index indexEmployess on Employees(Role_Id)
go
create index indexEmpDepartment on Employees(Department_Id)
go 
DBCC Showcontig('Employees','indexEmployess')
 go
 DBCC SHOWCONTIG ('Employees','indexEmpDepartment')

 BACKUP DATABASE DigitalMarket TO  DISK = N'D:\Techno.bak'


 
 -- создаем руководителя магазина он у меня делает все что угодно с заданой базой данных
CREATE LOGIN [Director] WITH PASSWORD=N'12345'
GO

CREATE USER [Director] FOR LOGIN [Director] WITH DEFAULT_SCHEMA=[db_owner]


-- создаем кассира 

CREATE LOGIN [CashierPetrov] WITH PASSWORD=N'22222'
go
CREATE USER [Petrov Petr] FOR LOGIN [CashierPetrov]

grant select on dbo.Products  to [Petrov Petr]
grant select on dbo.Products to [Petrov Petr]
grant select on dbo.Sale to [Petrov Petr]
grant select on dbo.SaleDetails to [Petrov Petr]
grant insert on dbo.Sale to [Petrov Petr]
grant delete on dbo.Sale to [Petrov Petr]
grant update on dbo.Sale to [Petrov Petr]
grant insert on dbo.SaleDetails to [Petrov Petr]
grant delete on dbo.SaleDetails to [Petrov Petr]
grant update on dbo.SaleDetails to [Petrov Petr]
grant select on ShowSales to [Petrov Petr]
grant execute on AddSale to [Petrov Petr]

CREATE LOGIN [ManagerIvanov] WITH PASSWORD=N'11111'
go
CREATE USER [Ivanov Ivan] FOR LOGIN [ManagerIvanov]

Grant select on dbo.Products to [Ivanov Ivan] 
grant insert on dbo.Products to [Ivanov Ivan] 
grant update on dbo.Products to [Ivanov Ivan] 
grant delete on dbo.Products to [Ivanov Ivan] 
Grant execute on dbo.AddProd to [Ivanov Ivan] 
Grant execute on dbo.ChangeName to [Ivanov Ivan] 
Grant execute on dbo.CountProducts  to [Ivanov Ivan] 

	




	




---- удаление логина
-- SELECT session_id
--FROM sys.dm_exec_sessions
--WHERE login_name = 'Director'
--kill 56
--drop login Rost