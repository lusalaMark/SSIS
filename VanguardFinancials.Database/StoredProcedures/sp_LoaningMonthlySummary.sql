IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_LoaningMonthlySummary') BEGIN
   EXEC('CREATE PROC [dbo].[sp_LoaningMonthlySummary] as')
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
---select DisbursedDate,AppraisedAmount from vfin_LoanCases
--select * from vfin_postingperiods

--select AppraisedAmount,DisbursedDate from vfin_LoanCases
--select startdate from dbo.GetMonthList(getdate(),1) where monthnumber=4
---sp_LoanSummary '01/01/2014'
---select DisbursedDate,AppraisedAmount from vfin_LoanCases
---sp_LoaningMonthlySummary 'CB716133-38CB-CEA8-CF3F-08D1F352E534','47802','AppraisedAmount','DisbursedDate'
ALTER PROCEDURE [dbo].[sp_LoaningMonthlySummary] 
	-- Add the parameters for the stored procedure here
	(
	@PostingPeriod VARCHAR(50)='CB716133-38CB-CEA8-CF3F-08D1F352E534',
	@Section nvarchar(50)='47803',
	@AmountColumn as Varchar(50)='AppraisedAmount',
	@DateColumn as Varchar(50)='DisbursedDate'
	)
AS
	DECLARE

	@SQLtext1 NVARCHAR(3000),
	@SQLtext2 NVARCHAR(3000),

	@Desc1 varchar(10)='Backoffice',
	@Desc2 varchar(10)='FrontOffice'

BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	set @SQLtext1='
DECLARE 
	@StartDate Datetime
	set @StartDate=(select top 1 Duration_StartDate from vfin_PostingPeriods where id='''+@PostingPeriod+''')

	select Description,
	isnull((
		select sum('+@AmountColumn+') from vfin_LoanCases 
		where LoanProductId=dbo.vfin_LoanProducts.id AND '+@DateColumn+' 
		between (select StartDate from dbo.GetMonthList(@StartDate,1) where MonthNumber=1) and (select EndDate from dbo.GetMonthList(@StartDate,1) where MonthNumber=1)
	),0) as January,
	isnull((
		select sum('+@AmountColumn+') from vfin_LoanCases 
		where LoanProductId=dbo.vfin_LoanProducts.id AND '+@DateColumn+'  
		between (select StartDate from dbo.GetMonthList(@StartDate,1) where MonthNumber=2) and (select EndDate from dbo.GetMonthList(@StartDate,1) where MonthNumber=2)
	),0) as Febuary,
	isnull((
		select sum('+@AmountColumn+') from vfin_LoanCases 
		where LoanProductId=dbo.vfin_LoanProducts.id AND '+@DateColumn+'  
		between (select StartDate from dbo.GetMonthList(@StartDate,1) where MonthNumber=3) and (select EndDate from dbo.GetMonthList(@StartDate,1) where MonthNumber=3)
	),0) as March,
	isnull((
		select sum('+@AmountColumn+') from vfin_LoanCases 
		where LoanProductId=dbo.vfin_LoanProducts.id AND '+@DateColumn+'  
		between (select StartDate from dbo.GetMonthList(@StartDate,1) where MonthNumber=4) and (select EndDate from dbo.GetMonthList(@StartDate,1) where MonthNumber=4)
	),0) as April,
	isnull((
		select sum('+@AmountColumn+') from vfin_LoanCases 
		where LoanProductId=dbo.vfin_LoanProducts.id AND '+@DateColumn+'  
		between (select StartDate from dbo.GetMonthList(@StartDate,1) where MonthNumber=5) and (select EndDate from dbo.GetMonthList(@StartDate,1) where MonthNumber=5)
	),0) as May,
	isnull((
		select sum('+@AmountColumn+') from vfin_LoanCases 
		where LoanProductId=dbo.vfin_LoanProducts.id AND '+@DateColumn+'  
		between (select StartDate from dbo.GetMonthList(@StartDate,1) where MonthNumber=6) and (select EndDate from dbo.GetMonthList(@StartDate,1) where MonthNumber=6)
	),0) as June,
	isnull((
		select sum('+@AmountColumn+') from vfin_LoanCases 
		where LoanProductId=dbo.vfin_LoanProducts.id AND '+@DateColumn+'  
		between (select StartDate from dbo.GetMonthList(@StartDate,1) where MonthNumber=7) and (select EndDate from dbo.GetMonthList(@StartDate,1) where MonthNumber=7)
	),0) as July,
	isnull((
		select sum('+@AmountColumn+') from vfin_LoanCases 
		where LoanProductId=dbo.vfin_LoanProducts.id AND '+@DateColumn+'  
		between (select StartDate from dbo.GetMonthList(@StartDate,1) where MonthNumber=8) and (select EndDate from dbo.GetMonthList(@StartDate,1) where MonthNumber=8)
	),0) as August,'

	set @SQLtext2='
	isnull((
		select sum('+@AmountColumn+') from vfin_LoanCases 
		where LoanProductId=dbo.vfin_LoanProducts.id AND '+@DateColumn+'  
		between (select StartDate from dbo.GetMonthList(@StartDate,1) where MonthNumber=9) and (select EndDate from dbo.GetMonthList(@StartDate,1) where MonthNumber=9)
	),0) as September,
	isnull((
		select sum('+@AmountColumn+') from vfin_LoanCases 
		where LoanProductId=dbo.vfin_LoanProducts.id AND '+@DateColumn+'  
		between (select StartDate from dbo.GetMonthList(@StartDate,1) where MonthNumber=10) and (select EndDate from dbo.GetMonthList(@StartDate,1) where MonthNumber=10)
	),0) as October,
	isnull((
		select sum('+@AmountColumn+') from vfin_LoanCases 
		where LoanProductId=dbo.vfin_LoanProducts.id AND '+@DateColumn+'  
		between (select StartDate from dbo.GetMonthList(@StartDate,1) where MonthNumber=11) and (select EndDate from dbo.GetMonthList(@StartDate,1) where MonthNumber=11)
	),0) as November,
	isnull((
		select sum('+@AmountColumn+') from vfin_LoanCases 
		where LoanProductId=dbo.vfin_LoanProducts.id AND '+@DateColumn+'  
		between (select StartDate from dbo.GetMonthList(@StartDate,1) where MonthNumber=12) and (select EndDate from dbo.GetMonthList(@StartDate,1) where MonthNumber=12)
	),0) as December,
	LoanRegistration_LoanProductSection as Section
	 from vfin_LoanProducts 
	 WHERE LoanRegistration_LoanProductSection in ('+@Section+')'

declare @CarrierList table (Description varchar(50), January numeric(18,2), February numeric(18,2),March numeric(18,2),April numeric(18,2),May numeric(18,2),June numeric(18,2),
							July numeric(18,2),August numeric(18,2),September numeric(18,2),October numeric(18,2),November numeric(18,2),December numeric(18,2),Section varchar(10));
set @SQLtext1=ltrim(ltrim(@SQLtext1))
set @SQLtext2=ltrim(ltrim(@SQLtext2))

insert @CarrierList exec(@SQLtext1+@SQLtext2)
select Description,January,February,March,April,May,June,July,August,September,October,November,December,
CASE WHEN Section=47803 THEN 'BackOffice' WHEN Section=47802 THEN 'FrontOffice' END AS Section from @CarrierList

END





GO
