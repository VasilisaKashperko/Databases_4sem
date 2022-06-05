---------------------------- Task 1.1 ----------------------------

set nocount on
if exists (select * from sys.objects where OBJECT_ID = object_id(N'dbo.Tabl')) -- таблица Tabl есть?
	begin
		drop table Tabl
		print 'Таблица удалена'
	end

declare @Kolich int, @flag int = 100 -- commit или rollback?

set implicit_transactions on
create table Tabl(Chislo int); -- начало транзакции 
insert Tabl values (1),(2),(3),(4)
set @Kolich = (select count(*) from Tabl)
print 'Количество строк в таблице: ' + cast(@Kolich as nvarchar(10))
if @flag = 1000 commit
else rollback
set implicit_transactions off

if exists (select * from sys.objects where OBJECT_ID = object_id(N'dbo.Tabl'))
print 'Таблица создалась'
else print 'Таблица не создалась'

drop table Tabl

---------------------------- Task 2 ----------------------------

begin try 
	begin tran
		insert into AUDITORIUM_TYPE(AUDITORIUM_TYPE,AUDITORIUM_TYPENAME) values
		('ЛК-К      ','test')
		delete from AUDITORIUM_TYPE where AUDITORIUM_TYPE = 'ЛК-К      '
	commit tran
end try
begin catch 
	print 'Error: ' + cast(error_number()as nvarchar(20))
	print error_message()
	if @@TRANCOUNT>0 rollback tran -- если больше 0, то не завершена
end catch
go

---------------------------- Task 3 ----------------------------

declare @controlPoint nvarchar(10)

begin try
	begin tran
		create table #Local (Numbers int primary key)
		insert into #Local values (1),(2),(3),(4),(5),(6),(7),(8),(9)
		set @controlPoint = 'Point1'
		save tran @controlPoint

		insert into #Local values (1),(11),(12) -- 1 вместо 10
		select Numbers[Числа] from #Local
		rollback tran @controlPoint
		select Numbers[Числа] from #Local

		drop table #Local
		save tran @controlPoint
	commit tran
end try

begin catch
	print 'Ошибка ' + error_message()
	print 'Точка сохранения ' + @controlPoint
	rollback tran @controlPoint
	select * from #Local
	drop table #Local 
end catch
go

---------------------------- Task 8 ----------------------------

drop table #Task8

begin tran 
	create table #Task8 (Num int identity, Words nvarchar(20))
	insert #Task8 values ('Кашперко'), ('Василиса'), ('Сергеевна')

	begin tran 
		insert #Task8 values ('Это я')
	commit tran 

 if exists (select Words from #Task8 where Words = 'Это я')
 commit tran 
 else rollback tran 
 select Num[Id], Words[Строки] from #Task8


drop table #Task8_1
begin tran 
	create table #Task8_1(Num int identity, Words nvarchar(20))
	insert #Task8_1 values ('qwerty'), ('asdfg'), ('zxcvb')
	begin tran 
		insert #Task8_1 values ('zxcvbn')
	rollback tran 
 if exists (select Words from #Task8_1 where Words = 'zxcvbn')
 commit tran 
 else rollback tran 
 select Num[Id], Words[Строки] from #Task8_1