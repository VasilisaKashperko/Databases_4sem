--------------- Task 1 ---------------

USE [UNIVER-4];

SELECT MAX(AUDITORIUM.AUDITORIUM_CAPACITY) [Максимальная вместимость],
	   MIN(AUDITORIUM.AUDITORIUM_CAPACITY) [Минимальная вместимость],
	   AVG(AUDITORIUM.AUDITORIUM_CAPACITY) [Среднее значение вместимости],
	   SUM(AUDITORIUM.AUDITORIUM_CAPACITY) [Сумма вместимостей],
	   COUNT(*) [Общее количество аудиторий]
FROM AUDITORIUM;

--------------- Task 2 ---------------

USE [UNIVER-4];

SELECT AUDITORIUM_TYPE.AUDITORIUM_TYPENAME,
	   MAX(AUDITORIUM.AUDITORIUM_CAPACITY) [Максимальная вместимость],
	   MIN(AUDITORIUM.AUDITORIUM_CAPACITY) [Минимальная вместимость],
	   AVG(AUDITORIUM.AUDITORIUM_CAPACITY) [Среднее значение вместимости],
	   SUM(AUDITORIUM.AUDITORIUM_CAPACITY) [Сумма вместимостей],
	   COUNT(*) [Количество аудиторий данного типа]
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
				   ELSE 'Оценка ниже 4'
			   END [Оценки], COUNT(*) [Количество]
	   FROM PROGRESS
	   Group by Case WHEN NOTE = 10 then '10'
					 WHEN NOTE IN(8,9) then '8-9'
					 WHEN NOTE IN(6,7) then '6-7'
					 WHEN NOTE IN(4,5) then '4-5'
					 ELSE 'Оценка ниже 4'
			   END) as T
Order by Case [Оценки]
		 WHEN '10' then 1
		 WHEN '8-9' then 2
		 WHEN '6-7' then 3
		 WHEN '4-5' then 4
		 ELSE 0
		 END

--------------- Task 4.1 ---------------

USE [UNIVER-4];

-- float(n), где n — количество битов, которые используются для хранения мантиссы числа с плавающей запятой

SELECT f.FACULTY [Факультет], g.PROFESSION [Специальность],
	   g.YEAR_FIRST [Год, когда стали перокурсниками], round(avg(cast(p.NOTE as float(4))), 2) [Средняя оценка]
FROM FACULTY f Inner Join GROUPS g ON f.FACULTY = g.FACULTY
			   Inner Join STUDENT s ON g.IDGROUP = s.IDGROUP
			   Inner Join PROGRESS p ON p.IDSTUDENT = s.IDSTUDENT

Group by f.FACULTY, g.PROFESSION, g.YEAR_FIRST
Order by [Средняя оценка] desc;

--------------- Task 4.2 ---------------

USE [UNIVER-4];

SELECT f.FACULTY [Факультет], g.PROFESSION [Специальность],
	   g.YEAR_FIRST [Год поступления], round(avg(cast(p.NOTE as float(4))), 2) [Средняя оценка]
FROM FACULTY f Inner Join GROUPS g ON f.FACULTY = g.FACULTY
			   Inner Join STUDENT s ON g.IDGROUP = s.IDGROUP
			   Inner Join PROGRESS p ON p.IDSTUDENT = s.IDSTUDENT
WHERE p.SUBJECT like 'ОАиП' or p.SUBJECT = 'СУБД'
Group by f.FACULTY, g.PROFESSION, g.YEAR_FIRST
Order by [Средняя оценка] desc;

--------------- Task 5.1 ---------------


USE [UNIVER-4];

SELECT f.FACULTY [Факультет], g.PROFESSION [Специальность],
	   p.SUBJECT [Дисциплина], round(avg(cast(p.NOTE as float(4))), 2) [Средняя оценка]
FROM FACULTY f Inner Join GROUPS g ON f.FACULTY = g.FACULTY
			   Inner Join STUDENT s ON g.IDGROUP = s.IDGROUP
			   Inner Join PROGRESS p ON p.IDSTUDENT = s.IDSTUDENT
WHERE f.FACULTY like 'ИТ'
group by f.FACULTY, g.PROFESSION, p.SUBJECT
Order by [Средняя оценка] desc;

--------------- Task 5.2 ---------------

USE [UNIVER-4];

-- ROLLUP возвращает комбинацию групп и итоговых строк, которая определена в порядке, в котором заданы группируемые столбцы

SELECT f.FACULTY [Факультет], g.PROFESSION [Специальность],
	   p.SUBJECT [Дисциплина], round(avg(cast(p.NOTE as float(4))), 2) [Средняя оценка]
FROM FACULTY f Inner Join GROUPS g ON f.FACULTY = g.FACULTY
			   Inner Join STUDENT s ON g.IDGROUP = s.IDGROUP
			   Inner Join PROGRESS p ON p.IDSTUDENT = s.IDSTUDENT
