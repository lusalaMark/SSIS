USE [VanguardFinancialsDB_KHS]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetStandingOrdersByEmployerAndTrigger]    Script Date: 2/18/2016 3:28:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 04.07.2014
-- Description:	GetStandingOrdersByEmployerAndTrigger
-- =============================================
---select * from vfin_Employers
--sp_GetStandingOrdersByEmployerAndTrigger '87aa5e3a-98b9-44aa-a07a-cc6bc2b6fe18',0
Create PROCEDURE [dbo].[sp_GetStandingOrdersByCustomerProductTrigger] 
	-- Add the parameters for the stored procedure here
	@CustomerID UniqueIdentifier , 
	@ProductID UniqueIdentifier , 
	@Trigger int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT       dbo.vfin_StandingOrders.*
	FROM            dbo.vfin_StandingOrders INNER JOIN
                         dbo.vfin_CustomerAccounts ON dbo.vfin_StandingOrders.BenefactorCustomerAccountId = dbo.vfin_CustomerAccounts.Id INNER JOIN
                         dbo.vfin_Customers ON dbo.vfin_CustomerAccounts.CustomerId = dbo.vfin_Customers.Id INNER JOIN
                         dbo.vfin_Employers INNER JOIN
                         dbo.vfin_Divisions INNER JOIN
                         dbo.vfin_Zones INNER JOIN
                         dbo.vfin_Stations ON dbo.vfin_Zones.Id = dbo.vfin_Stations.ZoneId ON dbo.vfin_Divisions.Id = dbo.vfin_Zones.DivisionId ON 
                         dbo.vfin_Employers.Id = dbo.vfin_Divisions.EmployerId ON dbo.vfin_Customers.StationId = dbo.vfin_Stations.Id
	WHERE  vfin_Customers.ID=@CustomerID and vfin_CustomerAccounts.CustomerAccountType_TargetProductId=@ProductID and dbo.vfin_StandingOrders.[Trigger]=@Trigger

END

