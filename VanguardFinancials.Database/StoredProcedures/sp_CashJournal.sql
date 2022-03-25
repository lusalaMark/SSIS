IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_CashJournal') BEGIN
   EXEC('CREATE PROC [dbo].[sp_CashJournal] as')
END
GO
	/****** Object:  StoredProcedure [dbo].[sp_CashJournal]    Script Date: 12/19/2014 3:55:24 PM ******/
	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO
	---sp_CashJournal '12/08/2014','12/08/2014'
	--select count()
	ALTER Procedure [dbo].[sp_CashJournal] (@StartDate DateTime, @EndDate DateTime)as
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));

	With CashJournal(ItemDescription,AccountName,ItemCode,ParentItemCode,Debit,Credit,PrimaryDescription)
	as
	(select 'Previous Balance','Cash in Hand','00000','00000',CASE  WHEN    sum(amount)<0 then SUM(Amount)*-1  else 0 end as Debit,CASE  WHEN    sum(amount)>0 then SUM(Amount)  else 0 end as Credit,'CASH IN HAND' from vfin_JournalEntries where ChartOfAccountId in (select ChartOfAccountId from vfin_Treasuries) and CreatedDate<@StartDate
	union 
	SELECT        TOP (100) PERCENT dbo.vfin_ModuleNavigationItems.ItemDescription, dbo.vfin_ChartOfAccounts.AccountName, dbo.vfin_ModuleNavigationItems.ItemCode, 
							 dbo.vfin_ModuleNavigationItems.ParentItemCode,
						 CASE  WHEN SUM(dbo.vfin_JournalEntries.Amount)>0 then SUM(dbo.vfin_JournalEntries.Amount)  else 0 end as Debit,
							 CASE  WHEN SUM(dbo.vfin_JournalEntries.Amount)<0 then SUM(dbo.vfin_JournalEntries.Amount)*-1  else 0 end as Credit,
							  LEFT(dbo.vfin_Journals.PrimaryDescription, 17) 
							 AS PrimaryDescription
	FROM            dbo.vfin_ModuleNavigationItems INNER JOIN
							 dbo.vfin_Journals ON dbo.vfin_ModuleNavigationItems.ItemCode = dbo.vfin_Journals.ModuleNavigationItemCode INNER JOIN
							 dbo.vfin_JournalEntries ON dbo.vfin_Journals.Id = dbo.vfin_JournalEntries.JournalId INNER JOIN
							 dbo.vfin_ChartOfAccounts ON dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_ChartOfAccounts.Id INNER JOIN
							 dbo.vfin_Tellers ON dbo.vfin_JournalEntries.ContraChartOfAccountId = dbo.vfin_Tellers.ChartOfAccountId
	WHERE        (dbo.vfin_ModuleNavigationItems.ItemCode IN ('61657', '61754', '61757', '61758', '61759', '61760', '61755', '61756', '61655')) AND 
							 (dbo.vfin_JournalEntries.CreatedDate BETWEEN @StartDate AND @EndDate) 
	GROUP BY dbo.vfin_ChartOfAccounts.AccountName, dbo.vfin_ModuleNavigationItems.ItemCode, dbo.vfin_ModuleNavigationItems.ParentItemCode, 
							 dbo.vfin_ModuleNavigationItems.ItemDescription, LEFT(dbo.vfin_Journals.PrimaryDescription, 17)
	)

	select ROW_NUMBER() OVER(ORDER BY ItemCode) AS Row,* into #temp1 from  CashJournal where accountname not in ('Uncleared Cheques Control') and PrimaryDescription not like '%cheque%'
	and accountname not in ('Treasury Kabianga','Treasury Kapsoit','Treasury Kericho') order by ItemCode

	select *,SUM(debit-credit) OVER(ORDER BY Row 
							ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal from  #temp1  order by ItemCode