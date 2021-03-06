
/****** Object:  StoredProcedure [dbo].[sp_GenerateOpeningBalanceFromArchive]    Script Date: 2/12/2016 7:35:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[sp_GenerateOpeningBalanceFromArchive] 
as
with OpeningBalanceCTE (ChartOfAccountId,amount,CustomerAccountId)
as (
select ChartOfAccountId,sum(amount),CustomerAccountId from vfin_JournalEntriesArchive 
where ChartOfAccountId in (select ChartOfAccountId from products(0))
group by CustomerAccountId,ChartOfAccountId 
union
select ChartOfAccountId,sum(amount),null from vfin_JournalEntriesArchive 
where ChartOfAccountId not in (select ChartOfAccountId from products(0))
group by ChartOfAccountId 
)
select * from OpeningBalanceCTE where amount<>0 order by ChartOfAccountId,CustomerAccountId 




