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
-- Author:		<Name, Joan>
-- Create date: <Create Date, 05/06/2015 >
-- Description:	<Description, FixedDepositCertificate Report>
-- =============================================
--exec sp_FixedDepositCertificate '0101-001-10480', '2015/04/25'
create PROCEDURE sp_FixedDepositCertificate
	-- Add the parameters for the stored procedure here
	@AccountNumber varchar(50),
	@CreateDate datetime
	--@ValueAmount numeric (18,2)
AS
BEGIN
	--set @createDate=	(select DATEADD(day, DATEDIFF(day, 0, @createDate), '23:59:59'));
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT        dbo.vfin_Customers.Individual_FirstName + ' ' + dbo.vfin_Customers.Individual_LastName AS Fullname, dbo.vfin_Customers.Individual_IdentityCardNumber, dbo.vfin_Customers.Individual_PayrollNumbers, 
                         dbo.vfin_FixedDeposits.Value, dbo.vfin_FixedDeposits.Term, dbo.vfin_FixedDeposits.Rate, dbo.vfin_FixedDeposits.Remarks, dbo.vfin_FixedDeposits.MaturityDate, dbo.vfin_FixedDeposits.Status, 
                         dbo.vfin_FixedDeposits.ExpectedInterest, dbo.vfin_FixedDeposits.TotalExpected, dbo.vfin_FixedDeposits.PaidBy, dbo.vfin_FixedDeposits.PaidDate, dbo.vfin_FixedDeposits.CreatedDate, 
                         dbo.vfin_Customers.Address_AddressLine1, dbo.vfin_Customers.Address_AddressLine2, dbo.vfin_Customers.Address_Street, dbo.vfin_Customers.Address_PostalCode, dbo.vfin_FixedDeposits.CreatedBy, 
                         dbo.vfin_Customers.Address_MobileLine, dbo.vfin_Customers.Reference1, dbo.vfin_NextOfKin.FirstName + ' '+ dbo.vfin_NextOfKin.LastName As NextOfKinName, dbo.vfin_NextOfKin.Relationship, 
                         dbo.vfin_NextOfKin.Address_MobileLine AS [Next of Kin Mobile], dbo.vfin_NextOfKin.Address_AddressLine1 AS [Next of Kin Address]
FROM            dbo.vfin_FixedDeposits INNER JOIN
                         dbo.vfin_CustomerAccounts ON dbo.vfin_FixedDeposits.CustomerAccountId = dbo.vfin_CustomerAccounts.Id INNER JOIN
                         dbo.vfin_Customers ON dbo.vfin_CustomerAccounts.CustomerId = dbo.vfin_Customers.Id INNER JOIN
                         dbo.vfin_NextOfKin ON dbo.vfin_Customers.Id = dbo.vfin_NextOfKin.CustomerId
	--where dbo.vfin_Customers.Reference1=@AccountNumber and  dbo.vfin_FixedDeposits.CreatedDate=@CreateDate
	--where dbo.vfin_Customers.Reference1=@AccountNumber and CONVERT(datetime(10), dbo.vfin_FixedDeposits.CreatedDate, 103) = @CreateDate
	where dbo.vfin_Customers.Reference1=@AccountNumber and Convert(varchar, dbo.vfin_FixedDeposits.CreatedDate,111)= @CreateDate
	END
GO
