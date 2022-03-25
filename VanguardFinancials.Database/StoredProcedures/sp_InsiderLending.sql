IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_InsiderLending') BEGIN
   EXEC('CREATE PROC [dbo].[sp_InsiderLending] as')
END
GO

/****** Object:  StoredProcedure [dbo].[sp_InsiderLending]    Script Date: 9/13/2014 9:12:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 16.07.2014
-- Description:	InsiderLending
-- =============================================
ALTER PROCEDURE [dbo].[sp_InsiderLending] 
	-- Add the parameters for the stored procedure here
	@EndDate DateTime 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));

    -- Insert statements for procedure here
				SELECT        dbo.vw_MemberRegister.Salutation +' '+ dbo.vw_MemberRegister.Individual_FirstName +' '+ dbo.vw_MemberRegister.Individual_LastName as FullName, 
									 dbo.vw_MemberRegister.Gender, dbo.vw_MemberRegister.Individual_IdentityCardNumber, dbo.vw_MemberRegister.MembershipNumber, 
									 dbo.vw_MemberRegister.Individual_PayrollNumbers,


			isnull((

			SELECT        sum(dbo.vfin_JournalEntries.Amount)
			FROM            dbo.vfin_CustomerAccounts INNER JOIN
									 dbo.vfin_JournalEntries ON dbo.vfin_CustomerAccounts.Id = dbo.vfin_JournalEntries.CustomerAccountId INNER JOIN
									 dbo.vfin_LoanProducts ON dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductId = dbo.vfin_LoanProducts.Id AND 
									 dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_LoanProducts.ChartOfAccountId
			WHERE        (dbo.vfin_CustomerAccounts.CustomerId = vfin_Directors.CustomerId) AND 
									 (dbo.vfin_LoanProducts.LoanRegistration_LoanProductSection = 47803) and vfin_JournalEntries.CreatedDate<=@EndDate
			),0)*-1 as BosaLoans,
			isnull((
			SELECT        sum(dbo.vfin_JournalEntries.Amount)
			FROM            dbo.vfin_CustomerAccounts INNER JOIN
									 dbo.vfin_JournalEntries ON dbo.vfin_CustomerAccounts.Id = dbo.vfin_JournalEntries.CustomerAccountId INNER JOIN
									 dbo.vfin_LoanProducts ON dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductId = dbo.vfin_LoanProducts.Id AND 
									 dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_LoanProducts.ChartOfAccountId
			WHERE        (dbo.vfin_CustomerAccounts.CustomerId = vfin_Directors.CustomerId) AND 
									 (dbo.vfin_LoanProducts.LoanRegistration_LoanProductSection = 47802) and vfin_JournalEntries.CreatedDate<=@EndDate
			),0)*-1 as FosaLoans,
			isnull((
			SELECT        sum(dbo.vfin_JournalEntries.Amount)
			FROM            dbo.vfin_CustomerAccounts INNER JOIN
									 dbo.vfin_JournalEntries ON dbo.vfin_CustomerAccounts.Id = dbo.vfin_JournalEntries.CustomerAccountId INNER JOIN
									 dbo.vfin_LoanProducts ON dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductId = dbo.vfin_LoanProducts.Id AND 
									 dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_LoanProducts.ChartOfAccountId
			WHERE        (dbo.vfin_CustomerAccounts.CustomerId = vfin_Directors.CustomerId) and vfin_JournalEntries.CreatedDate<=@EndDate
			),0)*-1 as TotalLoans,

			isnull((
			SELECT        sum(dbo.vfin_JournalEntries.Amount)
			FROM            dbo.vfin_CustomerAccounts INNER JOIN
									 dbo.vfin_JournalEntries ON dbo.vfin_CustomerAccounts.Id = dbo.vfin_JournalEntries.CustomerAccountId INNER JOIN
									 dbo.vfin_InvestmentProducts ON dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductId = dbo.vfin_InvestmentProducts.Id AND 
									 dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_InvestmentProducts.ChartOfAccountId
			WHERE        (dbo.vfin_CustomerAccounts.CustomerId = vfin_Directors.CustomerId) and vfin_InvestmentProducts.Code=1 and vfin_JournalEntries.CreatedDate<=@EndDate
			),0) as ShareCapital,
			isnull((
			SELECT        sum(dbo.vfin_JournalEntries.Amount)
			FROM            dbo.vfin_CustomerAccounts INNER JOIN
									 dbo.vfin_JournalEntries ON dbo.vfin_CustomerAccounts.Id = dbo.vfin_JournalEntries.CustomerAccountId INNER JOIN
									 dbo.vfin_InvestmentProducts ON dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductId = dbo.vfin_InvestmentProducts.Id AND 
									 dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_InvestmentProducts.ChartOfAccountId
			WHERE        (dbo.vfin_CustomerAccounts.CustomerId = vfin_Directors.CustomerId) and vfin_InvestmentProducts.Code=2 and vfin_JournalEntries.CreatedDate<=@EndDate
			),0) as ShareDeposits,'Directors' as Description


			FROM            dbo.vfin_Directors INNER JOIN
									 dbo.vw_MemberRegister ON dbo.vfin_Directors.CustomerId = dbo.vw_MemberRegister.Id

			union
			SELECT        FullName, Gender, IdentityCardNumber, MembershipNumber, PersonalFileNumber,
			isnull((

			SELECT        sum(dbo.vfin_JournalEntries.Amount)
			FROM            dbo.vfin_CustomerAccounts INNER JOIN
									 dbo.vfin_JournalEntries ON dbo.vfin_CustomerAccounts.Id = dbo.vfin_JournalEntries.CustomerAccountId INNER JOIN
									 dbo.vfin_LoanProducts ON dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductId = dbo.vfin_LoanProducts.Id AND 
									 dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_LoanProducts.ChartOfAccountId
			WHERE        (dbo.vfin_CustomerAccounts.CustomerId = vw_EmployeeRegister.CustomerId) AND 
									 (dbo.vfin_LoanProducts.LoanRegistration_LoanProductSection = 47803) and vfin_JournalEntries.CreatedDate<=@EndDate
			),0)*-1 as BosaLoans,
			isnull((
			SELECT        sum(dbo.vfin_JournalEntries.Amount)
			FROM            dbo.vfin_CustomerAccounts INNER JOIN
									 dbo.vfin_JournalEntries ON dbo.vfin_CustomerAccounts.Id = dbo.vfin_JournalEntries.CustomerAccountId INNER JOIN
									 dbo.vfin_LoanProducts ON dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductId = dbo.vfin_LoanProducts.Id AND 
									 dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_LoanProducts.ChartOfAccountId
			WHERE        (dbo.vfin_CustomerAccounts.CustomerId = vw_EmployeeRegister.CustomerId) AND 
									 (dbo.vfin_LoanProducts.LoanRegistration_LoanProductSection = 47802) and vfin_JournalEntries.CreatedDate<=@EndDate
			),0)*-1 as FosaLoans,
			isnull((
			SELECT        sum(dbo.vfin_JournalEntries.Amount)
			FROM            dbo.vfin_CustomerAccounts INNER JOIN
									 dbo.vfin_JournalEntries ON dbo.vfin_CustomerAccounts.Id = dbo.vfin_JournalEntries.CustomerAccountId INNER JOIN
									 dbo.vfin_LoanProducts ON dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductId = dbo.vfin_LoanProducts.Id AND 
									 dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_LoanProducts.ChartOfAccountId
			WHERE        (dbo.vfin_CustomerAccounts.CustomerId = vw_EmployeeRegister.CustomerId and vfin_JournalEntries.CreatedDate<=@EndDate) 
			),0)*-1 as TotalLoans,

			isnull((
			SELECT        sum(dbo.vfin_JournalEntries.Amount)
			FROM            dbo.vfin_CustomerAccounts INNER JOIN
									 dbo.vfin_JournalEntries ON dbo.vfin_CustomerAccounts.Id = dbo.vfin_JournalEntries.CustomerAccountId INNER JOIN
									 dbo.vfin_InvestmentProducts ON dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductId = dbo.vfin_InvestmentProducts.Id AND 
									 dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_InvestmentProducts.ChartOfAccountId
			WHERE        (dbo.vfin_CustomerAccounts.CustomerId = vw_EmployeeRegister.CustomerId) and vfin_InvestmentProducts.Code=1 and vfin_JournalEntries.CreatedDate<=@EndDate
			),0) as ShareCapital,
			isnull((
			SELECT        sum(dbo.vfin_JournalEntries.Amount)
			FROM            dbo.vfin_CustomerAccounts INNER JOIN
									 dbo.vfin_JournalEntries ON dbo.vfin_CustomerAccounts.Id = dbo.vfin_JournalEntries.CustomerAccountId INNER JOIN
									 dbo.vfin_InvestmentProducts ON dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductId = dbo.vfin_InvestmentProducts.Id AND 
									 dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_InvestmentProducts.ChartOfAccountId
			WHERE        (dbo.vfin_CustomerAccounts.CustomerId = vw_EmployeeRegister.CustomerId) and vfin_InvestmentProducts.Code=2 and vfin_JournalEntries.CreatedDate<=@EndDate
			),0) as ShareDeposits,'Staff' as Description


			FROM            dbo.vw_EmployeeRegister


END
