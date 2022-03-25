IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_ProductsListing') BEGIN
   EXEC('CREATE PROC [dbo].[sp_ProductsListing] as')
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

ALTER PROCEDURE [dbo].[sp_ProductsListing]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

select id,'Savings     ' as type,Description,ChartOfAccountId into #temp from vfin_SavingsProducts

insert into #temp(id,type,Description,ChartOfAccountId)
select id,'Loans',Description,ChartOfAccountId from vfin_LoanProducts

insert into #temp(id,type,Description,ChartOfAccountId)
select id,'Investments',Description,ChartOfAccountId from vfin_InvestmentProducts

select id,type, description,ChartOfAccountId from #temp
END





GO
