CREATE PROCEDURE InsertOrganizer @Name VARCHAR(256), @Phone int, @NIF CHAR(9),@Mail VARCHAR(256)
AS
BEGIN TRANSACTION
	IF EXISTS(SELECT PHONE_NUMBER FROM PERSON WHERE PHONE_NUMBER = @Phone AND NIF NOT LIKE @NIF)
	BEGIN
		RAISERROR('Numero de telemovel j� existe',16,1)
		COMMIT TRAN
		RETURN 1
	END
	IF EXISTS(SELECT MAIL_ADDRESS FROM ORGANIZER WHERE MAIL_ADDRESS = @Mail AND NIF NOT LIKE @NIF)
	BEGIN
		RAISERROR('Endere�o de Email j� existe',16,1)
		COMMIT TRAN
		RETURN 1
	END
	UPDATE PERSON SET [NAME] = @Name, PHONE_NUMBER = @Phone WHERE NIF = @NIF;
	UPDATE ORGANIZER SET MAIL_ADDRESS = @Mail WHERE NIF = @NIF;

COMMIT
GO


CREATE PROCEDURE InsertStaff @Name VARCHAR(256), @Phone int, @NIF CHAR(9),@Price int, @Staff_number int,@NIF_Organizer CHAR(9)
AS
BEGIN TRANSACTION
	IF EXISTS(SELECT NIF FROM PERSON WHERE NIF = @NIF)
	BEGIN
		RAISERROR('NIF J� existente',16,1)
		COMMIT TRAN
		RETURN 1
	END
	IF EXISTS(SELECT PHONE_NUMBER FROM PERSON WHERE PHONE_NUMBER = @Phone)
	BEGIN
		RAISERROR('Numero de telemovel j� existe',16,1)
		COMMIT TRAN
		RETURN 1
	END
	IF EXISTS(SELECT STAFF_NUMBER FROM STAFF WHERE NIF_Organizer = @NIF_ORGANIZER AND STAFF_NUMBER = @Staff_number)
	BEGIN
		RAISERROR('Numero de Staff j� existe para este organizador',16,1)
		COMMIT TRAN
		RETURN 1
	END
	
	INSERT INTO PERSON VALUES (@NIF,@Name,@Phone);
	INSERT INTO STAFF VALUES (@NIF,@NIF_Organizer,@Price,@Staff_number);
	

COMMIT
GO


CREATE PROCEDURE InsertArtist @Name VARCHAR(256), @Phone int, @NIF CHAR(9), @Artist_Name VARCHAR(128),@NIF_Organizer CHAR(9)
AS
BEGIN TRANSACTION;

	IF EXISTS(SELECT NIF FROM PERSON WHERE NIF = @NIF)
	BEGIN
		RAISERROR('NIF J� existente',16,1)
		COMMIT TRAN
		RETURN 1
	END
	IF EXISTS(SELECT PHONE_NUMBER FROM PERSON WHERE PHONE_NUMBER = @Phone)
	BEGIN
		RAISERROR('Numero de telemovel j� existe',16,1)
		COMMIT TRAN
		RETURN 1
	END

	INSERT INTO PERSON VALUES (@NIF,@Name,@Phone);
	INSERT INTO ARTIST VALUES (@NIF,@Artist_Name,@NIF_Organizer);

COMMIT
GO



CREATE PROCEDURE InsertSponsor @NIF_ORGANIZER CHAR(9), @DESCRIPTION VARCHAR(256), @NAME VARCHAR(256)
AS
BEGIN

	INSERT INTO SPONSOR VALUES (@NIF_ORGANIZER,@DESCRIPTION,@NAME);

END
GO


CREATE PROCEDURE SponsorFestival @Sponsor_ID int, @Festival_Reference CHAR(9),@Investment int
AS
BEGIN
	
	IF @Investment <= 0
	BEGIN
		RAISERROR('Invalid value for investment',16,1);
	END
	ELSE
	BEGIN
		INSERT INTO SPONSORS VALUES (@Sponsor_ID,@Festival_Reference,@Investment)
	END

END
GO

CREATE PROCEDURE InsertMusic @ArtistNif CHAR(9), @Music_Name VARCHAR(256),@Music_Genre VARCHAR(128), @Music_DURATION TIME
AS
BEGIN TRANSACTION;
	IF EXISTS(SELECT [NAME] FROM MUSIC WHERE [NAME] = @Music_Name)
	BEGIN
		RAISERROR('Nome da musica J� existente',16,1)
		COMMIT TRAN
		RETURN 1
	END
	INSERT INTO MUSIC VALUES (@Music_Name,@Music_DURATION,@Music_Genre);
	INSERT INTO PLAYED VALUES(@ArtistNif,@Music_Name);

