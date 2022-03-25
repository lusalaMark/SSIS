IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='vw_MicroCreditGroups') BEGIN
   EXEC('CREATE view [dbo].[vw_MicroCreditGroups] as select top 1 * from vfin_Companies')
END
GO


/****** Object:  View [dbo].[vw_Budget]    Script Date: 9/14/2014 6:05:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

alter view [dbo].[vw_MicroCreditGroups]
WITH SCHEMABINDING

AS
SELECT        dbo.vfin_Customers.NonIndividual_Description AS MicroCreditGroupName, 
                         dbo.vfin_Customers.NonIndividual_RegistrationNumber AS MicroCreditGroupRegistrationNumber, 
                         dbo.vfin_Customers.NonIndividual_PersonalIdentificationNumber AS MicroCreditGroupPIN, 
                         dbo.vfin_Customers.NonIndividual_DateEstablished AS MicroCreditGroupDateEstablished, dbo.vfin_Customers.SerialNumber AS MicroCreditGroupSerialNumber, 
                         CASE dbo.vfin_MicroCreditGroups.Type WHEN 1 THEN 'ROSCA' WHEN 2 THEN 'ASCA' WHEN 4 THEN 'Table Banking' END AS MicroCreditGroupType, 
                         dbo.vfin_MicroCreditGroups.Purpose, dbo.vfin_MicroCreditGroups.Activities, 
                         CASE dbo.vfin_MicroCreditGroups.MeetingFrequency WHEN 2 THEN 'Semi-Annual' WHEN 3 THEN 'Tri-Annual' WHEN 4 THEN 'Quartery' WHEN 6 THEN 'Bi-Monthly' WHEN
                          12 THEN 'Monthly' WHEN 24 THEN 'Semi-Monthly' WHEN 26 THEN 'Bi-Weekly' WHEN 52 THEN 'Weekly' END AS MicroCreditGroupMeetingFrequency, 
                         CASE dbo.vfin_MicroCreditGroups.MeetingDayOfWeek WHEN 0 THEN 'Sunday' WHEN 1 THEN 'Monday' WHEN 2 THEN 'Tuesday' WHEN 3 THEN 'Wednesday' WHEN
                          4 THEN 'Thursday' WHEN 5 THEN 'Friday' WHEN 6 THEN 'Saturday' END AS MicroCreditGroupMeetingDayOfWeek, dbo.vfin_MicroCreditGroups.MeetingPlace, 
                         dbo.vfin_MicroCreditGroups.MinimumMembers, dbo.vfin_MicroCreditGroups.MaximumMembers, dbo.vfin_MicroCreditGroups.Remarks, 
                         dbo.vw_EmployeeRegister.FullName AS MicroCreditOfficerName, dbo.vw_EmployeeRegister.IdentityCardNumber AS MicroCreditOfficerIdentityCardNumber, 
                         dbo.vw_EmployeeRegister.MembershipNumber AS MicroCreditOfficerMembershipNumber, 
                         dbo.vw_EmployeeRegister.PersonalFileNumber AS MicroCreditOfficerPersonalFileNumber
FROM            dbo.vfin_MicroCreditGroups INNER JOIN
                         dbo.vfin_MicroCreditOfficers ON dbo.vfin_MicroCreditGroups.MicroCreditOfficerId = dbo.vfin_MicroCreditOfficers.Id INNER JOIN
                         dbo.vfin_Customers ON dbo.vfin_MicroCreditGroups.CustomerId = dbo.vfin_Customers.Id INNER JOIN
                         dbo.vw_EmployeeRegister ON dbo.vfin_MicroCreditOfficers.EmployeeId = dbo.vw_EmployeeRegister.EmployeeID
go
