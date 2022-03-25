IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_GetMonthlyAbility') BEGIN
   EXEC('CREATE PROC [dbo].[sp_GetMonthlyAbility] as')
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
-- Create date: 15.10.2014
-- Description:	Get letest monthly ability from loancases given loanproduct
-- =============================================
alter PROCEDURE sp_GetMonthlyAbility 
	-- Add the parameters for the stored procedure here
	@CustomerID varchar(50),
	@LoanProductID varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT      top 1  AppraisedAbility,MonthlyPaybackAmount
	FROM            dbo.vfin_LoanCases
	WHERE        (CustomerID=@CustomerID and LoanProductId = @LoanProductID and AuditedDate is not null) order by AuditedDate desc

END
GO
