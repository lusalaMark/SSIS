IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_ChartOfAccountsListingSorted') BEGIN
   EXEC('CREATE PROC [dbo].[sp_ChartOfAccountsListingSorted] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_ChartOfAccountsListingSorted]    Script Date: 9/13/2014 3:41:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_ChartOfAccountsListingSorted]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 	id,	space(depth*4)+ ltrim(rtrim(AccountCode))+' '+ltrim([AccountName]) as Code
	  FROM [dbo].[vfin_ChartOfAccounts] order by AccountType,AccountCode
END






