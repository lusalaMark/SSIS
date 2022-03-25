/**** Test Script ***/

DECLARE @LoanValue decimal(38,20)
DECLARE @APR decimal(20,15)
DECLARE @FullTerm int
DECLARE @CurrentPeriod int

SET @LoanValue     = -165000
SET @APR           = 0.05  --5%
SET @FullTerm      = 300  --300 months = 25 years
SET @CurrentPeriod = 1 --For which payment period do you want the payment breakdown?

DECLARE @PMT    decimal(38,20)
DECLARE @FV     decimal(38,20)
DECLARE @IPMT   decimal(38,20)
DECLARE @PPMT   decimal(38,20)

SET @PMT =  dbo.PMT(@APR/12.0, @FullTerm, @LoanValue, 0, 0)
SET @FV =   dbo.FV(@APR/12.0, @CurrentPeriod, @PMT, @LoanValue, 0)
SET @IPMT = dbo.IPMT(@APR/12.0, @CurrentPeriod, @FullTerm, @LoanValue, 0, 0)
SET @PPMT = dbo.PPMT(@APR/12.0, @CurrentPeriod, @FullTerm, @LoanValue, 0, 0)

SELECT @PMT AS PMT, @FV AS FV, @IPMT AS IPMT, @PPMT AS PPMT

/**Loan Repayment Schedule**/
DECLARE @PV as Float = -1000000 --Loan Amount
,@FV as float = 0 --Value of the loan at termination
,@Term as float = 4 --The term of the loan in years
,@Pay_type as bit = 0 --Identifies the payment as due at the end (0) or the beginning (1) of the period
,@annual_rate as float = .07 --The annual rate of interest
,@payment_frequency as float = 12 --The number of payments in a year
,@startdate as datetime = '12/1/2013'
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