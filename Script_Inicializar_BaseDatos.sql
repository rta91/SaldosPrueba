
--Crear BD prueba si no existe
IF NOT EXISTS (
    SELECT name
    FROM sys.databases
    WHERE name = N'PruebaRaul'
)
BEGIN
    create database PruebaRaul;
END
go
use PruebaRaul;
go
-- Crear tabla Gestores si no existe
IF NOT EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_NAME = 'Gestores'
)
BEGIN
    CREATE TABLE Gestores (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Nombre VARCHAR(20)
    );
	INSERT INTO Gestores (Nombre)
VALUES 
    ('Gestor 1'),
    ('Gestor 2'),
    ('Gestor 3'),
    ('Gestor 4'),
    ('Gestor 5'),
    ('Gestor 6'),
    ('Gestor 7'),
    ('Gestor 8'),
    ('Gestor 9'),
    ('Gestor 10');
END
go
-- Crear tabla Saldos si no existe
IF NOT EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_NAME = 'Saldos'
)
BEGIN
    CREATE TABLE Saldos (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Saldo INT NOT NULL
    );

INSERT INTO Saldos (Saldo)
VALUES 
    (2277), (3953), (4726), (1414), (627), (1784), (1634), (3958), (2156), (1347), 
    (2166), (820), (2325), (3613), (2389), (4130), (2007), (3027), (2591), (3940), 
    (3888), (2975), (4470), (2291), (3393), (3588), (3286), (2293), (4353), (3315), 
    (4900), (794), (4424), (4505), (2643), (2217), (4193), (2893), (4120), (3352), 
    (2355), (3219), (3064), (4893), (272), (1299), (4725), (1900), (4927), (4011);
END
-- Crear tabla GestorSaldos si no existe
IF NOT EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_NAME = 'GestorSaldos'
)
BEGIN
CREATE TABLE GestorSaldos (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    GestorId INT NOT NULL,
    SaldoId INT NOT NULL,
    FOREIGN KEY (GestorId) REFERENCES Gestores(Id),
    FOREIGN KEY (SaldoId) REFERENCES Saldos(Id)
);
END

select * from Saldos
select * from Gestores

select gs.GestorId,g.Nombre,s.Saldo from GestorSaldos gs
left join Saldos s on s.Id = gs.SaldoId
left join Gestores g on g.Id = gs.GestorId
order by g.Id asc,s.Saldo desc

truncate table GestorSaldos;


-- Declarar variables
DECLARE @CantidadGestores INT, @Indice INT, @GestorId INT, @SaldoId INT, @Iteracion INT

-- Obtener la cantidad de gestores y saldos
SELECT @CantidadGestores = COUNT(*) FROM Gestores
DECLARE @ConteoSaldos INT = (SELECT COUNT(*) FROM Saldos)

-- Calcular el número de iteraciones usando CEILING para redondear hacia arriba
DECLARE @TotalIteraciones INT
SET @TotalIteraciones = CEILING(CAST(@ConteoSaldos AS FLOAT) / @CantidadGestores)

-- Variable para el índice de gestor
SET @Indice = 1
SET @Iteracion = 1

-- Cursor para recorrer los saldos ordenados en orden descendente y asignar a los gestores
DECLARE SaldoCursor CURSOR FOR
SELECT Id FROM Saldos ORDER BY Saldo DESC

OPEN SaldoCursor

FETCH NEXT FROM SaldoCursor INTO @SaldoId

WHILE @@FETCH_STATUS = 0 AND @Iteracion <= @TotalIteraciones
BEGIN
    -- Realizar 10 inserciones por iteración
    DECLARE @InsertsCount INT = 0
    
    WHILE @InsertsCount < @CantidadGestores
    BEGIN
        -- Obtener el GestorId basado en el índice
        SELECT @GestorId = Id FROM Gestores WHERE Id = @Indice
        
        -- Insertar en GestorSaldos
        INSERT INTO GestorSaldos (GestorId, SaldoId)
        VALUES (@GestorId, @SaldoId)
        
        -- Incrementar el índice
        SET @Indice = @Indice + 1
        
        -- Reiniciar el índice si excede el número de gestores
        IF @Indice > @CantidadGestores
        BEGIN
            SET @Indice = 1
        END
        
        SET @InsertsCount = @InsertsCount + 1
        
        -- Obtener el siguiente saldo
        FETCH NEXT FROM SaldoCursor INTO @SaldoId
    END
    
    SET @Iteracion = @Iteracion + 1
END

CLOSE SaldoCursor
DEALLOCATE SaldoCursor


