IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_LoanProductBalanceAndInterestNegativeLoans') BEGIN
   EXEC('CREATE PROC [dbo].[sp_LoanProductBalanceAndInterestNegativeLoans] as')
END
GO


/****** Object:  StoredProcedure [dbo].[sp_LoanProductBalanceAndInterest]    Script Date: 5/7/2015 7:08:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 25.10.2014
-- Description:	Loan and Interest Balances
-- =============================================
alter PROCEDURE [dbo].[sp_LoanProductBalanceAndInterestNegativeLoans] 
	-- Add the parameters for the stored procedure here
	@ProductID uniqueidentifier, 
	@EndDate DateTime 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));

    -- Insert statements for procedure here
	With LoanProductBalances(AccountNo,Reference1,Reference2,Reference3,AccountName,Balance,Interest)
	AS
	(
		SELECT        dbo.vw_CustomerAccounts.FullAccount,dbo.vw_CustomerAccounts.Reference1,dbo.vw_CustomerAccounts.Reference2,dbo.vw_CustomerAccounts.Reference3, 
		dbo.vw_CustomerAccounts.FullName, 0,
		SUM(dbo.vfin_JournalEntries.Amount)*-1 AS Amount
		FROM            dbo.vw_CustomerAccounts INNER JOIN
								 dbo.vfin_LoanProducts ON dbo.vw_CustomerAccounts.CustomerAccountType_TargetProductId = dbo.vfin_LoanProducts.Id INNER JOIN
								 dbo.vfin_JournalEntries ON dbo.vw_CustomerAccounts.Id = dbo.vfin_JournalEntries.CustomerAccountId AND 
								 dbo.vfin_LoanProducts.InterestReceivableChartOfAccountId = dbo.vfin_JournalEntries.ChartOfAccountId
		WHERE        (dbo.vfin_LoanProducts.id = @ProductID and dbo.vfin_JournalEntries.CreatedDate<=@EndDate)
		GROUP BY dbo.vw_CustomerAccounts.Reference1,dbo.vw_CustomerAccounts.Reference2,dbo.vw_CustomerAccounts.Reference3, dbo.vw_CustomerAccounts.FullName,
		dbo.vw_CustomerAccounts.FullAccount
		UNION ALL
		SELECT        dbo.vw_CustomerAccounts.FullAccount,dbo.vw_CustomerAccounts.Reference1,dbo.vw_CustomerAccounts.Reference2,dbo.vw_CustomerAccounts.Reference3, 
		dbo.vw_CustomerAccounts.FullName, 
		SUM(dbo.vfin_JournalEntries.Amount)*-1 AS Amount,0
		FROM            dbo.vw_CustomerAccounts INNER JOIN
								 dbo.vfin_LoanProducts ON dbo.vw_CustomerAccounts.CustomerAccountType_TargetProductId = dbo.vfin_LoanProducts.Id INNER JOIN
								 dbo.vfin_JournalEntries ON dbo.vw_CustomerAccounts.Id = dbo.vfin_JournalEntries.CustomerAccountId AND 
								 dbo.vfin_LoanProducts.ChartOfAccountId = dbo.vfin_JournalEntries.ChartOfAccountId
		WHERE        (dbo.vfin_LoanProducts.id = @ProductID and dbo.vfin_JournalEntries.CreatedDate<=@EndDate)
		GROUP BY dbo.vw_CustomerAccounts.Reference1,dbo.vw_CustomerAccounts.Reference2, dbo.vw_CustomerAccounts.Reference3,  dbo.vw_CustomerAccounts.FullName,
		dbo.vw_CustomerAccounts.FullAccount
	)
	SELECT AccountNo,rtrim(rtrim(Reference1)) as Reference1,ltrim(rtrim(Reference2)) as Reference2,ltrim(rtrim(Reference3)) as Reference3 ,AccountName,SUM(Balance) AS Balance,sum(Interest) as Interest 
	FROM LoanProductBalances 
	Group By AccountNo,Reference1,Reference2,Reference3,AccountName having SUM(Balance)<0 or  sum(Interest)<0
END
