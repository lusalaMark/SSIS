
/****** Object:  StoredProcedure [dbo].[sp_InvestmentProductBalance]    Script Date: 04-Aug-15 6:40:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---select * from vfin_InvestmentProducts
--sp_InvestmentProductBalanceWithIncreament '76ACE21D-C656-C0F1-67C6-08D1AD47AEEF','05/31/2015'
create PROCEDURE [dbo].[sp_InvestmentProductBalanceWithIncreament] 
	-- Add the parameters for the stored procedure here
	@ProductID varchar(100), 
	@EndDate DateTime 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @StartDate DateTime
	set @StartDate=(SELECT DATEADD(month, DATEDIFF(month, 0, @EndDate), 0))
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));

    -- Insert statements for procedure here
	With InvestmentProductBalances(id,Reference1,Reference2,Reference3,AccountName,Balance)
	AS
	(
		SELECT        dbo.vw_CustomerAccounts.id,dbo.vw_CustomerAccounts.Reference1,dbo.vw_CustomerAccounts.Reference2,dbo.vw_CustomerAccounts.Reference3, 
		dbo.vw_CustomerAccounts.FullName,
		SUM(dbo.vfin_JournalEntries.Amount) AS Amount
		FROM            dbo.vw_CustomerAccounts INNER JOIN
								 dbo.vfin_InvestmentProducts ON dbo.vw_CustomerAccounts.CustomerAccountType_TargetProductId = dbo.vfin_InvestmentProducts.Id INNER JOIN
								 dbo.vfin_JournalEntries ON dbo.vw_CustomerAccounts.Id = dbo.vfin_JournalEntries.CustomerAccountId AND 
								 dbo.vfin_InvestmentProducts.ChartOfAccountId = dbo.vfin_JournalEntries.ChartOfAccountId
		WHERE        (dbo.vfin_InvestmentProducts.id in (@ProductID) and dbo.vfin_JournalEntries.CreatedDate<=@StartDate)
		GROUP BY dbo.vw_CustomerAccounts.Reference1,dbo.vw_CustomerAccounts.Reference2, dbo.vw_CustomerAccounts.Reference3,  dbo.vw_CustomerAccounts.FullName,
		dbo.vw_CustomerAccounts.Id
	)
	SELECT id,rtrim(rtrim(Reference1)) as Reference1,ltrim(rtrim(Reference2)) as Reference2,ltrim(rtrim(Reference3)) as Reference3 ,AccountName,SUM(Balance) AS Balance,
	isnull((select sum(amount) from vfin_JournalEntries where CustomerAccountId=InvestmentProductBalances.id and ChartOfAccountId in (select ChartOfAccountId from vfin_InvestmentProducts where id=@ProductID) and CreatedDate between @StartDate and @EndDate),0) as Increament,
SUM(Balance) +isnull((select sum(amount) from vfin_JournalEntries where CustomerAccountId=InvestmentProductBalances.id and ChartOfAccountId in (select ChartOfAccountId from vfin_InvestmentProducts where id=@ProductID) and CreatedDate between @StartDate and @EndDate),0) as NewBalance
		
	FROM InvestmentProductBalances 
	Group By id,Reference1,Reference2,Reference3,AccountName having SUM(Balance) <>0
END

