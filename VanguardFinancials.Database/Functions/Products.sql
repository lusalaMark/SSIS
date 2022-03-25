IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Products') BEGIN
   EXEC('CREATE function [dbo].[Products] as')
END
GO

/****** Object:  UserDefinedFunction [dbo].[Products]    Script Date: 9/14/2014 7:36:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from dbo.Products(0)
ALTER function [dbo].[Products] 
(
	@Product  Int
)
RETURNS 
	@temp table (id varchar(50),type varchar(20),Description varchar(50),ChartOfAccountId varchar(50),InterestReceivable uniqueidentifier,MinBalance Numeric(12,2),Code int,InterestCalculationMode int)
as
begin
	insert into @temp
	select id,'Savings     ' as type,Description,ChartOfAccountId,null,MinimumBalance,Code,0  from vfin_SavingsProducts
	insert into @temp
	select id,'Loans',Description,ChartOfAccountId,InterestReceivableChartOfAccountId,0,Code,LoanInterest_CalculationMode from vfin_LoanProducts
	insert into @temp
	select id,'Investments',Description,ChartOfAccountId,null,0,Code,0 from vfin_InvestmentProducts
	return
end
GO