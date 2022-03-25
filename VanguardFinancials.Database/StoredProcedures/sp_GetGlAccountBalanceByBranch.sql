IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_GetGlAccountBalanceByBranch') BEGIN
   EXEC('CREATE PROC [dbo].[sp_GetGlAccountBalanceByBranch] as')
END
GO

alter PROCEDURE [dbo].[sp_GetGlAccountBalanceByBranch] 
	-- Add the parameters for the stored procedure here
	@BranchID varchar(100),
	@ChartOfAccountID varchar(100)  , 
	@EndDate DateTime,
	@TransactionDateFilter int = 1
AS
BEGIN
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT        isnull(SUM(dbo.vfin_JournalEntries.Amount),0) AS Balance
	FROM            dbo.vfin_JournalEntries INNER JOIN
							 dbo.vfin_Journals ON dbo.vfin_JournalEntries.JournalId = dbo.vfin_Journals.Id
	WHERE			(dbo.vfin_JournalEntries.ChartOfAccountId = @ChartOfAccountID) 	and dbo.vfin_Journals.BranchId=@BranchID			
					AND 
					Case
					WHEN @TransactionDateFilter =1 then dbo.vfin_Journals.ValueDate 
					WHEN @TransactionDateFilter =2 then dbo.vfin_Journals.CreatedDate 
					END <= @EndDate 
END