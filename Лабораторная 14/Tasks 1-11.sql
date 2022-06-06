------------------------- Task 1 -------------------------

drop table TR_AUDIT

create table TR_AUDIT
(
ID int identity, -- Номер
STMT varchar(20) check (STMT in ('INS', 'DEL', 'UPD', 'UPD--')), -- DML-оператор (событие, на которое среагировал)
TRNAME varchar(50), -- Имя триггера
CC varchar(300) -- "Вопросы?"
)

drop trigger TR_TEACHER_INS

go
create trigger TR_TEACHER_INS on TEACHER after insert as
	begin
		declare @code nvarchar(10), @name nvarchar(100), @gender char(1), @pulpit nvarchar(10), @all nvarchar(300) = '', @time datetime
		print 'Операция INSERT '
		set @code = rtrim((select TEACHER from inserted))
		set @name = (select TEACHER_NAME from inserted)
		set @gender = (select GENDER from inserted)
		set @pulpit = (select PULPIT from inserted)
		set @time = sysdatetime()
		set  @all = @code + ' ' + @name + ' ' + @gender + ' ' + @pulpit + ' ' + cast(@time as nvarchar(20))
		insert into TR_AUDIT (STMT, TRNAME, CC) values
						('INS','TR_TEACHER_INS',@all)
		return
	end
go

insert into TEACHER (TEACHER, TEACHER_NAME, GENDER, PULPIT) values
			('КШПРК','Кашперко Василиса Сергеевна','ж','ИСиТ')

select * from TR_AUDIT

------------------------- Task 2 -------------------------

drop trigger TR_TEACHER_DEL
go
create trigger TR_TEACHER_DEL on TEACHER after delete as
begin
	declare @code nvarchar(10), @name nvarchar(100), @gender char(1), @pulpit nvarchar(10), @all nvarchar(300) = '', @time datetime
	print 'Операция удаления '
	set @code = rtrim((select TEACHER from deleted))
	set @name = (select TEACHER_NAME from deleted)
	set @gender = (select GENDER from deleted)
	set @pulpit = (select PULPIT from deleted)
	set @time = sysdatetime()
	set  @all = @code + ' ' + @name + ' ' + @gender + ' ' + @pulpit + ' ' + cast(@time as nvarchar(20))
	insert into TR_AUDIT (STMT, TRNAME, CC) values
					('DEL','TR_TEACHER_DEL',@all)
	return
end
go

delete TEACHER where TEACHER_NAME = 'Кашперко Василиса Сергеевна'
select * from TR_AUDIT

------------------------- Task 3 -------------------------

drop trigger TR_TEACHER_UPD
go
create trigger TR_TEACHER_UPD on TEACHER after update as
begin
	declare @code nvarchar(10), @name nvarchar(100), @gender char(1), @pulpit nvarchar(10), @all nvarchar(300) = '', @time datetime
	declare @code1 nvarchar(10), @name1 nvarchar(100), @gender1 char(1), @pulpit1 nvarchar(10), @all1 nvarchar(300) = '', @time1 datetime
	print 'Операция UPDATE '
	set @code = rtrim((select TEACHER from inserted))
	set @name = (select TEACHER_NAME from inserted)
	set @gender = (select GENDER from inserted)
	set @pulpit = (select PULPIT from inserted)
	set @time = sysdatetime()
	set @all = @code + ' ' + @name + ' ' + @gender + ' ' + @pulpit + ' ' + cast(@time as nvarchar(20)) + '--'

	set @code1 = rtrim((select TEACHER from deleted))
	set @name1 = (select TEACHER_NAME from deleted)
	set @gender1 = (select GENDER from deleted)
	set @pulpit1 = (select PULPIT from deleted)
	set @time1 = sysdatetime()
	set @all1 = @code1 + ' ' + @name1 + ' ' + @gender1 + ' ' + @pulpit1 + ' ' + cast(@time1 as nvarchar(20))

	insert into TR_AUDIT (STMT, TRNAME, CC) values
				('UPD','TR_TEACHER_UPD',@all),
				('UPD--','TR_TEACHER_UPD',@all1)
	return
end
go
update TEACHER set TEACHER = 'КШПРКО' where TEACHER = 'КШПРК'
select * from TR_AUDIT

