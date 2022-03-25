IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_ChartOfAccountsListingSortedSearch') BEGIN
   EXEC('CREATE PROC [dbo].[sp_ChartOfAccountsListingSortedSearch] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_ChartOfAccountsListingSortedSearch]    Script Date: 9/13/2014 3:43:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--[sp_ChartOfAccountsListingSortedSearch] 'ord'
ALTER PROCEDURE [dbo].[sp_ChartOfAccountsListingSortedSearch]
(@Search VarChar(100))
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/****** Script for SelectTopNRows command from SSMS  ******/
	set @Search=upper(@Search)
SELECT 	id,	space(depth*4)+ ltrim(rtrim(AccountCode))+' '+ltrim([AccountName]) as Code
	  FROM vfin_ChartOfAccounts 
	  	  WHERE (upper(AccountName) like '%'+@Search+'%')
	  order by AccountType,AccountCode



END






