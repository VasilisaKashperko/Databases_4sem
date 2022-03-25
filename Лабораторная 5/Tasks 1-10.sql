-------------- Task 1 --------------

USE [UNIVER-4];

SELECT PULPIT.PULPIT_NAME [�������], FACULTY.FACULTY_NAME [���������], PROFESSION.PROFESSION_NAME [�������������]
FROM PULPIT, FACULTY, PROFESSION
Where FACULTY.FACULTY = PULPIT.FACULTY
	  and
	  FACULTY.FACULTY = PROFESSION.FACULTY
	  and
	  PROFESSION_NAME in (SELECT PROFESSION_NAME FROM PROFESSION where (PROFESSION_NAME like '%�����%'));

-- ��� ���, ������ �������, �� ���������� ������� ���� ������������� �� ������ "����������(-�)":

USE [UNIVER-4];

SELECT PULPIT.PULPIT_NAME
FROM PULPIT
Where FACULTY in (SELECT FACULTY FROM PROFESSION where (PROFESSION_NAME like '%�����%'));

-------------- Task 2 --------------

USE [UNIVER-4];

SELECT PULPIT.PULPIT_NAME [�������], FACULTY.FACULTY_NAME [���������], PROFESSION.PROFESSION_NAME [�������������]
FROM PULPIT Inner Join FACULTY ON FACULTY.FACULTY = PULPIT.FACULTY
			Inner Join PROFESSION ON FACULTY.FACULTY = PROFESSION.FACULTY
Where PROFESSION_NAME in (SELECT PROFESSION_NAME FROM PROFESSION where (PROFESSION_NAME like '%�����%'));

-------------- Task 3 --------------

USE [UNIVER-4];

SELECT PULPIT.PULPIT_NAME [�������], FACULTY.FACULTY_NAME [���������], PROFESSION.PROFESSION_NAME [�������������]
FROM PULPIT Inner Join FACULTY ON FACULTY.FACULTY = PULPIT.FACULTY
			Inner Join PROFESSION ON FACULTY.FACULTY = PROFESSION.FACULTY where (PROFESSION_NAME like '%�����%');

-------------- Task 4 --------------

USE [UNIVER-4];

SELECT a.AUDITORIUM_TYPE [��� ���������], a.AUDITORIUM_CAPACITY
FROM AUDITORIUM as a
WHERE AUDITORIUM_CAPACITY = (SELECT top(1) AUDITORIUM_CAPACITY FROM AUDITORIUM aa
							  WHERE a.AUDITORIUM_TYPE = aa.AUDITORIUM_TYPE
							  Order by AUDITORIUM_CAPACITY desc)
Order by AUDITORIUM_CAPACITY desc;

-------------- Task 5 --------------

USE [UNIVER-4];

-- ����������: � ����� �� ����� ����������� ��� ������ ���

SELECT FACULTY.FACULTY_NAME
FROM FACULTY
WHERE not exists (SELECT * FROM PULPIT
				  WHERE FACULTY.FACULTY = PULPIT.FACULTY)

-------------- Task 6 --------------

USE [UNIVER-4];

-- ����������: � ����� �� ��� �������� "��", �� ���� ���� "��"

SELECT top(1)
	   (SELECT AVG(PROGRESS.NOTE) FROM PROGRESS where SUBJECT like '����') [����],
	   (SELECT AVG(PROGRESS.NOTE) FROM PROGRESS where SUBJECT like '��') [��],
	   (SELECT AVG(PROGRESS.NOTE) FROM PROGRESS where SUBJECT like '����') [����]
FROM PROGRESS;

-------------- Task 7 --------------

USE [UNIVER-4];

-- ���������: �������� ������� "�����������" �� ������� "���������", ��� ����� ��������� ���������� � 4-�
-- ������: > 15 � > 90

SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM.AUDITORIUM_CAPACITY
FROM AUDITORIUM
WHERE AUDITORIUM.AUDITORIUM_CAPACITY >= all (SELECT AUDITORIUM.AUDITORIUM_CAPACITY 
											 FROM AUDITORIUM
											 WHERE AUDITORIUM.AUDITORIUM like '4%')

-------------- Task 8 --------------

USE [UNIVER-4];

-- ������: > 15 ��� > 90

SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM.AUDITORIUM_CAPACITY
FROM AUDITORIUM
WHERE AUDITORIUM.AUDITORIUM_CAPACITY >= any (SELECT AUDITORIUM.AUDITORIUM_CAPACITY 
											 FROM AUDITORIUM
											 WHERE AUDITORIUM.AUDITORIUM like '4%')

-------------- Task 9 --------------

USE [VK_MyBASE];

SELECT GOODS.Goods_name [������, ���������� ��������� Apple]
FROM GOODS
WHERE Goods_name in (SELECT Order_goodsName FROM ORDERS where (Order_customer like 'Apple'));

-----------------

USE [VK_MyBASE];

SELECT o.Order_customer [��������], o.Order_amount [���������� ������������� ���������� ���������� �������]
FROM ORDERS o
WHERE Order_amount = (SELECT MAX(Order_amount) FROM ORDERS)

-----------------

USE [VK_MyBASE];

SELECT GOODS.Goods_name [������, ������� ����� �� ������� :(]
FROM GOODS
WHERE not exists (SELECT * FROM ORDERS
				  WHERE ORDERS.Order_goodsName = GOODS.Goods_name);

-----------------

USE [VK_MyBASE];

SELECT top(1)
	   (SELECT AVG(ORDERS.Order_cost) FROM ORDERS WHERE Order_goodsName like '�������������') [�������������],
	   (SELECT AVG(ORDERS.Order_cost) FROM ORDERS WHERE Order_goodsName like '�����') [�����]
FROM ORDERS;

-----------------

USE [VK_MyBASE];

SELECT GOODS.Goods_name, GOODS.Cost
FROM GOODS
WHERE Cost >= all (SELECT Cost FROM GOODS -- ������ ��� ����� ���� ���� ������� � ������ "�"
				   WHERE Goods_name like '%�%')

-----------------

USE [VK_MyBASE];

SELECT GOODS.Goods_name, GOODS.Cost
FROM GOODS
WHERE Cost >= any (SELECT Cost FROM GOODS -- ������ ��� ����� ���� ���� �� ������ ������� � ������ "�"
				   WHERE Goods_name like '%�%')

-------------- Task 10 --------------

USE [UNIVER-4]

SELECT s.NAME, s.BDAY
FROM STUDENT s
WHERE BDAY in (SELECT BDAY FROM STUDENT ss
			   WHERE s.BDAY = ss.BDAY AND s.NAME <> ss.NAME)
Order by BDAY;

SELECT s.NAME, s.BDAY
FROM STUDENT s
WHERE BDAY in (SELECT BDAY FROM STUDENT ss
			   Group by BDAY HAVING (count(BDAY) > 1))
Order by BDAY;