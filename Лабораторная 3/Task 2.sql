--USE master;
--CREATE database VK_MyBASE;

USE VK_MyBASE;

--CREATE table GOODS
--(
--	Goods_name nvarchar(50) primary key,
--	Cost money unique not null,
--	Amount int
--);

--CREATE table CUSTOMERS
--(   
--	Firm_name nvarchar(20) primary key,
--	Customer_address nvarchar(50),
--	Checking_account nvarchar(20) 
--);

CREATE table ORDERS
 (   Order_number int primary key,
     Order_goodsName nvarchar(50) foreign key REFERENCES GOODS (Goods_name),
	 Order_cost real,
	 Order_amount int,
	 Order_date date,
	 Order_customer nvarchar(20) foreign key references CUSTOMERS (Firm_name)
);