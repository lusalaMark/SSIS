USE [VanguardFinancialsDB_KHS]
GO
/****** Object:  StoredProcedure [dbo].[sp_InvestmentProductBalanceWithGrowerNumbers]    Script Date: 6/29/2015 11:42:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 25.10.2014
-- Description:	Loan and Interest Balances
-- =============================================
alter PROCEDURE [dbo].[sp_InvestmentProductBalanceWithGrowerNumbers] 
	-- Add the parameters for the stored procedure here
	@ProductID varchar(100), 
	@EndDate DateTime ,
	@BuyingCenterCode varchar(5)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));

	declare 
	@LocalProductID varchar(100)=@ProductID, 
	@LocalEndDate DateTime =@EndDate,
	@LocalBuyingCenterCode varchar(5)=	@BuyingCenterCode ;
    -- Insert statements for procedure here
	With InvestmentProductBalances(AccountNo,Reference1,Reference2,Reference3,AccountName,Balance,GrowerNo,PayrollNumbers)
	AS
	(
		SELECT        dbo.vw_CustomerAccounts.FullAccount,dbo.vw_CustomerAccounts.Reference1,dbo.vw_CustomerAccounts.Reference2,dbo.vw_CustomerAccounts.Reference3, 
		dbo.vw_CustomerAccounts.FullName, 
		SUM(dbo.vfin_JournalEntries.Amount) AS Amount,SUBSTRING(Individual_PayrollNumbers,PATINDEX('%'+@LocalBuyingCenterCode+'%',vw_CustomerAccounts.Individual_PayrollNumbers ),9),dbo.vw_CustomerAccounts.Individual_PayrollNumbers
		FROM            dbo.vw_CustomerAccounts INNER JOIN
								 dbo.vfin_InvestmentProducts ON dbo.vw_CustomerAccounts.CustomerAccountType_TargetProductId = dbo.vfin_InvestmentProducts.Id INNER JOIN
								 dbo.vfin_JournalEntries ON dbo.vw_CustomerAccounts.Id = dbo.vfin_JournalEntries.CustomerAccountId AND 
								 dbo.vfin_InvestmentProducts.ChartOfAccountId = dbo.vfin_JournalEntries.ChartOfAccountId
		WHERE        (dbo.vfin_InvestmentProducts.id in (@LocalProductID) and dbo.vfin_JournalEntries.CreatedDate<=@LocalEndDate) and dbo.vw_CustomerAccounts.Individual_PayrollNumbers like '%'+@LocalBuyingCenterCode+'%'
		GROUP BY dbo.vw_CustomerAccounts.Reference1,Individual_PayrollNumbers,dbo.vw_CustomerAccounts.Reference2, dbo.vw_CustomerAccounts.Reference3,  dbo.vw_CustomerAccounts.FullName,
		dbo.vw_CustomerAccounts.FullAccount
	)
	SELECT AccountNo,rtrim(rtrim(Reference1)) as Reference1,ltrim(rtrim(Reference2)) as Reference2,ltrim(rtrim(Reference3)) as Reference3 ,AccountName,SUM(Balance) AS Balance,GrowerNo,PayrollNumbers 
	FROM InvestmentProductBalances where left(GrowerNo,5)=@BuyingCenterCode
	Group By AccountNo,Reference1,Reference2,Reference3,AccountName,GrowerNo,PayrollNumbers having SUM(Balance) <>0 order by GrowerNo
END

