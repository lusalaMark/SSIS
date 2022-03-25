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
-- Create date: 13/09/2014
-- Description:	CustomerAccountBalance
-- =============================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_Balance') BEGIN
   EXEC('CREATE PROC [dbo].[sp_Balance] as')
END
GO
Alter PROCEDURE [dbo].[sp_Balance] 
	-- Add the parameters for the stored procedure here
	@CustomerAccountID varchar(100),
	@Type int  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT 
	CASE 
		WHEN @Type=1 THEN ---Account Balance

			(		SELECT SUM(dbo.vfin_JournalEntries.Amount) AS amount
					FROM   dbo.vfin_JournalEntries INNER JOIN
						dbo.Products(0) AS Products_1 ON dbo.vfin_JournalEntries.ChartOfAccountId = Products_1.ChartOfAccountId
					WHERE CustomerAccountId =@CustomerAccountId and ContraChartOfAccountId<>'F219BF2C-7956-C13E-C38E-08D133ECD9FB'
			
			) 

		 ELSE  --- AccountInterest

			(		SELECT SUM(dbo.vfin_JournalEntries.Amount) AS amount
					FROM   dbo.vfin_JournalEntries INNER JOIN
						dbo.Products(0) AS Products_1 ON dbo.vfin_JournalEntries.ChartOfAccountId = Products_1.InterestReceivable
					WHERE CustomerAccountId =@CustomerAccountId 
			)
		  END as Balance
END
GO
