-------------------------- Task 1.1 --------------------------
drop function Count_Students

go
create function Count_Students (@faculty nvarchar(20)) returns int
as
begin
	declare @kolich int;
	set @kolich = (select count(*) from FACULTY
						  join GROUPS on FACULTY.FACULTY = GROUPS.FACULTY 
						  join STUDENT on GROUPS.IDGROUP = STUDENT.IDGROUP
						  where  FACULTY.FACULTY = @faculty)
	return @kolich
end
go

print 'Количество студентов на факультете ИТ: ' + cast(dbo.Count_Students('ИТ') as nvarchar(20))
select FACULTY, dbo.Count_Students(FACULTY) from FACULTY

-------------------------- Task 1.2 --------------------------

go
alter function COUNT_STUDENTS (@faculty nvarchar(20)= null, @prof nvarchar(200) = null) returns int
as
begin
	declare @counter int = 0
	set @counter =
	(select count(STUDENT.IDSTUDENT) from FACULTY
			join GROUPS on FACULTY.FACULTY = GROUPS.FACULTY
			join STUDENT on GROUPS.IDGROUP = STUDENT.IDGROUP
			join PROFESSION on FACULTY.FACULTY = PROFESSION.FACULTY
	where FACULTY.FACULTY = @faculty and PROFESSION.PROFESSION_NAME = @prof)
	return @counter
end
go

select FACULTY.FACULTY, PROFESSION.PROFESSION_NAME,
	   dbo.COUNT_STUDENTS(FACULTY.FACULTY, PROFESSION.PROFESSION_NAME)
	   from FACULTY
	   join PROFESSION on FACULTY.FACULTY = PROFESSION.FACULTY

print 'Количество студентов: ' + 
cast(dbo.Count_students('ХТиТ', 'Конструирование и производство изделий из композиционных материалов') as nvarchar(20))

-------------------------- Task 2 --------------------------

drop function fsubjects;

go
create function fsubjects (@p nvarchar(20)) returns nvarchar(300) as
begin
	declare @word nvarchar(10), @string nvarchar(200) = ' ';

	declare fsubj cursor local static
	for select SUBJECT from SUBJECT where PULPIT = @p

	open fsubj
	fetch fsubj into @word
	set @string  = @string + rtrim(@word)
	fetch fsubj into @word
	while @@FETCH_STATUS = 0
		begin
			fetch fsubj into @word
			set @string  =@string  + ', ' + rtrim(@word)
		end
	close fsubj
	return @string
end
go

select PULPIT, dbo.fsubjects(PULPIT) [Дисциплины] from SUBJECT group by PULPIT

-------------------------- Task 3 --------------------------

drop function ffacpul

go 
create function ffacpul (@ff nvarchar(20), @pp nvarchar(20)) returns table 
as return
select FACULTY.FACULTY, PULPIT.PULPIT from FACULTY
	   left join PULPIT on FACULTY.FACULTY = PULPIT.FACULTY
where FACULTY.FACULTY = isnull(@ff,FACULTY.FACULTY)
	  and PULPIT.PULPIT = isnull(@pp,PULPIT.PULPIT)
go

select * from dbo.ffacpul (null,null)
select * from dbo.ffacpul ('ЛХФ',null)
select * from dbo.ffacpul (null,'ЛВ')
select * from dbo.ffacpul ('ЛХФ','ЛВ')

-------------------------- Task 4 --------------------------

drop function fcteacher

go
create function fcteacher (@p nvarchar(20)) returns int as 
begin 
	declare @counter int = (select count(*) from TEACHER
							where PULPIT = isnull(@p,PULPIT))
	return @counter
end
go

select PULPIT, dbo.fcteacher(PULPIT)[Общее количество преподавателей] from TEACHER group by PULPIT
select dbo.fcteacher(null) [Общее количество преподавателей]

-------------------------- Task 6 --------------------------
USE [UNIVER-4]

drop function FacultyReport

go
create function StudentCount(@faculty varchar(50)) returns int
as
begin
	 declare @studentCount int  = 0
	 set @studentCount = 
		(select count(*) from STUDENT
				inner join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP
				inner join FACULTY on GROUPS.FACULTY = FACULTY.FACULTY
		where FACULTY.FACULTY = @faculty)
	return @studentCount
end
go

go
create function PulpitCount(@faculty varchar(50)) returns int
as
begin
	 declare @pulpitCount int = 0
	 set @pulpitCount = 
		(select count(*) from PULPIT
		 where PULPIT.FACULTY = @faculty)
	return @pulpitCount
end
go

create function ProfessionCount(@faculty varchar(50)) returns int
as
begin
	 declare @professionCount int = 0
	 set @professionCount = 
		(select count(*) from PROFESSION
		where PROFESSION.FACULTY = @faculty)
	return @professionCount
end
go

go
create function GroupCount(@faculty varchar(50)) returns int
as
begin
	declare @groupCount int = 0
	set @groupCount =
		(select count(*) from GROUPS
		where GROUPS.FACULTY = @faculty)
	return @groupCount
end
go

go
create function FacultyReport(@c int)
returns @result table
		(
		[Факультет] varchar(50),
		[Количество кафедр] int,
		[Количество групп] int,
		[Количество специальностей] int,
		[Количество студентов] int
		)

as
begin

	declare @faculty varchar(50)
	declare FacultyCursor cursor local for
		select FACULTY from FACULTY
		where dbo.StudentCount(FACULTY) > @c

	open FacultyCursor
		fetch FacultyCursor into @faculty
		while @@FETCH_STATUS = 0
		begin
			insert into @result values
			(@faculty, dbo.PulpitCount(@faculty), dbo.GroupCount(@faculty), dbo.ProfessionCount(@faculty), dbo.StudentCount(@faculty))
			fetch FacultyCursor into @faculty
		end

	close FacultyCursor
	return
