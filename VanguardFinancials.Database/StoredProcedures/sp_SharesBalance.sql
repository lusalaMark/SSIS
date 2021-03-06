
/****** Object:  StoredProcedure [dbo].[sp_SharesBalance]    Script Date: 15-Jun-15 3:15:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author, Joan Centrino>
-- Create date: <Create Date, '15/06/2014>
-- Description:	<Description, Shares Balances As At: >
-- =============================================
--sp_SharesBalance 'a382db4c-b6cb-c765-70cc-08d20dabfb88', '05/30/2015'
ALTER PROCEDURE [dbo].[sp_SharesBalance]
	-- Add the parameters for the stored procedure here
	@Id varchar (50),
	@EndDate Date
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT        SUM(dbo.vfin_Journals.TotalValue) AS Amount, dbo.vfin_Customers.Individual_FirstName + '' + dbo.vfin_Customers.Individual_LastName AS FullName, dbo.vfin_Customers.Individual_PayrollNumbers, 
                         dbo.vfin_Customers.Reference1, dbo.vfin_Customers.Reference2, dbo.vfin_Customers.Reference3, dbo.vfin_ChartOfAccounts.AccountCode, dbo.vfin_InvestmentProducts.Id
	FROM            dbo.vfin_JournalEntries INNER JOIN
                         dbo.vfin_Journals ON dbo.vfin_JournalEntries.JournalId = dbo.vfin_Journals.Id INNER JOIN
                         dbo.vfin_ChartOfAccounts ON dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_ChartOfAccounts.Id INNER JOIN
                         dbo.vfin_CustomerAccounts ON dbo.vfin_JournalEntries.CustomerAccountId = dbo.vfin_CustomerAccounts.Id INNER JOIN
                         dbo.vfin_Customers ON dbo.vfin_CustomerAccounts.CustomerId = dbo.vfin_Customers.Id INNER JOIN
                         dbo.vfin_InvestmentProducts ON dbo.vfin_ChartOfAccounts.Id = dbo.vfin_InvestmentProducts.ChartOfAccountId
	WHERE  (dbo.vfin_InvestmentProducts.Id = @Id) and dbo.vfin_JournalEntries.CreatedDate<= @EndDate 
	GROUP BY dbo.vfin_Customers.Individual_FirstName, dbo.vfin_Customers.Individual_LastName, dbo.vfin_Customers.Individual_PayrollNumbers, dbo.vfin_Customers.Reference1, dbo.vfin_Customers.Reference2, 
                         dbo.vfin_Customers.Reference3, dbo.vfin_ChartOfAccounts.AccountCode, dbo.vfin_InvestmentProducts.Id
	order by  dbo.vfin_Customers.Reference2 
END
