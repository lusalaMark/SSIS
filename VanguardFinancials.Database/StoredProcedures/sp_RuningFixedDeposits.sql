USE [VanguardFinancialsDB_KHS]
GO
/****** Object:  StoredProcedure [dbo].[sp_UnpaidFixedDepositTest]    Script Date: 11-Aug-15 9:25:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author, Joan>
-- Create date: <Create Date, 10/08/2015>
-- Description:	<Description, Unpaid fixed deposit test>
-- =============================================
--sp_RuningFixedDeposits '01/01/2015'
Alter PROCEDURE [dbo].[sp_RuningFixedDeposits]
	-- Add the parameters for the stored procedure here
	@MaturityDate DateTime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT        dbo.vfin_FixedDeposits.Value, dbo.vfin_FixedDeposits.Term, dbo.vfin_FixedDeposits.Rate, dbo.vfin_FixedDeposits.Status, dbo.vfin_FixedDeposits.MaturityDate, dbo.vfin_FixedDeposits.PaidDate, 
                         dbo.vfin_Customers.Individual_FirstName + ' ' + dbo.vfin_Customers.Individual_LastName as FullName, dbo.vfin_Customers.Individual_IdentityCardNumber, dbo.vfin_Customers.Reference1, dbo.vfin_Customers.Reference3, 
                         dbo.vfin_Customers.Reference2, dbo.vfin_FixedDeposits.CreatedDate, dbo.vfin_FixedDeposits.TotalExpected
	FROM            dbo.vfin_FixedDeposits INNER JOIN
                         dbo.vfin_CustomerAccounts ON dbo.vfin_FixedDeposits.CustomerAccountId = dbo.vfin_CustomerAccounts.Id INNER JOIN
                         dbo.vfin_Customers ON dbo.vfin_CustomerAccounts.CustomerId = dbo.vfin_Customers.Id
	where MaturityDate >= @MaturityDate
	order by MaturityDate
END
