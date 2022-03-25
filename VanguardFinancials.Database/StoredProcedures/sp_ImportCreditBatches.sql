select * from vfin_CreditBatches order by [month]

select * from vfin_CreditBatchEntries
select * from Legacy

select  * from Legacy.dbo.history where trdescpt = 'Salary for Sep 2015' and left(fosa_acno,4)='5-02' and year(trdate)=2015

  insert into vfin_CreditBatchEntries 
  (Id, CreditBatchId, CustomerAccountId, Principal, Interest, Balance, Beneficiary, Reference, Status, CreatedBy, CreatedDate)

SELECT    newid(),'B463529E-8318-C4AE-4A27-08D33DC709A4',    dbo.vw_CustomerAccounts.Id,Legacy.dbo.history.debit, 0,0,fosa_acno,fosa_acno,2,'Legacy', Legacy.dbo.history.trdate
FROM            dbo.vfin_SavingsProducts INNER JOIN
                         dbo.vw_CustomerAccounts ON dbo.vfin_SavingsProducts.Id = dbo.vw_CustomerAccounts.CustomerAccountType_TargetProductId INNER JOIN
                         Legacy.dbo.history ON dbo.vw_CustomerAccounts.Reference1 = Legacy.dbo.history.fosa_acno
WHERE        (Legacy.dbo.history.trdescpt = 'Salary for Oct 2015') AND (LEFT(Legacy.dbo.history.fosa_acno, 4) = '5-02') AND (YEAR(Legacy.dbo.history.trdate) = 2015)
