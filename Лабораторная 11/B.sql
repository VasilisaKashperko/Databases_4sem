---------------------------- Task 4 B ----------------------------

--set transaction isolation level read committed -- ���� �� ���������
begin tran
update Transactions set Info = '������ 6' where Counter = 4
insert Transactions values ('C����� 5')
--t1
rollback tran
--t2

---------------------------- Task 5 B ----------------------------

set transaction isolation level read committed
begin tran
update Transactions set Info = '������ 6' where Counter = 4
insert Transactions values ('C����� 5')
--t1
commit tran
--t2

---------------------------- Task 6 B ----------------------------

set transaction isolation level read committed
begin tran
--update Transactions set Info = '������ 6' where Counter = 4 -- �� ���������, ����� ����� ���������� ������ ����������
insert Transactions values ('������ 5')-- �����
--t1
commit tran
--t2

---------------------------- Task 7 B ----------------------------

set transaction isolation level read committed
begin tran
insert Transactions values ('������ 5')
--t1
rollback tran
--t2