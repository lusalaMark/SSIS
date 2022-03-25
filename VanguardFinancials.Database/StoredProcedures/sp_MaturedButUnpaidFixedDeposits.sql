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
-- Author:		<Author, Joan >
-- Create date: <Create Date, 10/08/2015>
-- Description:	<Description, Matured Fixed Deposits That Are Not Yet Paid>
-- =============================================
 --sp_MaturedButUnpaidFixedDeposits '06/01/2015'
 Alter PROCEDURE sp_MaturedButUnpaidFixedDeposits
	-- Add the parameters for the stored procedure here
	@MaturityDate DateTime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT        dbo.vfin_FixedDeposits.Value, dbo.vfin_FixedDeposits.Term, dbo.vfin_FixedDeposits.Rate, dbo.vfin_FixedDeposits.Status, dbo.vfin_FixedDeposits.MaturityDate, dbo.vfin_FixedDeposits.PaidDate, 
                         dbo.vfin_Customers.Individual_FirstName + '' + dbo.vfin_Customers.Individual_LastName as FullName, dbo.vfin_Customers.Individual_IdentityCardNumber, dbo.vfin_Customers.Reference1, dbo.vfin_Customers.Reference3, 
                         dbo.vfin_Customers.Reference2, dbo.vfin_FixedDeposits.CreatedDate, dbo.vfin_FixedDeposits.TotalExpected
	FROM            dbo.vfin_FixedDeposits INNER JOIN
                         dbo.vfin_CustomerAccounts ON dbo.vfin_FixedDeposits.CustomerAccountId = dbo.vfin_CustomerAccounts.Id INNER JOIN
                         dbo.vfin_Customers ON dbo.vfin_CustomerAccounts.CustomerId = dbo.vfin_Customers.Id
	Where MaturityDate <= @MaturityDate and  PaidDate is  null
						 
END
GO
