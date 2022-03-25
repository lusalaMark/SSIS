IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_FileMovementRegisterForSingleFile') BEGIN
   EXEC('CREATE PROC [dbo].[sp_FileMovementRegisterForSingleFile] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_FileMovementRegisterForSingleFile]    Script Date: 9/13/2014 7:46:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================


ALTER PROCEDURE [dbo].[sp_FileMovementRegisterForSingleFile]

	@MembershipNumber1 as varchar(10),
	@MembershipNumber2 as varchar(10),

	@StartDate as datetime,
	@EndDate as datetime
AS
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '11:59:59'));
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--select   REPLACE(STR(MembershipNumber, 5), SPACE(1), '0')  from vfin_Customers
	
	SET NOCOUNT ON;
 
SELECT        CASE [Status] WHEN '51898' THEN 'Dispatched' WHEN '51899' THEN 'Received' ELSE 'UnKnown' END AS Status, 
                         REPLACE(STR(dbo.vfin_Customers.SerialNumber, 5), SPACE(1), '0') AS MembershipNumber, 
                         dbo.vfin_Customers.Individual_PayrollNumbers, 
                         CASE dbo.vfin_Customers.Individual_Salutation WHEN '48814' THEN 'Mr' WHEN '48815' THEN 'Mrs' WHEN '48816' THEN 'Miss' WHEN '48817' THEN 'Dr' WHEN '48818' THEN
                          'Prof' WHEN '48819' THEN 'Rev' WHEN '48820' THEN 'Eng' WHEN '48821' THEN 'Hon' WHEN '48822' THEN 'Cllr' WHEN '48823' THEN 'Sir' WHEN '48824' THEN 'Ms'
                          ELSE 'UnKnown' END + ' ' + dbo.vfin_Customers.Individual_FirstName + ' ' + dbo.vfin_Customers.Individual_LastName AS FullName, 
                         dbo.vfin_Departments.Description AS SourceDepartment, vfin_Departments_1.Description AS DestinationDepartment, dbo.vfin_FileMovementHistories.Remarks, 
                         dbo.vfin_FileMovementHistories.Carrier, dbo.vfin_FileMovementHistories.Sender, dbo.vfin_FileMovementHistories.SendDate, 
                         dbo.vfin_FileMovementHistories.Recipient, dbo.vfin_FileMovementHistories.ReceiveDate, dbo.vfin_FileMovementHistories.CreatedDate
FROM            dbo.vfin_FileRegisters INNER JOIN
                         dbo.vfin_FileMovementHistories ON dbo.vfin_FileRegisters.Id = dbo.vfin_FileMovementHistories.FileRegisterId INNER JOIN
                         dbo.vfin_Departments ON dbo.vfin_FileMovementHistories.SourceDepartmentId = dbo.vfin_Departments.Id INNER JOIN
                         dbo.vfin_Departments AS vfin_Departments_1 ON dbo.vfin_FileMovementHistories.DestinationDepartmentId = vfin_Departments_1.Id INNER JOIN
                         dbo.vfin_Customers ON dbo.vfin_FileRegisters.CustomerId = dbo.vfin_Customers.Id
Where			REPLACE(STR(dbo.vfin_Customers.SerialNumber, 6), SPACE(1), '0') between REPLACE(STR(@MembershipNumber1, 5), SPACE(1), '0') and REPLACE(STR(@MembershipNumber2, 5), SPACE(1), '0')  
				AND dbo.vfin_FileMovementHistories.CreatedDate BETWEEN @StartDate AND @EndDate
ORDER BY status,dbo.vfin_Customers.SerialNumber,CreatedDate
END




