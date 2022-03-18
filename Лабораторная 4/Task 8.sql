USE master;
CREATE database Lab4Task8;

USE Lab4Task8;

CREATE table TASKS
(
task_id int primary key,
task_name nvarchar(75)
);

CREATE table WORKERS
(
worker_id int primary key,
worker_name nvarchar(75),
task_id int foreign key references TASKS(task_id)
);

USE Lab4Task8;

INSERT into TASKS (task_id, task_name) values
					(1, '�����������'),
					(2, '������� ���'),
					(3, '��������� ���������'),
					(4, '������ ���������'),
					(5, '��������'),
					(6, '��������� ����');

INSERT into WORKERS (worker_id, worker_name, task_id) values
					(1, '����', 2),
					(2, '������', 5),
					(3, '����', 4),
					(4, '�����', 1),
					(5, '����', 3),
					(6, '����������', null);

----------------------------------------------------------------------------------------

USE Lab4Task8; -- ���������������

SELECT isnull (WORKERS.worker_name, '��� ���������') [��������], isnull (TASKS.task_name, '��� �������') [�������] 
FROM WORKERS Full Outer Join TASKS on WORKERS.task_id = TASKS.task_id;

SELECT isnull (TASKS.task_name, '��� �������') [�������], isnull (WORKERS.worker_name, '��� ���������') [��������] 
FROM TASKS Full Outer Join WORKERS on TASKS.task_id = WORKERS.task_id;

----------------------------------------------------------------------------------------

USE Lab4Task8; -- ����������� Left Outer Join � Right Outer Join

SELECT WORKERS.worker_name [��������], isnull (TASKS.task_name, '��� �������') [�������] 
FROM WORKERS Left Outer Join TASKS on WORKERS.task_id = TASKS.task_id;

SELECT isnull (WORKERS.worker_name, '��� ���������'), TASKS.task_name [�������] 
FROM WORKERS Right Outer Join TASKS on WORKERS.task_id = TASKS.task_id;

----------------------------------------------------------------------------------------

USE Lab4Task8; -- �������� � ���� Inner Join

SELECT WORKERS.worker_name [��������], TASKS.task_name [�������] 
FROM WORKERS Inner Join TASKS on WORKERS.task_id = TASKS.task_id;

----------------------------------------------------------------------------------------

USE Lab4Task8; -- the 1st query (� ������ ������ null)

SELECT WORKERS.worker_name [��������], isnull (TASKS.task_name, '��� �������') [�������]
FROM WORKERS Full Outer Join TASKS on WORKERS.task_id = TASKS.task_id
	 WHERE TASKS.task_id is null AND WORKERS.worker_id is not null;

----------------------------------------------------------------------------------------

USE Lab4Task8; -- the 2nd query (� ����� ������ null)

SELECT isnull (WORKERS.worker_name, '��� ���������') [��������], isnull (TASKS.task_name, '��� �������') [�������] 
FROM WORKERS Full Outer Join TASKS on WORKERS.task_id = TASKS.task_id
	 WHERE WORKERS.worker_id is null AND TASKS.task_id is not null;

----------------------------------------------------------------------------------------

USE Lab4Task8;

SELECT isnull (WORKERS.worker_name, '��� ���������') [��������], isnull (TASKS.task_name, '��� �������') [�������] 
FROM WORKERS Full Outer Join TASKS on WORKERS.task_id = TASKS.task_id;