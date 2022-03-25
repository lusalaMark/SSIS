--sp_EducationAttendees '8E3EF596-E97D-C735-D9BA-08D4766C14F3','9519985B-7FB4-CD7E-7C69-08D4766C2DD0','03/28/2017','03/30/2017'
--select * from vfin_EducationVenues
--select * from vfin_EducationRegisters
--select * from vfin_EducationAttendees

ALTER PROCEDURE sp_EducationAttendees
@VenueId  Uniqueidentifier,
@RegisterId UniqueIdentifier,
@StartDate DateTime,
@EndDate DateTime
AS
set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));
SELECT        TOP (100) PERCENT dbo.vfin_Customers.Individual_FirstName + ' ' + dbo.vfin_Customers.Individual_LastName as FullName, dbo.vfin_Customers.Individual_IdentityCardNumber, 
CASE dbo.vfin_Customers.Individual_Gender WHEN 1 THEN 'Male' WHEN 2 THEN 'Female' ELSE 'Unknown' end as Gender, 
                         dbo.vfin_Customers.Reference1 as AccountNo, dbo.vfin_Customers.Reference2 as Mno, dbo.vfin_Customers.Reference3 as PFNo, 
						 dbo.vfin_Stations.Description
FROM            dbo.vfin_EducationRegisters INNER JOIN
                         dbo.vfin_EducationVenues ON dbo.vfin_EducationRegisters.EducationVenueId = dbo.vfin_EducationVenues.Id INNER JOIN
                         dbo.vfin_EducationAttendees ON dbo.vfin_EducationRegisters.Id = dbo.vfin_EducationAttendees.EducationRegisterId INNER JOIN
                         dbo.vfin_Customers ON dbo.vfin_EducationAttendees.CustomerId = dbo.vfin_Customers.Id INNER JOIN
                         dbo.vfin_Stations ON dbo.vfin_Customers.StationId = dbo.vfin_Stations.Id
						 where dbo.vfin_EducationRegisters.CreatedDate BETWEEN @StartDate and @EndDate and dbo.vfin_EducationVenues.Id=@VenueId
						 and dbo.vfin_EducationRegisters.Id=@RegisterId 
				