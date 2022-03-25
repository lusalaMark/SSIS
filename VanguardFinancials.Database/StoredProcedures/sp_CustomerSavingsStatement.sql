IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_CustomerSavingsStatement') BEGIN
   EXEC('CREATE PROC [dbo].[sp_CustomerSavingsStatement] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CustomerSavingsStatement]    Script Date: 9/13/2014 3:52:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---[sp_CustomerSavingsStatement] '01/01/2014','05/31/2014','reference1','0101-001-00671 '
ALTER PROCEDURE [dbo].[sp_CustomerSavingsStatement]
	(
		@StartDate datetime,
		@EndDate Datetime,
		@SearchBy NVARCHAR(MAX),
		@SearchString NVARCHAR(MAX)
	)

AS
BEGIN
	SET NOCOUNT ON;
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));

    -- Insert statements for procedure here
WITH Statement_cte (FullAccount,AccountName,Product,Type,TrxDate,PrimaryDescription,SecondaryDescription,reference,debit,credit,BookBalance,AvailableBalance)
AS
(
SELECT        CustomerAccounts.FullAccount, Customers.Salutation+' '+Customers.Individual_FirstName+' '+Customers.Individual_LastName as AccountName , Products_1.Description,Products_1.Code, JournalEntries.CreatedDate, Journals.PrimaryDescription, 
			  Journals.SecondaryDescription,  Journals.Reference, ISNULL(CASE WHEN JournalEntries.amount < 0 THEN JournalEntries.amount * - 1 END, 0) AS Debit, ISNULL(CASE WHEN JournalEntries.amount > 0 THEN JournalEntries.amount END, 0) AS Credit,
			  
			  SUM(isnull(JournalEntries.Amount,0)) OVER(PARTITION BY Products_1.Description  ORDER BY JournalEntries.CreatedDate
	  		  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as BookBalance,

					  SUM
						(
						  CASE 
						  WHEN JournalEntries.ContraChartOfAccountId<>'F219BF2C-7956-C13E-C38E-08D133ECD9FB' THEN
							isnull(JournalEntries.Amount ,0) 
						  ELSE 
							0 
						  END
						) 
					  OVER
						(
						  PARTITION BY Products_1.Description  ORDER BY JournalEntries.CreatedDate
	  					  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
						) -Products_1.MinimumBalance
FROM          dbo.vfin_SavingsProducts AS Products_1 INNER JOIN
                         dbo.vfin_JournalEntries AS JournalEntries ON Products_1.ChartOfAccountId = JournalEntries.ChartOfAccountId INNER JOIN
                         dbo.vw_CustomerAccounts CustomerAccounts INNER JOIN
                         dbo.vw_MemberRegister Customers  ON CustomerAccounts.CustomerId = Customers.Id INNER JOIN
                         dbo.vfin_Branches ON CustomerAccounts.BranchId = dbo.vfin_Branches.Id ON 
                         JournalEntries.CustomerAccountId = CustomerAccounts.Id INNER JOIN
                         dbo.vfin_Journals as Journals ON JournalEntries.JournalId = Journals.Id
WHERE 
CASE
	WHEN @SearchBy ='IdentityCardNumber' THEN Customers.Individual_IdentityCardNumber
	WHEN @SearchBy ='SerialNumber' THEN  Customers.SerialNumber
	WHEN @SearchBy ='PersonalFileNumber' THEN  Customers.Individual_PayrollNumbers
	WHEN @SearchBy ='Reference1' THEN  Customers.Reference1
	WHEN @SearchBy ='Reference2' THEN  Customers.Reference2
	WHEN @SearchBy ='FullAccount' THEN CustomerAccounts.FullAccount
end = (@SearchString) 
)
SELECT FullAccount,AccountName,Product,type,TrxDate,PrimaryDescription,SecondaryDescription,reference,debit,credit,BookBalance,AvailableBalance
FROM Statement_cte 
WHERE TrxDate Between @StartDate and @EndDate
order by Product,Trxdate 
END




