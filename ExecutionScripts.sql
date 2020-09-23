USE EcomerceeDB
GO
EXEC sp_insertCategory 'FASHION'
GO
EXEC sp_insertCategory 'SHOES'
GO
EXEC sp_insertCategory 'COSMETICS'
GO
EXEC sp_insertCategory 'HOME APPLIENCE'
GO
EXEC sp_insertCategory 'MOBILE PHONE'
GO
EXEC sp_insertCategory 'ELECTRONICS'
GO


--PRODUCTS
INSERT INTO Products VALUES('T-SHIRT',1,100)
INSERT INTO Products VALUES('Long Panjabi',1,40)
INSERT INTO Products VALUES('Casual Shirt',1,70)
INSERT INTO Products VALUES('Canvas Sneaker',2,90)
INSERT INTO Products VALUES('Lather Sandal',2,40)
INSERT INTO Products VALUES('Plastic Sandal',2,65)
INSERT INTO Products VALUES('MAC Lipstic',3,110)
INSERT INTO Products VALUES('Colormax Kajal',3,40)
INSERT INTO Products VALUES('Absolute Faoundation Beauty',3,30)
INSERT INTO Products VALUES('Sharp Juicer',4,90)
INSERT INTO Products VALUES('Vishion Micro Woven',4,40)
INSERT INTO Products VALUES('Philips Iron',4,65)
INSERT INTO Products VALUES('Sharp Juicer',5,94)
INSERT INTO Products VALUES('Vishion Micro Woven',5,44)
INSERT INTO Products VALUES('Philips Iron',5,51)
GO

--Customers
INSERT INTO Customer VALUES('Mahfuz','mahfoz231@gmail.com','Lalbag','01758091506'),
('Akramuzzaman','mahfoz231@gmail.com','Lalbag','01758091506'),
('Selim','atik1243@gmail.com','Azimpur','018456632112'),
('Ruman','romanidb@gmail.com','Mohammadpur','01475654123'),
('Siddik','smsiddik@gmail.com','Shymoli','01342567575'),
('Sajol','sssajol453@gmail.com','Panthapath','01748596423')
GO


--OrderDitails
INSERT INTO OrderDitails VALUES('10/10/2019',2,1,500,2,800)
INSERT INTO OrderDitails VALUES(DEFAULT,1,6,758,4,2000)
INSERT INTO OrderDitails VALUES('10/10/2019',4,2,800,2,1350)
INSERT INTO OrderDitails VALUES('10/10/2019',4,1,500,1,200)
INSERT INTO OrderDitails VALUES(DEFAULT,5,8,900,2,1800)
INSERT INTO OrderDitails VALUES('10/10/2019',3,3,890,2,1300)
INSERT INTO OrderDitails VALUES('10/10/2019',6,8,990,2,1300)
GO
----					Table Data -----
SELECT * FROM Category
GO
SELECT * FROM Products
GO
SELECT * FROM Customer
GO
SELECT * FROM OrderDitails
GO
SELECT * FROM Invoice
GO

---				INDEX Showing by Table information		---
EXEC sp_help Products

--				Store Procedure test ------

--**Insert
EXEC sp_insertCategory 'Furtre'
GO
---
SELECT * FROM Category--(For Show)


--***Update
EXEC sp_updateCategory 7,'FUNITURE'
GO
--
SELECT * FROM Category  --(For Show)

---***Delete
EXEC sp_deleteCategory 7
--
SELECT * FROM Category  --(For Show)


---							********View******* ------------
SELECT * FROM vOders_Information
GO

--						******** Scaler Function*********
SELECT dbo.fnMonthlyInvoicesDueCalculation(10,2019) 'Total Due That Month'

--						******** Table Valued Function*********
SELECT * FROM dbo.fnMonthlyInvoicesFullCalculation(10,2019)
