IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_SystemTransactionSummaryByGledger') BEGIN
   EXEC('CREATE PROC [dbo].[sp_SystemTransactionSummaryByGledger] as')
END

GO

-- =============================================
-- Author:		Centrino
-- Create date: 21.10.2014
-- Description:	System Transaction Summary by Module
-- =============================================


--- sp_SystemTransactionSummaryByGledger 'B8BAD591-07B8-C04C-C925-08D1AC51F90D','10/21/2014','10/21/2014'
alter PROCEDURE [dbo].[sp_SystemTransactionSummaryByGledger] 
	-- Add the parameters for the stored procedure here
	@ChartOfAccountID varchar(50),
	@StartDate Datetime , 
	@EndDate Datetime 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		 Declare @OpenningBalance Numeric(18,2)

    -- Insert statements for procedure here
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));
	 set @OpenningBalance=isnull((select sum(amount) from vfin_JournalEntries 
					where ChartOfAccountId =@ChartOfAccountID 
					and CreatedDate<@StartDate),0);
	With GLTransactionSummaries_CTE (Serial,ItemDescription,ItemCode,ModuleDescription,ParentItemDescription,Debit,Credit,Amount,AccountName,AccountCode)
	as
	(
	SELECT      ROW_NUMBER() OVER(ORDER BY ItemDescription),  dbo.vfin_ModuleNavigationItems.ItemDescription,dbo.vfin_ModuleNavigationItems.ItemCode, dbo.vfin_ModuleNavigationItems.ModuleDescription, dbo.vfin_ModuleNavigationItems.ParentItemDescription, 
							CASE 
							WHEN SUM(dbo.vfin_JournalEntries.Amount)<0 THEN  SUM(dbo.vfin_JournalEntries.Amount)*-1 
							ELSE 0 END AS DEBIT,CASE 
							WHEN SUM(dbo.vfin_JournalEntries.Amount)>0 THEN  SUM(dbo.vfin_JournalEntries.Amount) 
							ELSE 0 END AS CREDIT,SUM(dbo.vfin_JournalEntries.Amount), dbo.vfin_ChartOfAccounts.AccountName,dbo.vfin_ChartOfAccounts.AccountCode
	FROM            dbo.vfin_JournalEntries INNER JOIN
							 dbo.vfin_Journals ON dbo.vfin_JournalEntries.JournalId = dbo.vfin_Journals.Id INNER JOIN
							 dbo.vfin_ChartOfAccounts ON dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_ChartOfAccounts.Id INNER JOIN
							 dbo.vfin_ModuleNavigationItems ON dbo.vfin_Journals.ModuleNavigationItemCode = dbo.vfin_ModuleNavigationItems.ItemCode
	WHERE dbo.vfin_JournalEntries.ChartOfAccountId=@ChartOfAccountID and vfin_JournalEntries.CreatedDate BETWEEN @StartDate AND @EndDate 
/*
	AND vfin_JournalEntries.ChartOfAccountId not in
	(SELECT        ChartOfAccountId
	FROM            dbo.vfin_SystemGeneralLedgerAccountMappings INNER JOIN
							 dbo.vfin_ChartOfAccounts ON dbo.vfin_SystemGeneralLedgerAccountMappings.ChartOfAccountId = dbo.vfin_ChartOfAccounts.Id
	WHERE        (dbo.vfin_SystemGeneralLedgerAccountMappings.SystemGeneralLedgerAccountCode  IN ('48826')))
	*/
	GROUP BY dbo.vfin_ModuleNavigationItems.ItemDescription, dbo.vfin_ModuleNavigationItems.ModuleDescription, dbo.vfin_ModuleNavigationItems.ParentItemDescription, 
							 dbo.vfin_ChartOfAccounts.AccountName,dbo.vfin_ModuleNavigationItems.ItemCode,dbo.vfin_ChartOfAccounts.AccountCode having SUM(dbo.vfin_JournalEntries.Amount)!=0

	)
		---SELECT Serial,AccountCode, AccountName, Debit,Credit,Amount,CreatedDate,PrimaryDescription,ContrAccountCode,ContraAccountName INTO #TempGLTrans FROM GLTransactionSummaries_CTE

	select * into #TempGLTrans from GLTransactionSummaries_CTE 	ORDER BY ParentItemDescription,ModuleDescription,ItemDescription
	insert into #TempGLTrans(Serial,ItemDescription,ItemCode,ModuleDescription,ParentItemDescription,Debit,Credit,Amount,AccountName,AccountCode)
	select 0,'', 0, '','',0,0,@OpenningBalance,'Balance B/F',0  from #TempGLTrans where Serial=1

	select Serial,ItemDescription,ItemCode,ModuleDescription,ParentItemDescription,Debit,Credit,SUM(Amount) OVER(ORDER BY Serial 
							ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal,AccountName,AccountCode from #TempGLTrans

END
