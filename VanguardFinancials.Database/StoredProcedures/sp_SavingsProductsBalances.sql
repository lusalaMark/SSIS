IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_SavingsProductsBalances') BEGIN
   EXEC('CREATE PROC [dbo].[sp_SavingsProductsBalances] as')
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_SavingsProductsBalances]
	@ID varchar(MAX), 
	@Enddate Datetime,
	@Operator char(2),
	@OperatorValue float
AS
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));

BEGIN
	SET NOCOUNT ON;

;WITH JournalEntries (CustomerAccountID, Amount) AS
(
	SELECT CustomerAccountID, Amount
    FROM vfin_JournalEntries  where ChartOfAccountId IN (@ID) and CreatedDate<=@Enddate
),


CustomerAccounts (ID,FullAccount,FullName,Description) AS
(
	SELECT ID,FullAccount,FullName,Description
    FROM vw_CustomerAccounts h
),

Summary (FullName,FullAccount,Description,Balance) as
(
	SELECT  o.FullName,o.FullAccount,o.Description,sum(od.Amount) AS Balance
	FROM CustomerAccounts o
    INNER JOIN JournalEntries od ON o.id = od.CustomerAccountID
	GROUP BY o.FullAccount,o.FullName ,o.Description
)	

select FullAccount,FullName,Description, Balance From Summary

where	(
			(@Operator = '>' and Balance  > @OperatorValue)
			or (@Operator = '<' and Balance < @OperatorValue)
			or (@Operator = '<>' and Balance != @OperatorValue)
			or (@Operator = '>=' and Balance >= @OperatorValue)
			or (@Operator = '<=' and Balance <= @OperatorValue)
			or (@Operator = '=' and Balance = @OperatorValue)
		)

end




GO
