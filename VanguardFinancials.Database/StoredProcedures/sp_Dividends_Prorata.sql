IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_Dividends_Prorata') BEGIN
   EXEC('CREATE PROC [dbo].[sp_Dividends_Prorata] as')
END
GO

--exec sp_Dividends_Prorata '12/31/2014','s02'
ALTER Procedure [dbo].[sp_Dividends_Prorata](@enddate as Datetime,@ttype char(3))
as
set nocount on
Declare @year as numeric (4),@FirstDayOfYear datetime,@mcode int

set @mcode= case when @ttype='S01' THEN 1 when @ttype='S02' then 2 when @ttype='S03' then 5 when @ttype ='S05' then 3 end

set @year=year(@enddate)

set @FirstDayOfYear = DATEADD(YEAR, DATEDIFF(YEAR, 0, @enddate), 0)

select customer.fosa_Acno, customer.name, customer.EMPNO, customer.dept,
0 AS [month], 
0 AS monthly, 12 AS Expr1,
isnull((select top 1 coalesce(c.credit,0)-COALESCE(c.debit,0) from kericho_khs.dbo.sharehist c where c.fosa_Acno=customer.fosa_Acno  and c.ttype=@ttype order by trdate),0) as Opening,
 SUM(COALESCE(sharehist.credit,0)-COALESCE(sharehist.debit,0)) as balance,
 case 
 when @year =2012 then
	(isnull((select top 1 coalesce(c.credit,0)-COALESCE(c.debit,0) from kericho_khs.dbo.sharehist c where c.fosa_acno=customer.fosa_acno   and c.ttype=@ttype  order by trdate),0)+
	SUM(COALESCE(sharehist.credit,0)-COALESCE(sharehist.debit,0))) * 12/ 12 
 else
	 SUM(COALESCE(sharehist.credit,0)-COALESCE(sharehist.debit,0)) * 12/ 12  
 end
 AS qualified
INTO #TEMPOpeningBalances
FROM         kericho_khs.dbo.sharehist sharehist INNER JOIN
                      kericho_khs.dbo.customer customer ON sharehist.fosa_acno = customer.fosa_Acno
     
WHERE      (YEAR(sharehist.TrDATE) < @year)  and sharehist.ttype=@ttype  --and sharehist.fosa_acno='0101-001-00064'
GROUP BY customer.fosa_acno,  customer.name, customer.empno, customer.dept,tea_no
if @year<>2012
begin 
	update #TEMPOpeningBalances set opening=0 
end



select sharehist.fosa_acno,sharehist.trdate,sharehist.debit,sharehist.credit,docid,docno,TRDESCPT,ttype
Into #TempSharehist
from kericho_khs.dbo.sharehist WHERE (YEAR(sharehist.TRDATE) >=@year) and sharehist.ttype=@ttype -- and sharehist.fosa_acno='0101-001-00064'


insert into #TempSharehist (sharehist.fosa_acno,sharehist.trdate,sharehist.debit,sharehist.credit,docid,docno,TRDESCPT,ttype)
SELECT        ltrim(rtrim(dbo.vw_CustomerAccounts.Reference1)),dbo.vfin_JournalEntries.CreatedDate,0 as Debit, dbo.vfin_JournalEntries.Amount as Credit, '999' as Docid,'99999' as Docno,  
                         left(dbo.vfin_Journals.PrimaryDescription,30), @ttype
FROM            dbo.vw_CustomerAccounts INNER JOIN
                         dbo.vfin_JournalEntries ON dbo.vw_CustomerAccounts.Id = dbo.vfin_JournalEntries.CustomerAccountId INNER JOIN
                         dbo.vfin_InvestmentProducts ON dbo.vw_CustomerAccounts.CustomerAccountType_TargetProductId = dbo.vfin_InvestmentProducts.Id AND 
                         dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_InvestmentProducts.ChartOfAccountId INNER JOIN
                         dbo.vfin_Journals ON dbo.vfin_JournalEntries.JournalId = dbo.vfin_Journals.Id
WHERE        (dbo.vfin_InvestmentProducts.Code = @mcode) AND (dbo.vfin_Journals.PrimaryDescription <> 'BALANCE C/F')




UPDATE #TempSharehist SET trdate ='1/31/2012' WHERE TRDESCPT ='Balance B/F' AND COALESCE(DOCID,'')='IMP'


UPDATE #TempSharehist SET trdate =@FirstDayOfYear
FROM #TempSharehist WHERE COALESCE(#TempSharehist.DOCID,'')='S/O' and year(trdate) < YEAR(@enddate)

