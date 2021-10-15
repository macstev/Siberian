USE [master]
GO
/****** Object:  Database [SiberianDB]    Script Date: 14/10/2021 19:50:33 ******/
CREATE DATABASE [SiberianDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SiberianDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\SiberianDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'SiberianDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\SiberianDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [SiberianDB] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SiberianDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SiberianDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SiberianDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SiberianDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SiberianDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SiberianDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [SiberianDB] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [SiberianDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SiberianDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SiberianDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SiberianDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SiberianDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SiberianDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SiberianDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SiberianDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SiberianDB] SET  ENABLE_BROKER 
GO
ALTER DATABASE [SiberianDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SiberianDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SiberianDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SiberianDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SiberianDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SiberianDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SiberianDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SiberianDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [SiberianDB] SET  MULTI_USER 
GO
ALTER DATABASE [SiberianDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SiberianDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [SiberianDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [SiberianDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [SiberianDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [SiberianDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [SiberianDB] SET QUERY_STORE = OFF
GO
USE [SiberianDB]
GO
/****** Object:  User [macstev]    Script Date: 14/10/2021 19:50:34 ******/
CREATE USER [macstev] FOR LOGIN [macstev] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Table [dbo].[Ciudad]    Script Date: 14/10/2021 19:50:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ciudad](
	[IDCiudad] [int] IDENTITY(1,1) NOT NULL,
	[NombreCiudad] [varchar](100) NULL,
	[FechaCreacion] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[IDCiudad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Restaurantes]    Script Date: 14/10/2021 19:50:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Restaurantes](
	[IDRestaurante] [int] IDENTITY(1,1) NOT NULL,
	[NombreRestaurante] [varchar](100) NULL,
	[IDCiudad] [int] NULL,
	[NumeroAforo] [int] NULL,
	[Telefono] [int] NULL,
	[FechaCreacion] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[IDRestaurante] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Restaurantes]  WITH CHECK ADD  CONSTRAINT [fk_Ciudad] FOREIGN KEY([IDCiudad])
REFERENCES [dbo].[Ciudad] ([IDCiudad])
GO
ALTER TABLE [dbo].[Restaurantes] CHECK CONSTRAINT [fk_Ciudad]
GO
/****** Object:  StoredProcedure [dbo].[Sp_Restauranes]    Script Date: 14/10/2021 19:50:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Crear un stored procedure de Nombre Sp_Restauranes
a. La SP Debe Tener la función de 5 resultados
i. Lista de Restaurantes con el nombre de la ciudad
ii. Filtro por 1 solo restaurante
iii. Insert
iv. Update
v. Delete
*/

CREATE PROCEDURE [dbo].[Sp_Restauranes]   
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
	--@Mensaje nvarchar(500) output

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
			--set @Mensaje = 'REGISTRO EXITOSO'
			Select  top 1 IDRestaurante, NombreRestaurante, IDCiudad, NumeroAforo, Telefono, FechaCreacion
			from Restaurantes where NombreRestaurante = @Insertar_NombreRestaurante;
		END
		--set @Mensaje = 'NO SE REALIZO EL INGRESO DEL REGISTRO'
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
			--set @Mensaje = 'ELIMINACION EXITOSA'
		END
		--set @Mensaje = 'NO SE REALIZO LA ELIMINACION DEL REGISTRO'
	END
END
GO
USE [master]
GO
ALTER DATABASE [SiberianDB] SET  READ_WRITE 
GO
