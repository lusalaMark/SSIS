IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_InvestmentProductsBalances') BEGIN
   EXEC('CREATE PROC [dbo].[sp_InvestmentProductsBalances] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_InvestmentProductsBalances]    Script Date: 9/13/2014 9:14:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
---sp_InvestmentProductsBalances '04/01/2014','>',1000000
ALTER PROCEDURE [dbo].[sp_InvestmentProductsBalances] 
	@Enddate Datetime,
	@Operator char(2),
	@OperatorValue float
AS
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT        dbo.vw_CustomerAccounts.FullAccount, dbo.vw_CustomerAccounts.FullName, dbo.vw_CustomerAccounts.AccountName, SUM(dbo.vfin_JournalEntries.Amount) 
							 AS Balance

	FROM            dbo.vfin_JournalEntries INNER JOIN
							 dbo.vfin_InvestmentProducts ON dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_InvestmentProducts.ChartOfAccountId INNER JOIN
							 dbo.vw_CustomerAccounts ON dbo.vfin_JournalEntries.CustomerAccountId = dbo.vw_CustomerAccounts.Id
	where dbo.vfin_JournalEntries.CreatedDate<=@Enddate    
	GROUP BY dbo.vw_CustomerAccounts.FullAccount, dbo.vw_CustomerAccounts.FullName, dbo.vw_CustomerAccounts.AccountName
	HAVING
	 ((@Operator = '>' and SUM(dbo.vfin_JournalEntries.Amount)  > @OperatorValue)
		or (@Operator = '<' and SUM(dbo.vfin_JournalEntries.Amount) < @OperatorValue)
		or (@Operator = '<>' and SUM(dbo.vfin_JournalEntries.Amount) != @OperatorValue)
		or (@Operator = '>=' and SUM(dbo.vfin_JournalEntries.Amount) >= @OperatorValue)
		or (@Operator = '<=' and SUM(dbo.vfin_JournalEntries.Amount) <= @OperatorValue)
		or (@Operator = '=' and SUM(dbo.vfin_JournalEntries.Amount) = @OperatorValue)
		)

END




