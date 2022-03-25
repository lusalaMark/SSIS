IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_GlAccountStatementByAccountCode') BEGIN
   EXEC('CREATE PROC [dbo].[sp_GlAccountStatementByAccountCode] as')
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GlAccountStatement]    Script Date: 10/24/2014 7:59:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_GlAccountStatementByAccountCode] 
	-- Add the parameters for the stored procedure here
	@AccountID Varchar(20),
	@EndDate Datetime
AS
DECLARE
	@OpeningBalance Numeric (18,2),
	@ChartOfAccountID uniqueidentifier,
	@StartDate Datetime

	set @EndDate  =	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));
	set @ChartOfAccountID=(select top 1  id from vfin_ChartOfAccounts where AccountCode=@AccountID)

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;
    -- Insert statements for procedure here

WITH CTE AS
(
SELECT (select AccountCode from vfin_ChartOfAccounts where id=@ChartOfAccountID) as AccountCode,
(select AccountName from vfin_ChartOfAccounts where id=@ChartOfAccountID) as AccountName,'Balance B/F at ' +convert(varchar(10),@startdate,103) as PrimaryDescription,'<Opening Balance>' as SecondaryDescription,'<Opening Balance>' as Reference,
(select Balance from f_GLAccountBalance(@ChartOfAccountID,@StartDate)) as Amount,@StartDate as CreatedDate,'' as FullAccountNumber,'' as FullName,'' as ContrAccountCode,'' as ContraAccountName
    UNION ALL
SELECT        dbo.vfin_ChartOfAccounts.AccountCode, dbo.vfin_ChartOfAccounts.AccountName, dbo.vfin_Journals.PrimaryDescription, 
                         dbo.vfin_Journals.SecondaryDescription, dbo.vfin_Journals.Reference, dbo.vfin_JournalEntries.Amount, dbo.vfin_Journals. valueDate as CreatedDate, 
                         REPLACE(STR(dbo.vfin_Branches.Code, 3), SPACE(1), '0') + '-' + REPLACE(STR(dbo.vfin_Customers.SerialNumber, 6), SPACE(1), '0') 
                         + '-' + REPLACE(STR(dbo.vfin_CustomerAccounts.CustomerAccountType_ProductCode, 3), SPACE(1), '0') 
                         + '-' + REPLACE(STR(dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductCode, 3), SPACE(1), '0') AS FullAccountNumber, 
                         CASE dbo.vfin_Customers.Individual_Salutation WHEN '48814' THEN 'Mr' WHEN '48815' THEN 'Mrs' WHEN '48816' THEN 'Miss' WHEN '48817' THEN 'Dr' WHEN
                          '48818' THEN 'Prof' WHEN '48819' THEN 'Rev' WHEN '48820' THEN 'Eng' WHEN '48821' THEN 'Hon' WHEN '48822' THEN 'Cllr' WHEN '48823' THEN 'Sir' WHEN
                          '48824' THEN 'Ms' ELSE 'UnKnown' END + ' ' + dbo.vfin_Customers.Individual_FirstName + ' ' + dbo.vfin_Customers.Individual_LastName AS FullName, 
                         vfin_ChartOfAccounts_1.AccountCode AS ContraAccountCode, vfin_ChartOfAccounts_1.AccountName AS ContraAccountName
FROM            dbo.vfin_ChartOfAccounts INNER JOIN
                         dbo.vfin_Journals INNER JOIN
                         dbo.vfin_JournalEntries ON dbo.vfin_Journals.Id = dbo.vfin_JournalEntries.JournalId ON 
                         dbo.vfin_ChartOfAccounts.Id = dbo.vfin_JournalEntries.ChartOfAccountId INNER JOIN
                         dbo.vfin_ChartOfAccounts AS vfin_ChartOfAccounts_1 ON dbo.vfin_JournalEntries.ContraChartOfAccountId = vfin_ChartOfAccounts_1.Id LEFT OUTER JOIN
                         dbo.vfin_Branches INNER JOIN
                         dbo.vfin_CustomerAccounts ON dbo.vfin_Branches.Id = dbo.vfin_CustomerAccounts.BranchId INNER JOIN
                         dbo.vfin_Customers ON dbo.vfin_CustomerAccounts.CustomerId = dbo.vfin_Customers.Id ON 
                         dbo.vfin_JournalEntries.CustomerAccountId = dbo.vfin_CustomerAccounts.Id
WHERE        (dbo.vfin_JournalEntries.CreatedDate <= @EndDate)  AND 
                         (dbo.vfin_ChartOfAccounts.Id = @ChartOfAccountID)
						 ) SELECT AccountCode,AccountName,PrimaryDescription,SecondaryDescription,Reference,CreatedDate,FullAccountNumber,FullName,ContrAccountCode,ContraAccountName,
ISNULL(CASE WHEN AMOUNT<0 THEN AMOUNT*-1 END,0) AS DEBIT,
ISNULL(CASE WHEN AMOUNT>0 THEN AMOUNT END,0) AS CREDIT,
SUM(Amount) OVER(ORDER BY CreatedDate 
						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal
 FROM CTE ORDER BY CreatedDate


END