WHERE f.FACULTY like 'ИТ'
group by rollup (f.FACULTY, g.PROFESSION, p.SUBJECT)
Order by [Средняя оценка] desc;

--------------- Task 6 ---------------

USE [UNIVER-4];

-- Конструкция CUBE возвращает любую возможную комбинацию групп и итоговых строк

SELECT f.FACULTY [Факультет], g.PROFESSION [Специальность],
	   p.SUBJECT [Дисциплина], round(avg(cast(p.NOTE as float(4))), 2) [Средняя оценка]
FROM FACULTY f Inner Join GROUPS g ON f.FACULTY = g.FACULTY
			   Inner Join STUDENT s ON g.IDGROUP = s.IDGROUP
			   Inner Join PROGRESS p ON p.IDSTUDENT = s.IDSTUDENT
WHERE f.FACULTY like 'ИТ'
group by cube (f.FACULTY, g.PROFESSION, p.SUBJECT)
Order by [Средняя оценка] desc;

--------------- Task 7 ---------------

USE [UNIVER-4];

-- UNION удаляет дубликаты записей (где все столбцы в результатах одинаковы), UNION ALL - объединяет без удаления дубликатов.

SELECT f.FACULTY [Факультет], g.PROFESSION [Специальность],
	   p.SUBJECT [Дисциплина], round(avg(cast(p.NOTE as float(4))), 2) [Средняя оценка]
FROM FACULTY f Inner Join GROUPS g ON f.FACULTY = g.FACULTY
			   Inner Join STUDENT s ON g.IDGROUP = s.IDGROUP
			   Inner Join PROGRESS p ON p.IDSTUDENT = s.IDSTUDENT
WHERE f.FACULTY like 'ИТ'
group by f.FACULTY, g.PROFESSION, p.SUBJECT

UNION

SELECT f.FACULTY [Факультет], g.PROFESSION [Специальность],
	   p.SUBJECT [Дисциплина], round(avg(cast(p.NOTE as float(4))), 2) [Средняя оценка]
FROM FACULTY f Inner Join GROUPS g ON f.FACULTY = g.FACULTY
			   Inner Join STUDENT s ON g.IDGROUP = s.IDGROUP
			   Inner Join PROGRESS p ON p.IDSTUDENT = s.IDSTUDENT
WHERE f.FACULTY like 'ТОВ'
group by f.FACULTY, g.PROFESSION, p.SUBJECT
Order by [Средняя оценка] desc;

--------------- Task 7.1 ---------------

USE [UNIVER-4];

SELECT f.FACULTY [Факультет], g.PROFESSION [Специальность],
	   p.SUBJECT [Дисциплина], round(avg(cast(p.NOTE as float(4))), 2) [Средняя оценка]
FROM FACULTY f Inner Join GROUPS g ON f.FACULTY = g.FACULTY
			   Inner Join STUDENT s ON g.IDGROUP = s.IDGROUP
			   Inner Join PROGRESS p ON p.IDSTUDENT = s.IDSTUDENT
WHERE f.FACULTY like 'ИТ'
group by f.FACULTY, g.PROFESSION, p.SUBJECT

UNION ALL

SELECT f.FACULTY [Факультет], g.PROFESSION [Специальность],
	   p.SUBJECT [Дисциплина], round(avg(cast(p.NOTE as float(4))), 2) [Средняя оценка]
FROM FACULTY f Inner Join GROUPS g ON f.FACULTY = g.FACULTY
			   Inner Join STUDENT s ON g.IDGROUP = s.IDGROUP
			   Inner Join PROGRESS p ON p.IDSTUDENT = s.IDSTUDENT
WHERE f.FACULTY like 'ТОВ'
group by f.FACULTY, g.PROFESSION, p.SUBJECT
Order by [Средняя оценка] desc;

--------------- Task 8 ---------------

USE [UNIVER-4];

SELECT f.FACULTY [Факультет], g.PROFESSION [Специальность],
	   p.SUBJECT [Дисциплина], round(avg(cast(p.NOTE as float(4))), 2) [Средняя оценка]
FROM FACULTY f Inner Join GROUPS g ON f.FACULTY = g.FACULTY
			   Inner Join STUDENT s ON g.IDGROUP = s.IDGROUP
			   Inner Join PROGRESS p ON p.IDSTUDENT = s.IDSTUDENT
WHERE f.FACULTY like 'ИТ'
group by f.FACULTY, g.PROFESSION, p.SUBJECT

INTERSECT

SELECT f.FACULTY [Факультет], g.PROFESSION [Специальность],
	   p.SUBJECT [Дисциплина], round(avg(cast(p.NOTE as float(4))), 2) [Средняя оценка]
