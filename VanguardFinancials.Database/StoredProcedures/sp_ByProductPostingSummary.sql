IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_ByProductPostingSummary') BEGIN
   EXEC('CREATE PROC [dbo].[sp_ByProductPostingSummary] as')
END
GO
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
-- Create date: 21.01.2015
-- Description:	ByProductPostingSummary
-- =============================================
alter PROCEDURE sp_ByProductPostingSummary 
	-- Add the parameters for the stored procedure here
	@StartDate DateTime , 
	@EndDate DateTime 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Create table #ByProduct (Description Char(50), PrincipalAmount Numeric(18,2), Interest Numeric(18,2),Category char(10));

	With CTEByProductPrincipalCheckoff (Description,PrincipalAmount,Interest)
	as
	(
		SELECT        Products_1.Description,  SUM(dbo.vfin_JournalEntries.Amount) AS PrincipalAmount,0
		FROM            dbo.Products(0) AS Products_1 INNER JOIN
								 dbo.vfin_JournalEntries ON Products_1.ChartOfAccountId = dbo.vfin_JournalEntries.ChartOfAccountId INNER JOIN
								 dbo.vfin_Journals ON dbo.vfin_JournalEntries.JournalId = dbo.vfin_Journals.Id
		WHERE        (Products_1.type NOT IN ('Savings')) AND (dbo.vfin_Journals.SecondaryDescription LIKE '%Check-off%') 
		AND  dbo.vfin_Journals.CreatedDate between 
		@StartDate and @EndDate and Amount >0
		GROUP BY Products_1.Description, Products_1.type
	),
	CTEByProductInterestCheckoff (Description,PrincipalAmount,Interest)
	as
	(
		SELECT        Products_1.Description,  0,SUM(dbo.vfin_JournalEntries.Amount) AS Interest
		FROM            dbo.Products(0) AS Products_1 INNER JOIN
								 dbo.vfin_JournalEntries ON Products_1.InterestReceivable = dbo.vfin_JournalEntries.ChartOfAccountId INNER JOIN
								 dbo.vfin_Journals ON dbo.vfin_JournalEntries.JournalId = dbo.vfin_Journals.Id
		WHERE        (Products_1.type NOT IN ('Savings')) AND (dbo.vfin_Journals.SecondaryDescription LIKE '%Check-off%') 
		AND dbo.vfin_Journals.CreatedDate between 
		@StartDate and @EndDate 
		GROUP BY Products_1.Description, Products_1.type
	),
	CTEByProductPrincipalPayout (Description,PrincipalAmount,Interest)
	as
	(
		SELECT        Products_1.Description,  SUM(dbo.vfin_JournalEntries.Amount) AS PrincipalAmount,0
		FROM            dbo.Products(0) AS Products_1 INNER JOIN
								 dbo.vfin_JournalEntries ON Products_1.ChartOfAccountId = dbo.vfin_JournalEntries.ChartOfAccountId INNER JOIN
								 dbo.vfin_Journals ON dbo.vfin_JournalEntries.JournalId = dbo.vfin_Journals.Id
		WHERE        (Products_1.type NOT IN ('Savings')) AND (dbo.vfin_Journals.SecondaryDescription LIKE '%Payout%') 
		AND  dbo.vfin_Journals.CreatedDate between 
		@StartDate and @EndDate and Amount>0
		GROUP BY Products_1.Description, Products_1.type
	),
	CTEByProductInterestpayout (Description,PrincipalAmount,Interest)
	as
	(
		SELECT        Products_1.Description,  0,SUM(dbo.vfin_JournalEntries.Amount) AS Interest
		FROM            dbo.Products(0) AS Products_1 INNER JOIN
								 dbo.vfin_JournalEntries ON Products_1.InterestReceivable = dbo.vfin_JournalEntries.ChartOfAccountId INNER JOIN
								 dbo.vfin_Journals ON dbo.vfin_JournalEntries.JournalId = dbo.vfin_Journals.Id
		WHERE        (Products_1.type  not IN ('Savings'))  AND (dbo.vfin_Journals.SecondaryDescription LIKE '%Payout%') 
		AND dbo.vfin_Journals.CreatedDate between 
		@StartDate and @EndDate
		GROUP BY Products_1.Description, Products_1.type
	)

	insert #ByProduct (Description,PrincipalAmount,Interest,Category) 
	select Description,PrincipalAmount,Interest,'Checkoff'  from CTEByProductInterestCheckoff
	union
	select Description,PrincipalAmount,Interest,'Checkoff'  from CTEByProductPrincipalCheckoff
	union
	select Description,PrincipalAmount,Interest,'Payout'  from CTEByProductPrincipalPayout
	union
	select Description,PrincipalAmount,Interest,'Payout'  from CTEByProductInterestPayout

	select Description, sum(PrincipalAmount) as PrincipalAmount, sum(Interest) as Interest,Category 
	from  #ByProduct group by Description,Category


END
GO
