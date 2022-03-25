
/****** Object:  StoredProcedure [dbo].[sp_electroniclistBOSAFOSAloans]    Script Date: 8/19/2015 9:13:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---sp_electroniclistBOSAFOSAloans '07/31/2015'
create Procedure [dbo].[sp_electroniclistBOSAFOSAloans]
@pEndDate DateTime
as
--select disbursedBy from vfin_loancases order by createddate desc
select Reference1,Reference2,Reference3,FullName,
(select description from vfin_branches where code=1) as [Branch Name],

isnull((select top 1 disbursedBy from vfin_LoanCases where CustomerId=vw_CustomerAccounts.CustomerId and LoanProductId=vw_CustomerAccounts.CustomerAccountType_TargetProductId and DisbursedDate<=@pEndDate order by DisbursedDate desc),'') as [Loan Officer],
vw_CustomerAccounts.description,
vw_CustomerAccounts.EmployerName,

case when (select LoanInterest_CalculationMode from vfin_LoanProducts where id =vw_CustomerAccounts.CustomerAccountType_TargetProductId) ='512' then 'Reducing Balance'
	 WHEN (select LoanInterest_CalculationMode from vfin_LoanProducts where id =vw_CustomerAccounts.CustomerAccountType_TargetProductId) = '513' then 'Straight Line'
	 WHEN (select LoanInterest_CalculationMode from vfin_LoanProducts where id =vw_CustomerAccounts.CustomerAccountType_TargetProductId) = '514' then 'Amortization'
	 END as [Loan Amortization Type],
isnull((select  top 1 Principal from vfin_StandingOrders where BeneficiaryCustomerAccountId=vw_CustomerAccounts.id ),0) as [Loan Instalments]
,(select LoanInterest_AnnualPercentageRate from vfin_LoanProducts where id =vw_CustomerAccounts.CustomerAccountType_TargetProductId) as [Annual Loan Rate]
,(select LoanRegistration_TermInMonths from vfin_LoanProducts where id =vw_CustomerAccounts.CustomerAccountType_TargetProductId) as [Period]
,CASE (select LoanRegistration_PaymentFrequencyPerYear from vfin_LoanProducts where id =vw_CustomerAccounts.CustomerAccountType_TargetProductId)
WHEN 1 THEN 'Annual'
WHEN 2 THEN 'Semi-Annual (every 6 months)'
WHEN 3 THEN 'Quarterly (every 3 months)'
WHEN 4 THEN 'Tri-Annual (every 4 months)'
WHEN 6 THEN 'Bi-Monthly (every 2 months)'
WHEN 12 THEN 'Monthly'
WHEN 24 THEN 'Semi-Monthly (twice a month)'
WHEN 26 THEN 'Bi-Weekly (every 2 weeks)'
WHEN 52 THEN 'Weekly'
WHEN 256 THEN 'Daily'
END as [Loan Frequency],
(select top 1 Reference from vfin_LoanCases where CustomerId=vw_CustomerAccounts.CustomerId and LoanProductId=vw_CustomerAccounts.CustomerAccountType_TargetProductId and DisbursedDate<=@pEndDate order by DisbursedDate desc) as [Loan Number],

case 
when isnull((select  top 1 Duration_StartDate from vfin_StandingOrders where BeneficiaryCustomerAccountId=vw_CustomerAccounts.id ),'')<>''
then isnull((select  top 1 Duration_StartDate from vfin_StandingOrders where BeneficiaryCustomerAccountId=vw_CustomerAccounts.id ),'') 
else
(SELECT      top 1  Bosa.dbo.lntrans.iss_date
FROM            Bosa.dbo.lntrans INNER JOIN
                         dbo.vfin_LoanProducts ON Bosa.dbo.lntrans.loanname = dbo.vfin_LoanProducts.Description where Bosa.dbo.lntrans.pf_no=vw_CustomerAccounts.reference2 order by   Bosa.dbo.lntrans.iss_date desc)
end
as [Date Loan Disbursed],

dateadd(m,1,
isnull(case 
when isnull((select  top 1 Duration_StartDate from vfin_StandingOrders where BeneficiaryCustomerAccountId=vw_CustomerAccounts.id ),'')<>''
then isnull((select  top 1 Duration_StartDate from vfin_StandingOrders where BeneficiaryCustomerAccountId=vw_CustomerAccounts.id ),'') 
else
(SELECT      top 1  Bosa.dbo.lntrans.iss_date
FROM            Bosa.dbo.lntrans INNER JOIN
                         dbo.vfin_LoanProducts ON Bosa.dbo.lntrans.loanname = dbo.vfin_LoanProducts.Description where Bosa.dbo.lntrans.pf_no=vw_CustomerAccounts.reference2 order by   Bosa.dbo.lntrans.iss_date desc)
end,''))
as [Loan First Pmt Date],
case
	when isnull((select top 1 DisbursedAmount from vfin_LoanCases where CustomerId=vw_CustomerAccounts.CustomerId and LoanProductId=vw_CustomerAccounts.CustomerAccountType_TargetProductId  and DisbursedDate<=@pEndDate order by DisbursedDate desc),0)<>0
	then (select top 1 DisbursedAmount from vfin_LoanCases where CustomerId=vw_CustomerAccounts.CustomerId and LoanProductId=vw_CustomerAccounts.CustomerAccountType_TargetProductId  and DisbursedDate<=@pEndDate order by DisbursedDate desc)
else

case 
when dbo.vfin_LoanProducts.LoanRegistration_LoanProductSection='47803'
then
	(SELECT      top 1  Bosa.dbo.lntrans.comm_award
	FROM            Bosa.dbo.lntrans INNER JOIN
							 dbo.vfin_LoanProducts ON Bosa.dbo.lntrans.loanname = dbo.vfin_LoanProducts.Description where Bosa.dbo.lntrans.pf_no=vw_CustomerAccounts.reference2 order by   Bosa.dbo.lntrans.iss_date desc)
else
	(SELECT      top 1  fosa.dbo.lntrans.comm_award
	FROM            fosa.dbo.lntrans INNER JOIN
							 dbo.vfin_LoanProducts ON fosa.dbo.lntrans.loanname = dbo.vfin_LoanProducts.Description where fosa.dbo.lntrans.fosa_acno=vw_CustomerAccounts.reference1 order by   fosa.dbo.lntrans.iss_date desc)
end
end as   [Loan Amount]
,

isnull((select  top 1 Duration_EndDate from vfin_StandingOrders where BeneficiaryCustomerAccountId=vw_CustomerAccounts.id ),'') as [Loan Maturity],
isnull((select sum(amount) from vfin_JournalEntries where CustomerAccountId =vw_CustomerAccounts.id and ChartOfAccountId in (select ChartOfAccountId from vfin_LoanProducts) and CreatedDate<=@pEndDate) ,0)*-1 as [Loan Balance],
isnull((select sum(amount) from vfin_JournalEntries where CustomerAccountId =vw_CustomerAccounts.id and ChartOfAccountId in (select interestReceivablechartofaccountid from vfin_LoanProducts) and CreatedDate<=@pEndDate) ,0)*-1 as [Loan Interest Due],

case 
when (select top 1 CreatedDate from vfin_JournalEntries where CustomerAccountId =vw_CustomerAccounts.id and ChartOfAccountId in (select ChartOfAccountId from vfin_LoanProducts) and CreatedDate<=@pEndDate and amount>0 order by CreatedDate desc) is not null then
	(select top 1 CreatedDate from vfin_JournalEntries where CustomerAccountId =vw_CustomerAccounts.id and ChartOfAccountId in (select ChartOfAccountId from vfin_LoanProducts) and CreatedDate<=@pEndDate and amount>0 order by CreatedDate desc) 
else
		case
		when dbo.vfin_LoanProducts.LoanRegistration_LoanProductSection='47803'
		then
			(SELECT      top 1  Bosa.dbo.history.trdate
			FROM            Bosa.dbo.history INNER JOIN
                         bosa.dbo.lntypes ON bosa.dbo.history.ttype = bosa.dbo.lntypes.code where Bosa.dbo.history.pf_no=vw_CustomerAccounts.reference2 and bosa.dbo.lntypes.name=dbo.vfin_LoanProducts.Description order by   Bosa.dbo.history.trdate desc)
		else
			(SELECT      top 1  fosa.dbo.loanhist.trdate
			FROM            fosa.dbo.loanhist INNER JOIN
                         fosa.dbo.lntypes ON fosa.dbo.loanhist.ttype = fosa.dbo.lntypes.code where fosa.dbo.loanhist.fosa_acno=vw_CustomerAccounts.reference1 and fosa.dbo.lntypes.desc_=dbo.vfin_LoanProducts.Description order by   fosa.dbo.loanhist.trdate desc)
		end
end  as [Last Installment Date1],
case 
when (select top 1 amount from vfin_JournalEntries where CustomerAccountId =vw_CustomerAccounts.id and ChartOfAccountId in (select ChartOfAccountId from vfin_LoanProducts) and CreatedDate<=@pEndDate and amount>0 order by CreatedDate desc) is not null then
	(select top 1 amount from vfin_JournalEntries where CustomerAccountId =vw_CustomerAccounts.id and ChartOfAccountId in (select ChartOfAccountId from vfin_LoanProducts) and CreatedDate<=@pEndDate and amount>0 order by CreatedDate desc) 
else
		case
		when dbo.vfin_LoanProducts.LoanRegistration_LoanProductSection='47803'
		then
			(SELECT      top 1  Bosa.dbo.history.credit
			FROM            Bosa.dbo.history INNER JOIN
                         bosa.dbo.lntypes ON bosa.dbo.history.ttype = bosa.dbo.lntypes.code where Bosa.dbo.history.pf_no=vw_CustomerAccounts.reference2 and bosa.dbo.lntypes.name=dbo.vfin_LoanProducts.Description order by   Bosa.dbo.history.trdate desc)
		else
			(SELECT      top 1  fosa.dbo.loanhist.credit
			FROM            fosa.dbo.loanhist INNER JOIN
                         fosa.dbo.lntypes ON fosa.dbo.loanhist.ttype = fosa.dbo.lntypes.code where fosa.dbo.loanhist.fosa_acno=vw_CustomerAccounts.reference1 and fosa.dbo.lntypes.desc_=dbo.vfin_LoanProducts.Description order by   fosa.dbo.loanhist.trdate desc)
		end
end  as [Latest Amount Paid],
(select top 1 (select sum(AmountGuaranteed) from dbo.vfin_LoanGuarantors where LoanCaseId=vfin_LoanCases.id ) from vfin_LoanCases where CustomerId=vw_CustomerAccounts.CustomerId and LoanProductId=vw_CustomerAccounts.CustomerAccountType_TargetProductId and DisbursedDate<=@pEndDate order by DisbursedDate desc) as [Amount of Guarantee],
(select top 1 (select count(AmountGuaranteed) from dbo.vfin_LoanGuarantors where LoanCaseId=vfin_LoanCases.id ) from vfin_LoanCases where CustomerId=vw_CustomerAccounts.CustomerId and LoanProductId=vw_CustomerAccounts.CustomerAccountType_TargetProductId and DisbursedDate<=@pEndDate order by DisbursedDate desc) as [No of Loan Guarantors]

into #tempLoans  FROM            dbo.vw_CustomerAccounts INNER JOIN
                         dbo.vfin_LoanProducts ON dbo.vw_CustomerAccounts.CustomerAccountType_TargetProductId = dbo.vfin_LoanProducts.Id where CustomerAccountType_TargetProductId in (select id from vfin_LoanProducts) order by CustomerAccountType_TargetProductId

select *,[Last Installment Date1] as [Last Installment Date]  into #tempLoans1
from #tempLoans 

select *,case 
WHEN DATEDIFF(MM,[Last Installment Date],@pEndDate)<=2 THEN 1
WHEN DATEDIFF(MM,[Last Installment Date],@pEndDate)>=3 and DATEDIFF(MM,[Last Installment Date],@pEndDate)<=4 THEN 5
WHEN DATEDIFF(MM,[Last Installment Date],@pEndDate)>4 and DATEDIFF(MM,[Last Installment Date],@pEndDate)<=6 THEN 25
WHEN DATEDIFF(MM,[Last Installment Date],@pEndDate)>6 and DATEDIFF(MM,[Last Installment Date],@pEndDate)<=12 THEN 50
WHEN DATEDIFF(MM,[Last Installment Date],@pEndDate)>12 THEN 100
end as ClassOrder,
case 
WHEN DATEDIFF(MM,[Last Installment Date],@pEndDate)<=2 THEN 'Performing'
WHEN DATEDIFF(MM,[Last Installment Date],@pEndDate)>=3 and DATEDIFF(MM,[Last Installment Date],@pEndDate)<=4 THEN 'Watch'
WHEN DATEDIFF(MM,[Last Installment Date],@pEndDate)>4 and DATEDIFF(MM,[Last Installment Date],@pEndDate)<=6 THEN 'Substandard'
WHEN DATEDIFF(MM,[Last Installment Date],@pEndDate)>6 and DATEDIFF(MM,[Last Installment Date],@pEndDate)<=12 THEN 'Doubtful'
WHEN DATEDIFF(MM,[Last Installment Date],@pEndDate)>12 THEN 'Loss'
end as Classification,
DATEDIFF(MM,[Last Installment Date],@pEndDate) as DefaultFrequency,
case 
WHEN DATEDIFF(MM,[Last Installment Date],@pEndDate)<=2 THEN 1
WHEN DATEDIFF(MM,[Last Installment Date],@pEndDate)>=3 and DATEDIFF(MM,[Last Installment Date],@pEndDate)<=4 THEN 5
WHEN DATEDIFF(MM,[Last Installment Date],@pEndDate)>4 and DATEDIFF(MM,[Last Installment Date],@pEndDate)<=6 THEN 25
WHEN DATEDIFF(MM,[Last Installment Date],@pEndDate)>6 and DATEDIFF(MM,[Last Installment Date],@pEndDate)<=12 THEN 50
WHEN DATEDIFF(MM,[Last Installment Date],@pEndDate)>12 THEN 100 end as Provision
from #tempLoans1   where [Loan Balance]>0  order by case 
WHEN DATEDIFF(MM,[Last Installment Date],@pEndDate)<=2 THEN 1
WHEN DATEDIFF(MM,[Last Installment Date],@pEndDate)>=3 and DATEDIFF(MM,[Last Installment Date],@pEndDate)<=4 THEN 5
WHEN DATEDIFF(MM,[Last Installment Date],@pEndDate)>4 and DATEDIFF(MM,[Last Installment Date],@pEndDate)<=6 THEN 25
WHEN DATEDIFF(MM,[Last Installment Date],@pEndDate)>6 and DATEDIFF(MM,[Last Installment Date],@pEndDate)<=12 THEN 50
WHEN DATEDIFF(MM,[Last Installment Date],@pEndDate)>12 THEN 100 end