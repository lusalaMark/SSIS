IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_UpdateStandingOrderCapitalizedInterest') BEGIN
   EXEC('CREATE PROC [dbo].[sp_UpdateStandingOrderCapitalizedInterest] as')
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 13.06.2014
-- Description:	LoanForm
-- =============================================
ALTER PROCEDURE sp_UpdateStandingOrderCapitalizedInterest
@BeneficiaryAccount uniqueidentifier,
@InterestAMount decimal(18,2)
As

SET NOCOUNT ON;

BEGIN
		Declare @InterestCalcMode int

		set @InterestCalcMode=(
								SELECT  top 1    dbo.vfin_LoanProducts.LoanInterest_CalculationMode
								FROM        dbo.vfin_CustomerAccounts INNER JOIN
											dbo.vfin_LoanProducts ON dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductId = dbo.vfin_LoanProducts.Id
											Where vfin_CustomerAccounts.id=@BeneficiaryAccount)


		UPDATE vfin_StandingOrders SET
		 Interest = @InterestAMount
		 --Principal=
		 --(CASE 
			--WHEN @InterestCalcMode=514 THEN PeriodicAmount-@InterestAMount
			--ELSE Principal END)
		  from vfin_StandingOrders inner join vfin_CustomerAccounts C
		On C.Id = vfin_StandingOrders.BeneficiaryCustomerAccountId inner join vfin_CustomerAccounts C2 
		On C2.Id = vfin_StandingOrders.BenefactorCustomerAccountId 
		where BeneficiaryCustomerAccountId = @BeneficiaryAccount and C.CustomerId = C2.CustomerId
		END


GO
