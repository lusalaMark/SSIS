

---sp_UnpaidFixedDeposits '11/15/2014'
create procedure sp_Fixeddepositasat
(@EndDate DateTime)
as
set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));

SELECT        dbo.vfin_FixedDeposits.Value, dbo.vfin_FixedDeposits.Term, dbo.vfin_FixedDeposits.Rate, dbo.vfin_FixedDeposits.Remarks, dbo.vfin_FixedDeposits.Status, 
                         dbo.vfin_FixedDeposits.MaturityDate, dbo.vfin_FixedDeposits.ExpectedInterest, dbo.vfin_FixedDeposits.TotalExpected, dbo.vfin_FixedDeposits.PaidBy, 
                         dbo.vfin_FixedDeposits.PaidDate, dbo.vfin_FixedDeposits.CreatedBy, dbo.vfin_FixedDeposits.CreatedDate, 
                         dbo.vfin_FixedDeposits.Id, dbo.vw_CustomerAccounts.Reference1, dbo.vw_CustomerAccounts.FullAccount, dbo.vw_CustomerAccounts.FullName
 FROM            dbo.vfin_FixedDeposits INNER JOIN
                         dbo.vw_CustomerAccounts ON dbo.vfin_FixedDeposits.CustomerAccountId = dbo.vw_CustomerAccounts.Id
 wHERE         isnull(PaidDate,@EndDate)>=@EndDate and CreatedDate<@EndDate

