IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_CheckCustomerAccountLastWithdrawalDate') BEGIN
   EXEC('CREATE PROC [dbo].[sp_CheckCustomerAccountLastWithdrawalDate] as')
END
GO

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
-- Create date: 11.12.2014
-- Description:	CheckLastWithdrawalDate
-- =============================================
alter PROCEDURE sp_CheckCustomerAccountLastWithdrawalDate 
	-- Add the parameters for the stored procedure here
	@CustomerAccountID Varchar(50) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT    top 1     dbo.vfin_Journals.CreatedDate
	FROM            dbo.vfin_Journals INNER JOIN
							 dbo.vfin_JournalEntries ON dbo.vfin_Journals.Id = dbo.vfin_JournalEntries.JournalId
	WHERE        (dbo.vfin_Journals.PrimaryDescription LIKE 'Cash Withdrawal') and ModuleNavigationItemCode in ('61755')
				 AND CustomerAccountId=@CustomerAccountID
	order by CreatedDate desc
END
GO
