IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_GLAccountDeterminationListings') BEGIN
   EXEC('CREATE PROC [dbo].[sp_GLAccountDeterminationListings] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GLAccountDeterminationListings]    Script Date: 9/13/2014 8:46:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_GLAccountDeterminationListings] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  SELECT        TOP (100) 
                         PERCENT CASE dbo.vfin_SystemGeneralLedgerAccountMappings.SystemGeneralLedgerAccountCode 
						 WHEN '48826' THEN 'COMMON CONTROL' 
						 WHEN '48827' THEN 'EXTERNAL CHEQUES CONTROL'
                          WHEN '48828' THEN 'PAYROLL CONTROL' 
						  WHEN '48829' THEN 'IN-HOUSE CHEQUES CONTROL' 
						  WHEN '48830' THEN 'ELECTRONIC FUNDS TRANSFER CONTROL' 
						  WHEN '48831' THEN 'PROFIT & LOSS APPROPRIATION' 
						  WHEN  '48832' THEN 'FIXED DEPOSIT' 
						  WHEN '48833' THEN 'FIXED DEPOSIT INTEREST' 
						  WHEN '48834' THEN 'COST CENTER INTER-SETTLEMENT'
						  WHEN '48835' THEN 'SACCO-LINK SETTLEMENT'
						  WHEN '48836' THEN 'DECEASED CONTROL'
						  WHEN '48837' THEN 'JOURNAL VOUCHER CONTROL' 
						  WHEN '48838' THEN 'MOBILE WALLET SETTLEMENT' 
						  ELSE 'UnKnown'
                          END AS SystemGeneralLedgerAccountCode, dbo.vfin_ChartOfAccounts.AccountCode, dbo.vfin_ChartOfAccounts.AccountName, 
                         dbo.vfin_SystemGeneralLedgerAccountMappings.CreatedDate
FROM            dbo.vfin_SystemGeneralLedgerAccountMappings INNER JOIN
                         dbo.vfin_ChartOfAccounts ON dbo.vfin_SystemGeneralLedgerAccountMappings.ChartOfAccountId = dbo.vfin_ChartOfAccounts.Id
ORDER BY SystemGeneralLedgerAccountCode
END




