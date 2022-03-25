IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_NonCashJournal') BEGIN
   EXEC('CREATE PROC [dbo].[sp_NonCashJournal] as')
END
GO
---sp_NONCashJournal '12/09/2014','12/09/2014'
--select count()
alter Procedure sp_NonCashJournal (@StartDate DateTime, @EndDate DateTime)as
set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));

With CashJournal(ItemDescription,AccountName,ItemCode,ParentItemCode,Debit,Credit)
as(
SELECT        TOP (100) PERCENT dbo.vfin_ModuleNavigationItems.ItemDescription, dbo.vfin_ChartOfAccounts.AccountName, dbo.vfin_ModuleNavigationItems.ItemCode, 
                         dbo.vfin_ModuleNavigationItems.ParentItemCode,
						 CASE  WHEN SUM(dbo.vfin_JournalEntries.Amount)>0 then SUM(dbo.vfin_JournalEntries.Amount)  else 0 end as Debit,
						 CASE  WHEN SUM(dbo.vfin_JournalEntries.Amount)<0 then SUM(dbo.vfin_JournalEntries.Amount)*-1  else 0 end as Credit
                        
FROM            dbo.vfin_ModuleNavigationItems INNER JOIN
                         dbo.vfin_Journals ON dbo.vfin_ModuleNavigationItems.ItemCode = dbo.vfin_Journals.ModuleNavigationItemCode INNER JOIN
                         dbo.vfin_JournalEntries ON dbo.vfin_Journals.Id = dbo.vfin_JournalEntries.JournalId INNER JOIN
                         dbo.vfin_ChartOfAccounts ON dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_ChartOfAccounts.Id 
WHERE        (dbo.vfin_ModuleNavigationItems.ItemCode NOT IN ('61657', '61754', '61757', '61758', '61759', '61760', '61755', '61756', '61655')) AND 
                         (dbo.vfin_JournalEntries.CreatedDate BETWEEN @StartDate AND @EndDate) 
GROUP BY dbo.vfin_ChartOfAccounts.AccountName, dbo.vfin_ModuleNavigationItems.ItemCode, dbo.vfin_ModuleNavigationItems.ParentItemCode, 
                         dbo.vfin_ModuleNavigationItems.ItemDescription
)

select ROW_NUMBER() OVER(ORDER BY ItemCode) AS Row,* into #temp1 from  CashJournal where debit+credit>0 

select *,SUM(debit-credit) OVER(ORDER BY Row 
						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal from  #temp1  order by ItemCode