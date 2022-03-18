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
					(1, 'Распечатать'),
					(2, 'Сделать чай'),
					(3, 'Подписать документы'),
					(4, 'Купить украшения'),
					(5, 'Украсить'),
					(6, 'Покрасить блок');

INSERT into WORKERS (worker_id, worker_name, task_id) values
					(1, 'Влад', 2),
					(2, 'Максим', 5),
					(3, 'Иван', 4),
					(4, 'Игорь', 1),
					(5, 'Артём', 3),
					(6, 'Бездельник', null);

----------------------------------------------------------------------------------------

USE Lab4Task8; -- коммутативность

SELECT isnull (WORKERS.worker_name, 'Нет работника') [Работник], isnull (TASKS.task_name, 'Нет задания') [Задание] 
FROM WORKERS Full Outer Join TASKS on WORKERS.task_id = TASKS.task_id;

SELECT isnull (TASKS.task_name, 'Нет задания') [Задание], isnull (WORKERS.worker_name, 'Нет работника') [Работник] 
FROM TASKS Full Outer Join WORKERS on TASKS.task_id = WORKERS.task_id;

----------------------------------------------------------------------------------------

USE Lab4Task8; -- объединение Left Outer Join и Right Outer Join

SELECT WORKERS.worker_name [Работник], isnull (TASKS.task_name, 'Нет задания') [Задание] 
FROM WORKERS Left Outer Join TASKS on WORKERS.task_id = TASKS.task_id;

SELECT isnull (WORKERS.worker_name, 'Нет работника'), TASKS.task_name [Задание] 
FROM WORKERS Right Outer Join TASKS on WORKERS.task_id = TASKS.task_id;

----------------------------------------------------------------------------------------

USE Lab4Task8; -- включает в себя Inner Join

SELECT WORKERS.worker_name [Работник], TASKS.task_name [Задание] 
FROM WORKERS Inner Join TASKS on WORKERS.task_id = TASKS.task_id;

----------------------------------------------------------------------------------------

USE Lab4Task8; -- the 1st query (в правой только null)

SELECT WORKERS.worker_name [Работник], isnull (TASKS.task_name, 'Нет задания') [Задание]
FROM WORKERS Full Outer Join TASKS on WORKERS.task_id = TASKS.task_id
	 WHERE TASKS.task_id is null AND WORKERS.worker_id is not null;

----------------------------------------------------------------------------------------

USE Lab4Task8; -- the 2nd query (в левой только null)

SELECT isnull (WORKERS.worker_name, 'Нет работника') [Работник], isnull (TASKS.task_name, 'Нет задания') [Задание] 
FROM WORKERS Full Outer Join TASKS on WORKERS.task_id = TASKS.task_id
	 WHERE WORKERS.worker_id is null AND TASKS.task_id is not null;

----------------------------------------------------------------------------------------

USE Lab4Task8;

SELECT isnull (WORKERS.worker_name, 'Нет работника') [Работник], isnull (TASKS.task_name, 'Нет задания') [Задание] 
FROM WORKERS Full Outer Join TASKS on WORKERS.task_id = TASKS.task_id;