IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_CustomerAccountStatement') BEGIN
   EXEC('CREATE PROC [dbo].[sp_CustomerAccountStatement] as')
END
GO

/****** Object:  StoredProcedure [dbo].[sp_CustomerAccountStatement]    Script Date: 9/13/2014 3:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---sp_CustomerAccountStatement '01/01/2014','12/01/2014','reference1','0101-001-04583 '
ALTER PROCEDURE [dbo].[sp_CustomerAccountStatement]
	(
		@StartDate datetime,
		@EndDate Datetime,
		@SearchBy NVARCHAR(100),
		@SearchString NVARCHAR(100)
	)

AS
BEGIN

	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'))
	set @SearchString=ltrim(rtrim(@SearchString))
	Declare 
		@LocalStartDate datetime =@StartDate,
		@LocalEndDate Datetime=@EndDate,
		@LocalSearchBy NVARCHAR(100)=@SearchBy,
		@LocalSearchString NVARCHAR(100)=@SearchString


	SET NOCOUNT ON;

    -- Insert statements for procedure here
WITH Statement_cte (FullAccount,AccountName,Product,ID,TrxDate,PrimaryDescription,SecondaryDescription,reference,debit,credit,RunningTotal,InterestDR,InterestCR,IntBalance,Reference1,Reference2,Reference3)
AS
(
	SELECT      CustomerAccounts.FullAccount, Customers.Salutation+' '+Customers.Individual_FirstName+' '+Customers.Individual_LastName as AccountName , Products_1.Description,Products_1.id, JournalEntries.CreatedDate, Journals.PrimaryDescription, 
				Journals.SecondaryDescription,  Journals.Reference,ISNULL(CASE WHEN JournalEntries.amount < 0 THEN JournalEntries.amount * - 1 END, 0) AS Debit, ISNULL(CASE WHEN JournalEntries.amount > 0 THEN JournalEntries.amount END, 0) AS Credit, JournalEntries.Amount,0,0,0,CustomerAccounts.Reference1,CustomerAccounts.Reference2,CustomerAccounts.Reference3
	FROM        dbo.Products(1) AS Products_1 INNER JOIN
				dbo.vfin_JournalEntries AS JournalEntries ON Products_1.ChartOfAccountId = JournalEntries.ChartOfAccountId INNER JOIN
                dbo.vw_CustomerAccounts CustomerAccounts INNER JOIN
                dbo.vw_MemberRegister Customers  ON CustomerAccounts.CustomerId = Customers.Id INNER JOIN
                dbo.vfin_Branches ON CustomerAccounts.BranchId = dbo.vfin_Branches.Id ON 
                JournalEntries.CustomerAccountId = CustomerAccounts.Id INNER JOIN
                dbo.vfin_Journals as Journals ON JournalEntries.JournalId = Journals.Id
	WHERE  
	CASE
		WHEN @LocalSearchBy ='IdentityCardNumber' THEN Customers.Individual_IdentityCardNumber
		WHEN @LocalSearchBy ='SerialNumber' THEN  Customers.SerialNumber
		WHEN @LocalSearchBy ='PersonalFileNumber' THEN  Customers.Individual_PayrollNumbers
		WHEN @LocalSearchBy ='Reference1' THEN  Customers.Reference1
		WHEN @LocalSearchBy ='Reference2' THEN  Customers.Reference2
	end =@LocalSearchString
),

Statement_Interest_cte (FullAccount,AccountName,Product,id,TrxDate,PrimaryDescription,SecondaryDescription,reference,InterestDR,InterestCR,IntBalance,Debit,Credit,RunningTotal,Reference1,Reference2,Reference3)
AS
(
	SELECT       CustomerAccounts.FullAccount, Customers.Salutation+' '+Customers.Individual_FirstName+' '+Customers.Individual_LastName as AccountName , Products_1.Description,Products_1.id, JournalEntries.CreatedDate, Journals.PrimaryDescription, 
				 Journals.SecondaryDescription,  Journals.Reference, ISNULL(CASE WHEN JournalEntries.amount < 0 THEN JournalEntries.amount * - 1 END, 0) AS Debit, ISNULL(CASE WHEN JournalEntries.amount > 0 THEN JournalEntries.amount END, 0) AS Credit,
				 JournalEntries.Amount,0,0,0,CustomerAccounts.Reference1,CustomerAccounts.Reference2,CustomerAccounts.Reference3
	FROM         dbo.Products(1) AS Products_1 INNER JOIN
                 dbo.vfin_JournalEntries AS JournalEntries ON Products_1.InterestReceivable = JournalEntries.ChartOfAccountId INNER JOIN
                 dbo.vw_CustomerAccounts CustomerAccounts INNER JOIN
                 dbo.vw_MemberRegister Customers  ON CustomerAccounts.CustomerId = Customers.Id INNER JOIN
                 dbo.vfin_Branches ON CustomerAccounts.BranchId = dbo.vfin_Branches.Id ON 
                 JournalEntries.CustomerAccountId = CustomerAccounts.Id INNER JOIN
                 dbo.vfin_Journals as Journals ON JournalEntries.JournalId = Journals.Id
	WHERE  
	CASE
		WHEN @LocalSearchBy ='IdentityCardNumber' THEN Customers.Individual_IdentityCardNumber
		WHEN @LocalSearchBy ='SerialNumber' THEN  Customers.SerialNumber
		WHEN @LocalSearchBy ='PersonalFileNumber' THEN  Customers.Individual_PayrollNumbers
		WHEN @LocalSearchBy ='Reference1' THEN  Customers.Reference1
		WHEN @LocalSearchBy ='Reference2' THEN  Customers.Reference2
		WHEN @LocalSearchBy ='Reference3' THEN  Customers.Reference3
	end = (@LocalSearchString) or @LocalSearchString is null
),

Statement_Combined (FullAccount,AccountName,Product,id,TrxDate,PrimaryDescription,SecondaryDescription,reference,Credit,Debit,RunningTotal,InterestDR,InterestCR,IntBalance,Reference1,Reference2,Reference3)
AS
(
	SELECT FullAccount,AccountName,Product,id,TrxDate,PrimaryDescription,SecondaryDescription,reference,debit,credit,RunningTotal,
	InterestDR,InterestCR,IntBalance,Reference1,Reference2,Reference3
	FROM Statement_cte 
	union all
	SELECT FullAccount,AccountName,Product,id,TrxDate,PrimaryDescription,SecondaryDescription,reference,debit,credit,RunningTotal,
	InterestDR,InterestCR,IntBalance,Reference1,Reference2,Reference3
	FROM Statement_Interest_cte 
)

select FullAccount,AccountName,Product,id,TrxDate,ltrim(rtrim(PrimaryDescription))+' '+ltrim(rtrim(SecondaryDescription)) as PrimaryDescription ,reference,Debit,credit,SUM(isnull(RunningTotal,0)) OVER(PARTITION BY Product  ORDER BY TrxDate
	  		  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as RunningTotal,
InterestDR,InterestCR,SUM(isnull(IntBalance,0)) OVER(PARTITION BY Product  ORDER BY TrxDate
	  		  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)  as IntBalance,Reference1,Reference2,Reference3 into #temp from Statement_Combined order by product,TrxDate

select * from #temp WHERE TrxDate Between @LocalStartDate and @LocalEndDate

END

