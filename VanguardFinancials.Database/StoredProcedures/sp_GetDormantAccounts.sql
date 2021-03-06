USE [VanguardFinancialsDB_TEST]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetDormantAccounts]    Script Date: 02-Sep-15 12:44:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 22.01.2015
-- Description:	GetDormant
-- =============================================
-- sp_GetDormantAccounts 3, '01/31/2015'
ALTER PROCEDURE [dbo].[sp_GetDormantAccounts] 
	-- Add the parameters for the stored procedure here
	@Month int , 
	@Date Datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		set @Date=	(select DATEADD(day, DATEDIFF(day, 0, @Date), '23:59:59'));

		WITH DormantCTE (FosaAccount,FullName,LastTrxDATE)
		AS
		(
		select REFERENCE1,FullName, (SELECT MAX(CREATEDDATE) FROM vfin_JournalEntries WHERE CustomerAccountId =vw_CustomerAccounts.ID) AS LastTrxDate  
			FROM vw_CustomerAccounts where CustomerAccountType_TargetProductId in (select id from vfin_SavingsProducts)
		)
		SELECT DATEDIFF(MM,LastTrxDATE,@Date) AS Month,* 
		FROM DormantCTE WHERE DATEDIFF(DD,LastTrxDATE,@Date)>=@Month*30

END
