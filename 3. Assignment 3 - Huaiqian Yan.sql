/*
1. In SQL Server, assuming you can find the result by using both joins and subqueries, 
   which one would you prefer to use and why?
	
   I prefer to use joins because it is almost always faster.
*/


/*
2.	What is CTE and when to use it?

A Common Table Expression, also called as CTE in short form, is a temporary named result
set that you can reference within a SELECT, INSERT, UPDATE, or DELETE statement.

When to use:
- Create a recursive query.
- Substitute for a view when the general use of a view is not required.
- Using a CTE offers the advantages of improved readability and ease in maintenance of
  complex queries. 
*/


/*
3.	What are Table Variables? What is their scope and where are they created in SQL Server?

A table variable is a data type that can be used within a Transact-SQL batch, stored 
procedure, or function—and is created and defined similarly to a table, only with a 
strictly defined lifetime scope. 
*/


/*
4.	What is the difference between DELETE and TRUNCATE? Which one will have better performance and why?

- Truncate reseeds identity values, whereas delete doesn't.
- Truncate removes all records and doesn't fire triggers.
- Truncate is faster compared to delete as it makes less use of the transaction log.
- Truncate is not possible when a table is referenced by a Foreign Key or tables are used in 
  replication or with indexed views.
*/


/*
5.	What is Identity column? How does DELETE and TRUNCATE affect it?

A SQL Server IDENTITY column is a special type of column that is used to automatically 
generate key values based on a provided seed (starting point) and increment.

Truncate reseeds identity values, whereas delete doesn't.
*/


/*
6.	What is difference between “delete from table_name” and “truncate table table_name”?

Truncate is DDL, but delete is DML.
*/


USE Northwind
GO

-- 1.	List all cities that have both Employees and Customers.

-- Method 1: Subquery
SELECT DISTINCT
	City
FROM
	dbo.Customers
WHERE
	City IN (
				SELECT DISTINCT
					City
				FROM
					dbo.Employees
			)

-- Method 2: Join
SELECT DISTINCT
	C.City
FROM
    dbo.Customers C
	JOIN
		dbo.Employees E
		ON E.City = C.City


-- 2. List all cities that have Customers but no Employee.
-- a. Use sub-query
SELECT DISTINCT
	City
FROM
	dbo.Customers
WHERE
	City NOT IN (
					SELECT
						City
					FROM
						dbo.Employees
				)

-- b. Do not use sub-query
SELECT DISTINCT
	C.City
FROM
    dbo.Customers C
	LEFT JOIN
		dbo.Employees E
		ON E.City = C.City
WHERE
	E.City IS NULL


--3. List all products and their total order quantities throughout all orders.
SELECT
	P.ProductID,
	SUM(OD.Quantity) Total_Quatities
FROM
	dbo.Products P
	LEFT JOIN
		dbo.[Order Details] OD
		ON OD.ProductID = P.ProductID
GROUP BY
	P.ProductID


--4. List all Customer Cities and total products ordered by that city.
SELECT
	C.City,
	COUNT(OD.ProductID) Total_Product
FROM
	dbo.Customers C
	LEFT JOIN
		dbo.Orders O
		ON O.CustomerID = C.CustomerID
	JOIN
		dbo.[Order Details] OD
		ON OD.OrderID = O.OrderID
GROUP BY
	C.City


--5. List all Customer Cities that have at least two customers.
--a. Use union
SELECT
	City
FROM
	dbo.Customers
GROUP BY
	City
HAVING
	COUNT(*) = 2

UNION

SELECT
	City
FROM
	dbo.Customers
GROUP BY
	City
HAVING
	COUNT(*) > 2

--b. Use sub-query and no union
SELECT DISTINCT
	City
FROM
	dbo.Customers
WHERE
	City IN
			(
				SELECT
					City
				FROM
					dbo.Customers
				GROUP BY
					City
				HAVING
					COUNT(*) >= 2
			)


--6. List all Customer Cities that have ordered at least two different kinds of products.
SELECT
	C.City,
	COUNT(OD.ProductID) Total_Product
FROM
	dbo.Customers C
	LEFT JOIN
		dbo.Orders O
		ON O.CustomerID = C.CustomerID
	JOIN
		dbo.[Order Details] OD
		ON OD.OrderID = O.OrderID
