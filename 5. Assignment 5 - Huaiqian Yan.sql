/*
1. What is an object in SQL?

A database object is any defined object in a database that is used to store or reference data. 
Anything which we make from create command is known as Database Object.
*/



/*
8. What is normalization? What are the steps (normal forms) to achieve normalization?

Database Normalization is a process of organizing data to minimize redundancy (data duplication), 
which in turn ensures data consistency. 

1NF: - Data in each column should be atomic, no multiples values separated by comma.
	 - The table does not contain any repeating column group.
	 - Identify each record using primary key.
2NF: - The table must meet all the conditions of 1NF.
	 - Move redundant data to separate table.
	 - Create relationships between these tables using foreign keys.
3NF: - Table must meet all the conditions of 1NF and 2nd.
	 - Does not contain columns that are not fully dependent on primary key.
*/



/*
9. What is denormalization and under which scenarios can it be preferable?

Denormalization is a database optimization technique in which we add redundant data to one or more 
tables. This can help us avoid costly joins in a relational database.
*/



/*
10. How do you achieve Data Integrity in SQL Server?

- Entity Integrity: primary key
- Referential Integrity: foreign key
- Domain Integrity: constraints
*/



/*
11. What are the different kinds of constraint do SQL Server have?

NOT NULL
UNIQUE
PRIMARY KEY
FOREIGN KEY
CHECK
DEFAULT
*/



/*
12. What is the difference between Primary Key and Unique Key?

Primary key does not allows null values but unique key allows.
*/



/*
13. What is foreign key?

A foreign key (FK) is a column or combination of columns that is used to establish and enforce a 
link between the data in two tables. You can create a foreign key by defining a FOREIGN KEY 
constraint when you create or modify a table. 
*/



/*
14. Can a table have multiple foreign keys?

Yes
*/



/*
15. Does a foreign key have to be unique? Can it be null?

It can be duplicate and null.
*/



/*
17. What is Transaction? What types of transaction levels are there in SQL Server?

Transactions by definition are a logical unit of work  Transaction is a single recoverable unit 
of work that executes either:
	- Completely
	- Not at all

- Autocommit transactions
- Explicit transactions
- Implicit transactions
- Batch-scoped transactions
*/


USE Antra
GO


/*
1. Write an sql statement that will display the name of each customer and the sum of order totals 
   placed by that customer during the year 2002
*/

DROP TABLE IF EXISTS customer
CREATE TABLE customer
(
	cust_id INT,
	iname VARCHAR(50)
)

DROP TABLE IF EXISTS [order]
CREATE TABLE [order]
(
	order_id INT,
	cust_id INT,
	amount MONEY,
	order_date SMALLDATETIME
)
GO

SELECT
	iname,
	SUM(amount) AS Total_Amount
FROM
	customer AS c
	JOIN [order] AS o
		ON o.cust_id = c.cust_id
WHERE
	YEAR(order_date) = 2002
GROUP BY
	iname



/*
2. The following table is used to store information about company’s personnel:
   Write a query that returns all employees whose last names start with “A”.
*/
DROP TABLE IF EXISTS person
CREATE TABLE person
(
	id INT,
	firstname VARCHAR(100),
	lastname VARCHAR(100)
)
GO

SELECT
	*
FROM
	person
WHERE
	lastname LIKE 'A%'



/*
3. The information about company’s personnel is stored in the following table:
   The filed managed_id contains the person_id of the employee’s manager.
   Please write a query that would return the names of all top managers (an 
   employee who does not have  a manger, and the number of people that report directly to this manager).

*/
DROP TABLE IF EXISTS person
CREATE TABLE person
(
	person_id INT PRIMARY KEY,
	manager_id INT NULL,
	name VARCHAR(100) NOT NULL
)
GO

--Find the top managers and the quantity of their subordinates
WITH Top_Manager_CTE (person_id, Subordinate_Quantity)
AS
(
	SELECT
		manager_id,
		COUNT(person_id) AS Subordinate_Quantity
	FROM
		dbo.person
	WHERE
		manager_id IN (
						SELECT 
							person_id
						FROM
							dbo.person
						WHERE
							manager_id IS NULL
					 )
	GROUP BY
		manager_id		
)

--Get names of the top managers
SELECT
	p.name,
	tm.Subordinate_Quantity
FROM
	dbo.person p
	JOIN Top_Manager_CTE tm
		ON tm.person_id = p.person_id

--USE Northwind
--GO

--WITH Top_Manager_CTE (EmployeeID, Subordinate_Quantity)
--AS
--(
--	SELECT
--		ReportsTo,
--		COUNT(EmployeeID) AS Subordinate_Quantity
--	FROM
--		dbo.Employees
--	WHERE
--		ReportsTo IN (
--						SELECT 
--							EmployeeID
--						FROM
--							dbo.Employees
--						WHERE
--							ReportsTo IS NULL
--					 )
--	GROUP BY
--		ReportsTo
--)

--SELECT
--	e.EmployeeID,
--	e.LastName,
--	tm.Subordinate_Quantity
--FROM
--	dbo.Employees e
--	JOIN Top_Manager_CTE tm
--		ON tm.EmployeeID = e.EmployeeID



/*
4. List all events that can cause a trigger to be executed.

INSERT, UPDATE, DELETE
*/



/*
5. Generate a destination schema in 3rd Normal Form. Include all necessary fact, join, and dictionary 
   tables, and all Primary and Foreign Key relationships. The following assumptions can be made:
   a. Each Company can have one or more Divisions.
   b. Each record in the Company table represents a unique combination 
   c. Physical locations are associated with Divisions.
   d. Some Company Divisions are collocated at the same physical of Company Name and Division Name.
   e. Contacts can be associated with one or more divisions and the address, but are differentiated 
      by suite/mail drop records.status of each association should be separately maintained and audited.
*/