FROM FACULTY f Inner Join GROUPS g ON f.FACULTY = g.FACULTY
			   Inner Join STUDENT s ON g.IDGROUP = s.IDGROUP
			   Inner Join PROGRESS p ON p.IDSTUDENT = s.IDSTUDENT
WHERE f.FACULTY like 'ТОВ'
group by f.FACULTY, g.PROFESSION, p.SUBJECT
Order by [Средняя оценка] desc;

--------------- Task 9 ---------------

USE [UNIVER-4];

-- EXCEPT -> набор строк, являющийся разностью двух исходных наборов строк
-- (т.е. в результирующий набор включаются те строки, которые есть в первом запросе, но отсутствуют во втором).

SELECT f.FACULTY [Факультет], g.PROFESSION [Специальность],
	   p.SUBJECT [Дисциплина], round(avg(cast(p.NOTE as float(4))), 2) [Средняя оценка]
FROM FACULTY f Inner Join GROUPS g ON f.FACULTY = g.FACULTY
			   Inner Join STUDENT s ON g.IDGROUP = s.IDGROUP
			   Inner Join PROGRESS p ON p.IDSTUDENT = s.IDSTUDENT
WHERE f.FACULTY like 'ИТ'
group by f.FACULTY, g.PROFESSION, p.SUBJECT

EXCEPT

SELECT f.FACULTY [Факультет], g.PROFESSION [Специальность],
	   p.SUBJECT [Дисциплина], round(avg(cast(p.NOTE as float(4))), 2) [Средняя оценка]
FROM FACULTY f Inner Join GROUPS g ON f.FACULTY = g.FACULTY
			   Inner Join STUDENT s ON g.IDGROUP = s.IDGROUP
			   Inner Join PROGRESS p ON p.IDSTUDENT = s.IDSTUDENT
WHERE f.FACULTY like 'ТОВ'
group by f.FACULTY, g.PROFESSION, p.SUBJECT
Order by [Средняя оценка] desc;

--------------- Task 10 ---------------
USE [UNIVER-4];

SELECT p.SUBJECT [Дисциплина], p.NOTE [Оценка], (SELECT COUNT(*) FROM PROGRESS pp
						   WHERE p.SUBJECT = pp.SUBJECT
						   AND p.NOTE = pp.NOTE) [Количество]
FROM PROGRESS p
Group by p.SUBJECT, p.NOTE
HAVING NOTE = 8 or NOTE = 9;

--------------- Task 11 ---------------

USE [VK_MyBASE];

SELECT MAX(ORDERS.Order_cost) [Максимальная цена продажи],
	   MIN(ORDERS.Order_cost) [Минимальная цена продажи],
	   round(avg(cast(ORDERS.Order_cost as float(4))), 2) [Среднее значение цены продажи],
	   SUM(ORDERS.Order_cost) [Сумма цен продажи],
	   COUNT(*) [Общее количество аудиторий]
FROM ORDERS;

-----------

USE [VK_MyBASE];

--Определяем наименования и максимальные цены товаров при продаже,
--количество заказанных товаров для тех товаров, количество которых на складе больше 3х

SELECT ORDERS.Order_goodsName,  
          MAX(ORDERS.Order_cost)  [Максимальная цена],  
          COUNT(*)  [Количество заказанных товаров]
FROM  ORDERS  Inner Join  GOODS 
              ON  ORDERS.Order_goodsName = GOODS.Goods_name 
              and  GOODS.Amount >= 3
Group by Order_goodsName;

--------------- Task 12.1 ---------------

USE [UNIVER-4];

SELECT FACULTY.FACULTY_NAME [Факультет], GROUPS.IDGROUP [Номер группы], COUNT(*) [Количество]
FROM FACULTY Inner Join GROUPS ON FACULTY.FACULTY = GROUPS.FACULTY
			 Inner Join STUDENT on STUDENT.IDGROUP = GROUPS.IDGROUP
Group by rollup (FACULTY_NAME, GROUPS.IDGROUP);

--------------- Task 12.2 ---------------

USE [UNIVER-4];

-- Подсчитать количество аудиторий по типам и суммарной вместимости всего одним запросом.

SELECT AUDITORIUM.AUDITORIUM_TYPE [Тип аудитории], AUDITORIUM.AUDITORIUM_CAPACITY [Вместимость аудитории], COUNT(*) [Количество],
	   (SELECT SUM(AUDITORIUM_CAPACITY) FROM AUDITORIUM aa WHERE AUDITORIUM.AUDITORIUM_CAPACITY = aa.AUDITORIUM_CAPACITY) [Суммарная вместимость c одинаковым значением],
	   (SELECT SUM(AUDITORIUM.AUDITORIUM_CAPACITY) FROM AUDITORIUM)
FROM AUDITORIUM
Group by rollup (AUDITORIUM_TYPE, AUDITORIUM_CAPACITY);

