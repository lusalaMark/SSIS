IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_LoanProductBalanceAndInterest') BEGIN
   EXEC('CREATE PROC [dbo].[sp_LoanProductBalanceAndInterest] as')
END

-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 25.10.2014
-- Description:	Loan and Interest Balances
-- =============================================
<<<<<<< .mine
alter PROCEDURE [dbo].[sp_LoanProductBalanceAndInterestSingleMember] 
=======
ALTER PROCEDURE [dbo].[sp_LoanProductBalanceAndInterestSingleMember] 
>>>>>>> .r173
	-- Add the parameters for the stored procedure here
	@CustomerID varchar(100), 
	@EndDate DateTime 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));

    -- Insert statements for procedure here
	With LoanProductBalances(Product,AccountNo,Reference1,Reference2,Reference3,AccountName,Balance,Interest,LoanDate)
	AS
	(
		SELECT        dbo.vfin_LoanProducts.Description, dbo.vw_CustomerAccounts.FullAccount,dbo.vw_CustomerAccounts.Reference1,dbo.vw_CustomerAccounts.Reference2,dbo.vw_CustomerAccounts.Reference3, 
		dbo.vw_CustomerAccounts.FullName, 0,
		SUM(dbo.vfin_JournalEntries.Amount)*-1 AS Amount,'' as LoanDate
		FROM            dbo.vw_CustomerAccounts INNER JOIN
								 dbo.vfin_LoanProducts ON dbo.vw_CustomerAccounts.CustomerAccountType_TargetProductId = dbo.vfin_LoanProducts.Id INNER JOIN
								 dbo.vfin_JournalEntries ON dbo.vw_CustomerAccounts.Id = dbo.vfin_JournalEntries.CustomerAccountId AND 
								 dbo.vfin_LoanProducts.InterestReceivableChartOfAccountId = dbo.vfin_JournalEntries.ChartOfAccountId
		WHERE        dbo.vw_CustomerAccounts.CustomerId=@CustomerID and dbo.vfin_JournalEntries.CreatedDate<=@EndDate
		GROUP BY dbo.vfin_LoanProducts.Description,dbo.vw_CustomerAccounts.Reference1,dbo.vw_CustomerAccounts.Reference2,dbo.vw_CustomerAccounts.Reference3, dbo.vw_CustomerAccounts.FullName,
		dbo.vw_CustomerAccounts.FullAccount
		UNION ALL
		SELECT        dbo.vfin_LoanProducts.Description,dbo.vw_CustomerAccounts.FullAccount,dbo.vw_CustomerAccounts.Reference1,dbo.vw_CustomerAccounts.Reference2,dbo.vw_CustomerAccounts.Reference3, 
		dbo.vw_CustomerAccounts.FullName, 
		SUM(dbo.vfin_JournalEntries.Amount)*-1 AS Amount,0,
		isnull((select top 1 DisbursedDate from vfin_LoanCases where CustomerId=vw_CustomerAccounts.CustomerId and LoanProductId=dbo.vfin_LoanProducts.id and DisbursedDate is not null order by DisbursedDate desc),'') as DisbursedDate
		FROM            dbo.vw_CustomerAccounts INNER JOIN
								 dbo.vfin_LoanProducts ON dbo.vw_CustomerAccounts.CustomerAccountType_TargetProductId = dbo.vfin_LoanProducts.Id INNER JOIN
								 dbo.vfin_JournalEntries ON dbo.vw_CustomerAccounts.Id = dbo.vfin_JournalEntries.CustomerAccountId AND 
								 dbo.vfin_LoanProducts.ChartOfAccountId = dbo.vfin_JournalEntries.ChartOfAccountId
		WHERE        ( dbo.vw_CustomerAccounts.CustomerId=@CustomerID and  dbo.vfin_JournalEntries.CreatedDate<=@EndDate)
		GROUP BY dbo.vfin_LoanProducts.Description,dbo.vw_CustomerAccounts.Reference1,dbo.vw_CustomerAccounts.Reference2, dbo.vw_CustomerAccounts.Reference3,  dbo.vw_CustomerAccounts.FullName,
		dbo.vw_CustomerAccounts.FullAccount,vw_CustomerAccounts.CustomerId,dbo.vfin_LoanProducts.id
	)
	SELECT Product, AccountNo,rtrim(rtrim(Reference1)) as Reference1,ltrim(rtrim(Reference2)) as Reference2,ltrim(rtrim(Reference3)) as Reference3 ,AccountName,SUM(Balance) AS Balance,sum(Interest) as Interest,LoanDate 
	FROM LoanProductBalances 
	Group By Product,AccountNo,Reference1,Reference2,Reference3,AccountName,LoanDate having SUM(Balance) +sum(Interest)<>0
END

GO