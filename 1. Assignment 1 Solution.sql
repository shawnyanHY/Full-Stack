USE [AdventureWorks2012]
----- 1 ----
select productid,Name,Color,ListPrice from [Production].[Product]

----- 2 -----
select productid,Name,Color,ListPrice from [Production].[Product] where ListPrice <> 0

----- 3 -----

select productid,Name,Color,ListPrice from [Production].[Product]  where color is null

----- 4 -----
select productid,Name,Color,ListPrice from [Production].[Product] where color is not null

----- 5 -----
select productid,Name,Color,ListPrice from [Production].[Product] where color is not null and ListPrice > 0

------ 6 ----
select Name+':'+color from production.Product where color is not null

----- 7 -----
select 'NAME: '+ name+' -- COLOR: '+ color from production.product where color is not null





------ 8 -------
select productid,Name from [Production].[Product] where productid between 400 and 500

----- 9 ------
select productid,Name,Color from [Production].[Product] where color in ('Black','Blue')

------ 10 -----
select productid,Name,Color,ListPrice from [Production].[Product] where name like 'S%' 

------ 11 -----
select Name,ListPrice from [Production].[Product] order by name

------ 12 ------
select Name,ListPrice from Production.Product where Name like 'S%' or Name like 'A%' 




----- 13 ------
SELECT [Name], ListPrice 
FROM Production.Product
WHERE [Name] LIKE 'spo[^k]%'
ORDER BY [Name]



------ 14 -----
select distinct Color from Production.Product order by Color desc


------ 15 ------
select distinct ProductSubcategoryID ,Color from Production.Product where Color is not null and ProductSubcategoryID is not null order by ProductSubcategoryID,Color

------- 16 -----
select ProductSubcategoryID,LEFT([NAME],35) AS [NAME],color,ListPrice from Production.Product
where ListPrice between 1000 and 2000 or ( ProductSubcategoryID = 1 and Color in ('Red','Black'))
order by ProductID



