-- Question 1: Top 3
USE Northwind;

WITH SalesCTE (City, ProductID, Total_Sales, RK)
AS
	(
		SELECT
			C.City,
			OD.ProductID,
			ROUND(SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)), 2)  Total_Sales,
			RANK() OVER (PARTITION BY C.City ORDER BY SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) DESC) RK
		FROM
			dbo.[Order Details] OD
			JOIN
				dbo.Orders O
				ON O.OrderID = OD.OrderID
			JOIN
				dbo.Customers C
				ON C.CustomerID = O.CustomerID
		GROUP BY
			C.City,
			OD.ProductID
	)

SELECT
	City,
	ProductID,
	Total_Sales,
	RK
FROM
	SalesCTE
WHERE
	RK <= 3


---- Question 2: Distance
CREATE DATABASE Antra
GO

USE Antra
GO

CREATE TABLE Distance
(
	Destination VARCHAR(1),
	Distance int
)
GO

INSERT INTO Distance VALUES ('A', 0)
INSERT INTO Distance VALUES ('B', 20)
INSERT INTO Distance VALUES ('C', 50)
INSERT INTO Distance VALUES ('D', 70)
INSERT INTO Distance VALUES ('E', 85)

SELECT 
	D1.Destination + '-' + D2.Destination AS Destination,
	D2.Distance - D1.Distance AS Distance
FROM 
	Distance D1
	LEFT JOIN
		Distance D2
		ON ASCII(D2.Destination) = ASCII(D1.Destination) + 1
WHERE
	D2.Destination IS NOT NULL