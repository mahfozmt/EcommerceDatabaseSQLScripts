--E-commerce Database,
--presented by MAHFOZUR RAHMAN, ID-1251275 ESAD-CS, Round-42.

USE master
GO
IF EXISTS (SELECT * FROM Sysdatabases WHERE NAME='EcomerceeDB')
BEGIN
	RAISERROR('Droping Existing database EcomerceeDB',0,1)
	DROP DATABASE EcomerceeDB
END
GO


--DATABASE manualy creating in dafault location
CREATE DATABASE EcomerceeDB
ON
(
	name=CollegeDB_data,
	filename='C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\EcomerceeDB_data.mdf',--File path location
	size=200 mb,
	filegrowth=5%,
	maxsize=1gb
)
LOG ON
(
	name=CollegeDB_log,
	filename='C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\EcomerceeDB_log.ldf',--File path location
	size=100 mb,
	filegrowth=5%,
	maxsize=500mb
)
GO

USE EcomerceeDB
GO

CREATE TABLE Category
(
	categoryId INT IDENTITY PRIMARY KEY,
	categoryName VARCHAR(100)
)
GO

CREATE TABLE Products
(
	ProductID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	ProductName varchar(500) NULL,
	CategoryId int NULL REFERENCES Category(categoryId) ,
	StockQuantity int NULL
)
GO

CREATE TABLE Customer
(
	CustomerId int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	CustomerName varchar(200) NULL,
	EmailId varchar(200) NULL,
	[Address] varchar(MAX) Not Null,
	mobile varchar(20) Not null
)
GO
CREATE TABLE OrderDitails
(
	OrderId INT IDENTITY,
	OrderDate DATE DEFAULT GETDATE(),
	CustomerId INT REFERENCES Customer(CustomerId),
	ProductID INT REFERENCES Products(ProductID),
	UnitPrice MONEY,
	Quantity int,
	TotalPrice AS (UnitPrice*Quantity),
	PaidAmount MONEY DEFAULT 0,
)
GO
CREATE TABLE Invoice
(
	InvoiceNo INT IDENTITY(100,1) PRIMARY KEY,
	InvoiceDate DATE DEFAULT GETDATE(),
	CustomerId INT REFERENCES Customer(CustomerId),
	BillTo VARCHAR(100),
	TotalBill INT ,
	PaidAmount MONEY,
	DueAmount AS (TotalBill-PaidAmount)
)
GO

--INDEX--
CREATE INDEX Ix_productName
ON Products(ProductName)
GO



--												***Store Procedure INSERT,UPDATE,DELETE***--



--INSERT
CREATE PROC sp_insertCategory
			@CategoryName VARCHAR(40)
AS INSERT INTO Category VALUES(@CategoryName)
GO  


--UPDATE
CREATE PROC sp_updateCategory
			@Id INT,
			@ProductName VARCHAR(40)
AS UPDATE Category SET categoryName=@ProductName WHERE categoryId=@Id
GO


--DELETE
CREATE PROC sp_deleteCategory
			@Id INT
AS DELETE FROM Category WHERE categoryId=@Id
GO

----------------------------                 ******TRIGGER********-----------------------------
CREATE TRIGGER trInsert_OrderDitails_to_enforce_inserting_Data_Invoice_Table_Aoutomatically
ON OrderDitails
AFTER INSERT
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		DECLARE @cId INT ,@cName VARCHAR(100),@totalBill INT,@pAmount MONEY,@qty INT,@date DATE
		SELECT @cId=i.CustomerId,@cName=c.CustomerName,@totalBill=i.TotalPrice,@pAmount=i.PaidAmount,@qty=i.Quantity,@date=i.OrderDate
		FROM inserted AS i LEFT OUTER JOIN Customer AS c ON c.CustomerId=i.CustomerId
		IF @qty<1
		BEGIN
					ROLLBACK TRANSACTION
					PRINT 'Order can''t be placed, Quantity should be one or more '
		END
		ELSE
				BEGIN
					PRINT 'Order Placed Succesfully! Invoice is ready also!!'
					INSERT INTO Invoice(InvoiceDate,CustomerId,BillTO,TotalBill,PaidAmount)
					VALUES (@date,@cId,@cName,@totalBill,@pAmount)
				END
	END TRY
	BEGIN CATCH

	END CATCH
	COMMIT TRANSACTION
END
GO
--******view******															

CREATE VIEW vOders_Information
AS
SELECT od.OrderId 'Order ID' ,c.CustomerName 'Customer Name', od.OrderDate 'Order Placed On',p.ProductName 'Ordered Product',
ct.categoryName 'Product category',i.InvoiceNo 'Invoice Number',i.TotalBill 'Total Payable',i.PaidAmount 'Paid',i.DueAmount 'Due'
FROM OrderDitails od
INNER JOIN Customer c on od.CustomerId=c.CustomerId
INNER JOIN Products p on od.OrderId=p.ProductID
INNER JOIN Category ct on p.CategoryId=ct.categoryId
INNER JOIN Invoice i on od.CustomerId=i.CustomerId
GO


---					      ***Scaler Function***

CREATE FUNCTION fnMonthlyInvoicesDueCalculation(@month INT, @year INT)
RETURNS MONEY
AS
	BEGIN
			DECLARE @t MONEY
			SELECT @t=SUM(DueAmount)  FROM Invoice i
			WHERE MONTH(i.InvoiceDate)=@month AND YEAR(i.InvoiceDate)=@year
	   RETURN @t
	END
GO
--



---							 ***Table Valued Function***
CREATE FUNCTION fnMonthlyInvoicesFullCalculation(@month INT, @year INT)
RETURNS TABLE
AS
RETURN 
		
		SELECT SUM(TotalBill)'Total Sale',SUM(PaidAmount)'Total Payment Recieved',SUM(DueAmount)'Total Due' FROM Invoice i		
		--WHERE i.InvoiceDate='10/10/2019'
		WHERE MONTH(i.InvoiceDate)=@month AND YEAR(i.InvoiceDate)=@year
GO










