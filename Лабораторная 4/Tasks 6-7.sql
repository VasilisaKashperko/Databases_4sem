-- Task 6

USE [UNIVER-4];

SELECT PULPIT.PULPIT_NAME [�������], isnull (TEACHER.TEACHER_NAME, '***') [�������������]
FROM PULPIT Left Outer Join TEACHER on PULPIT.PULPIT = TEACHER.PULPIT

-- Task 7.1

USE [UNIVER-4];

SELECT PULPIT.PULPIT_NAME [�������], isnull (TEACHER.TEACHER_NAME, '***') [�������������]
FROM TEACHER Left Outer Join PULPIT on PULPIT.PULPIT = TEACHER.PULPIT
-- ������ � ������� ������� �� ����� ���� �������� NULL? ������ ��� ������ ������������� �������� � �������,
-- �.�. ��� �������������� ��� �������.

-- Task 7.2
USE [UNIVER-4];

SELECT PULPIT.PULPIT_NAME [�������], isnull (TEACHER.TEACHER_NAME, '***') [�������������]
FROM TEACHER Right Outer Join PULPIT on PULPIT.PULPIT = TEACHER.PULPIT
