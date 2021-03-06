
/****** Object:  StoredProcedure [dbo].[sp_LoansDisbursedInsurance]    Script Date: 11-Jun-15 12:53:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author, Joan Centrino>
-- Create date: <Create Date, 05/29/2015>
-- Description:	<Description, Loans Disburded Report Machakos>
-- =============================================
--exec sp_CICLoansDisbursed '04/28/2015','04/28/2015', '18'
--'Machakos',
CREATE PROCEDURE [dbo].[sp_LoansDisbursedInsurance] 
	@StartDate datetime,
	@EndDate datetime,
	--@BranchCode varchar(50)
	@code varchar (50)
	
AS
BEGIN
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT        SUM(dbo.vfin_LoanCases.DisbursedAmount) AS DisbursedAmount, dbo.vfin_Customers.Individual_FirstName + '' + dbo.vfin_Customers.Individual_LastName As Name, dbo.vfin_Customers.Reference1, dbo.vfin_Customers.Individual_IdentityCardNumber,
                         dbo.vfin_Customers.Individual_PayrollNumbers, dbo.vfin_LoanCases.CaseNumber, dbo.vfin_LoanCases.AmountApplied, dbo.vfin_LoanCases.ReceivedDate AS [Date Applied], 
                         dbo.vfin_LoanCases.DisbursedDate, dbo.vfin_LoanProducts.Description, dbo.vfin_LoanCases.LoanRegistration_TermInMonths, dbo.vfin_Branches.Description AS Branch, dbo.vfin_Branches.Code, 
                         dbo.vfin_LoanProducts.Code AS [Loan Code]
	FROM            dbo.vfin_LoanCases INNER JOIN
                         dbo.vfin_Customers ON dbo.vfin_LoanCases.CustomerId = dbo.vfin_Customers.Id INNER JOIN
                         dbo.vfin_Branches ON dbo.vfin_LoanCases.BranchId = dbo.vfin_Branches.Id INNER JOIN
                         dbo.vfin_LoanProducts ON dbo.vfin_LoanCases.LoanProductId = dbo.vfin_LoanProducts.Id
	WHERE        (dbo.vfin_LoanCases.DisbursedAmount <> 0) and dbo.vfin_LoanCases.DisbursedDate between @StartDate and @EndDate and dbo.vfin_LoanProducts.Code =@code
	--and @BranchCode=dbo.vfin_Branches.Description 
	GROUP BY dbo.vfin_LoanProducts.Code, dbo.vfin_Branches.Code, dbo.vfin_Branches.Description, dbo.vfin_LoanCases.LoanRegistration_TermInMonths, dbo.vfin_LoanProducts.Description, 
                         dbo.vfin_LoanCases.DisbursedDate, dbo.vfin_LoanCases.ReceivedDate, dbo.vfin_LoanCases.AmountApplied, dbo.vfin_LoanCases.CaseNumber, dbo.vfin_Customers.Individual_PayrollNumbers, 
                         dbo.vfin_Customers.Reference1, dbo.vfin_Customers.Individual_LastName, dbo.vfin_Customers.Individual_FirstName, dbo.vfin_Customers.Individual_IdentityCardNumber
END
