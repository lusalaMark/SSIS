
/****** Object:  StoredProcedure [dbo].[sp_LoanProductBalanceAndInterestSingleMember]    Script Date: 07-Jul-15 11:20:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 25.10.2014
-- Description:	Loan and Interest Balances
-- =============================================
--select * from dbo.Products(0)
--exec sp_LoanProductBalanceAndInterestSingleMember '1389F574-A349-C1DF-5D85-08D24D5414F3'
--'12542'

CREATE PROCEDURE [dbo].[sp_LoanProductBalanceAndInterestSingleMember] 
	-- Add the parameters for the stored procedure here
	@CustomerID varchar(100)
	--@Reference2 Varchar (50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	With LoanProductBalances(Product,AccountNo,Reference1,Reference2,Reference3,AccountName,Balance,Interest,LoanDate)
	AS
	(
		SELECT        vfin_LoanProducts.Description, dbo.vw_CustomerAccounts.FullAccount,dbo.vw_CustomerAccounts.Reference1,dbo.vw_CustomerAccounts.Reference2,dbo.vw_CustomerAccounts.Reference3, 
		dbo.vw_CustomerAccounts.FullName, 0,
		SUM(dbo.vfin_JournalEntries.Amount)*-1 AS Amount,'' as LoanDate
		FROM            dbo.vw_CustomerAccounts INNER JOIN
								 dbo.Products(0) vfin_LoanProducts  ON dbo.vw_CustomerAccounts.CustomerAccountType_TargetProductId = vfin_LoanProducts.Id INNER JOIN
								 dbo.vfin_JournalEntries ON dbo.vw_CustomerAccounts.Id = dbo.vfin_JournalEntries.CustomerAccountId AND 
								 vfin_LoanProducts.InterestReceivable = dbo.vfin_JournalEntries.ChartOfAccountId
		WHERE  dbo.vw_CustomerAccounts.CustomerId=@CustomerID       
		--Reference2=@Reference2
		
		GROUP BY vfin_LoanProducts.Description,dbo.vw_CustomerAccounts.Reference1,dbo.vw_CustomerAccounts.Reference2,dbo.vw_CustomerAccounts.Reference3, dbo.vw_CustomerAccounts.FullName,
		dbo.vw_CustomerAccounts.FullAccount
		UNION ALL
		SELECT        vfin_LoanProducts.Description,dbo.vw_CustomerAccounts.FullAccount,dbo.vw_CustomerAccounts.Reference1,dbo.vw_CustomerAccounts.Reference2,dbo.vw_CustomerAccounts.Reference3, 
		dbo.vw_CustomerAccounts.FullName, 
		SUM(dbo.vfin_JournalEntries.Amount)*-1 AS Amount,0,
		isnull((select top 1 DisbursedDate from vfin_LoanCases where CustomerId=vw_CustomerAccounts.CustomerId and LoanProductId=vfin_LoanProducts.id and DisbursedDate is not null order by DisbursedDate desc),'') as DisbursedDate
		FROM            dbo.vw_CustomerAccounts INNER JOIN
								 dbo.Products(0) vfin_LoanProducts ON dbo.vw_CustomerAccounts.CustomerAccountType_TargetProductId = vfin_LoanProducts.Id INNER JOIN
								 dbo.vfin_JournalEntries ON dbo.vw_CustomerAccounts.Id = dbo.vfin_JournalEntries.CustomerAccountId AND 
								 vfin_LoanProducts.ChartOfAccountId = dbo.vfin_JournalEntries.ChartOfAccountId
		WHERE   dbo.vw_CustomerAccounts.CustomerId=@CustomerID   
		 
		-- Reference2=@Reference2
		GROUP BY vfin_LoanProducts.Description,dbo.vw_CustomerAccounts.Reference1,dbo.vw_CustomerAccounts.Reference2, dbo.vw_CustomerAccounts.Reference3,  dbo.vw_CustomerAccounts.FullName,
		dbo.vw_CustomerAccounts.FullAccount,vw_CustomerAccounts.CustomerId,vfin_LoanProducts.id
	)
	SELECT Product, AccountNo,rtrim(rtrim(Reference1)) as Reference1,ltrim(rtrim(Reference2)) as Reference2,ltrim(rtrim(Reference3)) as Reference3 ,AccountName,SUM(Balance)*-1 AS Balance,sum(Interest) as Interest,LoanDate 
	FROM LoanProductBalances 
	Group By Product,AccountNo,Reference1,Reference2,Reference3,AccountName,LoanDate having SUM(Balance)*-1 +sum(Interest)<>0
END

