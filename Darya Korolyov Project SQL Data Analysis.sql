--שאילה 1

SELECT ProductID,Name,Color,ListPrice,Size
FROM Production.Product
WHERE ProductID NOT IN
	(SELECT ProductID
	FROM Sales.SalesOrderDetail)
ORDER BY ProductID


--שאילה 2

SELECT SC.CustomerID, ISNULL (PP.LastName,'Unknown') AS "LastName",
ISNULL (PP.FirstName,'Unknown') AS "FirstName"
FROM  Sales.Customer SC LEFT JOIN Person.Person PP
ON SC.CustomerID = PP.BusinessEntityID
WHERE SC.CustomerID NOT IN 
	(SELECT CustomerID
	FROM Sales.SalesOrderHeader)
ORDER BY SC.CustomerID


--שאילה 3

SELECT TOP 10 SC.CustomerID,PP.FirstName, PP.LastName, 
COUNT (SOH.SalesOrderID) "CountofOrders"
FROM Sales.Customer SC JOIN Person.Person PP
ON SC.PersonID = PP.BusinessEntityID
JOIN Sales.SalesOrderHeader SOH
ON SOH.CustomerID=SC.CustomerID
GROUP BY SC.CustomerID,PP.FirstName, PP.LastName
ORDER BY CountofOrders DESC, SC.CustomerID


--שאילה 4

SELECT PP.FirstName,PP.LastName,HRE.JobTitle,HRE.HireDate,
COUNT (*) OVER (PARTITION BY HRE.JobTitle ORDER BY HRE.JobTitle) AS CountOfTitle
FROM HumanResources.Employee HRE JOIN Person.Person PP
ON HRE.BusinessEntityID = PP.BusinessEntityID


--שאילה 5

SELECT SalesOrderID,CustomerID,LastName,FirstName,OrderDate AS LastOrder, PreviosOrder
FROM
	(
	SELECT SOH.SalesOrderID, SC.CustomerID,PP.LastName,PP.FirstName,SOH.OrderDate,
	DENSE_RANK () OVER (PARTITION BY SOH.CustomerID ORDER BY SOH.OrderDate DESC) RN,
	LAG (SOH.OrderDate) OVER (PARTITION BY SOH.CustomerID ORDER BY SOH.OrderDate) AS PreviosOrder
	FROM Sales.Customer SC  JOIN Sales.SalesOrderHeader SOH
	ON SOH.CustomerID=SC.CustomerID
	JOIN  Person.Person PP
	ON SC.PersonID=PP.BusinessEntityID
	) AAA
WHERE RN=1 
ORDER BY LastName,CustomerID, LastOrder 

--שאילה 6


SELECT Year,SalesOrderID,LastName,FirstName,FORMAT (Total,'000,000.0') Total
FROM
	(
	SELECT YEAR (SOH.OrderDate) Year, SOH.SalesOrderID, PP.LastName,PP.FirstName,
	SUM (SOD.UnitPrice*(1-SOD.UnitPriceDiscount)*SOD.OrderQty) AS Total,
	ROW_NUMBER () OVER (PARTITION BY YEAR (SOH.OrderDate) 
	ORDER BY SUM (SOD.UnitPrice*(1-SOD.UnitPriceDiscount)*SOD.OrderQty) DESC) AS RN
		FROM Sales.SalesOrderHeader SOH JOIN Sales.Customer SC
		ON SOH.CustomerID = SC.CustomerID
		JOIN Person.Person PP
		ON SC.PersonID = PP.BusinessEntityID
		JOIN Sales.SalesOrderDetail SOD
		ON SOD.SalesOrderID = SOH.SalesOrderID
	GROUP BY YEAR (SOH.OrderDate), SOH.SalesOrderID, PP.LastName,PP.FirstName
	) DDD
WHERE RN = 1


--שאילה 7

SELECT Month,[2011], [2012], [2013], [2014]
FROM 	
	(SELECT YEAR (OrderDate) AS YY,MONTH (OrderDate) Month,SalesOrderID
	FROM Sales.SalesOrderHeader) OO
PIVOT (COUNT (SalesOrderID) FOR YY IN ([2011], [2012], [2013], [2014])) NEW
ORDER BY Month

--שאילה 8

