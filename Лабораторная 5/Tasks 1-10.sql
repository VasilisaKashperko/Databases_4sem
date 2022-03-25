-------------- Task 1 --------------

USE [UNIVER-4];

SELECT PULPIT.PULPIT_NAME [Кафедра], FACULTY.FACULTY_NAME [Факультет], PROFESSION.PROFESSION_NAME [Специальность]
FROM PULPIT, FACULTY, PROFESSION
Where FACULTY.FACULTY = PULPIT.FACULTY
	  and
	  FACULTY.FACULTY = PROFESSION.FACULTY
	  and
	  PROFESSION_NAME in (SELECT PROFESSION_NAME FROM PROFESSION where (PROFESSION_NAME like '%техно%'));

-- или так, просто кафедры, на факультете которых есть специальность со словом "технология(-и)":

USE [UNIVER-4];

SELECT PULPIT.PULPIT_NAME
FROM PULPIT
Where FACULTY in (SELECT FACULTY FROM PROFESSION where (PROFESSION_NAME like '%техно%'));

-------------- Task 2 --------------

USE [UNIVER-4];

SELECT PULPIT.PULPIT_NAME [Кафедра], FACULTY.FACULTY_NAME [Факультет], PROFESSION.PROFESSION_NAME [Специальность]
FROM PULPIT Inner Join FACULTY ON FACULTY.FACULTY = PULPIT.FACULTY
			Inner Join PROFESSION ON FACULTY.FACULTY = PROFESSION.FACULTY
Where PROFESSION_NAME in (SELECT PROFESSION_NAME FROM PROFESSION where (PROFESSION_NAME like '%техно%'));

-------------- Task 3 --------------

USE [UNIVER-4];

SELECT PULPIT.PULPIT_NAME [Кафедра], FACULTY.FACULTY_NAME [Факультет], PROFESSION.PROFESSION_NAME [Специальность]
FROM PULPIT Inner Join FACULTY ON FACULTY.FACULTY = PULPIT.FACULTY
			Inner Join PROFESSION ON FACULTY.FACULTY = PROFESSION.FACULTY where (PROFESSION_NAME like '%техно%');

-------------- Task 4 --------------

USE [UNIVER-4];

SELECT a.AUDITORIUM_TYPE [Тип аудитории], a.AUDITORIUM_CAPACITY
FROM AUDITORIUM as a
WHERE AUDITORIUM_CAPACITY = (SELECT top(1) AUDITORIUM_CAPACITY FROM AUDITORIUM aa
							  WHERE a.AUDITORIUM_TYPE = aa.AUDITORIUM_TYPE
							  Order by AUDITORIUM_CAPACITY desc)
Order by AUDITORIUM_CAPACITY desc;

-------------- Task 5 --------------

USE [UNIVER-4];

-- примечание: в нашей БД таких факультетов без кафедр нет

SELECT FACULTY.FACULTY_NAME
FROM FACULTY
WHERE not exists (SELECT * FROM PULPIT
				  WHERE FACULTY.FACULTY = PULPIT.FACULTY)

-------------- Task 6 --------------

USE [UNIVER-4];

-- примечание: в нашей БД нет предмета "БД", но зато есть "КГ"

SELECT top(1)
	   (SELECT AVG(PROGRESS.NOTE) FROM PROGRESS where SUBJECT like 'ОАиП') [ОАиП],
	   (SELECT AVG(PROGRESS.NOTE) FROM PROGRESS where SUBJECT like 'КГ') [КГ],
	   (SELECT AVG(PROGRESS.NOTE) FROM PROGRESS where SUBJECT like 'СУБД') [СУБД]
FROM PROGRESS;

-------------- Task 7 --------------

USE [UNIVER-4];

-- подзапрос: выбираем столбец "вместимость" из таблицы "аудитории", где номер аудитории начинается с 4-х
-- запрос: > 15 И > 90

SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM.AUDITORIUM_CAPACITY
FROM AUDITORIUM
WHERE AUDITORIUM.AUDITORIUM_CAPACITY >= all (SELECT AUDITORIUM.AUDITORIUM_CAPACITY 
											 FROM AUDITORIUM
											 WHERE AUDITORIUM.AUDITORIUM like '4%')

-------------- Task 8 --------------

USE [UNIVER-4];

-- запрос: > 15 ИЛИ > 90

SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM.AUDITORIUM_CAPACITY
FROM AUDITORIUM
WHERE AUDITORIUM.AUDITORIUM_CAPACITY >= any (SELECT AUDITORIUM.AUDITORIUM_CAPACITY 
											 FROM AUDITORIUM
											 WHERE AUDITORIUM.AUDITORIUM like '4%')

-------------- Task 9 --------------

USE [VK_MyBASE];

SELECT GOODS.Goods_name [Товары, заказанные компанией Apple]
FROM GOODS
WHERE Goods_name in (SELECT Order_goodsName FROM ORDERS where (Order_customer like 'Apple'));

-----------------

USE [VK_MyBASE];

SELECT o.Order_customer [Заказчик], o.Order_amount [Наибольшее одновременное количество заказанных товаров]
FROM ORDERS o
WHERE Order_amount = (SELECT MAX(Order_amount) FROM ORDERS)

-----------------

USE [VK_MyBASE];

SELECT GOODS.Goods_name [Товары, которые никто не заказал :(]
FROM GOODS
WHERE not exists (SELECT * FROM ORDERS
				  WHERE ORDERS.Order_goodsName = GOODS.Goods_name);

-----------------

USE [VK_MyBASE];

SELECT top(1)
	   (SELECT AVG(ORDERS.Order_cost) FROM ORDERS WHERE Order_goodsName like 'Микроволновка') [Микроволновка],
	   (SELECT AVG(ORDERS.Order_cost) FROM ORDERS WHERE Order_goodsName like 'Пульт') [Пульт]
FROM ORDERS;

-----------------

USE [VK_MyBASE];

SELECT GOODS.Goods_name, GOODS.Cost
FROM GOODS
WHERE Cost >= all (SELECT Cost FROM GOODS -- больше или равна цене ВСЕХ товаров с буквой "т"
				   WHERE Goods_name like '%т%')

-----------------

USE [VK_MyBASE];

SELECT GOODS.Goods_name, GOODS.Cost
FROM GOODS
WHERE Cost >= any (SELECT Cost FROM GOODS -- больше или равна цене ХОТЯ БЫ ОДНОГО товаров с буквой "т"
				   WHERE Goods_name like '%т%')

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