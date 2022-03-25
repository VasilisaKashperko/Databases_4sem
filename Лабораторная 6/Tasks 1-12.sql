--------------- Task 1 ---------------

USE [UNIVER-4];

SELECT MAX(AUDITORIUM.AUDITORIUM_CAPACITY) [������������ �����������],
	   MIN(AUDITORIUM.AUDITORIUM_CAPACITY) [����������� �����������],
	   AVG(AUDITORIUM.AUDITORIUM_CAPACITY) [������� �������� �����������],
	   SUM(AUDITORIUM.AUDITORIUM_CAPACITY) [����� ������������],
	   COUNT(*) [����� ���������� ���������]
FROM AUDITORIUM;

--------------- Task 2 ---------------

USE [UNIVER-4];

SELECT AUDITORIUM_TYPE.AUDITORIUM_TYPENAME,
	   MAX(AUDITORIUM.AUDITORIUM_CAPACITY) [������������ �����������],
	   MIN(AUDITORIUM.AUDITORIUM_CAPACITY) [����������� �����������],
	   AVG(AUDITORIUM.AUDITORIUM_CAPACITY) [������� �������� �����������],
	   SUM(AUDITORIUM.AUDITORIUM_CAPACITY) [����� ������������],
	   COUNT(*) [���������� ��������� ������� ����]
FROM AUDITORIUM Inner Join AUDITORIUM_TYPE
	 ON AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
	 Group by AUDITORIUM_TYPENAME

--------------- Task 3 ---------------

USE [UNIVER-4];

SELECT *
FROM ( SELECT Case WHEN NOTE = 10 then '10'
				   WHEN NOTE IN(8,9) then '8-9'
				   WHEN NOTE IN(6,7) then '6-7'
				   WHEN NOTE IN(4,5) then '4-5'
				   ELSE '������ ���� 4'
			   END [������], COUNT(*) [����������]
	   FROM PROGRESS
	   Group by Case WHEN NOTE = 10 then '10'
					 WHEN NOTE IN(8,9) then '8-9'
					 WHEN NOTE IN(6,7) then '6-7'
					 WHEN NOTE IN(4,5) then '4-5'
					 ELSE '������ ���� 4'
			   END) as T
Order by Case [������]
		 WHEN '10' then 1
		 WHEN '8-9' then 2
		 WHEN '6-7' then 3
		 WHEN '4-5' then 4
		 ELSE 0
		 END

--------------- Task 4.1 ---------------

USE [UNIVER-4];

-- float(n), ��� n � ���������� �����, ������� ������������ ��� �������� �������� ����� � ��������� �������

SELECT f.FACULTY [���������], g.PROFESSION [�������������],
	   g.YEAR_FIRST [���, ����� ����� ��������������], round(avg(cast(p.NOTE as float(4))), 2) [������� ������]
FROM FACULTY f Inner Join GROUPS g ON f.FACULTY = g.FACULTY
			   Inner Join STUDENT s ON g.IDGROUP = s.IDGROUP
			   Inner Join PROGRESS p ON p.IDSTUDENT = s.IDSTUDENT

Group by f.FACULTY, g.PROFESSION, g.YEAR_FIRST
Order by [������� ������] desc;

--------------- Task 4.2 ---------------

USE [UNIVER-4];

SELECT f.FACULTY [���������], g.PROFESSION [�������������],
	   g.YEAR_FIRST [��� �����������], round(avg(cast(p.NOTE as float(4))), 2) [������� ������]
FROM FACULTY f Inner Join GROUPS g ON f.FACULTY = g.FACULTY
			   Inner Join STUDENT s ON g.IDGROUP = s.IDGROUP
			   Inner Join PROGRESS p ON p.IDSTUDENT = s.IDSTUDENT
WHERE p.SUBJECT like '����' or p.SUBJECT = '����'
Group by f.FACULTY, g.PROFESSION, g.YEAR_FIRST
Order by [������� ������] desc;

--------------- Task 5.1 ---------------


USE [UNIVER-4];

SELECT f.FACULTY [���������], g.PROFESSION [�������������],
	   p.SUBJECT [����������], round(avg(cast(p.NOTE as float(4))), 2) [������� ������]
FROM FACULTY f Inner Join GROUPS g ON f.FACULTY = g.FACULTY
			   Inner Join STUDENT s ON g.IDGROUP = s.IDGROUP
			   Inner Join PROGRESS p ON p.IDSTUDENT = s.IDSTUDENT
WHERE f.FACULTY like '��'
group by f.FACULTY, g.PROFESSION, p.SUBJECT
Order by [������� ������] desc;

--------------- Task 5.2 ---------------

USE [UNIVER-4];

-- ROLLUP ���������� ���������� ����� � �������� �����, ������� ���������� � �������, � ������� ������ ������������ �������

