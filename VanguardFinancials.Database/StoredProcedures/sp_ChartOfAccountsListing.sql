IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_ChartOfAccountsListing') BEGIN
   EXEC('CREATE PROC [dbo].[sp_ChartOfAccountsListing] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_ChartOfAccountsListing]    Script Date: 9/13/2014 3:40:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_ChartOfAccountsListing]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 	[AccountType],
			[AccountTypeCode] =
			CASE [AccountType]
				WHEN 1000000 THEN 'Assets'
				WHEN 2000000 THEN 'Liabilities'
				WHEN 3000000 THEN 'Equity'
				WHEN 4000000 THEN 'Income'
				WHEN 5000000 THEN 'Expenses'
			END,
			space(depth*4)+ ltrim(rtrim(AccountCode))+' '+ltrim([AccountName]) as Code
		  , [AccountCode] 
		  ,space(depth*4)+ [AccountName] as [AccountName]
		  ,[Depth]
	  FROM [dbo].[vfin_ChartOfAccounts] order by AccountType,AccountCode
END






