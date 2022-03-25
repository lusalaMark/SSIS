IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_Defaulters') BEGIN
   EXEC('CREATE PROC [dbo].[sp_Defaulters] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_Defaulters]    Script Date: 9/13/2014 4:15:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

USE [VanguardFinancialsDB_KWETU]
GO
/****** Object:  StoredProcedure [dbo].[sp_Defaulters]    Script Date: 6/9/2015 9:15:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_Defaulters 0,'06/01/2015'
ALTER procedure [dbo].[sp_Defaulters]
(
	@GracePeriod int=0,
	@EndDate as Datetime
)

 as
SET NOCOUNT ON;

set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));


WITH Frequency_CTE (pf_no,Ttype,LastTrxDate,Balance,Description)
AS
(
select pf_no,ttype,max(trdate) as TrxDate,(select sum(debit-credit) from bosa.dbo.history  where pf_no= Loanhist.pf_no and ttype=loanhist.ttype) as balance,(select name from bosa.dbo.lntypes where code=Loanhist.ttype) as description from Bosa.dbo.history as Loanhist where left(ttype,1)='L'   and docid not in('203','608')  group by pf_no,ttype
)

select 
(select Name from bosa.dbo.customer  where pf_no= Frequency_CTE.pf_no) as Name,(select empno from bosa.dbo.customer  where pf_no= Frequency_CTE.pf_no) as PayrollNo,Balance,pf_no,LastTrxDate,datediff(mm,LastTrxDate,@EndDate) as DefaultFrequency,
(select Description from vfin_LoanProducts where Description=Frequency_CTE.Description COLLATE Latin1_General_CI_AS) as LoanName,
 '001-'+(select top 1  REPLACE(STR(SerialNumber, 6), SPACE(1), '0') from vfin_Customers where Reference2=Frequency_CTE.pf_no COLLATE Latin1_General_CI_AS)+'-002-'+
 (select REPLACE(STR(Code, 3), SPACE(1), '0') from vfin_LoanProducts where Description=Frequency_CTE.Description COLLATE Latin1_General_CI_AS) as FullAccount
 ,Frequency_CTE.pf_no as Reference1 into #temp1 from Frequency_CTE where BAlance>0 ;


WITH Frequency_CTEFOSA (pf_no,Ttype,LastTrxDate,Balance,Description)
AS
(
select fosa_acno,ttype,max(trdate) as TrxDate,(select sum(debit-credit) from fosa.dbo.loanhist  where fosa_acno= Loanhist1.fosa_acno and ttype=Loanhist1.ttype) as balance,(select desc_ from fosa.dbo.lntypes where code=Loanhist1.ttype) from fosa.dbo.Loanhist as Loanhist1 where left(ttype,1)='L' and isnull(credit,0)+isnull(intcr,0)>0 group by fosa_acno,ttype 
)

select 
(select Name from fosa.dbo.customer  where fosa_acno= Frequency_CTEFOSA.pf_no) as Name,Balance,pf_no,LastTrxDate,datediff(mm,LastTrxDate,@EndDate) as DefaultFrequency,
(select Description from vfin_LoanProducts where Description=Frequency_CTEFOSA.Description COLLATE Latin1_General_CI_AS) as LoanName,
 ltrim(rtrim('001-'+(select top 1  REPLACE(STR(SerialNumber, 6), SPACE(1), '0') from vfin_Customers where Reference1=Frequency_CTEFOSA.pf_no COLLATE Latin1_General_CI_AS)+'-002-'+
 (select REPLACE(STR(Code, 3), SPACE(1), '0') from vfin_LoanProducts where Description=Frequency_CTEFOSA.description COLLATE Latin1_General_CI_AS))) as FullAccount
 ,Frequency_CTEFOSA.pf_no as Reference1 into #tempFosa from Frequency_CTEFOSA where BAlance>0 


 SELECT        vw_CustomerAccounts.FullName,isnull((select sum(amount) from vfin_JournalEntries where CustomerAccountId=vw_CustomerAccounts.Id and ChartOfAccountId=vfin_LoanProducts.ChartOfAccountId and CreatedDate<=@EndDate),0)*-1 as Balance ,
 isnull((select sum(amount) from vfin_JournalEntries where CustomerAccountId=vw_CustomerAccounts.Id and ChartOfAccountId=vfin_LoanProducts.InterestReceivableChartOfAccountId and CreatedDate<=@EndDate),0)*-1 as InterestAccrued,vw_CustomerAccounts.reference1,
vw_CustomerAccounts.reference2,vw_CustomerAccounts.Reference3, (SELECT        MAX(dbo.vfin_JournalEntries.CreatedDate) AS Expr1
FROM            dbo.vfin_JournalEntries INNER JOIN
                         dbo.vfin_Journals ON dbo.vfin_JournalEntries.JournalId = dbo.vfin_Journals.Id
WHERE        (dbo.vfin_JournalEntries.CustomerAccountId = vw_CustomerAccounts.Id) AND (dbo.vfin_JournalEntries.ChartOfAccountId = vfin_LoanProducts.ChartOfAccountId) AND 
                         (dbo.vfin_JournalEntries.CreatedDate <= @EndDate and PrimaryDescription not like '%c/f%' )) as LastActivity
, dbo.vfin_LoanProducts.Description as LoanName, 
                         dbo.vw_CustomerAccounts.FullAccount
into #temp2_ FROM             dbo.vw_CustomerAccounts INNER JOIN
                         dbo.vfin_LoanProducts ON dbo.vw_CustomerAccounts.CustomerAccountType_TargetProductId = dbo.vfin_LoanProducts.Id


select *,datediff(mm,#temp2_.LastActivity,@EndDate) as DefaultFrequency into #temp2 from #temp2_					



CREATE  CLUSTERED INDEX IX_1 on #temp2 (fullAccount)

insert into #temp2(FullName,Balance,Reference2,LastActivity,DefaultFrequency,LoanName,FullAccount,reference1) 
select Name,Balance,pf_no,LastTrxDate,DefaultFrequency,LoanName,FullAccount,reference1 from #Temp1 where balance>0 -----and FullAccount not in (select FullAccount from #temp2)

insert into #temp2(FullName,Balance,Reference2,LastActivity,DefaultFrequency,LoanName,FullAccount,reference1) 
select Name,Balance,pf_no,LastTrxDate,DefaultFrequency,LoanName,FullAccount,reference1 from #tempFosa where balance>0 ----and FullAccount not in (select FullAccount from #temp2)



select (select top 1 FullName from #temp2 where FullAccount=temp2.FullAccount order by LastActivity desc) as FullName,(select top 1 balance from #temp2 where FullAccount=temp2.FullAccount order by LastActivity desc) as Balance ,Reference2,max(LastActivity) as LastActivity ,datediff(mm,max(LastActivity),@EndDate) as  DefaultFrequency,FullAccount,LoanName,reference1 into #temp4 from #temp2 temp2 group by Reference2,LoanName,FullAccount,Reference1


select reference1,Fullaccount,fullname,balance,LoanName,max(lastactivity) as lastactivity into #temp3 from #temp4 group by Fullaccount,fullname,balance,LoanName,Reference1;

With CTEFinal(FullName,Balance,LastActivity,ClassOrder,Classification,DefaultFrequency,FullAccount,LoanName,ProductSection,provision_amount,reference1)
as
(
select 
FullName,Balance,LastActivity,
case 
WHEN DATEDIFF(MM,LastActivity,@EndDate)<=2 THEN 0
WHEN DATEDIFF(MM,LastActivity,@EndDate)>=3 and DATEDIFF(MM,LastActivity,@EndDate)<=4 THEN 5
WHEN DATEDIFF(MM,LastActivity,@EndDate)>4 and DATEDIFF(MM,LastActivity,@EndDate)<=6 THEN 25
WHEN DATEDIFF(MM,LastActivity,@EndDate)>6 and DATEDIFF(MM,LastActivity,@EndDate)<=12 THEN 50
WHEN DATEDIFF(MM,LastActivity,@EndDate)>12 THEN 100
end as ClassOrder

,case 
WHEN DATEDIFF(MM,LastActivity,@EndDate)<=2 THEN 'Performing'
WHEN DATEDIFF(MM,LastActivity,@EndDate)>=3 and DATEDIFF(MM,LastActivity,@EndDate)<=4 THEN 'Watch'
WHEN DATEDIFF(MM,LastActivity,@EndDate)>4 and DATEDIFF(MM,LastActivity,@EndDate)<=6 THEN 'Substandard'
WHEN DATEDIFF(MM,LastActivity,@EndDate)>6 and DATEDIFF(MM,LastActivity,@EndDate)<=12 THEN 'Doubtful'
WHEN DATEDIFF(MM,LastActivity,@EndDate)>12 THEN 'Loss'
end as Classification,
DATEDIFF(MM,LastActivity,@EndDate) as DefaultFrequency,FullAccount,LoanName,
(select LoanRegistration_LoanProductSection from vfin_LoanProducts where Description=#temp3.LoanName) as ProductSection,
case 
WHEN DATEDIFF(MM,LastActivity,@EndDate)<=2 THEN 0
WHEN DATEDIFF(MM,LastActivity,@EndDate)>=3 and DATEDIFF(MM,LastActivity,@EndDate)<=4 THEN 5
WHEN DATEDIFF(MM,LastActivity,@EndDate)>4 and DATEDIFF(MM,LastActivity,@EndDate)<=6 THEN 25
WHEN DATEDIFF(MM,LastActivity,@EndDate)>6 and DATEDIFF(MM,LastActivity,@EndDate)<=12 THEN 50
WHEN DATEDIFF(MM,LastActivity,@EndDate)>12 THEN 100
end *Balance *0.01 as provision_amount,Reference1 
 from #temp3 where fullname is not null and balance>0 and DATEDIFF(m,LastActivity,@EndDate)>=@GracePeriod 
)
select 

* from CTEFinal order by DATEDIFF(MM,LastActivity,@EndDate),FullAccount,LoanName

