--create a database for car rental system
CREATE DATABASE Car_Rental

USE Car_Rental

--create a vehicle table
CREATE TABLE Vehicles(
vehicleID INT IDENTITY(1,1) PRIMARY KEY,
make VARCHAR(50),
model VARCHAR(50),
[Year] DATE,
dailyRate FLOAT,
available INT,
passenger_capacity INT,
engine_capacity INT)

--CREATE A CUSTOMER TABLE
CREATE TABLE Customers(
customerID INT IDENTITY(1,1) PRIMARY KEY,
firstName VARCHAR(50),
lastName VARCHAR(50),
Email VARCHAR(100),
PhoneNumber INT)

--CREATE LEASE TABLE
CREATE TABLE Lease(
leaseId INT IDENTITY(1,1) PRIMARY KEY,
vehicleId INT,
customerID INT,
startDate DATE,
endDate Date,
leasetype VARCHAR(50),
FOREIGN KEY (vehicleId) REFERENCES Vehicles(VehicleID) 
ON DELETE CASCADE,
FOREIGN KEY (customerID) REFERENCES Customers(customerID)
ON DELETE CASCADE)

--CREATE A PAYMENT TABLE
CREATE TABLE Payments(
paymentID INT IDENTITY(1,1) PRIMARY KEY,
leaseId INT,
paymentDate DATE,
Amount MONEY,
FOREIGN KEY(leaseId) REFERENCES Lease(leaseId)
ON DELETE CASCADE)

--INSERT VALUES IN Vehicles TABLE
INSERT INTO Vehicles VALUES
('Toyota','Camry','2022',50,1,4,1450),
('Honda','Civic','2023',45,1,7,1500),
('Ford','Focus','2022',48,0,4,1400),
('Nissan','Altima','2023',52,1,7,1200),
('Chevrolet','Malibu','2022',47,1,4,1800),
('Hyundai','Sonata','2023',49,0,7,1400),
('BMW','3 Series','2023',60,1,7,2499),
('Mercedes','C-Class','2022',58,1,8,2599),
('Audi','A4','2022',55,0,4,2500),
('Lexus','ES','2023',54,1,4,2500)

--CHANGING DATATYPE OF dailyRate to MONEY
ALTER TABLE Vehicles
ALTER COLUMN dailyRate MONEY

--INSERT VALUES INTO Customers TABLE
INSERT INTO Customers VALUES
('John','Doe','johndoe@example.com',555-555-5555),
('Jane','Smith','janesmith@example.com',555-123-4567),
('Robert','Johnson','robert@example.com',555-789-1234),
('Sarah','Brown','sarah@example.com',555-456-7890),
('David','Lee','david@example.com',555-987-6543),
('Laura','Hall','laura@example.com',555-234-5678),
('Michael','Davis','michael@example.com',555-876-5432),
('Emma','Wilson','emma@example.com',555-432-1098),
('William','Taylor','willian@example.com',555-321-6547),
('Olivia','Adams','olivia@gmail.com',555-765-4321)

--INSERT VALUES INTO Lease TABLE
INSERT INTO Lease VALUES
(1,1,'2023-01-01','2023-01-05','Daily'),
(2,2,'2023-02-15','2023-02-28','Monthly'),
(3,3,'2023-03-10','2023-03-15','Daily'),
(4,4,'2023-04-20','2023-04-30','Monthly'),
(5,5,'2023-05-05','2023-05-10','Daily'),
(4,3,'2023-06-15','2023-06-30','Monthly'),
(7,7,'2023-07-01','2023-07-10','Daily'),
(8,8,'2023-08-12','2023-08-15','Monthly'),
(3,3,'2023-09-07','2023-09-10','Daily'),
(10,10,'2023-10-10','2023-10-31','Monthly')

--INSERT VALUES INTO Payment TABLE
INSERT INTO Payments VALUES
(1,'2023-01-03',200),
(2,'2023-02-20',1000),
(3,'2023-03-12',75),
(4,'2023-04-25',900),
(5,'2023-05-07',60),
(6,'2023-06-18',1200),
(7,'2023-07-03',40),
(8,'2023-08-14',1100),
(9,'2023-09-09',80),
(10,'2023-10-25',1500)

