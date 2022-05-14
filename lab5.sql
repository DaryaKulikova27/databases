use [lab5]
-- 1. �������� ������� �����.
ALTER TABLE room_in_booking
   ADD CONSTRAINT FK_room_in_booking_room FOREIGN KEY (id_room)
      REFERENCES room (id_room)
;

ALTER TABLE room
   ADD CONSTRAINT FK_room_hotel FOREIGN KEY (id_hotel)
      REFERENCES hotel (id_hotel)
;

ALTER TABLE room
   ADD CONSTRAINT FK_category_room_room FOREIGN KEY (id_room_category)
      REFERENCES room_category (id_room_category)
;

ALTER TABLE room_in_booking
   ADD CONSTRAINT FK_room_in_booking_booking_ FOREIGN KEY (id_booking)
      REFERENCES booking (id_booking)
;

ALTER TABLE booking
   ADD CONSTRAINT FK_booking_client FOREIGN KEY (id_client)
      REFERENCES client (id_client)
;

-- 2. ������ ���������� � �������� ��������� �������, ����������� � ������� ��������� ����� �� 1 ������ 2019�.
SELECT [client].name, [client].phone
FROM client
	INNER JOIN booking
	ON client.id_client = booking.id_client
	INNER JOIN room_in_booking
	ON booking.id_booking = room_in_booking.id_booking
	INNER JOIN room
	ON room_in_booking.id_room = room.id_room
	INNER JOIN room_category
	ON room.id_room_category = room_category.id_room_category
	INNER JOIN hotel
	ON room.id_hotel = hotel.id_hotel
WHERE (room_category.name = '����') AND (hotel.name = '������') AND 
((room_in_booking.checkin_date <= '2019-04-01') AND (room_in_booking.checkout_date > '2019-04-01'));


-- 3. ���� ������ ��������� ������� ���� �������� �� 22 ������
SELECT distinct [room].number,
       [room].id_room
FROM room
  INNER JOIN hotel 
  ON room.id_hotel = hotel.id_hotel
  LEFT JOIN room_in_booking 
  ON room_in_booking.id_room = room.id_room
WHERE room_in_booking.checkout_date < '2019.04.22'
  OR room_in_booking.checkin_date > '2019.04.22'
  or room_in_booking.id_room_in_booking is null

-- 4.���� ���������� ����������� � ��������� ������� �� 23 ����� �� ������ ��������� �������
SELECT
  [room_category].name,
  COUNT(room_in_booking.id_room_in_booking)
FROM room
  INNER JOIN hotel 
ON room.id_hotel = hotel.id_hotel
  INNER JOIN room_category 
  ON room.id_room_category = room_category.id_room_category
  INNER JOIN room_in_booking
  ON room.id_room = room_in_booking.id_room
WHERE room_in_booking.checkin_date <= '2019.03.23'
  AND room_in_booking.checkout_date > '2019.03.23'
  AND hotel.name = '������'
GROUP BY room_category.id_room_category;

-- 5. ���� ������ ��������� ����������� �������� �� ���� �������� ���������
-- �������, ��������� � ������ � ��������� ���� ������.
SELECT hotel.name,
       room.number,
       client.name,
       room_in_booking.checkout_date
FROM (
     SELECT room_in_booking.id_room AS id_room,
            MAX(room_in_booking.checkout_date) AS checkout_date
     FROM room_in_booking
     GROUP BY room_in_booking.id_room
  ) AS last_room_booking
  INNER JOIN room_in_booking ON room_in_booking.id_room = last_room_booking.id_room AND last_room_booking.checkout_date = room_in_booking.checkout_date
  INNER JOIN booking ON room_in_booking.id_booking = booking.id_booking
  INNER JOIN client ON booking.id_client = client.id_client
  INNER JOIN room ON room_in_booking.id_room = room.id_room
  INNER JOIN hotel ON room.id_hotel = hotel.id_hotel
WHERE hotel.name='������'
  AND (room_in_booking.checkout_date BETWEEN '2019.05.01' AND '2019.05.31');

-- 6. �������� �� 2 ��� ���� ���������� � ��������� ������� ���� �������� ������ ���������
-- �������, ������� ���������� 10 ���.
UPDATE rib
SET rib.checkout_date = DATEADD(DAY, 2, rib.checkout_date )
from [room_in_booking] rib
  INNER JOIN room ON rib.id_room = room.id_room
  INNER JOIN hotel ON room.id_hotel = hotel.id_hotel
  INNER JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE hotel.name ='������'
  AND rib.checkin_date = '2019.05.10'
  AND room_category.name = '������';

-- 7. ����� ��� "��������������" �������� ����������. ���������� ���������: �� �����
-- ���� ������������ ���� ����� �� ���� ���� ��������� ���, �.�. ������ ���������� ����������
-- �������� � ���� �����. ������ � ������� room_in_booking � id_room_in_booking = 5 � 2154
-- �������� �������� ������������� � ��������, ������� ���������� �����. ��������������
-- ������ ������� ������ ��������� ���������� � ���� ������������� �������.
SELECT rib1.id_room_in_booking,
       rib2.id_room_in_booking,
       rib1.checkin_date,
       rib1.checkout_date,
       rib2.checkin_date,
       rib2.checkout_date
FROM room_in_booking rib1
    INNER JOIN room_in_booking rib2
        ON rib1.id_room = rib2.id_room
		AND rib1.id_room_in_booking < rib2.id_room_in_booking
        AND (
            (
				(rib1.checkin_date BETWEEN rib2.checkin_date AND rib2.checkout_date)
                OR (rib2.checkin_date BETWEEN rib1.checkin_date AND rib1.checkout_date)
            )
        )
ORDER BY rib1.id_room;

-- 8. ������� ������������ � ����������
BEGIN TRANSACTION;
INSERT INTO booking(id_booking, id_client, booking_date)
VALUES (10001, 1, '2022.04.15');
INSERT INTO room_in_booking(id_room_in_booking, id_booking, id_room, checkin_date, checkout_date)
VALUES (100001, SCOPE_IDENTITY(), 1, '2022.04.15', '2022.04.20');
COMMIT;

-- 9. �������� ����������� ������� ��� ���� ������
CREATE INDEX index_hotel_name
ON hotel(name);

CREATE INDEX index_checkin_date
ON room_in_booking(checkin_date);

CREATE INDEX index_checkout_date
ON room_in_booking(checkout_date);



