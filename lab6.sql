use [pharmacy]
--1. �������� ������� �����
ALTER TABLE dealer
	ADD CONSTRAINT FK_dealer_id_company FOREIGN KEY (id_company)
      REFERENCES company (id_company)
;

ALTER TABLE production
	ADD CONSTRAINT FK_production_id_company FOREIGN KEY (id_company)
      REFERENCES company (id_company)
;

ALTER TABLE [order]
	ADD CONSTRAINT FK_order_production FOREIGN KEY (id_production)
      REFERENCES [production] (id_production)
;

ALTER TABLE [order]
	ADD CONSTRAINT FK_order_dealer FOREIGN KEY (id_dealer)
      REFERENCES [dealer] (id_dealer)
;

ALTER TABLE [order]
	ADD CONSTRAINT FK_order_pharmacy FOREIGN KEY (id_pharmacy)
      REFERENCES [pharmacy] (id_pharmacy)
;

ALTER TABLE [production]
	ADD CONSTRAINT FK_production_medicine FOREIGN KEY (id_medicine)
      REFERENCES [medicine] (id_medicine)
;


--2. ������ ���������� �� ���� ������� ��������� ��������� �������� ������ � ��������� �������� �����, ���, ������ �������
SELECT [pharmacy].name, [order].date, [order].quantity
FROM [order]
	INNER JOIN pharmacy
	ON [order].id_pharmacy = [pharmacy].id_pharmacy
	INNER JOIN production
	ON [order].id_production = [production].id_production
	INNER JOIN company
	ON [production].id_company = [company].id_company
	INNER JOIN medicine
	ON [production].id_medicine = [medicine].id_medicine
WHERE medicine.name = '��������' AND company.name = '�����';


--3. ���� ������ �������� �������� �������, �� ������� �� ���� ������� ������ �� 25 ������.
-- ��������� ������� ������� �� �����������
SELECT [medicine].name
FROM [order]
	INNER JOIN production
		ON [order].id_production = [production].id_production
	INNER JOIN company
		ON [production].id_company = [company].id_company
	RIGHT JOIN medicine
		ON [production].id_medicine = [medicine].id_medicine
WHERE (company.name = '�����') AND (([order].date >= '2019-01-25') OR ([order].date = NULL));


--4. ���� ����������� � ������������ ����� �������� ������ �����, ������� �������� �� ����� 120 �������
SELECT MIN([production].rating), MAX([production].rating), [company].name
FROM production
	JOIN company
	ON [production].id_company = [company].id_company
	JOIN [order]
	ON [production].id_production = [order].id_production
GROUP BY [company].name
HAVING(COUNT([order].id_order) >= 120);
	


--5. ���� ������ ��������� ������ ����� �� ���� ������� �������� �AstraZeneca�. ���� � ������ ��� �������, � �������� ������ ���������� NULL
SELECT [pharmacy].name pharmacyName, [dealer].name dealerName
FROM dealer
	LEFT JOIN company
	ON [dealer].id_company = [company].id_company
	LEFT JOIN [order] 
	ON [dealer].id_dealer = [order].id_dealer
	LEFT JOIN pharmacy
	ON [pharmacy].id_pharmacy = [order].id_pharmacy
WHERE([company].name = 'AstraZeneca');


--6. ��������� �� 20% ��������� ���� ��������, ���� ��� ��������� 3000, � ������������ ������� �� ����� 7 ����
UPDATE [production]
SET [production].price = [production].price * 0.8
FROM [production]
	INNER JOIN medicine ON [production].id_medicine = [medicine].id_medicine
WHERE ([production].price > 3000) AND ([medicine].cure_duration <= 7);


--7. �������� ����������� �������
CREATE INDEX index_company_name
ON company(name);

CREATE INDEX index_medicine_name
ON medicine(name);

CREATE INDEX index_order_date
ON [order](date);

CREATE INDEX index_pharmacy_name
ON pharmacy(name);