--1)Update the daily rate for a Mercedes car to 68.
UPDATE  Vehicles
SET  dailyRate=68
WHERE vehicleID=8

SELECT * FROM Vehicles

--2)Delete a specific customer and all associated leases and payments.
DECLARE @ID INT =3
DELETE FROM  Customers WHERE customerID=@ID
DECLARE @ID INT =3
DELETE FROM  Lease WHERE customerID=@ID
DECLARE @ID INT =3
DELETE FROM  Payments WHERE leaseId IN
(SELECT leaseId FROM Lease WHERE customerID=3)

--3)Rename the "paymentDate" column in the Payment table to "transactionDate"
EXEC SP_RENAME 'Payments.paymentDate','transactionDate','COLUMN'

SELECT * FROM Payments

--4)Find a specific customer by email.
DECLARE @email VARCHAR(50)='emma@example.com'
SELECT * FROM Customers
WHERE email=@email

--5)Get active leases for a specific customer
DECLARE @custID INT=8
SELECT * FROM Lease
WHERE customerID=@custID

--6)Find all payments made by a customer with a specific phone number.
DECLARE @No INT=555-123-4567
SELECT P.* FROM Payments P
JOIN Lease L
ON P.leaseId=L.leaseId
JOIN Customers C
ON C.customerID=L.customerID
WHERE C.PhoneNumber=@No

--7)Calculate the average daily rate of all available cars.
SELECT AVG(dailyRate)AS Average_rate
FROM Vehicles

--8)Find the car with the highest daily rate.
SELECT * from Vehicles
WHERE dailyRate IN (SELECT MAX(dailyRate) AS highest_rate
FROM Vehicles)

--9)Retrieve all cars leased by a specific customer.
DECLARE @Cust INT=1
SELECT make,model FROM Vehicles 
WHERE vehicleID IN
(SELECT vehicleID FROM Lease
WHERE vehicleId=@Cust)

--10)Find the details of the most recent lease.
SELECT * FROM Lease
ORDER BY startDate DESC

--11)List all payments made in the year 2023.
SELECT amount FROM Payments
WHERE YEAR(transactionDate)='2023'

--12)Retrieve customers who have not made any payments
SELECT C.* FROM 
Customers C LEFT JOIN 
Lease L ON C.customerID=L.customerID
 LEFT JOIN Payments P
 ON L.leaseId=P.leaseId
 WHERE P.leaseId IS NULL

 --13)Retrieve Car Details and Their Total Payments.
 SELECT V.*,SUM(P.amount) AS total_payments
 FROM Vehicles v
 join Lease L
 ON V.vehicleID=L.vehicleId
 join Payments P
 ON L.leaseID=P.leaseId
 GROUP BY V.vehicleID,V.make,V.model,V.Year,V.dailyRate,V.available,V.passenger_capacity,v.engine_capacity

 --14)Calculate Total Payments for Each Customer.
SELECT c.*,
 SUM(p.amount) AS total_payments
FROM customers c
JOIN lease l ON c.customerID = l.customerID
JOIN payments p ON l.leaseId = p.leaseId
GROUP BY c.customerID,C.firstName,C.lastName,C.Email,C.PhoneNumber

--15)List Car Details for Each Lease.
SELECT V.*
FROM Vehicles V
JOIN Lease L
ON V.vehicleID=L.vehicleId

--16)Retrieve Details of Active Leases with Customer and Car Information.
SELECT  l.*, c.*, v.*
FROM Lease l
JOIN customers c ON l.customerID = c.customerID
JOIN Vehicles V ON V.vehicleID = l.vehicleId

--17)Find the Customer Who Has Spent the Most on Leases.
SELECT  c.*,SUM(P.Amount) as Total_Spent
FROM customers c
 JOIN  Lease l ON c.customerID = l.customerID
 JOIN payments p ON l.leaseId = p.leaseId
GROUP BY  c.customerID,C.firstName,C.lastName,C.Email,C.PhoneNumber
ORDER BY Total_Spent DESC

--List All Cars with Their Current Lease Information
SELECT V.*,L.*
FROM Vehicles V
JOIN Lease L 
ON V.vehicleID=L.vehicleId

