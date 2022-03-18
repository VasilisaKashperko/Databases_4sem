-- Task 6

USE [UNIVER-4];

SELECT PULPIT.PULPIT_NAME [Кафедра], isnull (TEACHER.TEACHER_NAME, '***') [Преподаватель]
FROM PULPIT Left Outer Join TEACHER on PULPIT.PULPIT = TEACHER.PULPIT

-- Task 7.1

USE [UNIVER-4];

SELECT PULPIT.PULPIT_NAME [Кафедра], isnull (TEACHER.TEACHER_NAME, '***') [Преподаватель]
FROM TEACHER Left Outer Join PULPIT on PULPIT.PULPIT = TEACHER.PULPIT
-- Почему в столбце Кафедра не может быть значения NULL? Потому что каждый преподаватель привязан к кафедре,
-- т.е. нет преподавателей без кафедры.

-- Task 7.2
USE [UNIVER-4];

SELECT PULPIT.PULPIT_NAME [Кафедра], isnull (TEACHER.TEACHER_NAME, '***') [Преподаватель]
FROM TEACHER Right Outer Join PULPIT on PULPIT.PULPIT = TEACHER.PULPIT
