IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_LoansProductsBalancesComparative') BEGIN
   EXEC('CREATE PROC [dbo].[sp_LoansProductsBalancesComparative] as')
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
---[sp_LoansProductsBalancesComparative] '04/01/2015'
alter PROCEDURE [dbo].[sp_LoansProductsBalancesComparative] 
	@Enddate Datetime
AS
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));
	declare @StartDate Datetime=(select DATEADD ( month ,-1,@EndDate ))

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


SELECT     dbo.vfin_LoanProducts.Description AS AccountName,
	isnull((select sum(amount) from vfin_Journalentries where 
	 ContraChartOfAccountId=vfin_LoanProducts.ChartOfAccountId and dbo.vfin_JournalEntries.CreatedDate<=@StartDate),0) as [Previous Month], 
	isnull((select sum(amount) from vfin_Journalentries where 
	 ContraChartOfAccountId=vfin_LoanProducts.ChartOfAccountId and dbo.vfin_JournalEntries.CreatedDate<=@Enddate),0) [Current Month]    
FROM            dbo.vfin_LoanProducts order by Code
END




GO
