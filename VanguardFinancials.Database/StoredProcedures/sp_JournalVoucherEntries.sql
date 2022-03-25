IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_JournalVoucherEntries') BEGIN
   EXEC('CREATE PROC [dbo].[sp_JournalVoucherEntries] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_JournalVoucherEntries]    Script Date: 9/13/2014 9:15:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Centrino
-- Create date: 14.06.2014
-- Description:	JournalVourcherEntries
-- =============================================
---sp_JournalVoucherEntries '06/01/2014','06/30/2014'
ALTER PROCEDURE [dbo].[sp_JournalVoucherEntries] 
	-- Add the parameters for the stored procedure here
	@StartDate DateTime  , 
	@EndDate DateTime 
AS
BEGIN

	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT        dbo.vfin_Branches.Description AS Branch, dbo.vfin_JournalVouchers.VoucherNumber, 
							 CASE dbo.vfin_JournalVouchers.Status WHEN 1 THEN 'Pending' WHEN 2 THEN 'Posted' WHEN 4 THEN 'Rejected' END AS Status, 
							 dbo.vfin_JournalVouchers.AuthorizedBy, dbo.vfin_JournalVouchers.AuthorizationRemarks, dbo.vfin_JournalVouchers.AuthorizedDate, 
							 dbo.vfin_JournalVouchers.CreatedBy, dbo.vfin_JournalVouchers.CreatedDate, 
							 CASE dbo.vfin_JournalVouchers.Type WHEN 53456 THEN 'Debit G/L Account' WHEN 53457 THEN 'Credit G/L Account' WHEN 53458 THEN 'Debit Customer Account' WHEN
							  53459 THEN 'Credit Customer Account' END AS Type, dbo.vfin_JournalVouchers.Principal, dbo.vfin_JournalVouchers.Interest, 
							 dbo.vfin_JournalVouchers.PrimaryDescription, dbo.vfin_JournalVouchers.SecondaryDescription, dbo.vfin_ChartOfAccounts.AccountCode, 
							 dbo.vfin_ChartOfAccounts.AccountName, vw_CustomerAccounts_1.FullAccount, vw_CustomerAccounts_1.FullName AS FullAccountName, 
							 CASE dbo.vfin_JournalVoucherEntries.Type WHEN 1 THEN 'G/L Account' WHEN 2 THEN 'Customer Account' END AS JournalVoucherEntriesType, 
							 dbo.vfin_JournalVoucherEntries.PrimaryDescription AS JournalVoucherEntriesPrimaryDescription, 
							 dbo.vfin_JournalVoucherEntries.SecondaryDescription AS JournalVoucherEntriesSecondaryDescription, 
							 dbo.vfin_JournalVoucherEntries.CreatedDate AS JournalVoucherEntriesCreatedDate, dbo.vfin_JournalVoucherEntries.Principal AS JournalVoucherEntriesPrincipal, 
							 dbo.vfin_JournalVoucherEntries.Interest AS JournalVoucherEntriesInterest, vfin_ChartOfAccounts_1.AccountCode AS JournalVoucherEntriesAccountCode, 
							 vfin_ChartOfAccounts_1.AccountName AS JournalVoucherEntriesAccountName, dbo.vw_CustomerAccounts.FullAccount AS JournalVoucherEntriesFullAccount, 
							 dbo.vw_CustomerAccounts.FullName AS JournalVoucherEntriesFullName
	FROM            dbo.vfin_JournalVouchers INNER JOIN
							 dbo.vfin_JournalVoucherEntries ON dbo.vfin_JournalVouchers.Id = dbo.vfin_JournalVoucherEntries.JournalVoucherId INNER JOIN
							 dbo.vfin_Branches ON dbo.vfin_JournalVouchers.BranchId = dbo.vfin_Branches.Id INNER JOIN
							 dbo.vfin_ChartOfAccounts ON dbo.vfin_JournalVouchers.ChartOfAccountId = dbo.vfin_ChartOfAccounts.Id INNER JOIN
							 dbo.vfin_ChartOfAccounts AS vfin_ChartOfAccounts_1 ON dbo.vfin_JournalVoucherEntries.ChartOfAccountId = vfin_ChartOfAccounts_1.Id LEFT OUTER JOIN
							 dbo.vw_CustomerAccounts ON dbo.vfin_JournalVoucherEntries.CustomerAccountId = dbo.vw_CustomerAccounts.Id LEFT OUTER JOIN
							 dbo.vw_CustomerAccounts AS vw_CustomerAccounts_1 ON dbo.vfin_JournalVouchers.CustomerAccountId = vw_CustomerAccounts_1.Id
	WHERE dbo.vfin_JournalVouchers.CreatedDate BETWEEN @StartDate and @EndDate
END
