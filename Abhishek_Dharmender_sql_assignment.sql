CREATE DATABASE DB8;  -- database
USE DB8;   -- using datbase

-- creating hotel table
CREATE TABLE hotel ( hotel_no CHAR(4) NOT NULL, name VARCHAR(20) NOT NULL, address VARCHAR(50) NOT NULL);

-- creating room table
CREATE TABLE room ( room_no VARCHAR(4) NOT NULL, hotel_no CHAR(4) NOT NULL, type CHAR(1) NOT NULL, price DECIMAL(5,2) NOT NULL);

-- creating booking
CREATE TABLE booking (hotel_no CHAR(4) NOT NULL, guest_no CHAR(4) NOT NULL, date_from DATETIME NOT NULL, date_to DATETIME NULL, room_no CHAR(4) NOT NULL);

-- creating guest table
CREATE TABLE guest ( guest_no CHAR(4) NOT NULL, name VARCHAR(20) NOT NULL, address VARCHAR(50) NOT NULL);

-- inserting row values in all table
 INSERT INTO hotel VALUE ('H111', 'Grosvenor Hotel', 'London');    -- hotel table value
 INSERT INTO room VALUES ('1', 'H111', 'S', 72.00);				   -- room table value
 INSERT INTO guest VALUES ('G111', 'John Smith', 'London');		   -- guest table value
 INSERT INTO booking VALUES ('H111', 'G111', DATE'1999-01-01', DATE'1999-01-02', '1');		-- booking table value
 
 -- chceking all the table is made corectly or not
 SELECT * FROM hotel;
 SELECT * FROM room;
 SELECT * FROM guest;
 SELECT * FROM booking;
 
 
 # here i am removing safe mode
 SET SQL_SAFE_UPDATES=0;
 
 # updating room table with setting new price
 UPDATE room SET price = price*1.05;
 
 # and now using safe mode
 SET SQL_SAFE_UPDATES=1;
 
 -- creating booking old table
 CREATE TABLE booking_old ( hotel_no CHAR(4) NOT NULL, guest_no CHAR(4) NOT NULL, date_from DATETIME NOT NULL, date_to DATETIME NULL, room_no VARCHAR(4) NOT NULL);
 
 -- inserting the values where date is less 2000-01-01
INSERT INTO booking_old (SELECT * FROM booking WHERE date_to < DATE'2000-01-01');

-- deleting where date less than 2000-01-01
DELETE FROM booking WHERE date_to < DATE'2000-01-01';


-- checking table booking_old
SELECT * FROM booking_old;

---------------------------------------------------------------------------
-- Simple Queries

# 1.List full details of all hotels. 
SELECT  * FROM hotel;   -- with this i can get all detail of the hotel table


# 2.List full details of all hotels in London.
SELECT  * FROM hotel
WHERE address = 'London'   -- here i am selecting all hotels in london


# 3.List the names and addresses of all guests in London, alphabetically ordered by name. 
SELECT name, address FROM guest
WHERE address LIKE '%London%'
ORDER BY name ASC;

# 4.List all double or family rooms with a price below £40.00 per night, in ascending order of price. 
SELECT * FROM room 
WHERE price < 40
ORDER BY price;


# 5.List the bookings for which no date_to has been specified.
SELECT * FROM booking
WHERE date_to IS NULL;

---------------------------------------------------------------------

-- Aggregate Functions 

# 1.How many hotels are there? 
SELECT COUNT(hotel_no) FROM booking;


# 2.What is the average price of a room? 
SELECT AVG(price) FROM room;


# 3. What is the total revenue per night from all double rooms? 
SELECT SUM(room_no*price) FROM room;


# 4. How many different guests have made bookings for August?
SELECT guest.guest_no, guest.name, booking.date_from, booking.date_to FROM guest, booking
WHERE booking.date_to = 1999-08-08;

------------------------------------------------------------------------------------

-- Subqueries and Joins 

# 1.List the price and type of all rooms at the Grosvenor Hotel.
SELECT room.type, room.price, hotel.name FROM room
INNER JOIN hotel ON hotel.hotel_no = room.hotel_no;


# 2.List all guests currently staying at the Grosvenor Hotel. 
SELECT guest.name, hotel.name FROM guest
INNER JOIN booking ON booking.guest_no = guest.guest_no
INNER JOIN hotel ON booking.hotel_no = hotel.hotel_no;


# 3.List the details of all rooms at the Grosvenor Hotel, 
# including the name of the guest staying in the room, if the room is occupied. 
SELECT room.room_no, guest.name, hotel.name FROM room
INNER JOIN booking ON booking.hotel_no = room.hotel_no
INNER JOIN hotel ON hotel.hotel_no = room.hotel_no
INNER JOIN guest ON guest.guest_no = booking.guest_no;


# 4.What is the total income from bookings for the Grosvenor Hotel today? 
SELECT SUM(price) AS "TOTAL INCOME" FROM room;


# 5.List the rooms that are currently unoccupied at the Grosvenor Hotel. 
SELECT hotel.name, room.room_no FROM hotel, room
WHERE room_no IS NULL;


# 6.What is the lost income from unoccupied rooms at the Grosvenor Hotel?
SELECT COALESCE(SUM(room.price),0), hotel.hotel_no FROM room
INNER JOIN hotel ON hotel.hotel_no = room.hotel_no;

----------------------------------------------------------------------------

-- Grouping 

# 1.List the number of rooms in each hotel. 
SELECT COUNT(hotel_no) AS "NUMBER OF ROOMS" FROM room
GROUP BY hotel_no;


# 2.List the number of rooms in each hotel in London. 
SELECT COUNT(room.room_no) AS "NO. OF ROOMS", hotel.address FROM room, hotel
WHERE room.hotel_no = hotel.hotel_no
GROUP BY room.room_no;


# 3.What is the average number of bookings for each hotel in August? 
SELECT AVG(booking.hotel_no), hotel.name, booking.date_from FROM booking
INNER JOIN hotel ON hotel.hotel_no = booking.hotel_no
WHERE date_from = 1999-08-08
GROUP BY booking.hotel_no;


# 4.What is the most commonly booked room type for each hotel in London? 
SELECT MAX(room.type), hotel.name, hotel.address FROM room
INNER JOIN hotel ON hotel.hotel_no = room.room_no
GROUP BY room.type;


# 5.What is the lost income from unoccupied rooms at each hotel today?
SELECT COALESCE(SUM(room.price)), room.room_no, hotel.name FROM room
INNER JOIN hotel ON hotel.hotel_no = room.room_no
WHERE room.room_no IS NULL;

