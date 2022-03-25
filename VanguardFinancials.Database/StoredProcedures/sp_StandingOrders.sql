IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_StandingOrders') BEGIN
   EXEC('CREATE PROC [dbo].[sp_StandingOrders] as')
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 01.06.2014
-- Description:	Standing Orders Listing
-- =============================================
-- sp_StandingOrders 0,0
ALTER PROCEDURE [dbo].[sp_StandingOrders] 
	-- Add the parameters for the stored procedure here
	@pStaus int = 0, 
	@pType int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT					CASE dbo.vfin_StandingOrders.[Trigger]
							 WHEN 0 THEN 'Payout'
							 WHEN 1 THEN 'Check-Off'
							 WHEN 2 THEN 'Other'
							 END AS StandingOrderTrigger,dbo.vfin_StandingOrders.[Trigger],
							 dbo.vw_CustomerAccounts.FullAccount, ltrim(rtrim(dbo.vw_CustomerAccounts.FullName)) as FullName, ltrim(rtrim(Products_1.Description)) AS SourceProduct, 
							  dbo.vfin_StandingOrders.Principal, dbo.vfin_StandingOrders.Interest, 
							 CASE dbo.vfin_StandingOrders.IsLocked
							 WHEN 0 THEN 'Running'
							 WHEN 1 THEN 'Stopped'
							 END Status, dbo.vfin_StandingOrders.IsLocked,
							 dbo.vfin_StandingOrders.CreatedDate, dbo.vfin_StandingOrders.CreatedBy, 
							  ltrim(rtrim(Products_2.Description)) AS BeneficiaryProduct, 
							 vw_CustomerAccounts_1.FullAccount AS BeneficiaryAccountNumber, ltrim(rtrim(vw_CustomerAccounts_1.FullName)) AS BeneficiaryFullName
	FROM            dbo.vfin_StandingOrders INNER JOIN
							 dbo.vw_CustomerAccounts ON dbo.vfin_StandingOrders.BenefactorCustomerAccountId = dbo.vw_CustomerAccounts.Id INNER JOIN
							 dbo.Products(0) AS Products_1 ON dbo.vw_CustomerAccounts.CustomerAccountType_TargetProductId = Products_1.id INNER JOIN
							 dbo.vw_CustomerAccounts AS vw_CustomerAccounts_1 ON dbo.vfin_StandingOrders.BeneficiaryCustomerAccountId = vw_CustomerAccounts_1.Id INNER JOIN
							 dbo.Products(0) AS Products_2 ON vw_CustomerAccounts_1.CustomerAccountType_TargetProductId = Products_2.id
	WHERE			dbo.vfin_StandingOrders.IsLocked=@pStaus 
					AND dbo.vfin_StandingOrders.[Trigger]=@pType
	ORDER BY		dbo.vw_CustomerAccounts.FullAccount, vw_CustomerAccounts_1.FullAccount
	
END

GO
