/*
1. What is View? What are the benefits of using views?

View is a saved SQL query. It can also be considered as a virtual table.
- Reduce the complexity of the database schema.
- Implement row and column level security.
- Present aggregated data and hide detailed data.
*/


/*
2. Can data be modified through views?

Yes.
*/


/*
3. What is stored procedure and what are the benefits of using it?

A stored procedure is group of T-SQL statements.
It can save your a lot of time if some statements will repeat.
*/


/*
4. What is the difference between view and stored procedure?

A view represents a virtual table.
A stored procedure uses parameters to do a function.
*/


/*
5. What is the difference between stored procedure and functions?

- The function must return a value but in Stored Procedure it is optional. Even a procedure can return zero or n values.
- Functions can have only input parameters for it whereas Procedures can have input or output parameters.
- Functions can be called from Procedure whereas Procedures cannot be called from a Function.
*/


/*
6. Can stored procedure return multiple result sets?

Yes
*/


/*
7. Can stored procedure be executed as part of SELECT Statement? Why?

No becasue procedures can return any number of result sets and change data.
*/


/*
8. What is Trigger? What types of Triggers are there?

Triggers are a special type of stored procedure that get executed (fired) when a specific event happens.
- After triggers
	- INSERT
	- UPDATE
	- DELETE
- Instead of triggers
*/


/*
9. What are the scenarios to use Triggers?

Enforce Integrity beyond simple Referential Integrity
Implement business rules
Maintain audit record of changes
Accomplish cascading updates and deletes
*/


/*
10. What is the difference between Trigger and Stored Procedure?

Tigger cannot be called manually, but stored procedure can.
*/


USE Northwind
GO


/*
1. Lock tables Region, Territories, EmployeeTerritories and Employees. Insert 
   following information into the database. In case of an error, no changes 
   should be made to DB.
*/
--a. A new region called “Middle Earth”;
INSERT INTO dbo.Region
VALUES (5, 'Middle Earth')

--b. A new territory called “Gondor”, belongs to region “Middle Earth”;
INSERT INTO dbo.Territories
VALUES (12345, 'Gondor', 5)

--c. A new employee “Aragorn King” who's territory is “Gondor”.
INSERT INTO dbo.Employees (LastName, FirstName)
VALUES ('King', 'Aragorn')

INSERT INTO dbo.EmployeeTerritories
VALUES (10, 12345)


--2. Change territory “Gondor” to “Arnor”.
UPDATE dbo.Territories
SET	TerritoryDescription = 'Arnor'
WHERE
	TerritoryDescription = 'Gondor'


/*
3. Delete Region “Middle Earth”. (tip: remove referenced data first) 
   (Caution: do not forget WHERE or you will delete everything.) In case 
   of an error, no changes should be made to DB. Unlock the tables mentioned 
   in question 1.
*/
DELETE FROM dbo.Employees WHERE EmployeeID = 10
DELETE FROM dbo.EmployeeTerritories WHERE TerritoryID = 12345
DELETE FROM dbo.Territories WHERE RegionID = 5
DELETE FROM dbo.Region WHERE RegionID = 5
GO

/*
4. Create a view named “view_product_order_[your_last_name]”, list all products 
   and total ordered quantity for that product.
*/
CREATE VIEW dbo.view_product_order_Yan
AS
SELECT
	ProductID,
	SUM(Quantity) AS Total_Quantity
FROM
	dbo.[Order Details]
GROUP BY
	ProductID
GO


/*
5. Create a stored procedure “sp_product_order_quantity_[your_last_name]” that 
   accept product id as an input and total quantities of order as output parameter.
*/
CREATE PROC dbo.sp_product_order_quantity_Yan
	@ProductID INT,
	@Total_Quantity INT OUT
AS
	SELECT
		@Total_Quantity = SUM(Quantity)
	FROM
		dbo.[Order Details]
	WHERE
		ProductID = @ProductID
GO


/*
6. Create a stored procedure “sp_product_order_city_[your_last_name]” that accept 
   product name as an input and top 5 cities that ordered most that product 
   combined with the total quantity of that product ordered from that city as output.
*/
--CREATE PROC dbo.sp_product_order_city_Yan
--	@ProductName NVARCHAR(40),
--	@Top_5 
--	@Total_Quantity INT OUT
--AS
--	SELECT
--		@Total_Quantity = SUM(Quantity)
--	FROM
--		dbo.[Order Details]
--	WHERE
--		ProductID = @ProductID
--GO