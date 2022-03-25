IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_SingleGlTransactions_DateRange') BEGIN
   EXEC('CREATE PROC [dbo].[sp_SingleGlTransactions_DateRange] as  select top 1 * from vfin_customers')
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  PROCEDURE [dbo].[sp_SingleGlTransactions_DateRange]
	-- Add the parameters for the stored procedure here
	@ChartOfAccountID as Varchar(100),
	@StartDate as Datetime,
	@EndDate as Datetime

AS
	Declare 
	@OpeningBalance Numeric (18,2)
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT  (
		SELECT
			(
			SELECT 
			  [Description]
			FROM [dbo].[vfin_Branches] 
			WHERE Id=[dbo].[vfin_Journals].BranchId
			)
		FROM [dbo].[vfin_Journals] 
		WHERE Id =  [dbo].[vfin_JournalEntries].JournalId
		) AS Branch
		,
		(
			SELECT 
			  [AccountCode]
			FROM [dbo].[vfin_ChartOfAccounts] 
			WHERE Id = [dbo].[vfin_JournalEntries].ChartOfAccountId
		) AS ChartOfAccount
		,
		(
			SELECT 
			  [AccountName]
			FROM [dbo].[vfin_ChartOfAccounts] 
			WHERE Id = [dbo].[vfin_JournalEntries].ChartOfAccountId
		) AS [AccountName]

		,
		(
			SELECT 
			  [AccountCode]
			FROM [dbo].[vfin_ChartOfAccounts] 
			WHERE Id = [dbo].[vfin_JournalEntries].[ContraChartOfAccountId]
		) AS ContraChartOfAccountCode
		,
		(
			SELECT 
			  [AccountName]
			FROM [dbo].[vfin_ChartOfAccounts] 
			WHERE Id = [dbo].[vfin_JournalEntries].[ContraChartOfAccountId]
		) AS [ContraAccountName]

      ,
	  (
		SELECT (
					SELECT
						[Individual_FirstName]+' '+
						[Individual_LastName]
					FROM [dbo].[vfin_Customers] 
					where Id=[dbo].[vfin_CustomerAccounts].CustomerId
				) 
		FROM [dbo].[vfin_CustomerAccounts] 
		WHERE Id=[dbo].[vfin_JournalEntries].CustomerAccountId
	  ) as CustomerAccountName
	  ,
		(
		  SELECT [PrimaryDescription]
		  FROM [dbo].[vfin_Journals]
		  WHERE Id=[dbo].[vfin_JournalEntries].JournalId
		) AS [PrimaryDescription]
	  ,
		(
		  SELECT [SecondaryDescription]
		  FROM [dbo].[vfin_Journals]
		  WHERE Id=[dbo].[vfin_JournalEntries].JournalId
		) AS [SecondaryDescription]
	  ,
		(
		  SELECT [Reference]
		  FROM [dbo].[vfin_Journals]
		  WHERE Id=[dbo].[vfin_JournalEntries].JournalId
		) AS [Reference]

	  ,[Amount]
	  ,[CreatedDate]
	  INTO #Temp 
	  FROM [dbo].[vfin_JournalEntries] 
	  where ChartOfAccountId=@ChartOfAccountId and CreatedDate>=@StartDate and CreatedDate<=@Enddate

	  set @OpeningBalance=
	  (
		SELECT sum(amount) 
		FROM [dbo].[vfin_JournalEntries] 
		WHERE ChartOfAccountId=@ChartOfAccountId and CreatedDate<@StartDate
	  )
	  set @OpeningBalance=isnull(@OpeningBalance,0)
	  insert into #temp (CreatedDate,SecondaryDescription,Reference,Amount) 
	  values(@StartDate,'Balance B/F', 'B/B', @OpeningBalance)
	  select *,case when [Amount]>0 then Amount else 0 end as Credit,case when [Amount]<0 then Amount*-1 else 0 end as Debit, 
	SUM(amount) OVER(ORDER BY CreatedDate 
     ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 
          AS RunningTotal
		  ,convert(varchar(10),CreatedDate,103) as date	  
	  from #Temp order by CreatedDate

	  

END


GO