end
go	

select * from dbo.FacultyReport(0)

-------------------------- Task 7 --------------------------

drop procedure PFACULTY_REPORTX

go
create procedure PFACULTY_REPORTX @faculty char(10) = null, @pulpit char(10) = null
as
begin

	declare @currFaculty varchar(30), @currPulpit varchar(30), @subjectString varchar(300)

	declare facultyCursor cursor local
	for
	select faculty from FACULTY

	declare pulpitCursor cursor local for 
		select pulpit from PULPIT

	declare @result int = 0

	open facultyCursor
	
	-- два значения null

	if(@faculty is null)
	begin
		if (@pulpit is null)
		begin
			
			fetch facultyCursor into @currFaculty
			while @@FETCH_STATUS = 0
			begin
				print 'Факультет: ' + @currFaculty
				open pulpitCursor 
				fetch pulpitCursor into @currPulpit
				while @@FETCH_STATUS = 0
				begin
					if (exists (select * from PULPIT where FACULTY = @currFaculty AND PULPIT = @currPulpit)) 
					begin
						print char(9) + 'Кафедра ' + @currPulpit
						print char(9) +  char(9) + 'Количество учителей: ' +cast(dbo.fcteacher(@currPulpit) as varchar(5))
						print char(9) +  char(9) + cast(dbo.fsubjects(@currPulpit) as varchar(300))
					end
					
					fetch pulpitCursor into @currPulpit
				end
				close pulpitCursor
				fetch facultyCursor into @currFaculty
			end
			set @result = dbo.PulpitCount(@faculty)
		end
		else

		-- faculty null

		begin
			
			fetch facultyCursor into @currFaculty
			open pulpitCursor
			while @@FETCH_STATUS = 0
			begin		
				fetch pulpitCursor into @currPulpit
				while @@FETCH_STATUS = 0
				begin
					if(@currPulpit = @pulpit)
					begin
						print 'Факультет: ' + @currFaculty
						print char(9) + 'Кафедра ' + @currPulpit
						print char(9) +  char(9) + 'Количество учителей: ' +cast(dbo.fcteacher(@currPulpit) as varchar(5))
						print char(9) +  char(9) + cast(dbo.fsubjects(@currPulpit) as varchar(300))
						
					end
					fetch pulpitCursor into @currPulpit
				end
				set @result = @result + dbo.PulpitCount(@faculty)
				fetch facultyCursor into @currFaculty
			end
			close pulpitCursor
		end
	end
	else 

	-- pulpit null

	begin
		if (@pulpit is null)
		begin
			
			fetch facultyCursor into @currFaculty
			open pulpitCursor
			while @@FETCH_STATUS = 0
			begin
				if(@currFaculty = @faculty)
				begin
					print 'Факультет: ' + @currFaculty
					fetch pulpitCursor into @currPulpit
					while @@FETCH_STATUS = 0
					begin
						if (exists (select * from PULPIT where FACULTY = @currFaculty AND PULPIT = @currPulpit)) 
						begin
							print char(9) + 'Кафедра ' + @currPulpit
							print char(9) +  char(9) + 'Количество учителей: ' +cast(dbo.fcteacher(@currPulpit) as varchar(5))
							print char(9) +  char(9) + cast(dbo.fsubjects(@currPulpit) as varchar(300))
						end
						fetch pulpitCursor into @currPulpit
					end
				end
				fetch facultyCursor into @currFaculty

			end
			set @result = dbo.PulpitCount(@faculty)
			close pulpitCursor
		end
		else
		begin
			-- оба не null
			fetch facultyCursor into @currFaculty
			open pulpitCursor
			while @@FETCH_STATUS = 0
			begin		
					fetch pulpitCursor into @currPulpit
					while @@FETCH_STATUS = 0
					begin
						if(@currPulpit = @pulpit)
						begin
							print 'Факультет: ' + @currFaculty
							print char(9) + 'Кафедра ' + @currPulpit
							print char(9) +  char(9) + 'Количество учителей: ' +cast(dbo.fcteacher(@currPulpit) as varchar(5))
							print char(9) +  char(9) + cast(dbo.fsubjects(@currPulpit) as varchar(300))
							
						end
						fetch pulpitCursor into @currPulpit
					end
					fetch facultyCursor into @currFaculty
			end
			set @result = dbo.PulpitCount(@faculty)
			close pulpitCursor

		end
	end

	close facultyCursor
	return @result
end
go

declare @rez int
exec @rez = PFACULTY_REPORTX 
print 'Код процедуры: ' + cast (@rez as nvarchar(10)) 
go

declare @rez int
exec @rez = PFACULTY_REPORTX @faculty = 'ХТиТ'
print ('');
print 'Код процедуры: ' + cast (@rez as nvarchar(10)) 
go

declare @rez int
exec @rez = PFACULTY_REPORTX @pulpit = 'ИСиТ'
print ('');
print 'Код процедуры: ' + cast (@rez as nvarchar(10)) 
go

-----
go
create function marks (@ff nvarchar(20)) returns table
as return
	select * from PROGRESS
	where PROGRESS.SUBJECT = @ff
go

select * from marks('СУБД');

----
drop function diciplines;

go
create function diciplines (@ff nvarchar(20)) returns table
as return
	select * from TIMETABLE
	where TIMETABLE.TEACHER = @ff
go

select * from diciplines('ЖЛК');