IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_RapaymentSchedule') BEGIN
   EXEC('CREATE PROC [dbo].[sp_RapaymentSchedule] as')
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

---sp_RapaymentSchedule 100000,12,4,.12,'04/30/2014',1
ALTER PROCEDURE [dbo].[sp_RapaymentSchedule] 
	-- Add the parameters for the stored procedure here
	
	@LoanAmount float, ----The term of the loan in years
	@payment_frequency as float, ---The number of payments in a year
	@Term as float,  ----The number of payments in a year
	@annual_rate as float, --.07 --The annual rate of interest
	@startdate datetime,
	@Pay_type as bit---- = 0 --Identifies the payment as due at the end (0) or the beginning (1) of the period	
	as
	set @LoanAmount=@LoanAmount*-1
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
/**Loan Repayment Schedule**/
DECLARE 
 @PV as Float = @LoanAmount
,@FV as float = 0 --Value of the loan at termination

,@rate as float
,@nper as float
 
Set @rate = @annual_rate/@payment_frequency
Set @nper = @Term * @payment_frequency
 
;WITH
Nbrs_3( n ) AS ( SELECT 1 UNION SELECT 0 ),
Nbrs_2( n ) AS ( SELECT 1 FROM Nbrs_3 n1 CROSS JOIN Nbrs_3 n2 ),
Nbrs_1( n ) AS ( SELECT 1 FROM Nbrs_2 n1 CROSS JOIN Nbrs_2 n2 ),
Nbrs_0( n ) AS ( SELECT 1 FROM Nbrs_1 n1 CROSS JOIN Nbrs_1 n2 ),
Nbrs ( n ) AS ( SELECT 1 FROM Nbrs_0 n1 CROSS JOIN Nbrs_0 n2 )
SELECT n as [Period]
,CASE @payment_frequency
WHEN 13 THEN convert(varchar, DATEADD(week,4*n,@startdate),106)
WHEN 26 THEN convert(varchar, DATEADD(week,2*n,@startdate),106)
WHEN 52 THEN convert(varchar, DATEADD(week,n,@startdate),106)
ELSE convert(varchar, DATEADD(M,12*n/@payment_frequency,@startdate),106)
 END as [Due Date]
,-dbo.PV(@rate,@nper-(n-1),dbo.PMT(@rate,@nper,@PV,@FV,@pay_type),@FV,@pay_type) as [Starting Balance]
,dbo.PMT(@rate,@nper,@PV,@FV,@pay_type) as [Payment]
,dbo.IPMT(@rate,n,@nper,@PV,@FV,@pay_type) as [Interest Payment]
,dbo.PPMT(@rate,n,@nper,@PV,@FV,@pay_type) as [Principal Payment]
,-dbo.PV(@rate,@nper-n,dbo.PMT(@rate,@nper,@PV,@FV,@pay_type),@FV,@pay_type) as [Ending Balance]
 FROM ( SELECT ROW_NUMBER() OVER (ORDER BY n)
           FROM Nbrs ) D( n )
 WHERE n <= @nper
END





GO