GROUP BY
	C.City
HAVING
	COUNT(OD.ProductID) >= 2


--7. List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.
SELECT DISTINCT
	C.CustomerID,
	C.ContactName,
	C.City,
	O.ShipCity
FROM
	dbo.Customers C
	JOIN
		dbo.Orders O
		ON O.CustomerID = C.CustomerID
WHERE
	C.City != O.ShipCity

	select * from dbo.[Order Details] order by ProductID
	select * from dbo.Products
--8. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
SELECT TOP 5
	P.ProductID,
	ROUND(SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) / SUM(OD.Quantity), 2) Average_Price,
	C.City
FROM
	dbo.Products P
	JOIN
		dbo.[Order Details] OD
		ON OD.ProductID = P.ProductID
	JOIN
		dbo.Orders O
		ON O.OrderID = OD.OrderID
	JOIN
		dbo.Customers C
		ON C.CustomerID = O.CustomerID
GROUP BY
	P.ProductID,
	C.City
ORDER BY
	SUM(OD.Quantity) DESC


--9. List all cities that have never ordered something but we have employees there.
--a. Use sub-query

SELECT
	City
FROM
	dbo.Employees
WHERE
	City NOT IN (
					SELECT
						C.City
					FROM
						dbo.Customers C
						JOIN
							dbo.Orders O
							ON O.CustomerID = C.CustomerID
				)

--b. Do not use sub-query
SELECT
	E.City
FROM
	dbo.Employees E
	LEFT JOIN
		dbo.Customers C
		ON C.City = E.City
WHERE
	C.City IS NULL


/*
10. List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, 
	and also the city of most total quantity of products ordered from. (tip: join  sub-query)
*/

SELECT
	City
FROM
	dbo.Customers
WHERE
	City = (
				SELECT TOP 1
					C.City
				FROM
					dbo.Customers C
					JOIN
						dbo.Orders O
						ON O.CustomerID = C.CustomerID
					JOIN
						dbo.[Order Details] OD
						ON OD.OrderID = O.OrderID
				GROUP BY
					C.City
				ORDER BY
					COUNT(O.OrderID) DESC
		   )
	AND City = (
					SELECT TOP 1
						C.City
					FROM
						dbo.Customers C
						JOIN
							dbo.Orders O
							ON O.CustomerID = C.CustomerID
						JOIN
							dbo.[Order Details] OD
							ON OD.OrderID = O.OrderID
					GROUP BY
						C.City
					ORDER BY
						SUM(OD.Quantity) DESC
			   )


--11. How do you remove the duplicates record of a table?
-- Distinct or Group by


/*
12. Sample table to be used for solutions below
	Employee (empid integer, mgrid integer, deptid integer, salary integer)
	Dept (deptid integer, deptname text)
	Find employees who do not manage anybody.
*/
SELECT
	E1.empid
FROM 
	Employee E1
WHERE 
	E1.empid NOT IN (
						SELECT 
							E2.mgrid
						FROM 
							Employee E2 
						WHERE 
							E2.mgrid = E1.empid
				   )

/*
13. Find departments that have maximum number of employees. (solution should 
	consider scenario having more than 1 departments that have maximum number of 
	employees). Result should only have - deptname, count of employees sorted by 
	deptname.
*/
With EmpCTE (deptid, empid, RK)
AS
	(
		SELECT
			deptid, 
			RANK() OVER (ORDER BY COUNT(empid) DESC) RK
		FROM 
			Employee
		GROUP BY
			deptid
	)

SELECT
	deptid,
	empid
FROM
	EmpCTE
WHERE
	RK = 1


/*
14. Find top 3 employees (salary based) in every department. Result should 
	have deptname, empid, salary sorted by deptname and then employee with 
	high to low salary.
*/
WITH EmpCTE (deptid, empid, salary, rnk)
AS
	(
		SELECT
			deptid,
			empid,
			salary,
			dense_rank() OVER (PARTITION BY d.deptid ORDER BY e.salary DESC) rnk
		FROM
			Employee
	)

SELECT
	empid
FROM
	EmpCTE
WHERE
	rnk <= 3