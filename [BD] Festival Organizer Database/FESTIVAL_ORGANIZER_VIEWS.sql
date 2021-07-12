CREATE VIEW SearchOrganizer
AS
SELECT ORGANIZER.NIF,ORGANIZER.MAIL_ADDRESS,PERSON.NAME,PERSON.PHONE_NUMBER FROM (ORGANIZER JOIN PERSON ON ORGANIZER.NIF = PERSON.NIF);
GO

CREATE VIEW SearchEquipmentType
AS
SELECT * FROM EQUIPMENT_TYPE;
GO

CREATE VIEW SearchRole
AS
SELECT * FROM [ROLE]
GO