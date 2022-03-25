USE [VanguardFinancialsDB_GDS]
GO
/****** Object:  StoredProcedure [dbo].[sp_Fiscal]    Script Date: 07/09/2015 18:27:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 15/10/2014
-- Description:	sp_Fiscal
-- =============================================
--select * from vfin_FiscalCounts
---select * from vfin_Branches where id='6A828776-11EE-C4A6-5B31-08D19D7D89D2'
---sp_Fiscal '10/04/2014','10/04/2014','8B8B1B74-141C-CF68-05C2-08D19D7D7330'
ALTER PROCEDURE [dbo].[sp_Fiscal] 
	-- Add the parameters for the stored procedure here
	@StartDate Datetime , 
	@EndDate Datetime,
	@BranchID uniqueidentifier
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));

WITH TreasuryAsAtCTE (PrimaryDescription, SecondaryDescription, Reference, Denomination_OneThousandValue, 
                      Denomination_FiveHundredValue, Denomination_TwoHundredValue, Denomination_OneHundredValue, Denomination_FiftyValue, Denomination_FourtyValue, 
                      Denomination_TwentyValue, Denomination_TenValue, Denomination_FiveValue, Denomination_OneValue, Denomination_FiftyCentValue, CreatedBy, CreatedDate,Mode)
						as
						 (
							SELECT  PrimaryDescription, SecondaryDescription, Reference, Denomination_OneThousandValue, 
									Denomination_FiveHundredValue, Denomination_TwoHundredValue, Denomination_OneHundredValue, Denomination_FiftyValue, Denomination_FourtyValue, 
									Denomination_TwentyValue, Denomination_TenValue, Denomination_FiveValue, Denomination_OneValue, Denomination_FiftyCentValue, CreatedBy, CreatedDate,
									case PrimaryDescription
										WHEN 'Bank to Treasury' THEN -1 
										WHEN 'Treasury to Bank' THEN -1 
										WHEN 'Treasury to Teller' THEN 1
										WHEN 'Treasury to Treasury (Source)' THEN 1
										WHEN 'Treasury to Treasury (Destination)' THEN -1
										WHEN 'Teller Cash Transfer' THEN -1
										WHEN 'Teller To Treasury' THEN -1
										WHEN 'Teller End-Of-Day' THEN -1 
									End Mode
							FROM       vfin_FiscalCounts
							WHERE        (BranchId = @BranchID)  and CreatedDate <@StartDate 
						),
		TreasuryAddMode ( PrimaryDescription, SecondaryDescription, Reference,Denomination_OneThousandValue, 
                         Denomination_FiveHundredValue, Denomination_TwoHundredValue, Denomination_OneHundredValue, Denomination_FiftyValue, Denomination_FourtyValue, 
                         Denomination_TwentyValue, Denomination_TenValue, Denomination_FiveValue, Denomination_OneValue, Denomination_FiftyCentValue,CreatedDate)
						as
						(

							select  PrimaryDescription, SecondaryDescription, Reference, Denomination_OneThousandValue*Mode , 
									Denomination_FiveHundredValue*Mode, Denomination_TwoHundredValue*Mode, Denomination_OneHundredValue*Mode, Denomination_FiftyValue*Mode, Denomination_FourtyValue*Mode, 
									Denomination_TwentyValue*Mode, Denomination_TenValue*Mode, Denomination_FiveValue*Mode, Denomination_OneValue*Mode, Denomination_FiftyCentValue*Mode,CreatedDate from TreasuryAsAtCTE
						),


/*Fetch Transactions Between StartDate and EndDate*/
 TreasuryTrxMode (PrimaryDescription, SecondaryDescription, Reference, Denomination_OneThousandValue, 
                      Denomination_FiveHundredValue, Denomination_TwoHundredValue, Denomination_OneHundredValue, Denomination_FiftyValue, Denomination_FourtyValue, 
                      Denomination_TwentyValue, Denomination_TenValue, Denomination_FiveValue, Denomination_OneValue, Denomination_FiftyCentValue, CreatedBy, CreatedDate,Mode)
						as
						 (
							SELECT  PrimaryDescription, SecondaryDescription, Reference, Denomination_OneThousandValue, 
									Denomination_FiveHundredValue, Denomination_TwoHundredValue, Denomination_OneHundredValue, Denomination_FiftyValue, Denomination_FourtyValue, 
									Denomination_TwentyValue, Denomination_TenValue, Denomination_FiveValue, Denomination_OneValue, Denomination_FiftyCentValue, CreatedBy, CreatedDate,
									case PrimaryDescription
										WHEN 'Bank to Treasury' THEN -1 
										WHEN 'Treasury to Bank' THEN -1 
										WHEN 'Treasury to Teller' THEN 1
										WHEN 'Treasury to Treasury (Destination)' THEN 1
										WHEN 'Treasury to Treasury (Source)' THEN -1
										WHEN 'Teller End-Of-Day' THEN -1
										WHEN 'Teller Cash Transfer' THEN -1
										WHEN 'Teller To Treasury' THEN -1
										WHEN 'Balance B/F' THEN -1
									END AS MODE
							FROM            vfin_FiscalCounts
							WHERE        (BranchId = @BranchID) and CreatedDate Between @StartDate and @EndDate
						),
						
	   TreasuryCTE2 (PrimaryDescription, SecondaryDescription, Reference,Denomination_OneThousandValue, 
                         Denomination_FiveHundredValue, Denomination_TwoHundredValue, Denomination_OneHundredValue, Denomination_FiftyValue, Denomination_FourtyValue, 
                         Denomination_TwentyValue, Denomination_TenValue, Denomination_FiveValue, Denomination_OneValue, Denomination_FiftyCentValue,CreatedDate)
		as		
		(
			select  'Balance BF','<Treasury>','Balance BF',sum(isnull(Denomination_OneThousandValue,0)) , 
					sum(isnull(Denomination_FiveHundredValue,0)), 
					sum(isnull(Denomination_TwoHundredValue,0)), 
					sum(isnull(Denomination_OneHundredValue,0)), 
					sum(isnull(Denomination_FiftyValue,0)), 
					sum(isnull(Denomination_FourtyValue,0)), 
					sum(isnull(Denomination_TwentyValue,0)), 
					sum(isnull(Denomination_TenValue,0)), 
					sum(isnull(Denomination_FiveValue,0)), 
					sum(isnull(Denomination_OneValue,0)), 
					sum(isnull(Denomination_FiftyCentValue,0)),@StartDate from TreasuryAddMode
					union
			select  PrimaryDescription, SecondaryDescription, Reference, 
					Denomination_OneThousandValue*Mode , 
					Denomination_FiveHundredValue*Mode, 
					Denomination_TwoHundredValue*Mode, 
					Denomination_OneHundredValue*Mode, 
					Denomination_FiftyValue*Mode, 
					Denomination_FourtyValue*Mode, 
					Denomination_TwentyValue*Mode, 
					Denomination_TenValue*Mode, 
					Denomination_FiveValue*Mode, 
					Denomination_OneValue*Mode, 
					Denomination_FiftyCentValue*Mode,CreatedDate from TreasuryTrxMode

		),

		TransactionsList 
				(PrimaryDescription, SecondaryDescription, Reference,Denomination_OneThousandValue, 
                 Denomination_FiveHundredValue, Denomination_TwoHundredValue, Denomination_OneHundredValue, Denomination_FiftyValue, Denomination_FourtyValue, 
                 Denomination_TwentyValue, Denomination_TenValue, Denomination_FiveValue, Denomination_OneValue, Denomination_FiftyCentValue,CreatedDate)
				 as
				 (

		select   PrimaryDescription, SecondaryDescription, Reference,Denomination_OneThousandValue, 
                 Denomination_FiveHundredValue, Denomination_TwoHundredValue, Denomination_OneHundredValue, Denomination_FiftyValue, Denomination_FourtyValue, 
                 Denomination_TwentyValue, Denomination_TenValue, Denomination_FiveValue, Denomination_OneValue, Denomination_FiftyCentValue,CreatedDate from TreasuryCTE2
/*
				 union
			select  'Balance C/F','Balance C/F','Balance C/F',
					sum(Denomination_OneThousandValue) , 
					sum(Denomination_FiveHundredValue), 
					sum(Denomination_TwoHundredValue), 
					sum(Denomination_OneHundredValue), 
					sum(Denomination_FiftyValue), 
					sum(Denomination_FourtyValue), 
					sum(Denomination_TwentyValue), 
					sum(Denomination_TenValue), 
					sum(Denomination_FiveValue), 
					sum(Denomination_OneValue), 
					sum(Denomination_FiftyCentValue),@EndDate from TreasuryCTE2
					*/
				 )
		select   PrimaryDescription, SecondaryDescription, Reference,Denomination_OneThousandValue, 
                 Denomination_FiveHundredValue, Denomination_TwoHundredValue, Denomination_OneHundredValue, Denomination_FiftyValue, Denomination_FourtyValue, 
                 Denomination_TwentyValue, Denomination_TenValue, Denomination_FiveValue, Denomination_OneValue, Denomination_FiftyCentValue,
					Denomination_OneThousandValue + 
					Denomination_FiveHundredValue+ 
					Denomination_TwoHundredValue+
					Denomination_OneHundredValue+ 
					Denomination_FiftyValue+
					Denomination_FourtyValue+ 
					Denomination_TwentyValue+ 
					Denomination_TenValue+
					Denomination_FiveValue+ 
					Denomination_OneValue+
					Denomination_FiftyCentValue as TotalTrx,
					SUM(Denomination_OneThousandValue + 
					Denomination_FiveHundredValue+ 
					Denomination_TwoHundredValue+
					Denomination_OneHundredValue+ 
					Denomination_FiftyValue+
					Denomination_FourtyValue+ 
					Denomination_TwentyValue+ 
					Denomination_TenValue+
					Denomination_FiveValue+ 
					Denomination_OneValue+
					Denomination_FiftyCentValue) OVER(ORDER BY CreatedDate 
						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal,convert(varchar(10),CreatedDate,103) as GroupDate,
									case PrimaryDescription
									WHEN 'Bank to Treasury' THEN -1 
									WHEN 'Treasury to Bank' THEN -1 
									WHEN 'Treasury to Teller' THEN 1
									WHEN 'Treasury to Treasury (Source)' THEN 1
									WHEN 'Treasury to Treasury (Destination)' THEN -1
									WHEN 'Teller Cash Transfer' THEN -1
									WHEN 'Teller To Treasury' THEN -1
									WHEN 'Teller End-Of-Day' THEN -1 End Mode,
				 CreatedDate from TransactionsList where Denomination_OneValue is not null  order by CreatedDate

END
