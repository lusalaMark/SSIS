
/****** Object:  StoredProcedure [dbo].[sp_ProductsBalances]    Script Date: 8/8/2015 2:19:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from products(0)
---sp_ProductsBalances '378FA5F1-6478-C49A-866E-08D10D7E3FD6','06/30/2014','<>',0
ALTER PROCEDURE [dbo].[sp_ProductsBalances]
	@ID varchar(MAX), 
	@Enddate Datetime,
	@Operator char(2),
	@OperatorValue float
AS
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));

BEGIN
	SET NOCOUNT ON;

;WITH JournalEntries (CustomerAccountID, Amount,ChartOfAccountId) AS
(
	SELECT CustomerAccountID, Amount,ChartOfAccountId
    FROM vfin_JournalEntries  where ChartOfAccountId IN (@ID) and CreatedDate<=@Enddate
),


CustomerAccounts (ID,FullAccount,FullName,Description,Reference1,reference2,reference3) AS
(
	SELECT ID,FullAccount,FullName,Description,Reference1,reference2,reference3
    FROM vw_CustomerAccounts h
),

Listing (FullName,FullAccount,Description,Balance,ChartOfAccountId,Reference1,reference2,reference3) as
(
	SELECT   o.FullName,o.FullAccount,o.Description,sum(od.Amount) AS Balance,od.ChartOfAccountId,Reference1,reference2,reference3
	FROM CustomerAccounts o
    INNER JOIN JournalEntries od ON o.id = od.CustomerAccountID
	GROUP BY o.FullAccount,o.FullName ,o.Description,od.ChartOfAccountId,reference1,reference2,reference3
),
	
Summary (FullAccount,FullName,Description, Balance,type,Reference1,reference2,reference3) as
(
	select a.FullAccount,a.FullName,a.Description, 
	case 
	When _products.type ='Loans' 
	Then a.Balance*-1
	else a.Balance end as Balance  ,_products.type,Reference1,reference2,reference3
	From Listing a
	left JOIN dbo.products(0) _products on a.ChartOfAccountId=_products.ChartOfAccountId
)

select distinct FullAccount,FullName,Description, Balance ,type,Reference1,reference2,reference3
From Summary 
where	(
			(@Operator = '>' and Balance  > @OperatorValue)
			or (@Operator = '<' and Balance < @OperatorValue)
			or (@Operator = '<>' and Balance != @OperatorValue)
			or (@Operator = '>=' and Balance >= @OperatorValue)
			or (@Operator = '<=' and Balance <= @OperatorValue)
			or (@Operator = '=' and Balance = @OperatorValue)
		)

end