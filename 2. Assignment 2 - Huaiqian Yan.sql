--1. What is a result set?
/*
Result set is a set of data, could be empty or not, returned by a select statement, 
or a stored procedure, that is saved in RAM or displayed on the screen.
*/


--2. What is the difference between Union and Union All?
/*
The UNION command combines the result set of two or more SELECT statements with only distinct values.

The UNION ALL command combines the result set of two or more SELECT statements with duplicate values.
*/


--3. What are the other Set Operators SQL Server has?
/*
INTERSECT, EXCEPT
*/


--4. What is the difference between Union and Join?
/*
Joins combine data into new columns, so the joined tables can have different column types.

Unions combine data into new rows, so the unioned tables must have same column types.
*/



--5. What is the difference between INNER JOIN and FULL JOIN?
/*
INNER JOIN only returns the intersection of two tables.

FULL JOIN returns all records of two tables.
*/


--6. What is difference between left join and outer join?
/*
LEFT JOIN returns all records of the left table and the intersection of the right table.

OUTER JOIN returns all records of both tables.
*/


--7. What is cross join?
/*
Cross joins return every combination of rows from two tables.
*/


--8. What is the difference between WHERE clause and HAVING clause?
/*
The where clauuse works on row's data, so aggregation function cannot be used in WHERE clause, but it can be in the HAVING clause.
*/


--9. Can there be multiple group by columns?
/*
Yes.
*/

USE AdventureWorks2019
GO

--1. How many products can you find in the Production.Product table?
SELECT DISTINCT
	count(*) Distinct_Product_Amount
FROM
	Production.Product


--2. Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
SELECT DISTINCT
	count(ProductSubcategoryID)
FROM
	Production.Product


--3. How many Products reside in each SubCategory? Write a query to display the results with the following titles.
SELECT DISTINCT
	ProductSubcategoryID,
	count(*) AS CountedProducts
FROM
	Production.Product
WHERE
	ProductSubcategoryID IS NOT NULL
GROUP BY
	ProductSubcategoryID


--4. How many products that do not have a product subcategory.
SELECT DISTINCT
	ProductSubcategoryID,
	count(*) AS CountedProducts
FROM
	Production.Product
WHERE
	ProductSubcategoryID IS NULL
GROUP BY
	ProductSubcategoryID
	

--5. Write a query to list the summary of products quantity in the Production.ProductInventory table.
SELECT
	SUM(Quantity) as Total_Quantity
FROM
	Production.ProductInventory


--6. Write a query to list the summary of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
SELECT
	ProductID,
	SUM(Quantity) as TheSum
FROM
	Production.ProductInventory
WHERE
	LocationID = 40
GROUP BY
	ProductID
HAVING
	SUM(Quantity) < 100


--7. Write a query to list the summary of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100
SELECT
	Shelf,
	ProductID,
	SUM(Quantity) as TheSum
FROM
	Production.ProductInventory
WHERE
	LocationID = 40
GROUP BY
	Shelf,
	ProductID
HAVING
	SUM(Quantity) < 100


--8. Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.
SELECT
	AVG(Quantity) as TheAvg
FROM
	Production.ProductInventory
WHERE
	LocationID = 10


--9. Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
SELECT
	ProductID,
	Shelf,
	AVG(Quantity) as TheAvg
FROM
	Production.ProductInventory
GROUP BY
	ProductID,
	Shelf


--10. Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory
SELECT
	ProductID,
	Shelf,
	AVG(Quantity) TheAvg
FROM
	Production.ProductInventory
WHERE
	Shelf NOT LIKE 'N/A'
GROUP BY
	ProductID,
	Shelf


--11. List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.
SELECT
	Color,
	Class,
	COUNT(*) TheCount,
	AVG(ListPrice) AvgPrice
FROM
	Production.Product
WHERE
	Color IS NOT NULL
	AND Class IS NOT NULL
GROUP BY
	Color,
	Class


--12. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following. 
SELECT
	C.Name Country,
	S.Name Province
FROM
	Person.CountryRegion C
	JOIN Person.StateProvince S
		ON C.CountryRegionCode = S.CountryRegionCode
ORDER BY
	Country


--13. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
SELECT
	C.Name Country,
	S.Name Province
FROM
	Person.CountryRegion C
	JOIN Person.StateProvince S
	ON C.CountryRegionCode = S.CountryRegionCode
WHERE
	C.Name IN ('Germany', 'Canada')
ORDER BY
	Country

USE Northwind
GO

--14. List all Products that has been sold at least once in last 25 years.
SELECT
	P.ProductID,
	P.ProductName
FROM
	dbo.Products P
	JOIN [dbo].[Order Details] OD
		ON P.ProductID = OD.ProductID
	JOIN dbo.Orders O
		ON O.OrderID = OD.OrderID
WHERE
	YEAR(O.OrderDate) >= (YEAR(SYSDATETIME()) - 25)


--15. List top 5 locations (Zip Code) where the products sold most
SELECT TOP 5
	O.ShipPostalCode,
	SUM(OD.Quantity) Quantity_Sold