------------------------- Task 4 -------------------------

drop trigger TR_TEACHER

go
create trigger TR_TEACHER on TEACHER after insert, update, delete
as
begin
	declare @code nvarchar(10), @name nvarchar(100), @gender char(1), @pulpit nvarchar(10), @all nvarchar(300) = '', @time datetime
	declare @code1 nvarchar(10), @name1 nvarchar(100), @gender1 char(1), @pulpit1 nvarchar(10), @all1 nvarchar(300) = '', @time1 datetime
	declare @ins int = (select count(*) from inserted), @del int = (select count(*) from deleted)
	if @ins >0 and @del = 0
	begin
		print 'Событие Insert'
		set @code = rtrim((select TEACHER from inserted))
		set @name = (select TEACHER_NAME from inserted)
		set @gender = (select GENDER from inserted)
		set @pulpit = (select PULPIT from inserted)
		set @time = sysdatetime()
		set  @all = @code + ' ' + @name + ' ' + @gender + ' ' + @pulpit + ' ' + cast(@time as nvarchar(20))
		insert into TR_AUDIT (STMT, TRNAME, CC) values
						('INS','TR_TEACHER',@all)
		return
	end
	else if @ins = 0 and @del>0
	begin
		print 'Событие Delete'
		set @code = rtrim((select TEACHER from deleted))
		set @name = (select TEACHER_NAME from deleted)
		set @gender = (select GENDER from deleted)
		set @pulpit = (select PULPIT from deleted)
		set @time = sysdatetime()
		set  @all = @code + ' ' + @name + ' ' + @gender + ' ' + @pulpit + ' ' + cast(@time as nvarchar(20))
		insert into TR_AUDIT (STMT, TRNAME, CC) values
						('DEL','TR_TEACHER',@all)
	return
	end
	else if @ins>0 and @del>0
	begin
		print 'Событие Update '
		set @code = rtrim((select TEACHER from inserted))
		set @name = (select TEACHER_NAME from inserted)
		set @gender = (select GENDER from inserted)
		set @pulpit = (select PULPIT from inserted)
		set @time = sysdatetime()
		set @all = @code + ' ' + @name + ' ' + @gender + ' ' + @pulpit + ' ' + cast(@time as nvarchar(20)) + '--'

		set @code1 = rtrim((select TEACHER from deleted))
		set @name1 = (select TEACHER_NAME from deleted)
		set @gender1 = (select GENDER from deleted)
		set @pulpit1 = (select PULPIT from deleted)
		set @time1 = sysdatetime()
		set @all1 = @code1 + ' ' + @name1 + ' ' + @gender1 + ' ' + @pulpit1 + ' ' + cast(@time1 as nvarchar(20))

		insert into TR_AUDIT (STMT, TRNAME, CC) values
						('UPD','TR_TEACHER',@all),
						('UPD--','TR_TEACHER',@all)
	return
	end
end
go

insert into TEACHER (TEACHER, TEACHER_NAME, GENDER, PULPIT) values
			('КАШПРК','Кашперко Василиса Сергеевна','ж','ИСиТ')
update TEACHER set TEACHER = 'КШП' where TEACHER = 'КАШПЕРК'
delete TEACHER where TEACHER = 'КШП'

select * from TR_AUDIT

delete TR_AUDIT

------------------------- Task 5 -------------------------

insert into TEACHER (TEACHER, TEACHER_NAME, GENDER, PULPIT) values
('КШПРК','Кашперко Василиса Сергеевна','12345йцукен','ИСиТ')

select * from TR_AUDIT

------------------------- Task 6 -------------------------

drop trigger TR_TEACHER_DEL1
drop trigger TR_TEACHER_DEL2
drop trigger TR_TEACHER_DEL3

go
create trigger TR_TEACHER_DEL1 on TEACHER after delete as
begin
	print 'Триггер 1' 
	declare @a nvarchar(50) = (select TEACHER from deleted)
	insert into TR_AUDIT values
		('DEL','TR_TEACHER_DEL1',@a)
end
go

go
create trigger TR_TEACHER_DEL2 on TEACHER after delete as
begin
	print 'Триггер 2' 
	declare @a nvarchar(50) = (select TEACHER from deleted)
	insert into TR_AUDIT values
	('DEL','TR_TEACHER_DEL2',@a)
