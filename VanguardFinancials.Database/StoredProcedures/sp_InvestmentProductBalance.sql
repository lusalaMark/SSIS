IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_InvestmentProductBalance') BEGIN
   EXEC('CREATE PROC [dbo].[sp_InvestmentProductBalance] as')
END

GO
/****** Object:  StoredProcedure [dbo].[sp_MemberPerEmployer]    Script Date: 10/15/2014 5:29:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

alter PROCEDURE [dbo].[sp_InvestmentProductBalance] 
	-- Add the parameters for the stored procedure here
	@ProductID varchar(100), 
	@EndDate DateTime 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));

    -- Insert statements for procedure here
	With InvestmentProductBalances(AccountNo,Reference1,Reference2,Reference3,AccountName,Balance)
	AS
	(
		SELECT        dbo.vw_CustomerAccounts.FullAccount,dbo.vw_CustomerAccounts.Reference1,dbo.vw_CustomerAccounts.Reference2,dbo.vw_CustomerAccounts.Reference3, 
		dbo.vw_CustomerAccounts.FullName, 
		SUM(dbo.vfin_JournalEntries.Amount) AS Amount
		FROM            dbo.vw_CustomerAccounts INNER JOIN
								 dbo.vfin_InvestmentProducts ON dbo.vw_CustomerAccounts.CustomerAccountType_TargetProductId = dbo.vfin_InvestmentProducts.Id INNER JOIN
								 dbo.vfin_JournalEntries ON dbo.vw_CustomerAccounts.Id = dbo.vfin_JournalEntries.CustomerAccountId AND 
								 dbo.vfin_InvestmentProducts.ChartOfAccountId = dbo.vfin_JournalEntries.ChartOfAccountId
		WHERE        (dbo.vfin_InvestmentProducts.id in (@ProductID) and dbo.vfin_JournalEntries.CreatedDate<=@EndDate)
		GROUP BY dbo.vw_CustomerAccounts.Reference1,dbo.vw_CustomerAccounts.Reference2, dbo.vw_CustomerAccounts.Reference3,  dbo.vw_CustomerAccounts.FullName,
		dbo.vw_CustomerAccounts.FullAccount
	)
	SELECT AccountNo,rtrim(rtrim(Reference1)) as Reference1,ltrim(rtrim(Reference2)) as Reference2,ltrim(rtrim(Reference3)) as Reference3 ,AccountName,SUM(Balance) AS Balance 
	FROM InvestmentProductBalances 
	Group By AccountNo,Reference1,Reference2,Reference3,AccountName having SUM(Balance) <>0
END

