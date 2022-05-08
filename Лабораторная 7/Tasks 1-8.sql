--------------- Task 1 ---------------

USE [UNIVER-4];

go
CREATE VIEW [Преподаватель]
	as select TEACHER [Код], TEACHER_NAME [Имя преподавателя], GENDER [Пол], PULPIT [Код кафедры]
	FROM TEACHER;
go

SELECT * FROM Преподаватель;

SELECT * FROM Преподаватель order by [Код кафедры];

go
ALTER VIEW [Преподаватель]
	as select TEACHER_NAME [Имя преподавателя], GENDER [Пол], PULPIT [Код кафедры]
	FROM TEACHER;
go

SELECT * FROM Преподаватель;

DROP VIEW Преподаватель;

--------------- Task 2 ---------------

go
CREATE VIEW [Количество кафедр]
	as select FACULTY.FACULTY_NAME [Факультет], COUNT(*) [Количетсво кафедр]
	from FACULTY join PULPIT
	on FACULTY.FACULTY = PULPIT.FACULTY
	group by FACULTY.FACULTY_NAME;
go
select * from [Количество кафедр];

--------------- Task 3 ---------------

go
CREATE VIEW [Аудитории](Код, [Наименование аудитории], [Тип аудитории])
	as select AUDITORIUM [Код], AUDITORIUM_NAME [Наименование аудитории], AUDITORIUM_TYPE [Тип аудитории]
	FROM AUDITORIUM
	where AUDITORIUM.AUDITORIUM_TYPE Like 'ЛК%';
go

SELECT * FROM [Аудитории];

INSERT Аудитории values('210-1','210-1','ЛК');

--------------- Task 4 ---------------

go
CREATE VIEW Лекционные_аудитории(Код, [Наименование аудитории], [Тип аудитории])
	as select AUDITORIUM [Код], AUDITORIUM_NAME [Наименование аудитории], AUDITORIUM_TYPE [Тип аудитории]
	FROM AUDITORIUM
	where AUDITORIUM.AUDITORIUM_TYPE Like 'ЛК%' WITH CHECK OPTION;
go

SELECT * FROM Лекционные_аудитории;

INSERT Лекционные_аудитории values('222-20','222-20','ПЗ');

--------------- Task 5 ---------------

go
CREATE VIEW [Дисциплины]
	as select Top 10 SUBJECT [Код], SUBJECT_NAME [Наименование дисциплины], PULPIT [Код кафедры]
	from SUBJECT
	order by SUBJECT_NAME;
go

SELECT * FROM Дисциплины;

--------------- Task 6 ---------------

go
ALTER VIEW [Количество кафедр] WITH SCHEMABINDING
	as select fc.FACULTY_NAME [Факультет], COUNT(*) [Количетсво кафедр]
	from dbo.FACULTY fc join dbo.PULPIT pl
	on fc.FACULTY = pl.FACULTY
	group by fc.FACULTY_NAME;
go

select * from [Количество кафедр];

--------------- Task 7 ---------------

USE VK_MyBASE;

go
create view [Заказанные товары]
	as select Order_goodsName [Наименование товара], Order_amount [Количество], Order_cost [Цена продажи]
	from ORDERS
go

SELECT * FROM [Заказанные товары];

------------------------------------------------------------

USE VK_MyBASE;

go
create view [Мои любимые покупатели]
	as select Firm_name [Название фирмы], Customer_address [Адрес любимчика]
	from CUSTOMERS
	where Firm_name like 'Samsung';
go

select * from [Мои любимые покупатели];

------------------------------------------------------------

USE VK_MyBASE;

go
create view [ТОЛЬКО мои любимые покупатели]([Название фирмы], [Адрес любимчика])
	as select Firm_name [Название фирмы], Customer_address [Адрес любимчика]
	from CUSTOMERS
	where Firm_name like 'Samsung' WITH CHECK OPTION;
go

select * from [Мои любимые покупатели];

insert [ТОЛЬКО мои любимые покупатели] values('GUCCI','Белорусская, 21');

------------------------------------------------------------
 USE VK_MyBASE;

go
create view [Заказанные товары x2] WITH SCHEMABINDiNG
	as select Order_goodsName [Наименование товара], Order_amount [Количество], Order_cost [Цена продажи]
	from dbo.ORDERS
go

select * from [Заказанные товары x2];

--------------- Task 8 ---------------

--PIVOT – это оператор Transact-SQL, который поворачивает результирующий набор данных,
--т.е. происходит транспонирование таблицы, 
--при этом используются агрегатные функции, и данные соответственно группируются. 
--Другими словами, значения, которые расположены по вертикали, мы выстраиваем по горизонтали.

--SELECT столбец для группировки,  [значения по горизонтали],
--FROM таблица, подзапрос или представление
--PIVOT(агрегатная функция
--FOR столбец, содержащий значения, которые станут именами столбцов
--IN ([значения по горизонтали],…)
--)AS псевдоним таблицы (обязательно)
--в случае необходимости ORDER BY;
USE [UNIVER-4];

ALTER Table TIMETABLE add CLASSNUMBER int;

go
create view [Расписание]
as select CLASSNUMBER [Номер пары], SUBJECT [Предмет], IDGROUP [Группа] from TIMETABLE
group by IDGROUP, CLASSNUMBER, SUBJECT;
go

select * from [Расписание];

select [Группа], [1] as [14.40-16.00], [2] as [16.30-17.50], [3] as [18.05-19.25], [4] as [19.40-21.00]
from [Расписание]
pivot(count([Предмет]) for [Номер пары] in([1], [2], [3], [4])) as pvt

select [Группа], [КМС], [БД], [ИНФ], [ИП], [ИГ]
from [Расписание]
pivot(count([Номер пары]) for [Предмет] in([КМС], [БД], [ИНФ], [ИП], [ИГ])) as pvt1