delete #TempSharehist where YEAR(#TempSharehist.TRDATE) <>@year
 

select fosa_acno,max(trdate) as Trdate,ttype into #TempWithdrawals from kericho_khs.dbo.sharehist where docid IN('33E','334') and year(trdate)=@year
--and sharehist.fosa_acno='0101-001-00064'
group by fosa_Acno,ttype


SELECT    sharehist.fosa_acno, customer.name, customer.EMPNO, customer.dept,
 MONTH(sharehist.TRDATE) AS [month], 
 SUM(COALESCE(sharehist.credit,0)-COALESCE(sharehist.debit,0)) as balance,
SUM(COALESCE(sharehist.credit,0)) AS monthly,
isnull((select month(trdate) from #TempWithdrawals  where fosa_acno=sharehist.fosa_acno and ttype=@ttype),13) - (MONTH(sharehist.TRDATE) ) AS Expr1,
 SUM(COALESCE(sharehist.credit,0)-COALESCE(sharehist.debit,0)) *(  
 isnull((select month(trdate) from #TempWithdrawals  where fosa_acno=sharehist.fosa_acno and ttype=@ttype),13) 
 - (MONTH(sharehist.TRDATE))) / 12 AS qualified
INTO #TEMPBalances
FROM         #TempSharehist sharehist INNER JOIN
                      kericho_khs.dbo.customer customer ON sharehist.fosa_Acno = customer.fosa_Acno
                      WHERE      (YEAR(sharehist.TRDATE) =@year)  and sharehist.ttype=@ttype 
GROUP BY sharehist.fosa_acno, sharehist.trdate, customer.name, customer.empno, customer.dept
--ORDER BY sharehist.saccomno, MONTH(sharehist.date)

insert into #TEMPBalances(fosa_acno,name,empno,dept,month,Monthly,expr1,Qualified,balance )
select fosa_acno,name,empno,dept,month,Monthly,expr1,Qualified,coalesce(balance,0)+coalesce(opening,0) from #TEMPOpeningBalances
/*
select fosa_acno,name,empno,dept as Activity,month,sum(monthly) as Monthly,expr1,
sum(qualified) as Qualified,sum(balance) as balance,@enddate as TRDATE
from #TEMPBalances --WHERE FOSA_aCNO='0101-001-00174 '
group by FOSA_ACNO,name,empno,DEPT,month,expr1
order by fosa_Acno,month
*/




select fosa_acno,name,
CASE 
WHEN MONTH=0 THEN sum(qualified)
END AS BalanceBF,
CASE 
WHEN MONTH=1 THEN sum(qualified)
END AS January,
CASE 
WHEN MONTH=2 THEN sum(qualified)
END AS February,
CASE 
WHEN MONTH=3 THEN sum(qualified)
END AS March,
CASE 
WHEN MONTH=4 THEN sum(qualified)
END AS April,
CASE 
WHEN MONTH=5 THEN sum(qualified)
END AS May,
CASE 
WHEN MONTH=6 THEN sum(qualified)
END AS June,
CASE 
WHEN MONTH=7 THEN sum(qualified)
END AS July,
CASE 
WHEN MONTH=8 THEN sum(qualified)
END AS August,
CASE 
WHEN MONTH=9 THEN sum(qualified)
END AS September,
CASE 
WHEN MONTH=10 THEN sum(qualified)
END AS October,
CASE 
WHEN MONTH=11 THEN sum(qualified)
END AS November,
CASE 
WHEN MONTH=12 THEN sum(qualified)
END AS December,
---sum(monthly) as Monthly,expr1,
sum(qualified) as Qualified into #TEMPBalances1
from #TEMPBalances --WHERE FOSA_aCNO='0101-001-00174 '
group by FOSA_ACNO,name,month
order by fosa_Acno


select Fosa_acno,ltrim(rtrim(name)) as name,sum(isnull(BalanceBF,0)) as BalanceBF ,sum(isnull(January,0)) as January,sum(isnull(February,0)) as February,sum(isnull(March,0)) as March
,sum(isnull(April,0)) as April,sum(isnull(May,0)) as May,sum(isnull(June,0)) as June,sum(isnull(July,0)) as July,sum(isnull(August,0)) as August,Sum(isnull(September,0)) as September,sum(isnull(october,0)) as October
,sum(isnull(November,0)) as November,sum(isnull(December,0)) as December ,sum(isnull(Qualified,0)) as Qualified from #TEMPBalances1 group  by Fosa_acno,name
order by fosa_acno

drop table #TEMPBalances
drop table #TEMPOpeningBalances









