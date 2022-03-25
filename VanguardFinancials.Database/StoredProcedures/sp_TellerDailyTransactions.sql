IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_TellerDailyTransactions') BEGIN
   EXEC('CREATE PROC [dbo].[sp_TellerDailyTransactions] as')
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
---select * from vfin_JournalEntries where ChartOfAccountId='F538AB2E-99EE-CF93-1E7A-08D10CAD12D7'
--select top 1000 * from vfin_JournalEntries where JournalId='743622FB-B23C-C87C-3FFD-08D13FC11C40' order by CreatedDate desc
--select * from vfin_Tellers
---sp_TellerDailyTransactions '05/20/2014', '313E32FF-19F0-C20F-215B-08D14000BA48'
ALTER PROCEDURE [dbo].[sp_TellerDailyTransactions] 
	-- Add the parameters for the stored procedure here
	@TrxDate DateTime,
	@TellerCode varchar(100)

AS
Declare 
@OpenningBalance Numeric(18,2)

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
  set @OpenningBalance=isnull((select sum(amount) from vfin_JournalEntries 
					where ChartOfAccountId in
					(select ChartOfAccountId from vfin_Tellers where ID= @TellerCode) 
					and CreatedDate<@TrxDate),0)
					
    -- Insert statements for procedure here

SELECT        REPLACE(STR(dbo.vfin_Branches.Code, 3), SPACE(1), '0') + '-' + REPLACE(STR(dbo.vfin_Customers.SerialNumber, 6), SPACE(1), '0') 
                         + '-' + REPLACE(STR(dbo.vfin_CustomerAccounts.CustomerAccountType_ProductCode, 3), SPACE(1), '0') 
                         + '-' + REPLACE(STR(dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductCode, 3), SPACE(1), '0') AS FullAccountNumber, 
                         ltrim(rtrim(CASE dbo.vfin_Customers.Individual_Salutation WHEN '48814' THEN 'Mr' WHEN '48815' THEN 'Mrs' WHEN '48816' THEN 'Miss' WHEN '48817' THEN 'Dr' WHEN '48818'
                          THEN 'Prof' WHEN '48819' THEN 'Rev' WHEN '48820' THEN 'Eng' WHEN '48821' THEN 'Hon' WHEN '48822' THEN 'Cllr' WHEN '48823' THEN 'Sir' WHEN '48824' THEN
                          'Ms' ELSE '' END + ' ' + isnull(dbo.vfin_Customers.Individual_FirstName,'') + ' ' + isnull(dbo.vfin_Customers.Individual_LastName,'')))+''+
						  isnull(dbo.vfin_Customers.NonIndividual_Description,'') AS FullName, 
                         dbo.vfin_Journals.PrimaryDescription,dbo.vfin_Customers.Reference1, dbo.vfin_Journals.SecondaryDescription, dbo.vfin_Journals.Reference, dbo.vfin_JournalEntries.Amount, 
                         CASE vfin_Customers_1.Individual_Salutation WHEN '48814' THEN 'Mr' WHEN '48815' THEN 'Mrs' WHEN '48816' THEN 'Miss' WHEN '48817' THEN 'Dr' WHEN '48818'
                          THEN 'Prof' WHEN '48819' THEN 'Rev' WHEN '48820' THEN 'Eng' WHEN '48821' THEN 'Hon' WHEN '48822' THEN 'Cllr' WHEN '48823' THEN 'Sir' WHEN '48824' THEN
                          'Ms' ELSE 'UnKnown' END + ' ' + vfin_Customers_1.Individual_FirstName + ' ' + vfin_Customers_1.Individual_LastName AS TellerFullName, 
                         dbo.vfin_Tellers.Description AS TellerCode,(select AccountName from vfin_ChartOfAccounts where id = dbo.vfin_JournalEntries.ContraChartOfAccountId) as ContraName, 
						 (select AccountCode from vfin_ChartOfAccounts where id = dbo.vfin_JournalEntries.ContraChartOfAccountId) as ContraGL,dbo.vfin_JournalEntries.CreatedDate,dbo.vfin_Customers.Individual_IdentityCardNumber
into #temp  FROM            dbo.vfin_Customers RIGHT OUTER JOIN
                         dbo.vfin_Journals INNER JOIN
                         dbo.vfin_JournalEntries ON dbo.vfin_Journals.Id = dbo.vfin_JournalEntries.JournalId INNER JOIN
                         dbo.vfin_Tellers ON dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_Tellers.ChartOfAccountId LEFT OUTER JOIN
                         dbo.vfin_Employees INNER JOIN
                         dbo.vfin_Customers AS vfin_Customers_1 ON dbo.vfin_Employees.CustomerId = vfin_Customers_1.Id ON 
                         dbo.vfin_Tellers.EmployeeId = dbo.vfin_Employees.Id LEFT OUTER JOIN
                         dbo.vfin_Branches INNER JOIN
                         dbo.vfin_CustomerAccounts ON dbo.vfin_Branches.Id = dbo.vfin_CustomerAccounts.BranchId ON 
                         dbo.vfin_JournalEntries.CustomerAccountId = dbo.vfin_CustomerAccounts.Id ON dbo.vfin_Customers.Id = dbo.vfin_CustomerAccounts.CustomerId
						 
WHERE   dbo.vfin_Tellers.Id=@TellerCode and convert(varchar(10),dbo.vfin_JournalEntries.CreatedDate,103) =convert(varchar(10),@TrxDate,103)
insert into #temp(PrimaryDescription,SecondaryDescription,Reference,Amount,CreatedDate) 
select 'Balance B/F','','B-B/F',@OpenningBalance,DATEADD(d,-1,@TrxDate)


SELECT CASE 
WHEN isnull(FullAccountNumber,'')='' THEN LTRIM(RTRIM(STR(ContraGL)))
ELSE FullAccountNumber
END AS FullAccountNumber,
CASE 
WHEN isnull(FullName,'')='' THEN LTRIM(RTRIM(ContraName))
ELSE FullName
END AS FullName
,PrimaryDescription,SecondaryDescription,reference,Reference1,convert(varchar(10),CreatedDate,103) as TrxDate,
CreatedDate as CreatedDateSorted , Individual_IdentityCardNumber,
						 isnull(case when Amount<=0 then Amount*-1 else 0 end,0) as Debit,
						 isnull(case when Amount>0 then Amount else 0 end,0) as Credit,
						 SUM(Amount) OVER(ORDER BY CreatedDate 
						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal from #temp
Order by CreatedDateSorted
END




