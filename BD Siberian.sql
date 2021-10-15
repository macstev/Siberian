create database SiberianDB
go

use SiberianDB
go

create table Ciudad(
IDCiudad INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
NombreCiudad VARCHAR(100),
FechaCreacion DATETIME)create table Restaurantes(
IDRestaurante INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
NombreRestaurante VARCHAR(100),
IDCiudad INT ,NumeroAforo INT,Telefono INT,FechaCreacion DATETIME,CONSTRAINT fk_Ciudad FOREIGN KEY (IDCiudad) REFERENCES Ciudad (IDCiudad))



CREATE PROCEDURE Sp_Restauranes   
    @Opcion nvarchar(50),   
    @Buscar_NombreRestaurante nvarchar(50) NULL,
	@Insertar_NombreRestaurante nvarchar(50) NULL,
	@Insertar_NombreCiudad nvarchar(50) NULL,
	@Insertar_NumeroAforo int NULL,
	@Insertar_Telefono int NULL,
	@Actualizar_NombreRestaurante nvarchar(50) NULL,
	@Actualizar_NombreCiudad nvarchar(50) NULL,
	@Actualizar_NumeroAforo int NULL,
	@Actualizar_Telefono int NULL,
	@Eliminar_Restaurante nvarchar(50) NULL

AS  
BEGIN
    Declare @Insertar_ID_CIUDAD int
	Declare @Insertar_Existe_Restauran nvarchar(50)
	Declare @Actualizar_Existe_Restauran nvarchar(50)
	Declare @Actualizar_Existe_Ciudad nvarchar(50)
	Declare @Eliminar_Existe_Restauran nvarchar(50)

	IF @Opcion='LISTA_RESTAURANTE'
	BEGIN
		Select R.IdRestaurante, R.NombreRestaurante, R.IDCiudad, R.NumeroAforo, R.Telefono, R.FechaCreacion, C.NombreCiudad
		from Restaurantes as R, Ciudad as C
		where r.IDCiudad = c.IDCiudad;
		Return
	END

	IF @Opcion='BUSCAR_RESTAURANTE'
	BEGIN
		Select *from Restaurantes where NombreRestaurante = @Buscar_NombreRestaurante;
	END

	IF @Opcion='INSERTA_RESTAURANTE'
	BEGIN
		 
		Select @Insertar_ID_CIUDAD = C.IDCiudad from ciudad as C where NombreCiudad = @Insertar_NombreCiudad;
		Select @Insertar_Existe_Restauran = R.NombreRestaurante from Restaurantes as R where NombreRestaurante = @Insertar_NombreRestaurante;
		IF @Insertar_ID_CIUDAD IS NOT NULL AND @Insertar_Existe_Restauran IS NULL
		BEGIN
		SET NOCOUNT ON
			Insert Into Restaurantes VALUES (@Insertar_NombreRestaurante, @Insertar_ID_CIUDAD, @Insertar_NumeroAforo, @Insertar_Telefono, getdate());
			Select  top 1 IDRestaurante, NombreRestaurante, IDCiudad, NumeroAforo, Telefono, FechaCreacion
			from Restaurantes where NombreRestaurante = @Insertar_NombreRestaurante;
		END
	END

	IF @Opcion='ACTUALIZAR_RESTAURANTE'
	BEGIN
		SET @Actualizar_Existe_Restauran = (Select R.NombreRestaurante from Restaurantes as R where NombreRestaurante = @Buscar_NombreRestaurante);
		SET @Actualizar_Existe_Ciudad = (Select C.IDCiudad from ciudad as C where NombreCiudad = @Actualizar_NombreCiudad);
		IF @Actualizar_Existe_Restauran IS NOT NULL AND @Actualizar_Existe_Ciudad IS NOT NULL
		BEGIN
		SET NOCOUNT ON
			Update Restaurantes Set NombreRestaurante = @Actualizar_NombreRestaurante,
			IDCiudad = @Actualizar_Existe_Ciudad, NumeroAforo = @Actualizar_NumeroAforo,
			Telefono = @Actualizar_Telefono
			where NombreRestaurante = @Buscar_NombreRestaurante;

			Select  top 1 IDRestaurante, NombreRestaurante, IDCiudad, NumeroAforo, Telefono, FechaCreacion
			from Restaurantes where NombreRestaurante = @Actualizar_NombreRestaurante;
		END 

	END

	IF @Opcion='ELIMINAR_RESTAURANTE'
	BEGIN
		Select @Eliminar_Existe_Restauran = R.NombreRestaurante from Restaurantes as R where NombreRestaurante = @Eliminar_Restaurante;
		IF @Eliminar_Existe_Restauran IS NOT NULL
		BEGIN
			Delete from Restaurantes where NombreRestaurante = @Eliminar_Restaurante
		END
	END
END
GO 