COMMIT
GO

CREATE PROCEDURE InsertEquipment @ArtistNif CHAR(9), @Reference INT, @Cost VARCHAR(128), @Name VARCHAR(128),@Type_ID INT
AS
BEGIN;
	IF EXISTS(SELECT RERENCE FROM EQUIPMENT WHERE RERENCE = @Reference)
	BEGIN
		RAISERROR('Nome da musica J� existente',16,1)
		RETURN 1
	END
	INSERT INTO EQUIPMENT VALUES (@Reference,@Cost,@Name,@Type_ID,@ArtistNif);
END
GO

CREATE PROCEDURE DeleteFestival @Reference char(9), @OrganizerNIF CHAR(9)
AS
BEGIN TRANSACTION
    DELETE FROM dbo.WORKS_ON WHERE FESTIVAL_REFERENCE LIKE @Reference
    DELETE FROM dbo.SPONSORS WHERE REFERENCE LIKE @Reference
    DELETE FROM dbo.CONCERT WHERE FESTIVAL_REFERENCE LIKE @Reference
    DELETE FROM dbo.FESTIVAL WHERE REFERENCE LIKE @Reference
	UPDATE dbo.VENUE SET NIF_ORGANIZER = NULL WHERE NIF_ORGANIZER LIKE @OrganizerNIF AND LOCATION IN (SELECT LOCATION FROM VENUE WHERE VENUE.NIF_ORGANIZER = @OrganizerNIF AND LOCATION NOT IN (SELECT LOCATION FROM (FESTIVAL JOIN VENUE ON LOCATION_VENUE = LOCATION) WHERE VENUE.NIF_ORGANIZER = @OrganizerNIF))

COMMIT
GO

CREATE PROCEDURE StaffWorksOn @ROLE_ID int,@STAGE_ID int,@Nif CHAR(9),@Reference CHAR(9)
AS
BEGIN
	INSERT INTO WORKS_ON VALUES (@ROLE_ID,@STAGE_ID,@Nif,@Reference)

END
GO

CREATE PROCEDURE UpdateVenue @OrganizerNIF char(9), @Location VARCHAR(256)
AS
BEGIN
	UPDATE VENUE SET NIF_ORGANIZER = @OrganizerNIF WHERE LOCATION LIKE @Location
END
GO
	
CREATE PROCEDURE AddConcert @FestivalReference CHAR(9), @ArtistNIF CHAR(9), @IdStage int, @Price int, @Duration time
AS
BEGIN
	INSERT INTO CONCERT VALUES(@IdStage,@ArtistNIF,@Price,@Duration,@FestivalReference)
END
GO

CREATE PROCEDURE AddOrganizer @NIF CHAR(9), @Phone_Number int, @Name VARCHAR(256), @Email VARCHAR(256), @Password VARCHAR(128)
AS
BEGIN TRANSACTION
	IF EXISTS(SELECT NIF FROM PERSON WHERE NIF = @NIF)
	BEGIN
		RAISERROR('NIF J� existente',16,1)
		COMMIT TRAN
		RETURN 1
	END
	IF EXISTS(SELECT PHONE_NUMBER FROM PERSON WHERE PHONE_NUMBER = @Phone_Number)
	BEGIN
		RAISERROR('Numero de telemovel j� existe',16,1)
		COMMIT TRAN
		RETURN 1
	END
	IF EXISTS(SELECT MAIL_ADDRESS FROM ORGANIZER WHERE MAIL_ADDRESS = @Email AND NIF NOT LIKE @NIF)
	BEGIN
		RAISERROR('Endere�o de Email j� existe',16,1)
		COMMIT TRAN
		RETURN 1
	END

	DECLARE @PasswordEncrypted as VARBINARY(128);
	SET @PasswordEncrypted = EncryptByPassPhrase('p2g7', @Password)
	INSERT INTO PERSON VALUES (@NIF,@Name,@Phone_Number);
	INSERT INTO ORGANIZER VALUES (@NIF,@Email,@PasswordEncrypted);
COMMIT
GO


CREATE PROCEDURE InsertFestival @Reference char(9), @Name Varchar(256), @Genre Varchar(128), @Start_Date datetime, @End_Date datetime, @Venue varchar(256), @Nif char(9)
AS
BEGIN
	IF EXISTS(SELECT REFERENCE FROM FESTIVAL WHERE REFERENCE = @Reference)
	BEGIN
		RAISERROR('Referencia do Festival j� existe',16,1)
		RETURN 1
	END
	INSERT INTO FESTIVAL VALUES(@Reference, @Name, @Genre, @Start_Date, @End_Date, @Venue, @Nif);
END
GO
