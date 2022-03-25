
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec sp_ShareTotals '08/24/2015'
alter  procedure [dbo].[sp_ShareTotals]

@EndDate datetime
as 
begin
 
 with sharetotals (AccountName,reference1,reference2,reference3,capital,deposit)
as
(
SELECT        dbo.vfin_Customers.Individual_FirstName+' '+ dbo.vfin_Customers.Individual_LastName as AccountName, dbo.vfin_Customers.Reference1
,dbo.vfin_Customers.Reference2,dbo.vfin_Customers.Reference3,isnull((SELECT        SUM(dbo.vfin_JournalEntries.Amount) AS Expr1
FROM            dbo.vfin_JournalEntries INNER JOIN
                         dbo.vw_CustomerAccounts ON dbo.vfin_JournalEntries.CustomerAccountId = dbo.vw_CustomerAccounts.Id INNER JOIN
                         dbo.vfin_InvestmentProducts ON dbo.vw_CustomerAccounts.CustomerAccountType_TargetProductId = dbo.vfin_InvestmentProducts.Id AND 
                         dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_InvestmentProducts.ChartOfAccountId
WHERE    dbo.vfin_JournalEntries.Amount<>0 and  dbo.vw_CustomerAccounts.CustomerId=  dbo.vfin_Customers.id and dbo.vfin_InvestmentProducts.code = 1 and vfin_JournalEntries.CreatedDate<=@EndDate  ),0) 
as [shares capital],
isnull((SELECT        SUM(dbo.vfin_JournalEntries.Amount) AS Expr1
FROM            dbo.vfin_JournalEntries INNER JOIN
                         dbo.vw_CustomerAccounts ON dbo.vfin_JournalEntries.CustomerAccountId = dbo.vw_CustomerAccounts.Id INNER JOIN
                         dbo.vfin_InvestmentProducts ON dbo.vw_CustomerAccounts.CustomerAccountType_TargetProductId = dbo.vfin_InvestmentProducts.Id AND 
                         dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_InvestmentProducts.ChartOfAccountId
WHERE      dbo.vw_CustomerAccounts.CustomerId=  dbo.vfin_Customers.id and dbo.vfin_InvestmentProducts.code = 5 and vfin_JournalEntries.CreatedDate<=@EndDate  ),0)
as [shares deposit] 
from   dbo.vfin_Customers
 )

 select AccountName,reference1,reference2,reference3,capital,deposit

 from sharetotals where capital+deposit<>0
 order by reference1

 end

 --sp_ShareTotals '12/12/2014'