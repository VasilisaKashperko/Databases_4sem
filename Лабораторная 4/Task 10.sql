USE VK_MyBASE;

SELECT GOODS.Goods_name, ORDERS.Order_cost, CUSTOMERS.Firm_name

FROM GOODS Inner Join ORDERS on GOODS.Goods_name = ORDERS.Order_goodsName 
	 Inner Join CUSTOMERS on CUSTOMERS.Firm_name = ORDERS.Order_customer

-----------------------------------------------------------------------------------

SELECT isnull (ORDERS.Order_goodsName, 'Нет товара') [Наименование товара в заказе],
	   isnull (ORDERS.Order_cost, '0') [Цена заказа],
	   CUSTOMERS.Firm_name [Заказчик]

FROM GOODS Full Outer Join ORDERS on GOODS.Goods_name = ORDERS.Order_goodsName
		   Full Join CUSTOMERS on CUSTOMERS.Firm_name = ORDERS.Order_customer