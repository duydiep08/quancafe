CREATE DATABASE QUANLYQUANCAFE
GO

USE QUANLYQUANCAFE
GO

--Food
--Table
--FoodCategory
--Account
--Bill
--BillInfo

 CREATE TABLE TableFood
(
   id INT IDENTITY PRIMARY KEY,
   name NVARCHAR(100) NOT NULL DEFAULT N'bàn chưa có tên',
   status NVARCHAR(100) DEFAULT N'trống'   --TRỐNG|| CÓ NGƯỜI
 )
 GO

  CREATE TABLE Account
(
   UserName NVARCHAR(100) PRIMARY KEY,
   DisplayName NVARCHAR(100) NOT NULL,
  
   PassWord NVARCHAR(100) NOT NULL,
   Type INT NOT NULL DEFAULT 0 --1: admin||0: staff
)
GO

 CREATE TABLE FoodCategory
(
   id INT IDENTITY PRIMARY KEY,
   name NVARCHAR(100) NOT NULL DEFAULT N'Chua dat ten'
)
GO

 CREATE TABLE Food
(
   id INT IDENTITY PRIMARY KEY,
   name NVARCHAR(100) NOT NULL,
   idCategory INT NOT NULL,
   price FLOAT NOT NULL DEFAULT 0

   FOREIGN KEY (idCategory) REFERENCES dbo.FoodCategory(id)
)
GO

CREATE TABLE Bill
(
   id INT IDENTITY PRIMARY KEY,
   DateCheckIn DATE NOT NULL DEFAULT GETDATE(),
   DateCheckOut DATE,
   idTable INT NOT NULL,
   status INT NOT NULL --1: đã thanh toán|| 0: chưa thanh toán

   FOREIGN KEY(idTable) REFERENCES dbo.TableFood(id)
)
GO

CREATE TABLE BillInfo
(
   id INT IDENTITY PRIMARY KEY,
   idBill INT NOT NULL,
   idFood INT NOT NULL,
   count INT NOT NULL DEFAULT 0

   FOREIGN KEY(idBill) REFERENCES dbo.Bill(id),
   FOREIGN KEY(idFood) REFERENCES dbo.Food(id)
)
GO
 
 INSERT INTO dbo.Account
 (
     UserName,
     DisplayName,
     PassWord,
     Type
 )
 VALUES
 (   N'admin', -- UserName - nvarchar(100)
     N'admin1', -- DisplayName - nvarchar(100)
     N'1', -- PassWord - nvarchar(100)
     1    -- Type - int
     )

 INSERT INTO dbo.Account
 (
     UserName,
     DisplayName,
     PassWord,
     Type
 )
 VALUES
 (   N'staff', -- UserName - nvarchar(100)
     N'staff1', -- DisplayName - nvarchar(100)
     N'1', -- PassWord - nvarchar(100)
     0    -- Type - int
     )
GO

CREATE PROC USP_GetAccountByUserName
@userName nvarchar(100)
AS
BEGIN
      SELECT *FROM dbo.Account WHERE UserName = @userName
END
GO 

EXEC dbo.USP_GetAccountByUserName @userName = N'admin' -- nvarchar(100)
GO

CREATE PROC USP_Login	
@userName nvarchar(100), @passWord nvarchar(100)
AS
BEGIN
   SELECT * FROM dbo.Account WHERE UserName = @userName AND PassWord = @passWord
END
GO



--thêm bàn
DECLARE @i INT = 1

WHILE @i<=12
BEGIN
   INSERT dbo.TableFood ( name) VALUES ( N'Bàn '+ CAST(@i AS nvarchar(100)))
   SET @i = @i +1
END
GO

CREATE PROC USP_GetTableList
AS SELECT * FROM dbo.TableFood
GO

UPDATE dbo.TableFood SET STATUS = N'Có người'WHERE id = 76

EXEC dbo.USP_GetTableList
GO


--thêm category
INSERT dbo.FoodCategory
    (name)
VALUES(N'Hải sản') 

INSERT dbo.FoodCategory
    (name)
VALUES(N'Nông sản')

INSERT dbo.FoodCategory
    (name)
VALUES(N'Lâm sản')

INSERT dbo.FoodCategory
    (name)
VALUES(N'Sản sản')
INSERT dbo.FoodCategory
    (name)
VALUES(N'Nước')




--thêm món ăn
INSERT dbo.Food
( name,   idCategory,   price)
VALUES( N'Mực nướng', 41, 120000)

INSERT dbo.Food
( name,   idCategory,   price)
VALUES( N'Nghêu hấp xả', 41,50000)

INSERT dbo.Food
( name,   idCategory,   price)
VALUES( N'vú sữa', 42,20000)

INSERT dbo.Food
( name,   idCategory,   price)
VALUES( N'Heo rừng', 43,120000)

