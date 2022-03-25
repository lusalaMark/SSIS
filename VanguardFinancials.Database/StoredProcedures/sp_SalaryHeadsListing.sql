IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_SalaryHeadsListing') BEGIN
   EXEC('CREATE PROC [dbo].[sp_SalaryHeadsListing] as')
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_SalaryHeadsListing] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT        dbo.vfin_SalaryHeads.Description, 
                         CASE type WHEN '61680' THEN 'Basic Pay Earning' WHEN '61681' THEN 'N.S.S.F Deduction' WHEN '61682' THEN 'N.H.I.F Deduction' WHEN '61683' THEN 'P.A.Y.E Deduction'
                          WHEN '61684' THEN 'Provident Fund Deduction' WHEN '61686' THEN 'Loan Deduction' WHEN '61687' THEN 'Investment Deduction' WHEN '61688' THEN 'Other Earning'
                          WHEN '61689' THEN 'Other Deduction' ELSE 'UnKnown' END AS SalaryHeadType, 
                         CASE [Category] WHEN 1 THEN 'Earning' WHEN 2 THEN 'Deduction' ELSE 'UnKnown' END AS Category, dbo.vfin_SalaryHeads.CreatedDate, 
                         dbo.vfin_ChartOfAccounts.AccountCode, dbo.vfin_ChartOfAccounts.AccountName
FROM            dbo.vfin_SalaryHeads INNER JOIN
                         dbo.vfin_ChartOfAccounts ON dbo.vfin_SalaryHeads.ChartOfAccountId = dbo.vfin_ChartOfAccounts.Id 
order by type
	END





GO