SELECT f.FACULTY [���������], g.PROFESSION [�������������],
	   p.SUBJECT [����������], round(avg(cast(p.NOTE as float(4))), 2) [������� ������]
FROM FACULTY f Inner Join GROUPS g ON f.FACULTY = g.FACULTY
			   Inner Join STUDENT s ON g.IDGROUP = s.IDGROUP
			   Inner Join PROGRESS p ON p.IDSTUDENT = s.IDSTUDENT
WHERE f.FACULTY like '��'
group by rollup (f.FACULTY, g.PROFESSION, p.SUBJECT)
Order by [������� ������] desc;

--------------- Task 6 ---------------

USE [UNIVER-4];

-- ����������� CUBE ���������� ����� ��������� ���������� ����� � �������� �����

SELECT f.FACULTY [���������], g.PROFESSION [�������������],
	   p.SUBJECT [����������], round(avg(cast(p.NOTE as float(4))), 2) [������� ������]
FROM FACULTY f Inner Join GROUPS g ON f.FACULTY = g.FACULTY
			   Inner Join STUDENT s ON g.IDGROUP = s.IDGROUP
			   Inner Join PROGRESS p ON p.IDSTUDENT = s.IDSTUDENT
WHERE f.FACULTY like '��'
group by cube (f.FACULTY, g.PROFESSION, p.SUBJECT)
Order by [������� ������] desc;

--------------- Task 7 ---------------

USE [UNIVER-4];

-- UNION ������� ��������� ������� (��� ��� ������� � ����������� ���������), UNION ALL - ���������� ��� �������� ����������.

SELECT f.FACULTY [���������], g.PROFESSION [�������������],
	   p.SUBJECT [����������], round(avg(cast(p.NOTE as float(4))), 2) [������� ������]
FROM FACULTY f Inner Join GROUPS g ON f.FACULTY = g.FACULTY
			   Inner Join STUDENT s ON g.IDGROUP = s.IDGROUP
			   Inner Join PROGRESS p ON p.IDSTUDENT = s.IDSTUDENT
WHERE f.FACULTY like '��'
group by f.FACULTY, g.PROFESSION, p.SUBJECT

UNION

SELECT f.FACULTY [���������], g.PROFESSION [�������������],
	   p.SUBJECT [����������], round(avg(cast(p.NOTE as float(4))), 2) [������� ������]
FROM FACULTY f Inner Join GROUPS g ON f.FACULTY = g.FACULTY
			   Inner Join STUDENT s ON g.IDGROUP = s.IDGROUP
			   Inner Join PROGRESS p ON p.IDSTUDENT = s.IDSTUDENT
WHERE f.FACULTY like '���'
group by f.FACULTY, g.PROFESSION, p.SUBJECT
Order by [������� ������] desc;

--------------- Task 7.1 ---------------

USE [UNIVER-4];

SELECT f.FACULTY [���������], g.PROFESSION [�������������],
	   p.SUBJECT [����������], round(avg(cast(p.NOTE as float(4))), 2) [������� ������]
FROM FACULTY f Inner Join GROUPS g ON f.FACULTY = g.FACULTY
			   Inner Join STUDENT s ON g.IDGROUP = s.IDGROUP
			   Inner Join PROGRESS p ON p.IDSTUDENT = s.IDSTUDENT
WHERE f.FACULTY like '��'
group by f.FACULTY, g.PROFESSION, p.SUBJECT

UNION ALL

SELECT f.FACULTY [���������], g.PROFESSION [�������������],
	   p.SUBJECT [����������], round(avg(cast(p.NOTE as float(4))), 2) [������� ������]
FROM FACULTY f Inner Join GROUPS g ON f.FACULTY = g.FACULTY
			   Inner Join STUDENT s ON g.IDGROUP = s.IDGROUP
			   Inner Join PROGRESS p ON p.IDSTUDENT = s.IDSTUDENT
WHERE f.FACULTY like '���'
group by f.FACULTY, g.PROFESSION, p.SUBJECT
Order by [������� ������] desc;

--------------- Task 8 ---------------

USE [UNIVER-4];

SELECT f.FACULTY [���������], g.PROFESSION [�������������],
	   p.SUBJECT [����������], round(avg(cast(p.NOTE as float(4))), 2) [������� ������]
FROM FACULTY f Inner Join GROUPS g ON f.FACULTY = g.FACULTY
			   Inner Join STUDENT s ON g.IDGROUP = s.IDGROUP
			   Inner Join PROGRESS p ON p.IDSTUDENT = s.IDSTUDENT
WHERE f.FACULTY like '��'
group by f.FACULTY, g.PROFESSION, p.SUBJECT

INTERSECT

SELECT f.FACULTY [���������], g.PROFESSION [�������������],
	   p.SUBJECT [����������], round(avg(cast(p.NOTE as float(4))), 2) [������� ������]
