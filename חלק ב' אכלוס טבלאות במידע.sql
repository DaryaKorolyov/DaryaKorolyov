

INSERT Sales.SpecialOfferProduct
SELECT *
FROM AdventureWorks2022.Sales.SpecialOfferProduct

INSERT  Sales.CreditCard
SELECT *
from AdventureWorks2022.Sales.CreditCard

INSERT Sales.Person.Address
SELECT *
FROM AdventureWorks2022.Person.Address


INSERT  Sales.CurrencyRate
SELECT *
from AdventureWorks2022.Sales.CurrencyRate


INSERT  Sales.Pursharing.ShipMethod
SELECT *
from AdventureWorks2022.Purchasing.ShipMethod


INSERT Sales.SalesTerritory
SELECT *
FROM AdventureWorks2022.Sales.SalesTerritory


INSERT  Sales.Customer
SELECT *
from AdventureWorks2022.Sales.Customer


INSERT Sales.SalesPerson
SELECT *
FROM AdventureWorks2022.Sales.SalesPerson


INSERT Sales.SalesOrderHeader
SELECT SalesOrderID,RevisionNumber,OrderDate,DueDate,ShipDate,Status,OnlineOrderFlag,
SalesOrderNumber,PurchaseOrderNumber,AccountNumber,CustomerID,SalesPersonID,TerritoryID,
BillToAddressID,ShipToAddressID,ShipMethodID,CreditCardID,CreditCardApprovalCode,CurrencyRateID,
SubTotal,TaxAmt,Freight
FROM AdventureWorks2022.Sales.SalesOrderHeader



INSERT  Sales.SalesOrderDetail
SELECT *
from AdventureWorks2022.Sales.SalesOrderDetail
