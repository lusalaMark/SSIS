IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_CheckRecovery') BEGIN
   EXEC('CREATE PROC [dbo].[sp_CheckRecovery] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CheckRecovery]    Script Date: 9/13/2014 3:44:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Centrino
-- Create date: 01.07.2014
-- Description:	Check Recovery
-- =============================================
---sp_CheckRecovery '0777363D-0845-C660-9E58-08D1336CB025','F579602B-431D-D9E6-5949-08D13F39CFC4',7
ALTER PROCEDURE [dbo].[sp_CheckRecovery]
	-- Add the parameters for the stored procedure here
	@PostingPeriod varchar(100),
	@CustomerAccountID varchar(100),
	@MonthNumber int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @MonthName varchar(20),
			@ExpectedPrincipal Numeric(18,2),
			@ExpectedInterest Numeric(18,2),
			@ActualPrincipal Numeric(18,2),
			@ActualInterest Numeric(18,2),
			@PrincipalArrears Numeric(18,2),
			@InterestArrears Numeric(18,2)
	SET @ExpectedPrincipal=ISNULL((SELECT TOP 1
							 [ExpectedPrincipal]
						     FROM [dbo].[vfin_StandingOrderHistories] where BeneficiaryCustomerAccountId=@CustomerAccountID and Month=@MonthNumber and PostingPeriodId=@PostingPeriod
							),0)
	SET @ExpectedInterest=ISNULL((SELECT TOP 1
							 [ExpectedInterest]
						     FROM [dbo].[vfin_StandingOrderHistories] where BeneficiaryCustomerAccountId=@CustomerAccountID and Month=@MonthNumber and PostingPeriodId=@PostingPeriod
							),0)
	SET @ActualPrincipal=ISNULL((SELECT SUM(ActualPrincipal)
						     FROM [dbo].[vfin_StandingOrderHistories] where BeneficiaryCustomerAccountId=@CustomerAccountID and Month=@MonthNumber and PostingPeriodId=@PostingPeriod
							),0)
	SET @ActualInterest=ISNULL((SELECT SUM(ActualInterest)
						     FROM [dbo].[vfin_StandingOrderHistories] where BeneficiaryCustomerAccountId=@CustomerAccountID and Month=@MonthNumber and PostingPeriodId=@PostingPeriod
							),0)
	set @PrincipalArrears=iif(@ExpectedPrincipal-@ActualPrincipal>0,@ExpectedPrincipal-@ActualPrincipal,0)
	set @InterestArrears=iif(@Expectedinterest-@ActualInterest>0,@Expectedinterest-@ActualInterest,0)


	if exists (
			SELECT 
			 [Month]
			  ,[ExpectedPrincipal]
			  ,[ExpectedInterest]
			  ,[ActualPrincipal]
			  ,[ActualInterest]
		  FROM [dbo].[vfin_StandingOrderHistories] where BeneficiaryCustomerAccountId=@CustomerAccountID and Month=@MonthNumber  ---and PostingPeriodId=@PostingPeriod 
			) 
			select 1  AS Flag,@PrincipalArrears as Principal,@InterestArrears as Interest
		else 
			select 0 AS Flag,@PrincipalArrears as Principal,@InterestArrears as Interest
	return	
END


