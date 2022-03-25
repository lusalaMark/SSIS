IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_StandingOrdersByEmployer') BEGIN
   EXEC('CREATE PROC [dbo].[sp_StandingOrdersByEmployer] as')
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
-- Create date: 23.10.2014
-- Description:	Standing Orders Listing By Employer
-- =============================================
---sp_StandingOrdersByEmployer 'D6E0B99B-690C-C23D-51BA-08D1BC0ACBF6'
ALTER PROCEDURE sp_StandingOrdersByEmployer 
	-- Add the parameters for the stored procedure here
	@EmployerID varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT        dbo.vw_CustomerAccounts.Reference1 AS BenefactorAccount, dbo.vw_CustomerAccounts.FullName AS BenefactorName, 
                         vw_CustomerAccounts_1.Reference1 AS BeneficiaryAccount, vw_CustomerAccounts_1.FullAccount AS BeneficiaryName, 
                         dbo.vfin_StandingOrders.Duration_StartDate, dbo.vfin_StandingOrders.Duration_EndDate, dbo.vfin_StandingOrders.Schedule_Frequency, 
                         dbo.vfin_StandingOrders.Schedule_ExpectedRunDate, dbo.vfin_StandingOrders.Schedule_ActualRunDate, dbo.vfin_StandingOrders.Schedule_ExecuteAttemptCount, 
                         dbo.vfin_StandingOrders.Schedule_IsExecuted, 
						 CASE dbo.vfin_StandingOrders.[Trigger]
						 WHEN 0 THEN 'Payout'
						 WHEN 1 THEN 'Check-Off'
						 WHEN 2 THEN 'Other'
						 END AS [Trigger] , ISNULL(dbo.vfin_StandingOrders.Principal,0)+ISNULL(dbo.vfin_StandingOrders.Charge_FixedAmount,0)+ISNULL(dbo.vfin_StandingOrders.Charge_Percentage,0) AS Principal , dbo.vfin_StandingOrders.Interest, 
                         dbo.vfin_StandingOrders.Remarks, dbo.vfin_StandingOrders.IsLocked, dbo.vfin_StandingOrders.CreatedBy, dbo.vfin_StandingOrders.CreatedDate, 
                         CASE dbo.vfin_StandingOrders.Charge_Type WHEN 1 THEN 'Percentage' WHEN 2 THEN 'Fixed Amount' END AS ChargeType
                         
	FROM            dbo.vfin_Customers INNER JOIN
							 dbo.vfin_CustomerAccounts ON dbo.vfin_Customers.Id = dbo.vfin_CustomerAccounts.CustomerId INNER JOIN
							 dbo.vfin_Stations ON dbo.vfin_Customers.StationId = dbo.vfin_Stations.Id INNER JOIN
							 dbo.vfin_Zones ON dbo.vfin_Stations.ZoneId = dbo.vfin_Zones.Id INNER JOIN
							 dbo.vfin_Divisions ON dbo.vfin_Zones.DivisionId = dbo.vfin_Divisions.Id INNER JOIN
							 dbo.vfin_Employers ON dbo.vfin_Divisions.EmployerId = dbo.vfin_Employers.Id INNER JOIN
							 dbo.vfin_StandingOrders ON dbo.vfin_CustomerAccounts.Id = dbo.vfin_StandingOrders.BenefactorCustomerAccountId INNER JOIN
							 dbo.vw_CustomerAccounts ON dbo.vfin_StandingOrders.BenefactorCustomerAccountId = dbo.vw_CustomerAccounts.Id INNER JOIN
							 dbo.vw_CustomerAccounts AS vw_CustomerAccounts_1 ON dbo.vfin_StandingOrders.BeneficiaryCustomerAccountId = vw_CustomerAccounts_1.Id
	WHERE   ISNULL(dbo.vfin_StandingOrders.Principal,0)+ISNULL(dbo.vfin_StandingOrders.Charge_FixedAmount,0)+ISNULL(dbo.vfin_StandingOrders.Charge_Percentage,0)>0 AND     (dbo.vfin_Divisions.EmployerId =@EmployerID)
END
GO