FROM FACULTY f Inner Join GROUPS g ON f.FACULTY = g.FACULTY
			   Inner Join STUDENT s ON g.IDGROUP = s.IDGROUP
			   Inner Join PROGRESS p ON p.IDSTUDENT = s.IDSTUDENT
WHERE f.FACULTY like '���'
group by f.FACULTY, g.PROFESSION, p.SUBJECT
Order by [������� ������] desc;

--------------- Task 9 ---------------

USE [UNIVER-4];

-- EXCEPT -> ����� �����, ���������� ��������� ���� �������� ������� �����
-- (�.�. � �������������� ����� ���������� �� ������, ������� ���� � ������ �������, �� ����������� �� ������).

SELECT f.FACULTY [���������], g.PROFESSION [�������������],
	   p.SUBJECT [����������], round(avg(cast(p.NOTE as float(4))), 2) [������� ������]
FROM FACULTY f Inner Join GROUPS g ON f.FACULTY = g.FACULTY
			   Inner Join STUDENT s ON g.IDGROUP = s.IDGROUP
			   Inner Join PROGRESS p ON p.IDSTUDENT = s.IDSTUDENT
WHERE f.FACULTY like '��'
group by f.FACULTY, g.PROFESSION, p.SUBJECT

EXCEPT

SELECT f.FACULTY [���������], g.PROFESSION [�������������],
	   p.SUBJECT [����������], round(avg(cast(p.NOTE as float(4))), 2) [������� ������]
FROM FACULTY f Inner Join GROUPS g ON f.FACULTY = g.FACULTY
			   Inner Join STUDENT s ON g.IDGROUP = s.IDGROUP
			   Inner Join PROGRESS p ON p.IDSTUDENT = s.IDSTUDENT
WHERE f.FACULTY like '���'
group by f.FACULTY, g.PROFESSION, p.SUBJECT
Order by [������� ������] desc;

--------------- Task 10 ---------------
USE [UNIVER-4];

SELECT p.SUBJECT [����������], p.NOTE [������], (SELECT COUNT(*) FROM PROGRESS pp
						   WHERE p.SUBJECT = pp.SUBJECT
						   AND p.NOTE = pp.NOTE) [����������]
FROM PROGRESS p
Group by p.SUBJECT, p.NOTE
HAVING NOTE = 8 or NOTE = 9;

--------------- Task 11 ---------------

USE [VK_MyBASE];

SELECT MAX(ORDERS.Order_cost) [������������ ���� �������],
	   MIN(ORDERS.Order_cost) [����������� ���� �������],
	   round(avg(cast(ORDERS.Order_cost as float(4))), 2) [������� �������� ���� �������],
	   SUM(ORDERS.Order_cost) [����� ��� �������],
	   COUNT(*) [����� ���������� ���������]
FROM ORDERS;

-----------

USE [VK_MyBASE];

--���������� ������������ � ������������ ���� ������� ��� �������,
--���������� ���������� ������� ��� ��� �������, ���������� ������� �� ������ ������ 3�

SELECT ORDERS.Order_goodsName,  
          MAX(ORDERS.Order_cost)  [������������ ����],  
          COUNT(*)  [���������� ���������� �������]
FROM  ORDERS  Inner Join  GOODS 
              ON  ORDERS.Order_goodsName = GOODS.Goods_name 
              and  GOODS.Amount >= 3
Group by Order_goodsName;

--------------- Task 12.1 ---------------

USE [UNIVER-4];

SELECT FACULTY.FACULTY_NAME [���������], GROUPS.IDGROUP [����� ������], COUNT(*) [����������]
FROM FACULTY Inner Join GROUPS ON FACULTY.FACULTY = GROUPS.FACULTY
			 Inner Join STUDENT on STUDENT.IDGROUP = GROUPS.IDGROUP
Group by rollup (FACULTY_NAME, GROUPS.IDGROUP);

--------------- Task 12.2 ---------------

USE [UNIVER-4];

-- ���������� ���������� ��������� �� ����� � ��������� ����������� ����� ����� ��������.

SELECT AUDITORIUM.AUDITORIUM_TYPE [��� ���������], AUDITORIUM.AUDITORIUM_CAPACITY [����������� ���������], COUNT(*) [����������],
	   (SELECT SUM(AUDITORIUM_CAPACITY) FROM AUDITORIUM aa WHERE AUDITORIUM.AUDITORIUM_CAPACITY = aa.AUDITORIUM_CAPACITY) [��������� ����������� c ���������� ���������],
	   (SELECT SUM(AUDITORIUM.AUDITORIUM_CAPACITY) FROM AUDITORIUM)
FROM AUDITORIUM
Group by rollup (AUDITORIUM_TYPE, AUDITORIUM_CAPACITY);

