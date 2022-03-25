IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='AccountProductsBalances') BEGIN
   EXEC('CREATE function [dbo].[AccountProductsBalances] as')
END
GO

/****** Object:  UserDefinedFunction [dbo].[AccountProductsBalances]    Script Date: 9/14/2014 6:53:48 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER function [dbo].[AccountProductsBalances] (@EndDate Datetime)
RETURNS TABLE
AS
RETURN
(
    SELECT 
	(SELECT 
	    RIGHT('00000'+CAST(ltrim(rtrim(SerialNumber)) AS VARCHAR(6)),6) 
		FROM [dbo].[vfin_Customers] 
		where id= [dbo].[vfin_CustomerAccounts].CustomerId) as MembershipNumber,
	(SELECT 
	    Individual_PayrollNumbers
		FROM [dbo].[vfin_Customers] 
		where id= [dbo].[vfin_CustomerAccounts].CustomerId) as PersonalFileNumber,
	(SELECT 
		[Salutation] =
		CASE Individual_Salutation
			WHEN '48814' THEN 'Mr'
			WHEN '48815' THEN 'Mrs'
			WHEN '48816' THEN 'Miss'
			WHEN '48817' THEN 'Dr'
			WHEN '48818' THEN 'Prof'
			WHEN '48819' THEN 'Rev'
			WHEN '48820' THEN 'Eng'
			WHEN '48821' THEN 'Hon'
			WHEN '48822' THEN 'Cllr'
			WHEN '48823' THEN 'Sir'
			WHEN '48824' THEN 'Ms'
			ELSE 'UnKnown'
		END +' '+
		[Individual_FirstName]+' '+
		[Individual_LastName]
		FROM [dbo].[vfin_Customers] 
		WHERE id= [dbo].[vfin_CustomerAccounts].CustomerId) as FullName
      ,
	  (SELECT [Description]
        FROM [dbo].[vfin_Branches] 
		WHERE ID=[dbo].[vfin_CustomerAccounts].[BranchId]) AS BranchName,
 		[Product Type] =
		CASE [CustomerAccountType_ProductCode]
			WHEN 1 THEN 'Savings'
			WHEN 2 THEN 'Loans'
			WHEN 3 THEN 'Investments'
			ELSE 'UnKnown'
		END 
		,
		[Product] =
		CASE [CustomerAccountType_ProductCode]
			WHEN 1 THEN 
				(SELECT 
				 [Description]
				FROM [dbo].[vfin_SavingsProducts] 
				WHERE ID=[dbo].[vfin_CustomerAccounts].[CustomerAccountType_TargetProductId])
			WHEN 2 THEN 
				(SELECT 
				 [Description]
				FROM [dbo].[vfin_LoanProducts] 
				WHERE ID=[dbo].[vfin_CustomerAccounts].[CustomerAccountType_TargetProductId])
			WHEN 3 THEN 
				(SELECT 
				 [Description]
				FROM [dbo].[vfin_InvestmentProducts] 
				WHERE ID=[dbo].[vfin_CustomerAccounts].[CustomerAccountType_TargetProductId])
			ELSE 'UnKnown'
		END,
		[Product Balance] =
		ISNULL(
				CASE [CustomerAccountType_ProductCode]
					WHEN 1 THEN 
					(SELECT 
						 (
							SELECT SUM(AMOUNT)
							FROM [dbo].[vfin_JournalEntries] 
							WHERE CustomerAccountId=[dbo].[vfin_CustomerAccounts].ID AND ChartOfAccountId=[dbo].[vfin_SavingsProducts].[ChartOfAccountId] AND CreatedDate<=@enddate
						 )
					FROM [dbo].[vfin_SavingsProducts] 
					WHERE ID=[dbo].[vfin_CustomerAccounts].[CustomerAccountType_TargetProductId])
					WHEN 2 THEN 
					(SELECT 
						 (
							SELECT SUM(AMOUNT)
							FROM [dbo].[vfin_JournalEntries] 
							WHERE CustomerAccountId=[dbo].[vfin_CustomerAccounts].ID AND ChartOfAccountId=[dbo].[vfin_LoanProducts].[ChartOfAccountId] AND CreatedDate<=@enddate
						 )
					FROM [dbo].[vfin_LoanProducts] 
					WHERE ID=[dbo].[vfin_CustomerAccounts].[CustomerAccountType_TargetProductId])
					WHEN 3 THEN 
					(SELECT 
						 (
							SELECT SUM(AMOUNT)
							FROM [dbo].[vfin_JournalEntries] 
							WHERE CustomerAccountId=[dbo].[vfin_CustomerAccounts].ID AND ChartOfAccountId=[dbo].[vfin_InvestmentProducts].[ChartOfAccountId] AND CreatedDate<=@enddate
						 )
					FROM [dbo].[vfin_InvestmentProducts] 
					WHERE ID=[dbo].[vfin_CustomerAccounts].[CustomerAccountType_TargetProductId])
				ELSE 0
				END 
				,0)
      ,[Remarks]
      ,[CreatedDate]
  FROM [dbo].[vfin_CustomerAccounts]

)


GO