FROM
	dbo.Orders O
	JOIN dbo.[Order Details] OD
		ON O.OrderID = OD.OrderID
WHERE
	O.ShipPostalCode IS NOT NULL
GROUP BY
	O.ShipPostalCode
ORDER BY
	Quantity_Sold DESC


--16. List top 5 locations (Zip Code) where the products sold most in last 20 years.
SELECT TOP 5
	O.ShipPostalCode,
	SUM(OD.Quantity) Quantity_Sold
FROM
	dbo.Orders O
	JOIN dbo.[Order Details] OD
		ON O.OrderID = OD.OrderID
WHERE
	O.ShipPostalCode IS NOT NULL
	AND YEAR(O.OrderDate) > (YEAR(SYSDATETIME()) - 20)
GROUP BY
	O.ShipPostalCode
ORDER BY
	Quantity_Sold DESC


--17. List all city names and number of customers in that city.
SELECT
	City,
	COUNT(*) Total_Customer
FROM
	dbo.Customers
GROUP BY
	City


--18. List city names which have more than 10 customers, and number of customers in that city 
SELECT
	City,
	COUNT(*) Total_Customer
FROM
	dbo.Customers
GROUP BY
	City
HAVING
	COUNT(*) > 10

--19. List the names of customers who placed orders after 1/1/98 with order date.
SELECT
	C.ContactName,
	O.OrderDate
FROM
	dbo.Customers C
	JOIN dbo.Orders O
		ON C.CustomerID = O.CustomerID
WHERE
	O.OrderDate > '1998-1-1'


--20. List the names of all customers with most recent order dates 
SELECT
	C.ContactName,
	O.OrderDate
FROM
	dbo.Customers C
	JOIN dbo.Orders O
		ON C.CustomerID = O.CustomerID
WHERE
	O.OrderDate = (SELECT MAX(OrderDate) FROM dbo.Orders)


--21. Display the names of all customers  along with the  count of products they bought
SELECT
	C.ContactName,
	SUM(OD.Quantity) Quantity_Baught
FROM
	dbo.Customers C
	JOIN dbo.Orders O
		ON C.CustomerID = O.CustomerID
	JOIN dbo.[Order Details] OD
		ON OD.OrderID = O.OrderID
GROUP BY
	C.ContactName


--22. Display the customer ids who bought more than 100 Products with count of products.
SELECT
	C.CustomerID,
	SUM(OD.Quantity) Quantity_Baught
FROM
	dbo.Customers C
	JOIN dbo.Orders O
		ON C.CustomerID = O.CustomerID
	JOIN dbo.[Order Details] OD
		ON OD.OrderID = O.OrderID
GROUP BY
	C.CustomerID
HAVING
	SUM(OD.Quantity) > 100


--23. List all of the possible ways that suppliers can ship their products. Display the results as below
SELECT DISTINCT
	Su.CompanyName,
	Sh.CompanyName
FROM
	dbo.Suppliers Su
	JOIN dbo.Products P
		ON Su.SupplierID = P.SupplierID
	JOIN dbo.[Order Details] OD
		ON OD.ProductID = P.ProductID
	JOIN dbo.Orders O
		ON O.OrderID = OD.OrderID
	JOIN dbo.Shippers Sh
		ON Sh.ShipperID = O.ShipVia


--24. Display the products order each day. Show Order date and Product Name.
SELECT DISTINCT
	O.OrderDate,
	P.ProductName
FROM
	dbo.Products P
	JOIN [dbo].[Order Details] OD
		ON P.ProductID = OD.ProductID
	JOIN dbo.Orders O
		ON O.OrderID = OD.OrderID


--25. Displays pairs of employees who have the same job title.
SELECT
	E1.EmployeeID Employee_1,
	E2.EmployeeID Employee_2,
	E1.Title
FROM
	dbo.Employees E1,
	dbo.Employees E2
WHERE
	E1.EmployeeID < E2.EmployeeID
	AND E1.Title = E2.Title


--26. Display all the Managers who have more than 2 employees reporting to them.
SELECT
	ReportsTo Manager_ID,
	COUNT(ReportsTo) Subordinatre_Quantity
FROM
	dbo.Employees
GROUP BY
	ReportsTo
HAVING
	COUNT(ReportsTo) > 2


--27. Display the customers and suppliers by city. The results should have the following columns
SELECT
	City,
	ContactName,
	CASE
		WHEN ID LIKE '[0-9]%' THEN 'Customer'
		ELSE 'Supplier'
	END C_S_Type
FROM
	(SELECT
		CustomerID ID,
		City,
		ContactName
	FROM
		dbo.Customers
	UNION
	SELECT
		CAST(SupplierID AS NCHAR) ID,
		City,
		ContactName
	FROM
		dbo.Suppliers) Cus_Sup


--28. Have two tables T1 and T2. Please write a query to inner join these two tables and write down the result of this query.
-- Not sure what F1 and F2 are.


--29. Based on above two table, Please write a query to left outer join these two tables and write down the result of this query.
-- Not sure what F1 and F2 are.