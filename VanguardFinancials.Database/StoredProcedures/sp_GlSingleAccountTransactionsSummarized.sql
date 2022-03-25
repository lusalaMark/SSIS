IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_GlSingleAccountTransactionsSummarized') BEGIN
   EXEC('CREATE PROC [dbo].[sp_GlSingleAccountTransactionsSummarized] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GlSingleAccountTransactionsSummarized]    Script Date: 9/13/2014 8:48:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 14.06.2014
-- Description:	GLTransactionsSummarized
-- =============================================
--sp_GlSingleAccountTransactionsSummarized '347FCC34-7D65-C7EF-1788-08D10D7DA0F1','05/20/2014','05/31/2014'
ALTER PROCEDURE [dbo].[sp_GlSingleAccountTransactionsSummarized] 
	-- Add the parameters for the stored procedure here
	@ChartOfAccountID VarChar(100),
	@PostingPeriod VarChar(100),
	@StartDate DateTime , 
	@EndDate DateTime 
AS
	 Declare @OpenningBalance Numeric(18,2)

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));
	 set @OpenningBalance=isnull((select sum(amount) from vfin_JournalEntries 
					where ChartOfAccountId =@ChartOfAccountID 
					and CreatedDate<@StartDate),0);


	WITH GLTransactionSummaries_CTE (Serial,AccountCode, AccountName, Debit,Credit,Amount,CreatedDate,PrimaryDescription,SecondaryDescription,ContrAccountCode,ContraAccountName)
	AS
	-- Define the first CTE query.
	(

		SELECT  ROW_NUMBER() OVER(ORDER BY CONVERT(varchar(10),dbo.vfin_JournalEntries.CreatedDate, 103)),dbo.vfin_ChartOfAccounts.AccountCode, dbo.vfin_ChartOfAccounts.AccountName, 
		CASE
		WHEN SUM(dbo.vfin_JournalEntries.Amount)<0 THEN SUM(dbo.vfin_JournalEntries.Amount)*-1
		ELSE 0 END AS DEBIT,
		CASE
		WHEN SUM(dbo.vfin_JournalEntries.Amount)>=0 THEN SUM(dbo.vfin_JournalEntries.Amount)
		ELSE 0 END AS CREDIT,
		SUM(dbo.vfin_JournalEntries.Amount) AS Amount, CONVERT(varchar(10), 
								 dbo.vfin_JournalEntries.CreatedDate, 103) AS CreatedDate, dbo.vfin_Journals.PrimaryDescription, dbo.vfin_Journals.secondaryDescription, vfin_ChartOfAccounts_1.AccountCode AS ContrAccountCode, 
								 vfin_ChartOfAccounts_1.AccountName AS ContraAccountName
		FROM            dbo.vfin_JournalEntries INNER JOIN
								 dbo.vfin_Journals ON dbo.vfin_JournalEntries.JournalId = dbo.vfin_Journals.Id INNER JOIN
								 dbo.vfin_ChartOfAccounts ON dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_ChartOfAccounts.Id INNER JOIN
								 dbo.vfin_ChartOfAccounts AS vfin_ChartOfAccounts_1 ON dbo.vfin_JournalEntries.ContraChartOfAccountId = vfin_ChartOfAccounts_1.Id
		WHERE dbo.vfin_JournalEntries.ChartOfAccountId=@ChartOfAccountID and vfin_Journals.PostingPeriodId=@PostingPeriod
		AND vfin_JournalEntries.CreatedDate BETWEEN @StartDate AND @EndDate
		GROUP BY dbo.vfin_ChartOfAccounts.AccountCode, dbo.vfin_ChartOfAccounts.AccountName, CONVERT(varchar(10), dbo.vfin_JournalEntries.CreatedDate, 103), 
								 dbo.vfin_Journals.PrimaryDescription,dbo.vfin_Journals.SecondaryDescription, vfin_ChartOfAccounts_1.AccountCode, vfin_ChartOfAccounts_1.AccountName

	)

	SELECT Serial,AccountCode, AccountName, Debit,Credit,Amount,CreatedDate,PrimaryDescription,SecondaryDescription,ContrAccountCode,ContraAccountName INTO #TempGLTrans FROM GLTransactionSummaries_CTE
	insert into #TempGLTrans(Serial,AccountCode, AccountName, Debit,Credit,Amount,CreatedDate,PrimaryDescription,ContrAccountCode,ContraAccountName)
	select 0,AccountCode, AccountName, 0,0,@OpenningBalance,@StartDate,'Balance B/F',AccountCode,AccountName  from #TempGLTrans where Serial=1

	SELECT Serial,AccountCode, AccountName,ContrAccountCode,ContraAccountName,CreatedDate,PrimaryDescription,SecondaryDescription, Debit,Credit,SUM(Amount) OVER(ORDER BY Serial 
							ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal
	FROM #TempGLTrans 						 
	
END