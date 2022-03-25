IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_ReversedTransactionsByDate') BEGIN
   EXEC('CREATE PROC [dbo].[sp_ReversedTransactionsByDate] as')
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
---sp_ReversedTransactionsByDate '01/01/2013','04/03/2014'
ALTER PROCEDURE [dbo].[sp_ReversedTransactionsByDate] 
	@StartDate as Datetime,
	@EndDate as Datetime

AS
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT        dbo.vfin_Branches.Description AS Branch, convert(Varchar(10),dbo.vfin_Journals.CreatedDate,103) as Date,dbo.vfin_PostingPeriods.Description AS PostingPeriod, vfin_ChartOfAccounts_1.AccountCode, 
                         vfin_ChartOfAccounts_1.AccountName, RIGHT('00' + CAST(LTRIM(RTRIM(dbo.vfin_Branches.Code)) AS VARCHAR(5)), 5) 
                         + '-' + RIGHT('00000' + CAST(LTRIM(RTRIM(dbo.vfin_Customers.SerialNumber)) AS VARCHAR(6)), 6) 
                         + '-' + RIGHT('00' + CAST(LTRIM(RTRIM(dbo.vfin_CustomerAccounts.CustomerAccountType_ProductCode)) AS VARCHAR(5)), 5) 
                         + '-' + RIGHT('00' + CAST(LTRIM(RTRIM(dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductCode)) AS VARCHAR(5)), 5) AS FullAccount, 
                         CASE Individual_Salutation WHEN '48814' THEN 'Mr' WHEN '48815' THEN 'Mrs' WHEN '48816' THEN 'Miss' WHEN '48817' THEN 'Dr' WHEN '48818' THEN 'Prof' WHEN '48819'
                          THEN 'Rev' WHEN '48820' THEN 'Eng' WHEN '48821' THEN 'Hon' WHEN '48822' THEN 'Cllr' WHEN '48823' THEN 'Sir' WHEN '48824' THEN 'Ms' ELSE 'UnKnown' END
                          + ' ' + dbo.vfin_Customers.Individual_FirstName + ' ' + dbo.vfin_Customers.Individual_LastName AS FullName, dbo.vfin_JournalEntries.CreatedDate, dbo.vfin_JournalEntries.Amount, 
                         dbo.vfin_ChartOfAccounts.AccountCode AS ContraAccountCode, dbo.vfin_ChartOfAccounts.AccountName AS ContraAccountName, 
                         dbo.vfin_Journals.PrimaryDescription, dbo.vfin_Journals.SecondaryDescription, dbo.vfin_Journals.Reference
FROM            dbo.vfin_ChartOfAccounts INNER JOIN
                         dbo.vfin_Journals INNER JOIN
                         dbo.vfin_JournalEntries ON dbo.vfin_Journals.Id = dbo.vfin_JournalEntries.JournalId INNER JOIN
                         dbo.vfin_ChartOfAccounts AS vfin_ChartOfAccounts_1 ON dbo.vfin_JournalEntries.ChartOfAccountId = vfin_ChartOfAccounts_1.Id INNER JOIN
                         dbo.vfin_PostingPeriods ON dbo.vfin_Journals.PostingPeriodId = dbo.vfin_PostingPeriods.Id INNER JOIN
                         dbo.vfin_Branches ON dbo.vfin_Journals.BranchId = dbo.vfin_Branches.Id ON 
                         dbo.vfin_ChartOfAccounts.Id = dbo.vfin_JournalEntries.ContraChartOfAccountId LEFT OUTER JOIN
                         dbo.vfin_Customers INNER JOIN
                         dbo.vfin_CustomerAccounts ON dbo.vfin_Customers.Id = dbo.vfin_CustomerAccounts.CustomerId ON 
                         dbo.vfin_JournalEntries.CustomerAccountId = dbo.vfin_CustomerAccounts.Id
WHERE        (dbo.vfin_Journals.ModuleNavigationItemCode = 64429) 
			AND (dbo.vfin_JournalEntries.Amount > 0) 
			AND dbo.vfin_JournalEntries.CreatedDate>=@StartDate 
			AND dbo.vfin_JournalEntries.CreatedDate<=@EndDate
order by Branch,CreatedDate
END





GO