INSERT dbo.Food
( name,   idCategory,   price)
VALUES( N'Cơm chiên', 44,50000)

INSERT dbo.Food
( name, idCategory, price)
VALUES( N'7Up', 45, 12000 ) 





   --them Bill
INSERT dbo.Bill
(DateCheckIn,DateCheckOut,idTable,status)
VALUES
( GETDATE(), -- DateCheckIn - date
   NULL, -- DateCheckOut - date
    73,         -- idTable - int
    0          -- status - int
    )

INSERT dbo.Bill
(DateCheckIn,DateCheckOut,idTable,status)
VALUES
(   GETDATE(), -- DateCheckIn - date
   NULL, -- DateCheckOut - date
    74,         -- idTable - int
    0          -- status - int
    )

INSERT dbo.Bill
(DateCheckIn,DateCheckOut,idTable,status
)
VALUES
(   GETDATE(), -- DateCheckIn - date
   GETDATE(), -- DateCheckOut - date
    75,         -- idTable - int
    1          -- status - int
    )
   

 
--thêm billinfo
INSERT dbo.BillInfo
(idBill,idFood,count)
VALUES
(   68, -- idBill - int
    45, -- idFood - int
    10  -- count - int
    )

INSERT dbo.BillInfo
(idBill, idFood, count)
VALUES
(   1, -- idBill - int
    3, -- idFood - int
    4  -- count - int
    )

INSERT dbo.BillInfo
( idBill, idFood, count)
VALUES
(   1, -- idBill - int
    5, -- idFood - int
   1  -- count - int
    )

INSERT dbo.BillInfo
( idBill, idFood, count)
VALUES
(   2, -- idBill - int
    6, -- idFood - int
    2  -- count - int
    )

INSERT dbo.BillInfo
( idBill, idFood, count
)
VALUES
(   3, -- idBill - int
    5, -- idFood - int
    2  -- count - int
    )
GO
  



 CREATE PROC USP_InsertBill
 @idTable INT
 AS
 BEGIN
	INSERT dbo.Bill
	(
	    DateCheckIn,
	    DateCheckOut,
	    idTable,
	    status
	)
	VALUES
	(   GETDATE(), -- DateCheckIn - date
	    NULL, -- DateCheckOut - date
	    @idTable,         -- idTable - int
	    0          -- status - int
	    )
 END
 GO 


CREATE PROC USP_InsertBillInfo
 @idBill INT, @idFood INT, @count INT
 AS
 BEGIN
  
	DECLARE @isExitsBillInfo INT;
	DECLARE @foodCount INT = 1

	SELECT @isExitsBillInfo = id, @foodCount = b.count 
	FROM dbo.BillInfo  AS b 
	WHERE idBill =@idBill AND idFood = @idFood

	IF (@isExitsBillInfo > 0)
	BEGIN
		DECLARE @newCount INT = @foodCount +@count
		IF(@newCount > 0)
			UPDATE dbo.BillInfo SET count = @foodCount +@count WHERE idFood = @idFood 
        ELSE 
			DELETE dbo.BillInfo WHERE idBill = @idBill AND idFood = @idFood
	END
	ELSE 
	BEGIN
	
		INSERT dbo.BillInfo
			(idBill,idFood, count)
		VALUES
			(   @idBill, -- idBill - int
				 @idFood, -- idFood - int
				@count  -- count - int
			 )
	END     
 END
 GO


 
 UPDATE dbo.Bill SET status = 0WHERE id = idTable

ALTER TRIGGER UTG_UpdateBillInfo
 ON dbo.BillInfo FOR INSERT , UPDATE 
 AS 
 BEGIN
    DECLARE @idBill INT

	SELECT @idBill FROM Inserted 

	DECLARE @idTable INT 

	SELECT @idTable = idTable FROM dbo.Bill WHERE id = @idBill AND status = 0

	UPDATE dbo.TableFood SET status = N'Có người' WHERE id = @idTable
 END 
 GO 

ALTER TRIGGER UTG_UpdateBill
 ON dbo.Bill FOR UPDATE
 AS
 BEGIN
	DECLARE @idBill INT

	SELECT @idBill = id FROM Inserted

	DECLARE @idTable INT 

	SELECT @idTable = idTable FROM dbo.Bill WHERE id = @idBill 

	DECLARE @count INT = 0

	SELECT @count = COUNT(*) FROM dbo.Bill WHERE idTable = @idTable and status = 0

	IF(@count = 0)
		UPDATE dbo.TableFood SET status = N'Trống' WHERE id = @idTable
    
 END
 GO 


 SELECT f.name, bi.count, f.price, f.price*bi.count AS totalPrice FROM dbo.BillInfo AS bi, dbo.Bill AS b, dbo.Food AS f WHERE bi.idBill = b.id AND bi.idFood = f.id AND b.status = 0 AND b.idTable =1


