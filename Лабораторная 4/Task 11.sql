use [UNIVER-4];

CREATE table WEEK_DAYS
(
	id_week_days int primary key,
	day_name nvarchar(20)
);

INSERT into WEEK_DAYS (id_week_days, day_name) values
			(1, 'Понедельник'),
			(2, 'Вторник'),
			(3, 'Среда'),
			(4, 'Четверг'),
			(5, 'Пятница'),
			(6, 'Суббота'),
			(7, 'Воскресенье');

CREATE table TIME
(
	id_time int primary key,
	start_time Time,
	end_time Time
);

INSERT into TIME (id_time, start_time, end_time) values
				 (1, '8:00', '9:20'),
				 (2, '9:35', '10:55'),
				 (3, '11:25', '12:40'),
				 (4, '13:00', '14:20'),
				 (5, '14:40', '16:00'),
				 (6, '16:30', '17:50'),
				 (7, '18:05', '19:25'),
				 (8, '19:40', '21:00');

CREATE table TIMETABLE
(
	id_timetable int primary key,
	IDGROUP int foreign key references GROUPS(IDGROUP),
	AUDITORIUM char(20) foreign key references AUDITORIUM(AUDITORIUM),
	SUBJECT char(10) foreign key references SUBJECT(SUBJECT),
	TEACHER char(10) foreign key references TEACHER(TEACHER),
	id_week_days int foreign key references WEEK_DAYS(id_week_days),
	id_time int foreign key references TIME(id_time)
);

INSERT into TIMETABLE (id_timetable, IDGROUP, AUDITORIUM, SUBJECT, TEACHER, id_week_days, id_time) values
					  (1, 1, '206-1', 'КМС', 'ГРН', 3, 6),
					  (2, 2, '301-1', 'ИНФ', 'ЖЛК', 2, 3),
					  (3, 1, '301-1', 'БД', 'ЖЛК', 5, 5),
					  (4, 5, '313-1', 'ИГ', 'УРБ', 1, 8),
					  (5, 3, '423-1', 'БД', 'СМЛВ', 6, 7),
					  (6, 3, '408-2', 'МП', 'СМЛВ', 6, 8);

----------------------------------------------------------------------
USE [UNIVER-4];

SELECT AUDITORIUM.AUDITORIUM_NAME, WEEK_DAYS.day_name, TIME.start_time -- наличие свободных аудиторий на определенную пару
FROM AUDITORIUM Cross Join WEEK_DAYS Cross Join TIME
				Left Outer Join TIMETABLE -- если аудитории нет в расписании, не значит, что аудитории не существует
ON AUDITORIUM.AUDITORIUM = TIMETABLE.AUDITORIUM AND WEEK_DAYS.id_week_days = TIMETABLE.id_week_days
												AND TIME.id_time = TIMETABLE.id_time
WHERE TIMETABLE.id_timetable is null AND TIME.start_time = '19:40'
ORDER BY AUDITORIUM.AUDITORIUM_NAME, WEEK_DAYS.id_week_days

----------------------------------------------------------------------

SELECT AUDITORIUM.AUDITORIUM_NAME, WEEK_DAYS.day_name, TIME.start_time -- наличие свободных аудиторий на определенный день недели
FROM AUDITORIUM Cross Join WEEK_DAYS Cross Join TIME
	 Left Outer Join TIMETABLE
ON AUDITORIUM.AUDITORIUM = TIMETABLE.AUDITORIUM AND WEEK_DAYS.id_week_days = TIMETABLE.id_week_days
												AND TIME.id_time = TIMETABLE.id_time
WHERE TIMETABLE.id_timetable is null AND WEEK_DAYS.day_name = 'Понедельник'
ORDER BY AUDITORIUM.AUDITORIUM_NAME

----------------------------------------------------------------------

SELECT GROUPS.IDGROUP, WEEK_DAYS.day_name, TIME.start_time -- наличие «окон» в группах
FROM GROUPS Cross Join TIME Cross Join WEEK_DAYS
	 Left Outer Join TIMETABLE
ON GROUPS.IDGROUP = TIMETABLE.IDGROUP AND TIME.id_time = TIMETABLE.id_time
									  AND WEEK_DAYS.id_week_days = TIMETABLE.id_week_days
WHERE TIMETABLE.IDGROUP is null
ORDER BY GROUPS.IDGROUP, WEEK_DAYS.id_week_days, TIME.start_time

----------------------------------------------------------------------

SELECT TEACHER.TEACHER_NAME, WEEK_DAYS.day_name, TIME.start_time -- наличие «окон» у преподавателей
FROM TEACHER Cross Join TIME Cross Join WEEK_DAYS
	 Left Outer Join TIMETABLE
ON TEACHER.TEACHER = TIMETABLE.TEACHER AND TIME.id_time = TIMETABLE.id_time AND WEEK_DAYS.id_week_days = TIMETABLE.id_week_days
WHERE TIMETABLE.IDGROUP is null
ORDER BY TEACHER.TEACHER_NAME, WEEK_DAYS.id_week_days, TIME.start_time