end
go

go
create trigger TR_TEACHER_DEL3 on TEACHER after delete as
begin
	print 'Триггер 3' 
	declare @a nvarchar(50) = (select TEACHER from deleted)
	insert into TR_AUDIT values
	('DEL','TR_TEACHER_DEL3',@a)
end
go

exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL1', @order = 'None', @stmttype = 'DELETE';
exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL2', @order = 'Last', @stmttype = 'DELETE';
exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL3', @order = 'First', @stmttype = 'DELETE';

insert into TEACHER (TEACHER, TEACHER_NAME, GENDER, PULPIT) values
('КШПРК','Кашперко Василиса Сергеевна','ж','ИСиТ')
delete TEACHER where TEACHER = 'КШПРК'

select * from TR_AUDIT

select t.name, e.type_desc 
from sys.triggers  t join  sys.trigger_events e  
on t.object_id = e.object_id  
where OBJECT_NAME(t.parent_id) = 'TEACHER' and e.type_desc = 'DELETE' ;  

------------------------- Task 7 -------------------------

drop trigger TRTASK7

go
create trigger TRTASK7 on TEACHER after insert, delete, update as
begin
	declare @count int = (select count(*) from TEACHER)
	if (@count>10)
		begin
			raiserror('Преподавателей слишком много для создания триггера',10,1)
			rollback
		end
	return
end
go

insert into TEACHER (TEACHER, TEACHER_NAME, GENDER, PULPIT) values
('КШПРК','Кашперко Василиса Сергеевна','ж','ИСиТ')

------------------------- Task 8 -------------------------

drop trigger InsteadOf

go
create trigger InsteadOf on TEACHER instead of delete as
begin
	raiserror(N'Удаление запрещено!',10,1)
	return
end
go

delete TEACHER
select * from TEACHER

delete TEACHER where TEACHER = 'КШПРК'

------------------------- Task 9 -------------------------
drop trigger TR_UNIVERSITY

go
create trigger TR_UNIVERSITY on database for DDL_DATABASE_LEVEL_EVENTS as
	declare @t1 varchar(50), @t2 varchar(50), @t3 varchar(50)
	set @t1 = EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]','varchar(50)')
	set @t2 = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]','varchar(50)')
	set @t3 = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]','varchar(50)')

	print 'Тип события: ' + @t1;
	print 'Имя объекта: ' + @t2;
	print 'Тип объекта: ' + @t3;

	raiserror ('Изменение базы данных запрещено!',10,1)
rollback
return
go

drop table NewTable;

create table NewTable
(
id int primary key,
vasilisa varchar(300)
);

select * from NewTable;
drop table NewTable;

------------------------- Task 10 -------------------------

create table Weather
(
city varchar(30),
startdate DATETIME,
enddate DATETIME,
temp NUMERIC
)

go
create trigger TR_WEATHER ON Weather FOR INSERT, UPDATE as
declare @CITY varchar(30), @STARTDATE DATETIME, @ENDDATE DATETIME, @TEMP NUMERIC, @ERROR varchar(300)

set @CITY = (select city from inserted)
set @STARTDATE = (select startdate from inserted)
set @ENDDATE = (select enddate from inserted)
set @TEMP = (select temp from inserted)

if (exists 
(select * from Weather where (startdate >=  @STARTDATE AND startdate <= @ENDDATE) OR (enddate >= @STARTDATE AND enddate <= @ENDDATE) 
except select * from INSERTED))
begin
	SET @ERROR = 'Не удалось выполнить INSERT ' + @CITY + ' ' + cast(@STARTDATE as varchar(20)) + ' ' + 
	cast(@ENDDATE as varchar(20)) + ' ' + cast(@TEMP as varchar(10)) + 'Данные уже существуют' 

	raiserror(@ERROR, 10, 1)
	rollback
end
return
go

select * from Weather order by enddate

delete from Weather

insert into Weather values
('Минск', '20210101 12:00', '20210101 23:59', 13)

insert into Weather values
('Минск', '20210101 00:00', '20210101 11:59', 7)

insert into Weather values
('Минск', '20210101 00:00', '20210101 02:00', 7)