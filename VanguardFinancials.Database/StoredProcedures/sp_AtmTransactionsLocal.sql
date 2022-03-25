GO
/****** Object:  StoredProcedure [dbo].[sp_AtmTransactions]    Script Date: 9/13/2014 3:04:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--	 =============================================
---select * from vfin_ChartOfAccounts where id='36206afb-23d0-cbc4-72d9-08d10cad4b96'
---sp_AtmTransactions 1,'01/01/2014', '12/31/2014'
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_AtmTransactionsLocal') BEGIN
   EXEC('CREATE PROC [dbo].[sp_AtmTransactionsLocal] as')
END
GO
-- ================================================

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
-- Author:		Centrino
-- Create date: 08/10/2014
-- Description:	AtmTransactions
-- =============================================
-- sp_AtmTransactions '10/08/2014','10/08/2014'
alter PROCEDURE [dbo].[sp_AtmTransactionsLocal] 
	-- Add the parameters for the stored procedure here
	@StartDate datetime , 
	@EndDate datetime,
	@ChartofAccountID varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));
    -- Insert statements for procedure here
	SELECT        TOP (100) PERCENT dbo.vfin_Journals.CreatedDate,dbo.vfin_Journals.PrimaryDescription, dbo.vfin_Journals.SecondaryDescription, dbo.vfin_Journals.Reference, 
                         dbo.vw_CustomerAccounts.FullAccount, dbo.vw_CustomerAccounts.FullName, dbo.vw_CustomerAccounts.Reference1, dbo.vw_CustomerAccounts.Reference3, dbo.vfin_Branches.Description AS Branch, 
                         dbo.vfin_Journals.TotalValue,CASE WHEN dbo.vfin_JournalEntries.Amount<0 THEN dbo.vfin_JournalEntries.Amount *-1 ELSE 0 END AS DEBIT,
						 CASE WHEN dbo.vfin_JournalEntries.Amount>0 THEN dbo.vfin_JournalEntries.Amount  ELSE 0 END AS CREDIT
	FROM            dbo.vfin_JournalEntries INNER JOIN
							 dbo.vfin_Journals ON dbo.vfin_JournalEntries.JournalId = dbo.vfin_Journals.Id INNER JOIN
							 dbo.vw_CustomerAccounts ON dbo.vfin_JournalEntries.CustomerAccountId = dbo.vw_CustomerAccounts.Id INNER JOIN
							 dbo.vfin_Branches ON dbo.vfin_Journals.BranchId = dbo.vfin_Branches.Id
	WHERE        (dbo.vfin_JournalEntries.ContraChartOfAccountId =@ChartofAccountID
                             )
	AND dbo.vfin_Journals.CreatedDate between @StartDate and @EndDate
							   
END
