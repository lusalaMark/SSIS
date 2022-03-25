IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_SystemTransactionSummaryByBranch') BEGIN
   EXEC('CREATE PROC [dbo].[sp_SystemTransactionSummaryByBranch] as')
END

GO

-- =============================================
-- Author:		Centrino
-- Create date: 21.10.2014
-- Description:	System Transaction Summary by Module
-- =============================================
--- sp_SystemTransactionSummary '10/21/2014','10/21/2014'
ALTER PROCEDURE [dbo].[sp_SystemTransactionSummaryByBranch] 
	-- Add the parameters for the stored procedure here
	@StartDate Datetime  , 
	@EndDate Datetime ,
	@BranchID uniqueidentifier
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));
	SELECT        dbo.vfin_ModuleNavigationItems.ItemDescription,dbo.vfin_ModuleNavigationItems.id as ModuleNavigationItemID ,dbo.vfin_ModuleNavigationItems.ItemCode,dbo.vfin_ModuleNavigationItems.ModuleDescription, dbo.vfin_ModuleNavigationItems.ParentItemDescription, 
							CASE 
							WHEN SUM(dbo.vfin_JournalEntries.Amount)<0 THEN  SUM(dbo.vfin_JournalEntries.Amount)*-1 
							ELSE 0 END AS DEBIT,CASE 
							WHEN SUM(dbo.vfin_JournalEntries.Amount)>0 THEN  SUM(dbo.vfin_JournalEntries.Amount) 
							ELSE 0 END AS CREDIT, dbo.vfin_ChartOfAccounts.Id as ChartOfAccountID,dbo.vfin_ChartOfAccounts.AccountName,dbo.vfin_ChartOfAccounts.AccountCode
	FROM            dbo.vfin_JournalEntries INNER JOIN
							 dbo.vfin_Journals ON dbo.vfin_JournalEntries.JournalId = dbo.vfin_Journals.Id INNER JOIN
							 dbo.vfin_ChartOfAccounts ON dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_ChartOfAccounts.Id INNER JOIN
							 dbo.vfin_ModuleNavigationItems ON dbo.vfin_Journals.ModuleNavigationItemCode = dbo.vfin_ModuleNavigationItems.ItemCode
	WHERE  dbo.vfin_Journals.BranchId=@BranchID and vfin_JournalEntries.CreatedDate BETWEEN @StartDate AND @EndDate
/*
	AND vfin_JournalEntries.ChartOfAccountId not in
	(SELECT        ChartOfAccountId
	FROM            dbo.vfin_SystemGeneralLedgerAccountMappings INNER JOIN
							 dbo.vfin_ChartOfAccounts ON dbo.vfin_SystemGeneralLedgerAccountMappings.ChartOfAccountId = dbo.vfin_ChartOfAccounts.Id
	WHERE        (dbo.vfin_SystemGeneralLedgerAccountMappings.SystemGeneralLedgerAccountCode  IN ('48826')))
	*/
	GROUP BY dbo.vfin_ModuleNavigationItems.ItemDescription, dbo.vfin_ModuleNavigationItems.ModuleDescription, dbo.vfin_ModuleNavigationItems.ParentItemDescription, 
							 dbo.vfin_ChartOfAccounts.AccountName,dbo.vfin_ChartOfAccounts.Id,dbo.vfin_ModuleNavigationItems.id,dbo.vfin_ModuleNavigationItems.ItemCode,dbo.vfin_ChartOfAccounts.AccountCode having SUM(dbo.vfin_JournalEntries.Amount)!=0
	ORDER BY ParentItemDescription,ModuleDescription,ItemDescription

END
