--------------- Task 1 ---------------
declare @a char = '�',
		@b varchar(3) = '���',
		@c datetime,
		@d time,
		@e int,
		@f smallint,
		@g tinyint,
		@h numeric(12,5);

set @c = getdate();
set @d = (select convert(varchar(12), getdate(), 114) 'hh:mi:ss:mmm');

select @e = 21122001, @f = 21, @G = 1;

select @a ������, @b ������, @c ����;

print '����� = ' + cast(@d as varchar);
print 'Int = ' + convert(varchar, @e);
print 'Smallint = ' + convert(varchar, @f);
print 'Tinyint = ' + convert(varchar, @g);
print 'Numeric = ' + convert(varchar, @h);

--------------- Task 2 ---------------
use [UNIVER-4];

declare @capacity int = (select cast(sum(AUDITORIUM_CAPACITY) as int) from AUDITORIUM),
		@total int,
		@avgCapacity int,
		@totalLessThanAvg int,
		@procent numeric(4,2);

if @capacity > 200
begin
	set @total = (select cast(count(*) as int) from AUDITORIUM);
	set @avgCapacity = (select avg(AUDITORIUM_CAPACITY) from AUDITORIUM);
	set @totalLessThanAvg = (select cast(count(*) as int) from AUDITORIUM where AUDITORIUM_CAPACITY < @avgCapacity);
	set @procent = @totalLessThanAvg * 100 / @total;
	select  @capacity '����� �����������',
			@total '����� ���������',
			@avgCapacity '������� �����������',
			@totalLessThanAvg '��������� � ������������ ���� ��������',
			@procent '������� ����� ���������'
end

else print '����� ����������� < 200'
--------------- Task 3 ---------------
 
print '����� ������������ �����: ' + cast(@@ROWCOUNT as varchar)
print '������ SQL Server: ' + cast(@@VERSION as varchar)
print '��������� ������������� ��������: ' + cast(@@SPID as varchar)
print '��� ��������� ������: ' + cast(@@ERROR as varchar)
print '��� �������: ' + cast(@@SERVERNAME as varchar)
print '������� ����������� ����������: ' + cast(@@TRANCOUNT as varchar)
print '�������� ���������� ���������� ����� ��������������� ������: ' + cast(@@FETCH_STATUS as varchar)
print '������� ����������� ������� ���������: ' + cast(@@NESTLEVEL as varchar)

--------------- Task 4.1 ---------------

declare @z float, @t float = 21, @x float = 5

	if @t > @x
		set @z = power(sin(@t), 2) 

	else if @t < @x
		set @z = 4*(@t + @x)

	else
		set @z = 1 - exp(@x-2)

	select @z

--------------- Task 4.2 ---------------

declare @lastName nvarchar(20) = '��������',
		@firstName nvarchar(20) = '��������',
		@surname nvarchar(20) = '���������',
		@longName nvarchar(60),
		@shortName nvarchar(60);

set @longName = @lastName + ' ' + @firstName + ' ' + @surname;

set @firstName = substring(@firstName, 1,1)+'.';
set @surname = substring(@surname, 1,1)+'.';
set @shortName = @lastName + ' ' + @firstName + ' ' + @surname;

select @longName [������ ���];
select @shortName [����������� ���];

--------------- Task 4.3 ---------------

use [UNIVER-4];

-- DATEDIFF(datepart, startdate, enddate)

select STUDENT.NAME, STUDENT.BDAY, (datediff(YY, STUDENT.BDAY, sysdatetime())) as �������
from STUDENT
where month(STUDENT.BDAY) = month(sysdatetime()) + 1;

--------------- Task 4.4 ---------------

declare @groupNumber int = 3;

select distinct PROGRESS.PDATE[���� ����������� ��������], case 
		when DATEPART(dw,PROGRESS.PDATE) = 1 then '�����������'
		when DATEPART(dw,PROGRESS.PDATE) = 2 then '�������'
		when DATEPART(dw,PROGRESS.PDATE) = 3 then '�����'
		when DATEPART(dw,PROGRESS.PDATE) = 4 then '�������'
		when DATEPART(dw,PROGRESS.PDATE) = 5 then '�������'
		when DATEPART(dw,PROGRESS.PDATE) = 6 then '�������'
		when DATEPART(dw,PROGRESS.PDATE) = 7 then '�����������'
end [���� ������]
from GROUPS inner join STUDENT on STUDENT.IDGROUP = GROUPS.IDGROUP
			inner join PROGRESS on STUDENT.IDSTUDENT= PROGRESS.IDSTUDENT
	where GROUPS.IDGROUP = @groupNumber

--------------- Task 5 ---------------

declare @amount int = (select count(*) from AUDITORIUM)
if @amount >= 10
begin
	print '��������� ������ 10'
end
else
begin
	print '��������� ������ 10'
end

--------------- Task 6 ---------------

-- WAITFOR DELAY '00:00:02';

select (case
	when NOTE between 0 and 3 then '�� ����'
	when NOTE between 4 and 5 then '�����'
	when NOTE between 6 and 7 then '���������'
	when NOTE between 8 and 10 then '������'
end) ������, count(*) [����������] from PROGRESS
group by (case
	when NOTE between 0 and 3 then '�� ����'
	when NOTE between 4 and 5 then '�����'
	when NOTE between 6 and 7 then '���������'
	when NOTE between 8 and 10 then '������'
end)
--------------- Task 7 ---------------

--�������� SET NOCOUNT ON �� ��������� ����� ���������� �����,
--��� ����� ��������� ������������������ �� ���� ���������� ������ �������,
--�������� ���� � ��� � ��������� ���� ����� ��� ��������� �������� ��������� ��������� �����,
--�� �� ���������� �������� ���������� �����.

create table #MyTable(����� int, ����� nvarchar(50), [��� �����] nvarchar(50));
set nocount on;
declare @i int = 1;
while @i <11
	begin
		insert into #MyTable values
		(cast(@i as int), cast(@i as nvarchar(10)) + '����','��' + cast(@i as nvarchar(10)))
		set @i +=1;
	end
select * from #MyTable
order by ����� desc
go

drop table #MyTable;

--------------- Task 8 ---------------

declare @i int = 20;
print @i+1;
print power(@i,3);
return
print @i+10;

--------------- Task 9 ---------------

begin try
	update PROGRESS set NOTE = '������ ������ int!!!' where NOTE = 9
end try
begin catch
	print ERROR_NUMBER() -- ��� ��������� ������
	print ERROR_MESSAGE() -- ��������� �� ������
	print ERROR_LINE() -- ��� ��������� ������
	print ERROR_PROCEDURE() -- ��� ��������� ��� NULL
	print ERROR_SEVERITY() -- ������� ����������� ������
	print ERROR_STATE() --
end catch