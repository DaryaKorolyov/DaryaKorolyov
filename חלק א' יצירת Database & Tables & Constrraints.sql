
create DATABASE Sales
go
use Sales
go
create schema Sales
go
create schema Pursharing
go
create schema Person
go


 create table Sales.SalesTerritory (
 TerritoyID int primary key not null,
 Name nvarchar(50) not null,
 CountryRegionCode nvarchar(3) not null,
 [Group] nvarchar (50) not null,
 SalesYTD money not null,
 SalesLastYear money not null,
 CostYTD money not null,
 CostLastYear money not null,
 rowquid uniqueidentifier not null,
 ModifiedDate datetime not null
 )

create table Pursharing.ShipMethod(
ShipMethodID int primary key not null,
Name nvarchar (50) not null,
ShipBase money not null,
ShipRate money not null,
rowguid uniqueidentifier not null,
ModifiedDate datetime not null
)

create table Person.Address(
AddressID int primary key not null,
AddressLine nvarchar (60) not null,
AddressLine2 nvarchar(60),
City nvarchar (30) not null,
StateProvanceID int not null,
PostalCode nvarchar(15) not null,
SpationLocation geography,
rowguid uniqueidentifier not null,
ModifiedDate datetime not null
)

create table Sales.Customer (
CustomerID int primary key not null,
PersonID int,
StoreID int,
TerritoryID int,
AccountNumber varchar(10) not null,
rowguid uniqueidentifier not null,
ModifiedDate datetime not null,
foreign key (TerritoryID) references Sales.SalesTerritory
)


 create table Sales.SalesPerson (
 BusinessEntityID int primary key not null,
 TerritoryID int,
 SalesQuota money,
 Bonus money not null,
 CommissionPCT smallmoney not null,
 SalesYTD money not null,
 SalesLastYear money not null,
 rowquid uniqueidentifier not null,
 ModifiedDate datetime not null,
 foreign key (TerritoryID) references Sales.SalesTerritory 
 )

create table Sales.CreditCard (
CreditCardID int primary key,
CardType nvarchar(50) not null,
CardNumber nvarchar (25) not null,
ExpMonth tinyint not null,
ExpYear smallint not null,
ModifiedDate datetime not null
)

create table Sales.SpecialOfferProduct (
SpecialOfferId int not null,
ProductID int not null,
rowguid uniqueidentifier not null,
ModifiedDate datetime not null,
primary key (SpecialOfferId,ProductID)
)

create table Sales.CurrencyRate (
CurrencyRateID int primary key not null,
CurrencyRateDate datetime not null,
FromCurrencyCode nchar(3) not null,
ToCurrencyCode nchar(3) not null,
AverageRate money not null,
EndOfDayRate money not null,
ModifiedDate datetime not null
)

create table Sales.SalesOrderHeader (
SalesOrderID int primary key not null,
RevisionNumber tinyint not null,
OrderDate datetime not null,
DueDate datetime not null,
ShipDate datetime,
Status tinyint not null,
OnlineOrderFlag bit not null,
SalesOrderNumber nvarchar (50) not null,
PurshaseOrderNumber nvarchar (50),
AccountNumber nvarchar (50),
CustomerId int,
SalesPersonID int,
TerritoryID int,
BillToAddressID int not null,
ShipToAddressID int not null,
ShipMethodID int not null,
CreditCardID int,
CreditCardApprovalCode varchar(15),
CurrencyRateID int,
SubTotal money not null,
TaxAmt money not null,
Freight money not null,
foreign key (customerID) references Sales.Customer,
foreign key (TerritoryID) references Sales.SalesTerritory,
foreign key (SalesPersonID) references  Sales.SalesPerson,
foreign key (CreditCardID) references Sales.CreditCard,
foreign key (ShipToAddressID) references Person.Address,
foreign key (ShipMethodID) references Pursharing.ShipMethod,
foreign key (CurrencyRateID) references Sales.CurrencyRate,
)

 

create table Sales.SalesOrderDetail (
SalesOrderID int not null,
SalesOrderDetailID int not null,
CarrierTrackingNumber nvarchar(25),
OrderCTY smallint not null,
ProductID int not null,
SpecialOfferId int not null,
Initprice money not null,
UnitPriceDiscount money not null,
LineTotal numeric(38,6) not null,
rowguid uniqueidentifier not null,
ModifiedDate datetime not null
primary key (SalesOrderID,SalesOrderDetailID),
foreign key (SalesOrderID) references Sales.SalesOrderHeader,
foreign key (SpecialOfferID,ProductID) references SAles.SpecialOfferProduct)

