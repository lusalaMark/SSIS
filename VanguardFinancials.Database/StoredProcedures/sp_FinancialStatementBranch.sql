IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_FinancialStatementBranch') BEGIN
   EXEC('CREATE PROC [dbo].[sp_FinancialStatementBranch] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_FinancialStatementBranch]    Script Date: 9/13/2014 7:47:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

---[sp_FinancialStatementBranch] '12/31/2014','77898C54-67FE-C2DF-8E3C-08D0F8307E3A'
ALTER PROCEDURE [dbo].[sp_FinancialStatementBranch] 
	-- Add the parameters for the stored procedure here
	@Enddate datetime,@Branch varchar(Max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	---select * from vfin_JournalEntries
 SELECT 	[AccountType],
			[AccountTypeCode] =
			CASE [AccountType]
				WHEN 100000 THEN 'Assets'
				WHEN 200000 THEN 'Liabilities'
				WHEN 300000 THEN 'Equity'
				WHEN 400000 THEN 'Income'
				WHEN 500000 THEN 'Expenses'
			END,
			left(AccountCode,3) as ShortCode,
			space(depth*4)+ ltrim(rtrim(AccountCode))+' '+ltrim([AccountName]) as Code
			,
			isnull((
				SELECT sum(isnull(amount,0)) 
				FROM [dbo].[vfin_JournalEntries] 
				where JournalId in 
				(
					select id from vfin_Journals where BranchId=@Branch and CreatedDate<=@Enddate --'77898C54-67FE-C2DF-8E3C-08D0F8307E3A'
				) and ChartOfAccountId=[dbo].[vfin_ChartOfAccounts].Id
				
 			),0) as Balance
	  FROM [dbo].[vfin_ChartOfAccounts] order by AccountType,AccountCode
	

END






