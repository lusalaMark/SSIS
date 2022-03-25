IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_LoansProductsBalances') BEGIN
   EXEC('CREATE PROC [dbo].[sp_LoansProductsBalances] as')
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
---sp_InvestmentProductsBalances '04/01/2014','<',0
ALTER PROCEDURE [dbo].[sp_LoansProductsBalances] 
	@Enddate Datetime,
	@Operator char(2),
	@OperatorValue float
AS
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT        dbo.vw_CustomerAccounts.FullAccount,dbo.vw_CustomerAccounts.reference1,dbo.vw_CustomerAccounts.reference2, dbo.vw_CustomerAccounts.FullName, dbo.vfin_LoanProducts.Description AS AccountName, SUM(dbo.vfin_JournalEntries.Amount)*-1 
							 AS Balance

	FROM            dbo.vfin_JournalEntries INNER JOIN
							 dbo.vfin_LoanProducts ON dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_LoanProducts.ChartOfAccountId INNER JOIN
							 dbo.vw_CustomerAccounts ON dbo.vfin_JournalEntries.CustomerAccountId = dbo.vw_CustomerAccounts.Id
	where dbo.vfin_JournalEntries.CreatedDate<=@Enddate    
	GROUP BY dbo.vw_CustomerAccounts.FullAccount, dbo.vw_CustomerAccounts.FullName, dbo.vfin_LoanProducts.Description,dbo.vw_CustomerAccounts.reference1,dbo.vw_CustomerAccounts.reference2
	HAVING
	 ((@Operator = '>' and SUM(dbo.vfin_JournalEntries.Amount)*-1  > @OperatorValue)
		or (@Operator = '<' and SUM(dbo.vfin_JournalEntries.Amount)*-1 < @OperatorValue)
		or (@Operator = '<>' and SUM(dbo.vfin_JournalEntries.Amount)*-1 != @OperatorValue)
		or (@Operator = '>=' and SUM(dbo.vfin_JournalEntries.Amount)*-1 >= @OperatorValue)
		or (@Operator = '<=' and SUM(dbo.vfin_JournalEntries.Amount)*-1 <= @OperatorValue)
		or (@Operator = '=' and SUM(dbo.vfin_JournalEntries.Amount)*-1 = @OperatorValue)
		)

END





GO
