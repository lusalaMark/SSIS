IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_LoaningReportDisbursed') BEGIN
   EXEC('CREATE PROC [dbo].[sp_LoaningReportDisbursed] as')
END

GO
/****** Object:  StoredProcedure [dbo].[sp_LoaningReportDisbursed]    Script Date: 10/25/2014 5:21:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 03.06.2014
-- Description:	LoanDisbursement
-- =============================================
ALTER PROCEDURE [dbo].[sp_LoaningReportDisbursed] 
	-- Add the parameters for the stored procedure here
	@StartDate Datetime , 
	@EndDate Datetime 
AS
BEGIN
set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		SELECT       ROW_NUMBER() OVER(ORDER BY dbo.vfin_Branches.Description DESC) AS Row, dbo.vfin_Branches.Description AS Branch, dbo.vfin_LoanProducts.Description AS LoanProduct, dbo.vfin_LoanPurposes.Description AS LoanPurpose, 
							 dbo.vfin_LoanCases.CaseNumber,dbo.vfin_LoanCases.LoanRegistration_TermInMonths, dbo.vfin_LoanCases.AmountApplied, dbo.vfin_LoanCases.ReceivedDate, 
							 CASE dbo.vfin_Customers.Individual_Salutation WHEN '48814' THEN 'Mr' WHEN '48815' THEN 'Mrs' WHEN '48816' THEN 'Miss' WHEN '48817' THEN 'Dr' WHEN '48818'
							  THEN 'Prof' WHEN '48819' THEN 'Rev' WHEN '48820' THEN 'Eng' WHEN '48821' THEN 'Hon' WHEN '48822' THEN 'Cllr' WHEN '48823' THEN 'Sir' WHEN '48824' THEN
							  'Ms' ELSE 'UnKnown' END + ' ' + dbo.vfin_Customers.Individual_FirstName + ' ' + dbo.vfin_Customers.Individual_LastName AS FullName, 
							 CASE Individual_Gender WHEN '57008' THEN 'Male' WHEN '57009' THEN 'Female' ELSE 'UnKnown' END AS Gender, 
							 CASE dbo.vfin_LoanCases.status WHEN '48826' THEN 'Registered' WHEN '48827' THEN 'Appraised' WHEN '48828' THEN 'Approved' WHEN '48829' THEN 'Disbursed'
							  WHEN '48830' THEN 'Rejected' WHEN '48831' THEN 'Differred' WHEN '48832' THEN 'Audited' ELSE 'UnKnown' END AS LoanStatus, 
							 CASE dbo.vfin_LoanProducts.LoanRegistration_LoanProductSection WHEN '47803' THEN 'BackOffice' WHEN '47802' THEN 'FrontOffice' ELSE 'UnKnown' END AS LoanProductSection,
							  REPLACE(STR(dbo.vfin_Customers.SerialNumber, 6), SPACE(1), '0') AS MembershipNumber, 
							 dbo.vfin_Customers.Reference1 AS PersonalFileNumber, dbo.vfin_LoanCases.AppraisedBy, dbo.vfin_LoanCases.AppraisedDate, 
							 dbo.vfin_LoanCases.SystemAppraisalRemarks, dbo.vfin_LoanCases.SystemAppraisedAmount, dbo.vfin_LoanCases.AppraisalRemarks, 
							 dbo.vfin_LoanCases.AppraisedAmount, dbo.vfin_LoanCases.AppraisedAmountRemarks, dbo.vfin_LoanCases.AppraisedNetIncome, 
							 dbo.vfin_LoanCases.ApprovedBy, dbo.vfin_LoanCases.ApprovedDate, dbo.vfin_LoanCases.ApprovalRemarks, dbo.vfin_LoanCases.AuditedBy, 
							 dbo.vfin_LoanCases.AuditedDate, dbo.vfin_LoanCases.AuditRemarks, dbo.vfin_LoanCases.DisbursedBy, dbo.vfin_LoanCases.DisbursedDate, 
							 dbo.vfin_LoanCases.disbursedamount, dbo.vfin_LoanCases.MonthlyPaybackAmount, 
							 dbo.vfin_LoanCases.TotalPaybackAmount, dbo.vfin_LoanCases.LoanProductInvestmentsBalance, dbo.vfin_LoanCases.LoanProductLoanBalance, 
							 dbo.vfin_LoanCases.TotalLoansBalance, REPLACE(STR(dbo.vfin_Branches.Code, 3), SPACE(1), '0') + '-' + REPLACE(STR(dbo.vfin_Customers.SerialNumber, 6), SPACE(1), '0') +'-001-001' as FullAccount,
							 CASE dbo.vfin_LoanCases.LoanInterest_CalculationMode WHEN 512 THEN 'Reducing Balance' WHEN 513 THEN 'Straight Line' WHEN 514 THEN 'Amortization' ELSE
							  'Unknown' END AS LoanInterest_CalculationMode, 
							 CASE dbo.vfin_LoanCases.LoanInterest_ChargeMode WHEN 768 THEN 'UpFront' WHEN 769 THEN 'Periodic' ELSE 'Unknown' END AS LoanInterest_ChargeMode, 
							 dbo.vfin_LoanCases.CreatedBy, dbo.vfin_LoanCases.CreatedDate, dbo.vfin_LoanCases.AuditTopUpAmount, dbo.vfin_LoanCases.DisburseBatchNumber, 
							 dbo.vfin_LoanCases.LoanProductId, 
							 CASE dbo.vfin_LoanCases.LoanRegistration_LoanProductSection WHEN '47802' THEN 'FrontOffice' WHEN '47803' THEN 'BackOffice' END AS ProductSection
	FROM            dbo.vfin_LoanCases INNER JOIN
							 dbo.vfin_Branches ON dbo.vfin_LoanCases.BranchId = dbo.vfin_Branches.Id INNER JOIN
							 dbo.vfin_Customers ON dbo.vfin_LoanCases.CustomerId = dbo.vfin_Customers.Id INNER JOIN
							 dbo.vfin_LoanProducts ON dbo.vfin_LoanCases.LoanProductId = dbo.vfin_LoanProducts.Id INNER JOIN
							 dbo.vfin_LoanPurposes ON dbo.vfin_LoanCases.LoanPurposeId = dbo.vfin_LoanPurposes.Id
	WHERE dbo.vfin_LoanCases.DisbursedDate BETWEEN @StartDate and @EndDate 
END
