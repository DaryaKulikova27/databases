/* �������� ������� INSERT */
-------------------------------------------------------------------------
use [lab4.1]
SELECT * FROM [client]

--a. ��� �������� ������ �����
INSERT INTO [client]
-- �������� ������� ������ ������ �����������, ������ ���������� ������� �� ���������.
VALUES
    (456, 'Ludmila Pusyieva', '451146', '55'); -- �������� ������.

--b. � ��������� ������ �����
INSERT INTO [client]             
    (full_name, id_client, telephone, age) -- �������� ������� ������ ������.
VALUES
    ('Alexander Lupkin', 3313, '6284241', '10'); -- �������� ������.

--c. � ������� �� ������ �������
INSERT INTO client(full_name) SELECT name FROM institution;

/* �������� �������� DELETE*/
-- ���� �������
DELETE [client];
SELECT * FROM [client];

-- � ��������
DELETE FROM client
WHERE
    full_name LIKE 'Sobakina%';


/*UPDATE*/
--���� �������
UPDATE [inventory_item]
SET name = 'lopata';

SELECT * FROM [inventory_item];


INSERT INTO [institution]      
    (name, address, id_institution) 
VALUES
    ('Shcool #2787', 'ul.Sobakina, 45', 19); -- �������� ������.
    

-- ���������� � ��������
UPDATE [institution]
SET address = 'ul.Koshkina, 100' -- �������� ��� ����,
WHERE address = 'ul.Sobakina, 45'	-- ��� ������� 'Pushkin'

-- �� ������� �������� ��������� ���������
UPDATE [institution]
SET address = 'ul.Beer, 19',
	name = 'shoop "On an uncle"'
WHERE id_institution = 19;

/*SELECT*/
-- � ������� ����������� ���������
SELECT price_for_day FROM [inventory]; 

-- �� ����� ����������
SELECT * FROM [inventory];

-- � �������� �� ��������
SELECT * FROM inventory
WHERE id_inventory = 182;

/*SELECT ORDER BY + TOP (LIMIT)*/
-- � ����������� �� ����������� ASC + ����������� ������ ���������� �������
SELECT TOP 1 *
FROM [client]
ORDER BY id_client ASC;

-- � ����������� �� �������� DESC
SELECT *
FROM [institution]
ORDER BY name DESC;

-- � ����������� �� ���� ��������� + ����������� ������ ���������� �������
SELECT *
FROM [inventory_item]
ORDER BY name, quality;

-- � ����������� �� ������� ��������, �� ������ �����������
SELECT *
FROM [inventory]
ORDER BY 1;

/*������ � ������*/
-- a. WHERE �� ����
SELECT * FROM inventory_item
WHERE date_of_purchase = 1915 

INSERT INTO [inventory_item]
VALUES (30, 'GRABLYA', '2009-19-07', 'HIGHT')

-- b. WHERE ���� � ���������
SELECT * FROM inventory_item 
WHERE date_of_purchase BETWEEN '2009-01-01' AND '2010-01-01'; 

-- c. ������� �� ������� �� ��� ����, � ������ ���
SELECT YEAR('2010-04-30T01:01:01.1234567-07:00') FROM inventory_item;

/* ������� ���������*/
-- ��������� ���������� ������� � �������
SELECT COUNT(*) FROM client

-- ��������� ���������� ���������� ������� � �������
SELECT COUNT(DISTINCT cost)  
FROM inventory_rental;  

-- ������� ���������� �������� �������
SELECT COUNT(DISTINCT 1)  
FROM inventory_rental;  

-- ����� ������������ �������� �������
SELECT MAX(price_for_day) as max FROM inventory

-- ����� ����������� �������� �������
SELECT MIN(price_for_day) as min FROM inventory

-- �������� ������ COUNT() + GROUP BY
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
-- LEFT JOIN ���� ������ � WHERE �� ������ �� ���������
SELECT full_name, telephone  
      FROM client LEFT JOIN inventory_rental  
	     ON client.id_client = inventory_rental.id_client
		 WHERE cost > 4000

-- RIGHT JOIN. �������� ����� �� ������� ��� � � 3.9 a
SELECT full_name, telephone  
      FROM inventory_rental  RIGHT JOIN client
	     ON client.id_client = inventory_rental.id_client
		 WHERE cost > 4000

-- LEFT JOIN ���� ������ + WHERE �� �������� �� ������ �������
SELECT full_name, telephone  
      FROM client LEFT JOIN inventory_rental  
	     ON client.id_client = inventory_rental.id_client
		 LEFT JOIN inventory 
		 ON inventory.id_inventory = inventory_rental.id_inventory
		 WHERE cost > 4000 AND price_for_day > 1000 AND age > 12

-- INNER JOIN ���� ������
SELECT full_name, telephone  
      FROM inventory_rental INNER JOIN client
	     ON client.id_client = inventory_rental.id_client
		 WHERE cost > 4000

/* ���������� */
-- �������� ������ � �������� WHERE IN (���������)
SELECT *
  FROM inventory
 WHERE id_inventory IN (SELECT id_inventory FROM institution)

-- �������� ������ SELECT atr1, atr2, (���������) FROM
SELECT rental_period, cost, (SELECT price_for_day FROM inventory WHERE inventory_rental.id_inventory = inventory.id_inventory)
  FROM inventory_rental

--�������� ������ ���� SELECT * FROM (���������)
SELECT * 
FROM (SELECT institution.name, type FROM institution LEFT JOIN inventory ON institution.id_inventory = inventory.id_inventory) check_type;

-- �������� ������ ���� SELECT * FROM table JOIN ( ��������� ) ON ...
SELECT * 
FROM client LEFT JOIN (SELECT inventory_rental.id_client, inventory.type 
						FROM inventory_rental JOIN inventory ON inventory_rental.id_inventory = inventory.id_inventory) 
typeofInventoryForClient ON client.id_client = typeofInventoryForClient.id_client;

