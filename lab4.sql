/* Оператор вставки INSERT */
-------------------------------------------------------------------------
use [lab4.1]
SELECT * FROM [client]

--a. Без указания списка полей
INSERT INTO [client]
-- Указание порядка записи данных отсутствует, значит используем порядок по умолчанию.
VALUES
    (456, 'Ludmila Pusyieva', '451146', '55'); -- Вводимые данные.

--b. С указанием списка полей
INSERT INTO [client]             
    (full_name, id_client, telephone, age) -- Указание порядка записи данных.
VALUES
    ('Alexander Lupkin', 3313, '6284241', '10'); -- Вводимые данные.

--c. С чтением из другой таблицы
INSERT INTO client(full_name) SELECT name FROM institution;

/* Оператор удаления DELETE*/
-- всех записей
DELETE [client];
SELECT * FROM [client];

-- с условием
DELETE FROM client
WHERE
    full_name LIKE 'Sobakina%';


/*UPDATE*/
--всех записей
UPDATE [inventory_item]
SET name = 'lopata';

SELECT * FROM [inventory_item];


INSERT INTO [institution]      
    (name, address, id_institution) 
VALUES
    ('Shcool #2787', 'ul.Sobakina, 45', 19); -- Вводимые данные.
    

-- обновление с условием
UPDATE [institution]
SET address = 'ul.Koshkina, 100' -- изменить имя того,
WHERE address = 'ul.Sobakina, 45'	-- чья Фамилия 'Pushkin'

-- по условию обновляя несколько атрибутов
UPDATE [institution]
SET address = 'ul.Beer, 19',
	name = 'shoop "On an uncle"'
WHERE id_institution = 19;

/*SELECT*/
-- с набором излвекаемых атрибутов
SELECT price_for_day FROM [inventory]; 

-- Со всеми атрибутами
SELECT * FROM [inventory];

-- С условием по атрибуту
SELECT * FROM inventory
WHERE id_inventory = 182;

/*SELECT ORDER BY + TOP (LIMIT)*/
-- С сортировкой по возрастанию ASC + ограничение вывода количества записей
SELECT TOP 1 *
FROM [client]
ORDER BY id_client ASC;

-- С сортировкой по убыванию DESC
SELECT *
FROM [institution]
ORDER BY name DESC;

-- С сортировкой по двум атрибутам + ограничение вывода количества записей
SELECT *
FROM [inventory_item]
ORDER BY name, quality;

-- С сортировкой по первому атрибуту, из списка извлекаемых
SELECT *
FROM [inventory]
ORDER BY 1;

/*Работа с датами*/
-- a. WHERE по дате
SELECT * FROM inventory_item
WHERE date_of_purchase = 1915 

INSERT INTO [inventory_item]
VALUES (30, 'GRABLYA', '2009-19-07', 'HIGHT')

-- b. WHERE дата в диапазоне
SELECT * FROM inventory_item 
WHERE date_of_purchase BETWEEN '2009-01-01' AND '2010-01-01'; 

-- c. Извлечь из таблицы не всю дату, а только год
SELECT YEAR('2010-04-30T01:01:01.1234567-07:00') FROM inventory_item;

/* Функции агрегации*/
-- Посчитать количество записей в таблице
SELECT COUNT(*) FROM client

-- Посчитать количество уникальных записей в таблице
SELECT COUNT(DISTINCT cost)  
FROM inventory_rental;  

-- Вывести уникальные значения столбца
SELECT COUNT(DISTINCT 1)  
FROM inventory_rental;  

-- Найти максимальное значение столбца
SELECT MAX(price_for_day) as max FROM inventory

-- Найти минимальное значение столбца
SELECT MIN(price_for_day) as min FROM inventory

-- Написать запрос COUNT() + GROUP BY
SELECT age, COUNT(*) AS [count]
FROM
    client
GROUP BY age
HAVING COUNT(*) > 10;

/* SELECT GROUP BY + HAVING */
SELECT quality 
FROM 
	inventory_item
GROUP BY quality
HAVING quality = 'high quality';

SELECT date_of_purchase, COUNT(quality)
FROM inventory_item
WHERE date_of_purchase IN (2012, 2017, 2020)
GROUP BY date_of_purchase
HAVING COUNT(*) > 5;

SELECT age, COUNT(*) AS [count]
FROM
    client
GROUP BY age
HAVING COUNT(*) > 4;

/* SELECT JOIN */
-- LEFT JOIN двух таблиц и WHERE по одному из атрибутов
SELECT full_name, telephone  
      FROM client LEFT JOIN inventory_rental  
	     ON client.id_client = inventory_rental.id_client
		 WHERE cost > 4000

-- RIGHT JOIN. Получить такую же выборку как и в 3.9 a
SELECT full_name, telephone  
      FROM inventory_rental  RIGHT JOIN client
	     ON client.id_client = inventory_rental.id_client
		 WHERE cost > 4000

-- LEFT JOIN трех таблиц + WHERE по атрибуту из каждой таблицы
SELECT full_name, telephone  
      FROM client LEFT JOIN inventory_rental  
	     ON client.id_client = inventory_rental.id_client
		 LEFT JOIN inventory 
		 ON inventory.id_inventory = inventory_rental.id_inventory
		 WHERE cost > 4000 AND price_for_day > 1000 AND age > 12

-- INNER JOIN двух таблиц
SELECT full_name, telephone  
      FROM inventory_rental INNER JOIN client
	     ON client.id_client = inventory_rental.id_client
		 WHERE cost > 4000

/* Подзапросы */
-- Написать запрос с условием WHERE IN (подзапрос)
SELECT *
  FROM inventory
 WHERE id_inventory IN (SELECT id_inventory FROM institution)

-- Написать запрос SELECT atr1, atr2, (подзапрос) FROM
SELECT rental_period, cost, (SELECT price_for_day FROM inventory WHERE inventory_rental.id_inventory = inventory.id_inventory)
  FROM inventory_rental

--Написать запрос вида SELECT * FROM (подзапрос)
SELECT * 
FROM (SELECT institution.name, type FROM institution LEFT JOIN inventory ON institution.id_inventory = inventory.id_inventory) check_type;

-- Написать запрос вида SELECT * FROM table JOIN ( подзапрос ) ON ...
SELECT * 
FROM client LEFT JOIN (SELECT inventory_rental.id_client, inventory.type 
						FROM inventory_rental JOIN inventory ON inventory_rental.id_inventory = inventory.id_inventory) 
typeofInventoryForClient ON client.id_client = typeofInventoryForClient.id_client;

