--------------- Task 1 ---------------

USE [UNIVER-4];

go
CREATE VIEW [�������������]
	as select TEACHER [���], TEACHER_NAME [��� �������������], GENDER [���], PULPIT [��� �������]
	FROM TEACHER;
go

SELECT * FROM �������������;

SELECT * FROM ������������� order by [��� �������];

go
ALTER VIEW [�������������]
	as select TEACHER_NAME [��� �������������], GENDER [���], PULPIT [��� �������]
	FROM TEACHER;
go

SELECT * FROM �������������;

DROP VIEW �������������;

--------------- Task 2 ---------------

go
CREATE VIEW [���������� ������]
	as select FACULTY.FACULTY_NAME [���������], COUNT(*) [���������� ������]
	from FACULTY join PULPIT
	on FACULTY.FACULTY = PULPIT.FACULTY
	group by FACULTY.FACULTY_NAME;
go
select * from [���������� ������];

--------------- Task 3 ---------------

go
CREATE VIEW [���������](���, [������������ ���������], [��� ���������])
	as select AUDITORIUM [���], AUDITORIUM_NAME [������������ ���������], AUDITORIUM_TYPE [��� ���������]
	FROM AUDITORIUM
	where AUDITORIUM.AUDITORIUM_TYPE Like '��%';
go

SELECT * FROM [���������];

INSERT ��������� values('210-1','210-1','��');

--------------- Task 4 ---------------

go
CREATE VIEW ����������_���������(���, [������������ ���������], [��� ���������])
	as select AUDITORIUM [���], AUDITORIUM_NAME [������������ ���������], AUDITORIUM_TYPE [��� ���������]
	FROM AUDITORIUM
	where AUDITORIUM.AUDITORIUM_TYPE Like '��%' WITH CHECK OPTION;
go

SELECT * FROM ����������_���������;

INSERT ����������_��������� values('222-20','222-20','��');

--------------- Task 5 ---------------

go
CREATE VIEW [����������]
	as select Top 10 SUBJECT [���], SUBJECT_NAME [������������ ����������], PULPIT [��� �������]
	from SUBJECT
	order by SUBJECT_NAME;
go

SELECT * FROM ����������;

--------------- Task 6 ---------------

go
ALTER VIEW [���������� ������] WITH SCHEMABINDING
	as select fc.FACULTY_NAME [���������], COUNT(*) [���������� ������]
	from dbo.FACULTY fc join dbo.PULPIT pl
	on fc.FACULTY = pl.FACULTY
	group by fc.FACULTY_NAME;
go

select * from [���������� ������];

--------------- Task 7 ---------------

USE VK_MyBASE;

go
create view [���������� ������]
	as select Order_goodsName [������������ ������], Order_amount [����������], Order_cost [���� �������]
	from ORDERS
go

SELECT * FROM [���������� ������];

------------------------------------------------------------

USE VK_MyBASE;

go
create view [��� ������� ����������]
	as select Firm_name [�������� �����], Customer_address [����� ���������]
	from CUSTOMERS
	where Firm_name like 'Samsung';
go

select * from [��� ������� ����������];

------------------------------------------------------------

USE VK_MyBASE;

go
create view [������ ��� ������� ����������]([�������� �����], [����� ���������])
	as select Firm_name [�������� �����], Customer_address [����� ���������]
	from CUSTOMERS
	where Firm_name like 'Samsung' WITH CHECK OPTION;
go

select * from [��� ������� ����������];

insert [������ ��� ������� ����������] values('GUCCI','�����������, 21');

------------------------------------------------------------
 USE VK_MyBASE;

go
create view [���������� ������ x2] WITH SCHEMABINDiNG
	as select Order_goodsName [������������ ������], Order_amount [����������], Order_cost [���� �������]
	from dbo.ORDERS
go

select * from [���������� ������ x2];

--------------- Task 8 ---------------

--PIVOT � ��� �������� Transact-SQL, ������� ������������ �������������� ����� ������,
--�.�. ���������� ���������������� �������, 
--��� ���� ������������ ���������� �������, � ������ �������������� ������������. 
--������� �������, ��������, ������� ����������� �� ���������, �� ����������� �� �����������.

--SELECT ������� ��� �����������,  [�������� �� �����������],
--FROM �������, ��������� ��� �������������
--PIVOT(���������� �������
--FOR �������, ���������� ��������, ������� ������ ������� ��������
--IN ([�������� �� �����������],�)
--)AS ��������� ������� (�����������)
--� ������ ������������� ORDER BY;
USE [UNIVER-4];

ALTER Table TIMETABLE add CLASSNUMBER int;

go
create view [����������]
as select CLASSNUMBER [����� ����], SUBJECT [�������], IDGROUP [������] from TIMETABLE
group by IDGROUP, CLASSNUMBER, SUBJECT;
go

select * from [����������];

select [������], [1] as [14.40-16.00], [2] as [16.30-17.50], [3] as [18.05-19.25], [4] as [19.40-21.00]
from [����������]
pivot(count([�������]) for [����� ����] in([1], [2], [3], [4])) as pvt

select [������], [���], [��], [���], [��], [��]
from [����������]
pivot(count([����� ����]) for [�������] in([���], [��], [���], [��], [��])) as pvt1