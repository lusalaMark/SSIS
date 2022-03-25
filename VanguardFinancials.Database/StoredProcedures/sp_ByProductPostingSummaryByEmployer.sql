IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_ByProductPostingSummaryByEmployer') BEGIN
   EXEC('CREATE PROC [dbo].[sp_ByProductPostingSummaryByEmployer] as')
END
GO

alter PROCEDURE [dbo].[sp_ByProductPostingSummaryByEmployer] 
	-- Add the parameters for the stored procedure here
	@StartDate DateTime , 
	@EndDate DateTime,
	@EmployerID varchar(50) 
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
                         dbo.vfin_Journals ON dbo.vfin_JournalEntries.JournalId = dbo.vfin_Journals.Id INNER JOIN
                         dbo.vfin_CustomerAccounts ON dbo.vfin_JournalEntries.CustomerAccountId = dbo.vfin_CustomerAccounts.Id INNER JOIN
                         dbo.vfin_Customers ON dbo.vfin_CustomerAccounts.CustomerId = dbo.vfin_Customers.Id INNER JOIN
                         dbo.vfin_Stations ON dbo.vfin_Customers.StationId = dbo.vfin_Stations.Id INNER JOIN
                         dbo.vfin_Zones ON dbo.vfin_Stations.ZoneId = dbo.vfin_Zones.Id INNER JOIN
                         dbo.vfin_Divisions ON dbo.vfin_Zones.DivisionId = dbo.vfin_Divisions.Id INNER JOIN
                         dbo.vfin_Employers ON dbo.vfin_Divisions.EmployerId = dbo.vfin_Employers.Id
		WHERE        (Products_1.type NOT IN ('Savings')) AND (dbo.vfin_Journals.SecondaryDescription LIKE '%Check-off%') 
		AND  dbo.vfin_Journals.CreatedDate between 
		@StartDate and @EndDate and Amount >0 and dbo.vfin_Employers.Id=@EmployerID
		GROUP BY Products_1.Description, Products_1.type
	),
	CTEByProductInterestCheckoff (Description,PrincipalAmount,Interest)
	as
	(
		SELECT        Products_1.Description,  0,SUM(dbo.vfin_JournalEntries.Amount) AS Interest
		FROM             dbo.Products(0) AS Products_1 INNER JOIN
                         dbo.vfin_JournalEntries ON Products_1.InterestReceivable = dbo.vfin_JournalEntries.ChartOfAccountId INNER JOIN
                         dbo.vfin_Journals ON dbo.vfin_JournalEntries.JournalId = dbo.vfin_Journals.Id INNER JOIN
                         dbo.vfin_CustomerAccounts ON dbo.vfin_JournalEntries.CustomerAccountId = dbo.vfin_CustomerAccounts.Id INNER JOIN
                         dbo.vfin_Customers ON dbo.vfin_CustomerAccounts.CustomerId = dbo.vfin_Customers.Id INNER JOIN
                         dbo.vfin_Stations ON dbo.vfin_Customers.StationId = dbo.vfin_Stations.Id INNER JOIN
                         dbo.vfin_Zones ON dbo.vfin_Stations.ZoneId = dbo.vfin_Zones.Id INNER JOIN
                         dbo.vfin_Divisions ON dbo.vfin_Zones.DivisionId = dbo.vfin_Divisions.Id INNER JOIN
                         dbo.vfin_Employers ON dbo.vfin_Divisions.EmployerId = dbo.vfin_Employers.Id
		WHERE        (Products_1.type NOT IN ('Savings')) AND (dbo.vfin_Journals.SecondaryDescription LIKE '%Check-off%') 
		AND dbo.vfin_Journals.CreatedDate between 
		@StartDate and @EndDate and dbo.vfin_Employers.Id=@EmployerID
		GROUP BY Products_1.Description, Products_1.type
	),
	CTEByProductPrincipalPayout (Description,PrincipalAmount,Interest)
	as
	(
	SELECT        Products_1.Description, SUM(dbo.vfin_JournalEntries.Amount) AS PrincipalAmount, 0 AS Expr1
FROM            dbo.Products(0) AS Products_1 INNER JOIN
                         dbo.vfin_JournalEntries ON Products_1.ChartOfAccountId = dbo.vfin_JournalEntries.ChartOfAccountId INNER JOIN
                         dbo.vfin_Journals ON dbo.vfin_JournalEntries.JournalId = dbo.vfin_Journals.Id INNER JOIN
                         dbo.vfin_CustomerAccounts ON dbo.vfin_JournalEntries.CustomerAccountId = dbo.vfin_CustomerAccounts.Id INNER JOIN
                         dbo.vfin_Customers ON dbo.vfin_CustomerAccounts.CustomerId = dbo.vfin_Customers.Id INNER JOIN
                         dbo.vfin_Stations ON dbo.vfin_Customers.StationId = dbo.vfin_Stations.Id INNER JOIN
                         dbo.vfin_Zones ON dbo.vfin_Stations.ZoneId = dbo.vfin_Zones.Id INNER JOIN
                         dbo.vfin_Divisions ON dbo.vfin_Zones.DivisionId = dbo.vfin_Divisions.Id INNER JOIN
                         dbo.vfin_Employers ON dbo.vfin_Divisions.EmployerId = dbo.vfin_Employers.Id
WHERE        (Products_1.type NOT IN ('Savings')) AND (dbo.vfin_Journals.SecondaryDescription LIKE '%Payout%') AND (dbo.vfin_Journals.CreatedDate BETWEEN 
                         @StartDate AND @EndDate) AND (dbo.vfin_JournalEntries.Amount > 0) and dbo.vfin_Employers.Id=@EmployerID
GROUP BY Products_1.Description, Products_1.type
	),
	CTEByProductInterestpayout (Description,PrincipalAmount,Interest)
	as
	(
		SELECT        Products_1.Description,  0,SUM(dbo.vfin_JournalEntries.Amount) AS Interest
		FROM             dbo.Products(0) AS Products_1 INNER JOIN
                         dbo.vfin_JournalEntries ON Products_1.InterestReceivable = dbo.vfin_JournalEntries.ChartOfAccountId INNER JOIN
                         dbo.vfin_Journals ON dbo.vfin_JournalEntries.JournalId = dbo.vfin_Journals.Id INNER JOIN
                         dbo.vfin_CustomerAccounts ON dbo.vfin_JournalEntries.CustomerAccountId = dbo.vfin_CustomerAccounts.Id INNER JOIN
                         dbo.vfin_Customers ON dbo.vfin_CustomerAccounts.CustomerId = dbo.vfin_Customers.Id INNER JOIN
                         dbo.vfin_Stations ON dbo.vfin_Customers.StationId = dbo.vfin_Stations.Id INNER JOIN
                         dbo.vfin_Zones ON dbo.vfin_Stations.ZoneId = dbo.vfin_Zones.Id INNER JOIN
                         dbo.vfin_Divisions ON dbo.vfin_Zones.DivisionId = dbo.vfin_Divisions.Id INNER JOIN
                         dbo.vfin_Employers ON dbo.vfin_Divisions.EmployerId = dbo.vfin_Employers.Id
		WHERE        (Products_1.type  not IN ('Savings'))  AND (dbo.vfin_Journals.SecondaryDescription LIKE '%Payout%') 
		AND dbo.vfin_Journals.CreatedDate between 
		@StartDate and @EndDate and dbo.vfin_Employers.Id=@EmployerID
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
