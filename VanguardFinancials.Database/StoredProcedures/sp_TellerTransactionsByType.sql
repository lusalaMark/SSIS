-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--select * from  vfin_Branches
--sp_TellerTransactionsByType '05/13/2015','05/13/2015','80899738-73B9-C628-8A3A-08D1CE089CFC',1
alter PROCEDURE sp_TellerTransactionsByType
	-- Add the parameters for the stored procedure here
	@StartDate DateTime,
	@EndDate DateTime,
	@BranchID varchar (50),
	@TransactionCode Int 

AS
set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'))
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	

    -- Insert statements for procedure here
	SELECT        dbo.vfin_Customers.Individual_FirstName + '' + dbo.vfin_Customers.Individual_LastName as FullName, dbo.vfin_Customers.Reference1, dbo.vfin_Journals.PrimaryDescription, dbo.vfin_Journals.SecondaryDescription, 
                         dbo.vfin_Journals.TransactionCode, dbo.vfin_Journals.TotalValue, dbo.vfin_ChartOfAccounts.AccountType, dbo.vfin_ChartOfAccounts.AccountCategory, dbo.vfin_ChartOfAccounts.AccountCode, 
                         dbo.vfin_ChartOfAccounts.AccountName, dbo.vfin_JournalEntries.Amount, dbo.vfin_Journals.CreatedDate, dbo.vfin_Branches.Code, dbo.vfin_Branches.Description
FROM            dbo.vfin_JournalEntries INNER JOIN
                         dbo.vfin_Journals ON dbo.vfin_JournalEntries.JournalId = dbo.vfin_Journals.Id INNER JOIN
                         dbo.vfin_CustomerAccounts ON dbo.vfin_JournalEntries.CustomerAccountId = dbo.vfin_CustomerAccounts.Id INNER JOIN
                         dbo.vfin_Customers ON dbo.vfin_CustomerAccounts.CustomerId = dbo.vfin_Customers.Id INNER JOIN
                         dbo.vfin_ChartOfAccounts ON dbo.vfin_JournalEntries.ContraChartOfAccountId = dbo.vfin_ChartOfAccounts.Id INNER JOIN
                         dbo.vfin_Branches ON dbo.vfin_Journals.BranchId = dbo.vfin_Branches.Id
WHERE        (dbo.vfin_Journals.TransactionCode =@TransactionCode)  and vfin_JournalEntries.ContraChartOfAccountId in (select ChartOfAccountId from vfin_Tellers) 
			 and dbo.vfin_JournalEntries.CreatedDate 
			 between @StartDate and @EndDate and dbo.vfin_Branches.id=@BranchID  


END
GO
