GO
/****** Object:  StoredProcedure [dbo].[sp_AtmTransactions]    Script Date: 9/13/2014 3:04:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
---select * from vfin_ChartOfAccounts where id='36206afb-23d0-cbc4-72d9-08d10cad4b96'
---sp_AtmTransactions 1,'01/01/2014', '12/31/2014'
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_LoanDisbursementByEmployer') BEGIN
   EXEC('CREATE PROC [dbo].[sp_LoanDisbursementByEmployer] as')
END
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 17.10.2014
-- Description:	LoanDisbursmentByEmployer
-- =============================================
---sp_LoandisbursementbyEmployer '05f1d9f8-2235-445b-9e85-83f864312870','1445b2cf-64aa-c189-dae3-08d1335639ad','01/01/2014','10/17/2014'
alter PROCEDURE sp_LoanDisbursementByEmployer 
	-- Add the parameters for the stored procedure here
	@EmployerID varchar(50) , 
	@LoanProductID Varchar(50),
	@StartDate Datetime,
	@EndDate DateTime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));
    -- Insert statements for procedure here
	SELECT        CASE vfin_Customers.Individual_Salutation WHEN '48814' THEN 'Mr' WHEN '48815' THEN 'Mrs' WHEN '48816' THEN 'Miss' WHEN '48817' THEN 'Dr' WHEN '48818'
                          THEN 'Prof' WHEN '48819' THEN 'Rev' WHEN '48820' THEN 'Eng' WHEN '48821' THEN 'Hon' WHEN '48822' THEN 'Cllr' WHEN '48823' THEN 'Sir' WHEN '48824' THEN
                          'Ms' ELSE 'UnKnown' END + ' ' + dbo.vfin_Customers.Individual_FirstName + ' ' + dbo.vfin_Customers.Individual_LastName AS FullName, 
                         CASE vfin_Customers.Individual_Gender WHEN '57008' THEN 'Male' WHEN '57009' THEN 'Female' ELSE 'UnKnown' END AS Gender, 
                         dbo.vfin_LoanProducts.Description AS LoanType, dbo.vfin_Employers.Description AS Employer, dbo.vfin_LoanCases.CaseNumber, 
                         dbo.vfin_LoanCases.AmountApplied, dbo.vfin_LoanCases.DisburseBatchNumber, dbo.vfin_LoanCases.DisbursedBy, dbo.vfin_LoanCases.DisbursedDate, 
                         dbo.vfin_LoanCases.DisbursedAmount,dbo.vfin_Customers.Reference1, REPLACE(STR(dbo.vfin_Customers.SerialNumber, 6), SPACE(1), '0') as SerialNumber , dbo.vfin_Customers.Reference3
	FROM            dbo.vfin_LoanCases INNER JOIN
                         dbo.vfin_Customers ON dbo.vfin_LoanCases.CustomerId = dbo.vfin_Customers.Id INNER JOIN
                         dbo.vfin_Stations ON dbo.vfin_Customers.StationId = dbo.vfin_Stations.Id INNER JOIN
                         dbo.vfin_Zones ON dbo.vfin_Stations.ZoneId = dbo.vfin_Zones.Id INNER JOIN
                         dbo.vfin_Divisions ON dbo.vfin_Zones.DivisionId = dbo.vfin_Divisions.Id INNER JOIN
                         dbo.vfin_LoanProducts ON dbo.vfin_LoanCases.LoanProductId = dbo.vfin_LoanProducts.Id INNER JOIN
                         dbo.vfin_Employers ON dbo.vfin_Divisions.EmployerId = dbo.vfin_Employers.Id

	WHERE dbo.vfin_Employers.Id=@EmployerID and dbo.vfin_LoanCases.LoanProductId=@LoanProductID 
	and dbo.vfin_LoanCases.DisbursedDate Between @StartDate and @EndDate 
	ORDER BY REPLACE(STR(dbo.vfin_Customers.SerialNumber, 6), SPACE(1), '0')
END
GO
