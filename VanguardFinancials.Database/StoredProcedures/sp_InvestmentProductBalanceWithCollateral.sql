
/****** Object:  StoredProcedure [dbo].[sp_InvestmentProductBalanceWithCollateral]    Script Date: 8/21/2015 9:24:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 25.10.2014
-- Description:	Loan and Interest Balances
-- =============================================
--select * from vfin_LoanGuarantors
---select * from vfin_InvestmentProducts
----sp_InvestmentProductBalanceWithCollateral '8B392C2A-6FB8-CB05-A450-08D1AD47AEEE','07/31/2015'
create PROCEDURE [dbo].[sp_InvestmentProductBalanceWithCollateral] 
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
	With InvestmentProductBalances(CustomerID,AccountNo,Reference1,Reference2,Reference3,AccountName,Balance)
	AS
	(
		SELECT        dbo.vw_CustomerAccounts.CustomerId,dbo.vw_CustomerAccounts.FullAccount,dbo.vw_CustomerAccounts.Reference1,dbo.vw_CustomerAccounts.Reference2,dbo.vw_CustomerAccounts.Reference3, 
		dbo.vw_CustomerAccounts.FullName, 
		SUM(dbo.vfin_JournalEntries.Amount) AS Amount
		FROM            dbo.vw_CustomerAccounts INNER JOIN
								 dbo.vfin_InvestmentProducts ON dbo.vw_CustomerAccounts.CustomerAccountType_TargetProductId = dbo.vfin_InvestmentProducts.Id INNER JOIN
								 dbo.vfin_JournalEntries ON dbo.vw_CustomerAccounts.Id = dbo.vfin_JournalEntries.CustomerAccountId AND 
								 dbo.vfin_InvestmentProducts.ChartOfAccountId = dbo.vfin_JournalEntries.ChartOfAccountId
		WHERE        (dbo.vfin_InvestmentProducts.id in (@ProductID) and dbo.vfin_JournalEntries.CreatedDate<=@EndDate)
		GROUP BY dbo.vw_CustomerAccounts.Reference1,dbo.vw_CustomerAccounts.Reference2, dbo.vw_CustomerAccounts.Reference3,  dbo.vw_CustomerAccounts.FullName,
		dbo.vw_CustomerAccounts.FullAccount,dbo.vw_CustomerAccounts.CustomerId
	)
	SELECT CustomerID,
	isnull((SELECT top 1 CaseNumber FROM  dbo.vfin_LoanCases INNER JOIN
                         dbo.vfin_LoanProducts ON dbo.vfin_LoanCases.LoanProductId = dbo.vfin_LoanProducts.Id where vfin_loancases.CustomerId=InvestmentProductBalances.customerid and vfin_LoanProducts.LoanRegistration_LoanProductSection='47803' and DisbursedDate is not null order by DisbursedDate desc),0) as [Loan Number],
	isnull((select sum(CommittedShares) from vfin_LoanGuarantors where CustomerId=InvestmentProductBalances.customerid and Status=0),0) as [Guarantee Amount],
	AccountNo,rtrim(rtrim(Reference1)) as Reference1,ltrim(rtrim(Reference2)) as Reference2,ltrim(rtrim(Reference3)) as Reference3 ,AccountName,SUM(Balance) AS Balance 
	into #temp1 FROM InvestmentProductBalances 
	Group By AccountNo,Reference1,Reference2,Reference3,AccountName,CustomerID having SUM(Balance) <>0
	
	select *,case when [Guarantee Amount]>Balance then balance else [Guarantee Amount] end as [Guarantee Amount1]  from #temp1 
END



