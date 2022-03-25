IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_FileMovementRegisterByReceiveDate') BEGIN
   EXEC('CREATE PROC [dbo].[sp_FileMovementRegisterByReceiveDate] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_FileMovementRegisterByReceiveDate]    Script Date: 9/13/2014 7:44:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_FileMovementRegisterByReceiveDate]

	@StartDate as datetime,
	@EndDate as datetime
AS
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
SELECT        CASE [Status] WHEN '51898' THEN 'Dispatched' WHEN '51899' THEN 'Received' ELSE 'UnKnown' END AS Status, 
                         RIGHT('00000' + CAST(LTRIM(RTRIM(dbo.vfin_Customers.SerialNumber)) AS VARCHAR(6)), 6) AS MembershipNumber, 
                         dbo.vfin_Customers.Individual_PayrollNumbers as PersonalFileNumber, 
                         CASE dbo.vfin_Customers.Individual_Salutation WHEN '48814' THEN 'Mr' WHEN '48815' THEN 'Mrs' WHEN '48816' THEN 'Miss' WHEN '48817' THEN 'Dr' WHEN '48818' THEN
                          'Prof' WHEN '48819' THEN 'Rev' WHEN '48820' THEN 'Eng' WHEN '48821' THEN 'Hon' WHEN '48822' THEN 'Cllr' WHEN '48823' THEN 'Sir' WHEN '48824' THEN 'Ms'
                          ELSE 'UnKnown' END + ' ' + dbo.vfin_Customers.Individual_FirstName + ' ' + dbo.vfin_Customers.Individual_LastName AS FullName, 
                         dbo.vfin_Departments.Description AS SourceDepartment, vfin_Departments_1.Description AS DestinationDepartment, dbo.vfin_FileMovementHistories.Remarks, 
                         dbo.vfin_FileMovementHistories.Carrier, dbo.vfin_FileMovementHistories.Sender, dbo.vfin_FileMovementHistories.SendDate, 
                         dbo.vfin_FileMovementHistories.Recipient, convert(varchar(10),dbo.vfin_FileMovementHistories.ReceiveDate,103) as ReceiveDate, 
						 dbo.vfin_FileMovementHistories.ReceiveDate as ReceiveDateSorted,  dbo.vfin_FileMovementHistories.CreatedDate
FROM            dbo.vfin_FileRegisters INNER JOIN 
                         dbo.vfin_FileMovementHistories ON dbo.vfin_FileRegisters.Id = dbo.vfin_FileMovementHistories.FileRegisterId INNER JOIN
                         dbo.vfin_Departments ON dbo.vfin_FileMovementHistories.SourceDepartmentId = dbo.vfin_Departments.Id INNER JOIN
                         dbo.vfin_Departments AS vfin_Departments_1 ON dbo.vfin_FileMovementHistories.DestinationDepartmentId = vfin_Departments_1.Id INNER JOIN
                         dbo.vfin_Customers ON dbo.vfin_FileRegisters.CustomerId = dbo.vfin_Customers.Id
Where			dbo.vfin_FileMovementHistories.ReceiveDate Between @StartDate AND @EndDate

END




