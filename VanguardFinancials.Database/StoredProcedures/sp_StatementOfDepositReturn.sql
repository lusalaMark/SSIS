IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_StatementOfDepositReturn') BEGIN
   EXEC('CREATE PROC [dbo].[sp_StatementOfDepositReturn] as')
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---[sp_StatementOfDepositReturn] '05/31/2014'
USE [VanguardFinancialsDB_KWETU]
GO
/****** Object:  StoredProcedure [dbo].[sp_StatementOfDepositReturn]    Script Date: 5/15/2015 9:45:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---[sp_StatementOfDepositReturn]'05/13/2015'

ALTER  Procedure [dbo].[sp_StatementOfDepositReturn]
(
@enddate as Datetime
)
as
 set nocount on
set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));


Create Table #response(Code char(3),Description varchar(50),Range1 numeric(14,2),Range2 numeric(14,2),
Balance numeric(14,2),countx numeric(14),OrderCode char(2),OrderName Char(50))

SELECT        dbo.vfin_FixedDeposits.Value, dbo.vfin_FixedDeposits.Term, dbo.vfin_FixedDeposits.Rate, dbo.vfin_FixedDeposits.Remarks, dbo.vfin_FixedDeposits.Status, 
                         dbo.vfin_FixedDeposits.MaturityDate, dbo.vfin_FixedDeposits.ExpectedInterest, dbo.vfin_FixedDeposits.TotalExpected, dbo.vfin_FixedDeposits.PaidBy, 
                         dbo.vfin_FixedDeposits.PaidDate, dbo.vfin_FixedDeposits.CreatedBy, dbo.vfin_FixedDeposits.CreatedDate, 
                         dbo.vfin_FixedDeposits.CustomerAccountId,dbo.vfin_FixedDeposits.Id, dbo.vw_CustomerAccounts.Reference1, dbo.vw_CustomerAccounts.FullAccount, dbo.vw_CustomerAccounts.FullName
into #temp1 FROM            dbo.vfin_FixedDeposits INNER JOIN
                         dbo.vw_CustomerAccounts ON dbo.vfin_FixedDeposits.CustomerAccountId = dbo.vw_CustomerAccounts.Id
 wHERE         isnull(PaidDate,@EndDate)<=@EndDate ---and dbo.vfin_FixedDeposits.CreatedDate<=@EndDate


select Id as CustomerAccountId,FullAccount,10000000000.00-10000000000.00 as Balance,
(select ChartOfAccountId from vfin_InvestmentProducts where id= vw_CustomerAccounts.CustomerAccountType_TargetProductId) as ChartOfAccountId
into #Sacco_DepositsAccounts
 from vw_CustomerAccounts where CustomerAccountType_ProductCode  = 3 -- Investments
and CustomerAccountType_TargetProductId in(SELECT id FROM vfin_InvestmentProducts WHERE Code in (2) -- Deposits
)
--select * from vfin_InvestmentProducts
select Id as CustomerAccountId,FullAccount,10000000000.00-10000000000.00 as Balance,
(select ChartOfAccountId from vfin_SavingsProducts where id= vw_CustomerAccounts.CustomerAccountType_TargetProductId) as ChartOfAccountId
into #Sacco_SavingsAccounts
 from vw_CustomerAccounts where CustomerAccountType_ProductCode = 1 -- Savings
and CustomerAccountType_TargetProductId in(SELECT id FROM vfin_SavingsProducts WHERE Code <>7 --  Fixed Deposits
)

select  CustomerAccountId,(select FullAccount from vw_CustomerAccounts where id=#temp1.CustomerAccountId) as FullAccount,10000000000.00-10000000000.00 as Balance,
(SELECT 
      [ChartOfAccountId]
  FROM [dbo].[vfin_SystemGeneralLedgerAccountMappings] where      SystemGeneralLedgerAccountCode='48832'
) as ChartOfAccountId
into #Sacco_TermDeposits
 from #temp1 ---where PaidDate is null
 --select * from   drop table #Sacco_TermDeposits

create table #temp(ChartOfAccountID UniqueIdentifier)

---insert into #temp(ChartOfAccountID)
--select ChartOfAccountId from #Sacco_TermDeposits group by ChartOfAccountId

insert into #temp(ChartOfAccountID)
select ChartOfAccountId from #Sacco_SavingsAccounts group by ChartOfAccountId

insert into #temp(ChartOfAccountID)
select ChartOfAccountId from #Sacco_DepositsAccounts group by ChartOfAccountId

SELECT vfin_JournalEntries.CustomerAccountId,SUM(coalesce(vfin_JournalEntries.amount,0)) as Balance
into #tempBalances
FROM vfin_JournalEntries
where ChartOfAccountId in(select ChartOfAccountId from #temp)
and  CreatedDate <=@enddate
group by vfin_JournalEntries.CustomerAccountId

update #Sacco_TermDeposits set Balance =isnull((select sum(value) from vfin_FixedDeposits where CustomerAccountId=
#Sacco_TermDeposits.CustomerAccountId and CreatedDate<=@enddate),0)

update #Sacco_SavingsAccounts set Balance =isnull((select Balance from #tempBalances where CustomerAccountId=
#Sacco_SavingsAccounts.CustomerAccountId),0)

update #Sacco_DepositsAccounts set Balance =isnull((select Balance from #tempBalances where CustomerAccountId=
#Sacco_DepositsAccounts.CustomerAccountId),0)

insert into #response(Code ,Description ,Range1,Range2,Balance,Countx,OrderCode,OrderName)
select '02','Savings',Ranges.range1,Ranges.Range2,sum(coalesce(#Sacco_SavingsAccounts.balance,0)) as Balance,
count(#Sacco_SavingsAccounts.FullAccount) as Countx,Ranges.Code ,Ranges.OrderName
from vfin_Depositsranges Ranges
left outer join #Sacco_SavingsAccounts on #Sacco_SavingsAccounts.balance >=Ranges.Range1 and  #Sacco_SavingsAccounts.balance <=Ranges.Range2
group by  Ranges.range1,Ranges.Range2,Ranges.Code,Ranges.OrderName


insert into #response(Code ,Description ,Range1,Range2,Balance,Countx,OrderCode,OrderName)
select '03','Term Deposits',Ranges.range1,Ranges.Range2,sum(coalesce(#Sacco_TermDeposits.balance,0)) as Balance,
count(#Sacco_TermDeposits.FullAccount) as Countx,Ranges.Code ,Ranges.OrderName
from vfin_Depositsranges Ranges
left outer join #Sacco_TermDeposits on #Sacco_TermDeposits.balance >=Ranges.Range1 and  #Sacco_TermDeposits.balance <=Ranges.Range2
group by  Ranges.range1,Ranges.Range2,Ranges.Code,Ranges.OrderName

insert into #response(Code ,Description ,Range1,Range2,Balance,Countx,OrderCode,OrderName)
select '01','Non Withdraw-able',Ranges.range1,Ranges.Range2,sum(coalesce(#Sacco_DepositsAccounts.balance,0)) as Balance,
count(#Sacco_DepositsAccounts.FullAccount) as Countx,Ranges.Code,Ranges.OrderName 
from vfin_Depositsranges Ranges
left outer  join #Sacco_DepositsAccounts on #Sacco_DepositsAccounts.balance >=Ranges.Range1 and  #Sacco_DepositsAccounts.balance <=Ranges.Range2
group by  Ranges.range1,Ranges.Range2,Ranges.Code,Ranges.OrderName

---select * from #Sacco_TermDeposits
select * from #response order by OrderCode,code