SELECT *
FROM

	(SELECT Year,CAST(Month AS VARCHAR) Month,FORMAT (Sum_Price,'0.00') Sum_Price,
	FORMAT (SUM(Sum_Price) OVER(PARTITION BY Year ORDER BY Month
	ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),'0.00') CumSum
	FROM
		(
		SELECT YEAR (SOH.OrderDate) Year, 
		MONTH (SOH.OrderDate) Month,  
		SUM (SOD.UnitPrice*(1-SOD.UnitPriceDiscount)) Sum_Price
		FROM Sales.SalesOrderHeader SOH JOIN Sales.SalesOrderDetail SOD
		ON SOH.SalesOrderID = SOD.SalesOrderID
		GROUP BY YEAR (SOH.OrderDate), MONTH (SOH.OrderDate)
		)AA

	UNION

	SELECT  YEAR (SOH.OrderDate) Year, 'grand_total' Month,  
	NULL AS Sum_Price,FORMAT(SUM(SOD.UnitPrice*(1-SOD.UnitPriceDiscount)),'0.00') Cum_Sum
	FROM Sales.SalesOrderHeader SOH JOIN Sales.SalesOrderDetail SOD
	ON SOH.SalesOrderID = SOD.SalesOrderID
	GROUP BY YEAR (SOH.OrderDate)
)BB

ORDER BY Year,
	CASE 
		WHEN Month = 'grand_total'
		THEN 13
		ELSE CAST(Month AS INT)
		END


--שאילה 9

SELECT HRD.Name DepartmentName, HRE.BusinessEntityID AS "Employee'sID",
PP.FirstName + ' ' + PP.LastName AS "Employee'sFullName", HRE.HireDate,
DATEDIFF(MM,HRE.HireDate,GETDATE()) AS Seniority,
LAG (PP.FirstName + ' ' + PP.LastName) OVER (PARTITION BY HRD.Name ORDER BY HRE.HireDate) AS PreviosEmpName,
LAG (HRE.HireDate) OVER (PARTITION BY HRD.Name  ORDER BY EDH.DepartmentID) AS PreviosEmpHDate,
DATEDIFF(DD,LAG (HRE.HireDate,1) 
OVER (PARTITION BY HRD.Name   ORDER BY HRE.HireDate) ,HRE.HireDate)  AS DiffDay
	FROM HumanResources.Department HRD JOIN HumanResources.EmployeeDepartmentHistory EDH
	ON HRD.DepartmentID=EDH.DepartmentID
	JOIN HumanResources.Employee HRE
	ON EDH.BusinessEntityID=HRE.BusinessEntityID
	JOIN Person.Person PP
	ON PP.BusinessEntityID=EDH.BusinessEntityID
ORDER BY  DepartmentName,HireDate DESC, Seniority 



--שאילה 10

SELECT HireDate,DepartmentID,TeamEmployees
	FROM 
	(
	SELECT HireDate,DepartmentID,TeamEmployees,
	DENSE_RANK() OVER (PARTITION BY TeamEmployees
	ORDER BY  DepartmentID DESC) AS RN
		FROM 
		(
		SELECT  DISTINCT HRE1.HireDate, EDH1.DepartmentID,
		STUFF(
			(SELECT ','+CAST(HRE.BusinessEntityID AS VARCHAR)+' '+PP.LastName+' '+PP.FirstName 
			FROM HumanResources.Employee HRE JOIN Person.Person PP
			ON HRE.BusinessEntityID = PP.BusinessEntityID
			JOIN HumanResources.EmployeeDepartmentHistory EDH
			ON HRE.BusinessEntityID=EDH.BusinessEntityID 
			WHERE HRE.HireDate = HRE1.HireDate AND EDH.DepartmentID=EDH1.DepartmentID
			FOR XML PATH('')),1,1,'') TeamEmployees
		FROM HumanResources.EmployeeDepartmentHistory EDH1
		JOIN HumanResources.Employee  HRE1
		ON EDH1.BusinessEntityID=HRE1.BusinessEntityID
		) AA
	)BB
WHERE RN=1
ORDER BY HireDate DESC
-------------------------------

--אופציה נוספת לשאילה 10

--יש אנשים שעובדים לבד בכמה מחלקות 
--למשל
-- 250, Word Sheela  
-- הוא עובד לבד במחלקה 4 וגם במחלקה 5 וגם במחלקה 13 
--תאם לא נצמצם אותם אז תוצאות שאילתה תהיו בבכמות קצת יותר גדולה
--פלוס 5 שורות בתוצאה



SELECT  DISTINCT HRE1.HireDate, EDH1.DepartmentID,
	STUFF(
		(SELECT ','+CAST(HRE.BusinessEntityID AS VARCHAR)+' '+PP.LastName+' '+PP.FirstName 
		FROM HumanResources.Employee HRE JOIN Person.Person PP
		ON HRE.BusinessEntityID = PP.BusinessEntityID
		JOIN HumanResources.EmployeeDepartmentHistory EDH
		ON HRE.BusinessEntityID=EDH.BusinessEntityID 
		WHERE HRE.HireDate = HRE1.HireDate AND EDH.DepartmentID=EDH1.DepartmentID
		FOR XML PATH('')),1,1,'') TeamEmployees
FROM HumanResources.EmployeeDepartmentHistory EDH1
JOIN HumanResources.Employee  HRE1
ON EDH1.BusinessEntityID=HRE1.BusinessEntityID
ORDER BY HireDate DESC
