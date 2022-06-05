---------------------- Task 1 ----------------------

USE [UNIVER-4];

exec sp_helpindex 'AUDITORIUM_TYPE' -- перечень индексов

create table #task1 (first int, second varchar(100))
set nocount on -- не выводить сообщения о вводе строк
declare @i int = 0
while @i < 1000
begin
	insert #task1(first, second) values (floor(20000*rand()), replicate('строка', 10))
	if (@i % 100 = 0) print @i;
	set @i = @i + 1
end

select * from #task1 where first between 1500 and 2500 order by first -- 0.0230752

checkpoint;  -- фиксация БД
dbcc dropcleanbuffers

create clustered index #task1_cl on #task1(first asc)

select * from #task1 where first between 1500 and 2500 order by first -- 0.0033414

drop index #task1_cl on #task1

---------------------- Task 2 ----------------------

create table #test2
(
	Info nvarchar (20),
	Iterator int identity(1,1),
	Time datetime
)

declare @x int =1;
while @x <= 11000
	begin
		insert into #test2 values
		('Строка' + cast(@x as nvarchar), SYSDATETIME())
		set @x +=1;
end

select * from #test2 where Info = 'Строка21' and Time <= SYSDATETIME() -- 0.0627894

checkpoint;
dbcc dropcleanbuffers

create index #test2_nonCl on #test2(Info, Time)

select * from #test2 where Info = 'Строка21' and Time <= SYSDATETIME() -- 0.0065704

drop index #test2_nonCl on #test2

---------------------- Task 3 ----------------------

create table #task3Pok
(
	Info nvarchar (20),
	Iterator int identity(1,1),
	Time datetime
)
declare @h int =1;
while @h <= 11000
	begin
		insert into #task3Pok values
		('Строка' + cast(@h as nvarchar), SYSDATETIME())
		set @h +=1;
end

select Info from #task3Pok where Iterator >=10000 -- 0.0627894

checkpoint;
dbcc dropcleanbuffers

create index #NonClustPok on #task3Pok(Iterator) include (Info)

select Info from #task3Pok where Iterator >=10000 -- 0.0080868

drop index #NonClustPok on #task3Pok

drop table #task3Pok

---------------------- Task 4 ----------------------

create table #task4Filter
(
	Info nvarchar (20),
	Iterator int identity(1,1),
	Time datetime
)
declare @z int =1;
while @z <= 11000
	begin
		insert into #task4Filter values
		('Строка' + cast(@z as nvarchar), SYSDATETIME())
		set @z +=1;
end

create index #Index on #task4Filter(Iterator) where (Iterator > 15000 and Iterator < 20000)
checkpoint;
dbcc dropcleanbuffers
select Iterator from #task4Filter where Iterator between 10000 and  20000 -- 0.0627894 -- 0.0627894
select Iterator from #task4Filter where Iterator > 15000 and Iterator < 20000 -- 0.0627894 -- 0.0032831

---------------------- Task 5 ----------------------

create table #task5 (tkey int, cc int identity(1,1), tf varchar(100))
set nocount on
declare @k int = 0
while @k < 10000
begin
	insert #task5(tkey, tf) values (floor(30000*rand()), replicate('Задание ', 10))
	set @k = @k + 1
end

checkpoint;
dbcc dropcleanbuffers

create index #task5_tkey on #task5(tkey)

-- поставить tempdb !!!

select name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)] -- степень фрагментации индекса
        FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'),
        OBJECT_ID(N'#task5'), NULL, NULL, NULL) ss
        JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id where name is not null; -- 0 -- 88

insert top(10000000) #task5(tkey, tf) select tkey, tf from #task5

drop index #task5_tkey on #task5

drop table #task5

alter index #task5_tkey on #task5 reorganize --реорганизация - только на самом нижнем уровне

alter index #task5_tkey on #task5 rebuild with (online = off) -- через все дерево

---------------------- Task 6 ----------------------

-- PAD_INDEX ON означает «Применить FILLFACTOR ко всем слоям»

drop index #task5_tkey on #task5 
create index #task5_tkey on #task5(tkey) with fillfactor = 65 -- процент заполнения индексных страниц нижнего уровня

insert top(50)percent #task5(tkey, tf) select tkey, tf from #task5

select name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
        FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'),
        OBJECT_ID(N'#task5'), NULL, NULL, NULL) ss
        JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id where name is not null;

---------------------- Task 7 ----------------------

USE VK_MyBASE

exec sp_helpindex CUSTOMERS
exec sp_helpindex GOODS
exec sp_helpindex  ORDERS

checkpoint;
dbcc dropcleanbuffers

create index task7 on CUSTOMERS(Firm_name)

drop index task7 on CUSTOMERS 

select * from CUSTOMERS where Firm_name like 'Samsung' --0.0032842 --0.0032831

