--------------------------------- Task 1 ---------------------------------

use [UNIVER-4];
go
create procedure PSUBJECT
as
begin
	declare @k int = (select COUNT(*) from SUBJECT);
	select SUBJECT [Код], SUBJECT_NAME [Дисциплина], PULPIT [Кафедра] from SUBJECT;
	return @k;
end;

declare @y int = 0;
exec @y = PSUBJECT;
print('Количество строк = ') + cast(@y as varchar(3));

drop procedure PSUBJECT;

--------------------------------- Task 2 ---------------------------------

-- altered in "programming -> procedures"

USE [UNIVER-4]
GO
/****** Object:  StoredProcedure [dbo].[PSUBJECT]    Script Date: 06.05.2022 2:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[PSUBJECT] @p varchar(20) = NULL, @c int output
as
begin
	declare @k int = (select COUNT(*) from SUBJECT where PULPIT = @p);
	print 'Параметры: @p = ' + @p + ', @c = ' + cast(@c as varchar(3));
	select SUBJECT [Код], SUBJECT_NAME [Дисциплина], PULPIT [Кафедра] from SUBJECT where PULPIT = @p;
	set @c = @@rowcount;
	return @k;
end;

declare @y int = 0, @z varchar(20) = 'ИСИТ', @w int = 0
exec @y = PSUBJECT @p = @z, @c = @w output
print 'Всего строк: ' + cast(@y as nvarchar)
print 'Строк с факультетом ' + @z + ': '+ cast(@w as nvarchar)

--------------------------------- Task 3 ---------------------------------

create table #SUBJECT
(
	subj nvarchar(20),
	subj_name nvarchar(300),
	pulp nvarchar(20)
)

go
alter procedure PSUBJECT @p varchar(20) = null as
begin
	select SUBJECT [Код], SUBJECT_NAME [Дисциплина], PULPIT [Кафедра] from SUBJECT where PULPIT = @p;
end
go

go
insert #SUBJECT exec PSUBJECT @p = 'ИСИТ'
insert #SUBJECT exec PSUBJECT @p = 'ЛУ'
select * from #SUBJECT
go

drop table #SUBJECT;

--------------------------------- Task 4 ---------------------------------

go
create procedure PASUDITORIUM_INSERT @a char(20), @n varchar(50), @c int = 0, @t char(10)
								   --auditorium,  name,			  capacity,	  type
as
begin
	begin try
		insert into AUDITORIUM(AUDITORIUM,AUDITORIUM_NAME,AUDITORIUM_CAPACITY,AUDITORIUM_TYPE)
					values (@a,@n,@c,@t)
		return 1;
	end try
	begin catch
		print cast(error_number() as varchar(10));
		print cast(error_severity() as varchar(6));
		print error_message();
		return -1;
	end catch
end
go

set nocount on
declare @res int
begin tran
	exec @res = PASUDITORIUM_INSERT @a = '206-1', @t = 'ЛК', @c = 90, @n = '206-1'
	print ' ';
	if @res = 1
	print('Процедура: выполнена')
	else print('Процедура: не выполнена')
rollback
declare @res1 int
begin tran
	exec @res1 = PASUDITORIUM_INSERT @a = '222-1', @t = 'ЛБ-К', @c = 30, @n = '222-1'
	print ' ';
	if @res1 = 1
	print('Процедура: выполнена')
	else print('Процедура: не выполнена')
rollback

drop procedure PASUDITORIUM_INSERT;
--------------------------------- Task 5 ---------------------------------

go
create procedure SUBJECT_REPORT @p nvarchar(10) as 
begin
	declare @counter int = 0;
	begin try
		declare @sub nvarchar(10), @line_sub nvarchar(500) = ''
		declare Subjects cursor local static for
		select SUBJECT from SUBJECT where PULPIT = @p order by PULPIT
		if not exists (select PULPIT from SUBJECT where PULPIT = @p)
		begin
			raiserror('Ошибка, нет таких кафедр', 11, 1);
		end
		else
		begin
			open Subjects
			fetch Subjects into @sub
			set @line_sub = trim(@sub)
			set @counter +=1
			fetch Subjects into @sub
			while @@FETCH_STATUS = 0
			begin
				set @line_sub = '' + trim(@sub) + ', ' + @line_sub
				set @counter +=1
				fetch Subjects into @sub
			end
			print 'Предметы на кафедре ' + @p + ': ' + @line_sub
			return @counter
		end
	end try
	begin catch
		print 'Ошибка в параметрах' 
        if error_procedure() is not null   
			print 'Имя процедуры : ' + error_procedure()
        return @counter
	end catch
end
go

declare @c int
exec @c = Subject_Report @p = 'ИСиТ'
print 'Количество предметов на специальности: ' + cast(@c as nvarchar)

drop procedure SUBJECT_REPORT;

--------------------------------- Task 6 ---------------------------------

go
create procedure PAUDITORIUM_INSERT_TYPE @a_ char(20), @n_ varchar(50), @c_ int = 0, @t_ char(10), @tn_ varchar(50)
as
begin
	declare @err nvarchar(50) = 'Ошибка: '
	declare @rez int
		set transaction isolation level serializable
			begin tran
				begin try
					insert into AUDITORIUM_TYPE values (@t_, @tn_)
						exec @rez = PASUDITORIUM_INSERT @a = @a_, @n = @n_, @c = @c_, @t = @t_
						if (@rez = -1)
							begin
								return -1
							end
				end try
				begin catch
					set @err = @err + error_message()
					raiserror(@err, 11, 1)
					rollback
					return -1
				end catch
			commit tran
		return 1
end
go

declare @rez int
begin tran
exec @rez = PAUDITORIUM_INSERT_TYPE @a_ = '208-1', @n_ = '208-1', @c_ = 90, @t_ = '208-1', @tn_ = 'Для 12 лабы' 
print @rez
if @rez = 1
	select * from AUDITORIUM
	select * from AUDITORIUM_TYPE
rollback
go

drop procedure PAUDITORIUM_INSERT_TYPE;

--------------------------------- Task 7 ---------------------------------



--------------------------------- Task 8 ---------------------------------

go
create procedure PFACULTY_REPORT @f char(10) = null, @p char(10) = null
as
begin
	declare @faculty nvarchar(10), @pulpitcount int, @i int = 0
	declare @pulpitName nvarchar(50), @teacherCount int, @j int = 0
	declare @subjectName nvarchar(15), @subjectline nvarchar(150) = '', @subjectPulpit nvarchar(50)

	declare facultyCount cursor local dynamic
	for
	select FACULTY.FACULTY, count(*) from FACULTY
		   inner join PULPIT on FACULTY.FACULTY = PULPIT.FACULTY
	group by FACULTY.FACULTY order by FACULTY.FACULTY asc

	declare pulpits cursor local dynamic
	for
	select PULPIT.PULPIT, count(*) from PULPIT
		   left outer join TEACHER on PULPIT.PULPIT = TEACHER.PULPIT
		   group by FACULTY, PULPIT.PULPIT
		   order by FACULTY asc

	declare @rezcount int = 0

	open facultyCount
	open pulpits

		if (@f is null AND @p is null)
		begin
			fetch from facultyCount into @faculty, @pulpitcount
			print 'Факультет: ' + @faculty

			while @@FETCH_STATUS = 0
			begin
				set @i = 0
					while @i < @pulpitcount
						begin
							set @subjectline = ''
							fetch from pulpits into @pulpitName,@teacherCount
							print char(9) + 'Кафедра: ' + @pulpitName
							print char(9) + char(9) + 'Количество преподавателей: ' + cast(@teacherCount as nvarchar(10))
							exec PSubject @p = @pulpitName
							set @i = @i + 1
						end

				fetch from facultyCount into @faculty, @pulpitcount
				if (@@FETCH_STATUS = 0)
					print 'Факультет: ' + @faculty
					set @rezcount = @rezcount + 1
			end

		return @rezcount
		end

		if(@p is not null)
		begin
			if (@p not in (select PULPIT from PULPIT))
			begin
				raiserror('Кафедра не найдена', 11, 1)
				return -1
			end
			fetch from facultyCount into @faculty, @pulpitcount
			if (@p in (select PULPIT from FACULTY
							  inner join PULPIT on PULPIT.FACULTY = FACULTY.FACULTY
							  where FACULTY.FACULTY = @faculty))
			begin
				begin
					set @i = 0
		
						while @i < @pulpitcount
							begin
								set @subjectline = ''
								fetch from pulpits into @pulpitName,@teacherCount
								if (@pulpitName = @p)
									begin
										print char(9) + 'Кафедра: ' + @pulpitName
										print char(9) + char(9) + 'Количество преподавателей: ' + cast(@teacherCount as nvarchar(10))
										exec @rezcount = PSubject @p = @pulpitName
										return @rezcount
									end
							end


					fetch from facultyCount into @faculty, @pulpitcount
					if (@@FETCH_STATUS = 0)
						print 'Факультет: ' + @faculty
						return @pulpitCount
			
				end
			end
		while (@@FETCH_STATUS = 0)
		begin
			fetch from facultyCount into @faculty, @pulpitcount
			if (@p in (select PULPIT from FACULTY
							  inner join PULPIT on PULPIT.FACULTY = FACULTY.FACULTY
							  where FACULTY.FACULTY = @faculty))
			begin
				begin
				set @i = 0
		
				while @i < @pulpitcount
					begin
						set @subjectline = ''
						fetch from pulpits into @pulpitName,@teacherCount
						if (@pulpitName = @p)
						begin
							print char(9) + 'Кафедра: ' + @pulpitName
							print char(9) + char(9) + 'Количество преподавателей: ' + cast(@teacherCount as nvarchar(10))
							exec @rezcount = PSubject @p = @pulpitName
							return @rezcount
						end
					end 


			fetch from facultyCount into @faculty, @pulpitcount
			if (@@FETCH_STATUS = 0) print 'Факультет: ' + @faculty
			return @pulpitCount
			
				end
			end
		end		
	end
	
	close facultyCount
	close pulpits

end
go

declare @rez int
exec @rez = PFACULTY_REPORT 
print 'Код процедуры: ' + cast (@rez as nvarchar(10)) 
go

declare @rez int
exec @rez = PFACULTY_REPORT @p = 'ИСиТ'
print 'Код процедуры: ' + cast (@rez as nvarchar(10)) 
go

declare @rez int
exec @rez = PFACULTY_REPORT @p = 'qwerty'
print 'Код процедуры: ' + cast (@rez as nvarchar(10)) 
go


------------------------------------------------------

drop function Diciplines;

use [UNIVER-4]

go
create function Diciplines(@f varchar(20)) returns char (300)
as
begin
declare @res char(20);
declare @r char(300) = 'Предметы: ';
declare Dicipl cursor local
for select * from TIMETABLE
	where TIMETABLE.TEACHER = @f;
	open Dicipl;
	fetch Dicipl into @res;
	while @@FETCH_STATUS  = 0
	begin
	set @r = @r +', ' + rtrim(@res);
	fetch Dicipl into @res;
end;
return @r;
end;
go


declare @y int = 0, @z varchar(20) = 'ЖЛК'
exec @y = Diciplines @f = @z
print cast(@r as nvarchar)

--------------------------------------

use [UNIVER-4];
go
create procedure prepod @g varchar(20)
as
begin
	declare @k int = (select COUNT(*) from SUBJECT);
	select SUBJECT [Код], TEACHER [Препод] from TIMETABLE where TEACHER = @g;
	return @k;
end;

declare @y int = 0, @t = 'ЖЛК';
exec @y = PSUBJECT, @g = @t;
print cast(@y as varchar(300));

drop procedure PSUBJECT;

-----------------------------------------------------
drop procedure prepod2;

go
   create procedure prepod2  @p CHAR(50)
   as  
   declare @rc int = 0;          
      declare @tv char(20), @t char(300) = ' ';  
      declare Prep CURSOR  for 
      select SUBJECT [Код] from TIMETABLE where TEACHER = @p;
      open Prep;	  
  fetch  Prep into @tv;   
  print   'Предметы';   
  while @@fetch_status = 0                                     
   begin 
       set @t = rtrim(@tv) + ', ' + @t;  
       set @rc = @rc + 1;       
       fetch  Prep into @tv; 
    end;   
print @t;        
close  Prep;
    return @rc;
go

declare @rc int;  
exec @rc = prepod2 @p  = 'ЖЛК';  
print 'Предметы: ' + cast(@rc as varchar(3)); 


