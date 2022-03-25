IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_SystemTransactionSummaryByBranchDetailed') BEGIN
   EXEC('CREATE PROC [dbo].[sp_SystemTransactionSummaryByBranchDetailed] as')
END

GO

---sp_SystemTransactionSummaryByBranchDetailed '01/31/2015','01/31/2015','8B8B1B74-141C-CF68-05C2-08D19D7D7330'
alter PROCEDURE [dbo].[sp_SystemTransactionSummaryByBranchDetailed] 
	-- Add the parameters for the stored procedure here
	@StartDate Datetime  , 
	@EndDate Datetime ,
	@BranchID uniqueidentifier,
	@ChartOfAccountID varchar(50),
	@ModuleNavigationItemsID Varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));
	SELECT        TOP (100) PERCENT dbo.vfin_ModuleNavigationItems.ItemDescription, dbo.vfin_ModuleNavigationItems.ItemCode, 
                         dbo.vfin_ModuleNavigationItems.ModuleDescription, dbo.vfin_ModuleNavigationItems.ParentItemDescription, CASE WHEN SUM(dbo.vfin_JournalEntries.Amount) 
                         < 0 THEN SUM(dbo.vfin_JournalEntries.Amount) * - 1 ELSE 0 END AS DEBIT, CASE WHEN SUM(dbo.vfin_JournalEntries.Amount) 
                         > 0 THEN SUM(dbo.vfin_JournalEntries.Amount) ELSE 0 END AS CREDIT, dbo.vfin_ChartOfAccounts.AccountName, dbo.vfin_ChartOfAccounts.AccountCode, 
                         dbo.vfin_Journals.PrimaryDescription, dbo.vfin_Journals.SecondaryDescription, dbo.vfin_Journals.Reference, dbo.vw_CustomerAccounts.FullName, 
                         dbo.vw_CustomerAccounts.Reference1
FROM            dbo.vfin_JournalEntries INNER JOIN
                         dbo.vfin_Journals ON dbo.vfin_JournalEntries.JournalId = dbo.vfin_Journals.Id INNER JOIN
                         dbo.vfin_ChartOfAccounts ON dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_ChartOfAccounts.Id INNER JOIN
                         dbo.vfin_ModuleNavigationItems ON dbo.vfin_Journals.ModuleNavigationItemCode = dbo.vfin_ModuleNavigationItems.ItemCode LEFT OUTER JOIN
                         dbo.vw_CustomerAccounts ON dbo.vfin_JournalEntries.CustomerAccountId = dbo.vw_CustomerAccounts.Id
WHERE        (dbo.vfin_Journals.BranchId = @BranchID and dbo.vfin_ModuleNavigationItems.id=@ModuleNavigationItemsID and dbo.vfin_ChartOfAccounts.ID=@ChartOfAccountID ) AND (dbo.vfin_JournalEntries.CreatedDate BETWEEN @StartDate AND @EndDate)
GROUP BY dbo.vfin_ModuleNavigationItems.ItemDescription, dbo.vfin_ModuleNavigationItems.ModuleDescription, dbo.vfin_ModuleNavigationItems.ParentItemDescription, 
                         dbo.vfin_ChartOfAccounts.AccountName, dbo.vfin_ModuleNavigationItems.ItemCode, dbo.vfin_ChartOfAccounts.AccountCode, dbo.vfin_Journals.PrimaryDescription, 
                         dbo.vfin_Journals.SecondaryDescription, dbo.vfin_Journals.Reference, dbo.vw_CustomerAccounts.FullName, dbo.vw_CustomerAccounts.Reference1
HAVING        (SUM(dbo.vfin_JournalEntries.Amount) <> 0)
ORDER BY dbo.vfin_ModuleNavigationItems.ParentItemDescription, dbo.vfin_ModuleNavigationItems.ModuleDescription, dbo.vfin_ModuleNavigationItems.ItemDescription
END
