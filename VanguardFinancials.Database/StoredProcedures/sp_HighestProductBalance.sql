-- =============================================
-- Author:		Centrino
-- Create date: 12/09/2014
-- Description:	Top X Highest Product Balance
-- =============================================
---sp_HighestProductBalance '2E2796E9-815D-C231-9829-08D133546EBA', '12/09/2014',10

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_HighestProductBalance') BEGIN
   EXEC('CREATE PROC [dbo].[sp_HighestProductBalance] as')
END
go
ALTER PROCEDURE [dbo].[sp_HighestProductBalance] 
	-- Add the parameters for the stored procedure here
	@Product uniqueidentifier , 
	@EndDate datetime ,
	@TopX int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	---select * from vw_CustomerAccounts
WITH TopXBalance (Account, Name,PayrollNo ,ProductName,Balance,Station,type)
AS
-- Define the CTE query.
(
    SELECT        dbo.vw_CustomerAccounts.FullAccount, dbo.vw_CustomerAccounts.FullName, dbo.vw_CustomerAccounts.reference3, Products_1.Description, 
                         SUM(dbo.vfin_JournalEntries.Amount) AS Balance,dbo.vfin_Stations.Description, Products_1.type
	FROM            dbo.vw_CustomerAccounts INNER JOIN
                         dbo.vfin_JournalEntries ON dbo.vw_CustomerAccounts.Id = dbo.vfin_JournalEntries.CustomerAccountId INNER JOIN
                         dbo.Products(0) AS Products_1 ON dbo.vw_CustomerAccounts.CustomerAccountType_TargetProductId = Products_1.id AND 
                         dbo.vfin_JournalEntries.ChartOfAccountId = Products_1.ChartOfAccountId LEFT OUTER JOIN
                         dbo.vfin_Stations ON dbo.vw_CustomerAccounts.StationId = dbo.vfin_Stations.Id
	where Products_1.id=@Product and dbo.vfin_JournalEntries.CreatedDate<=@EndDate
	GROUP BY dbo.vw_CustomerAccounts.FullAccount, dbo.vw_CustomerAccounts.FullName, Products_1.Description, dbo.vw_CustomerAccounts.Reference3,dbo.vfin_Stations.Description,Products_1.type
)
select top (@TopX) Account,Name,PayrollNo,ProductName,Station,
case type
when 'Loans' then Balance*-1
else
Balance
end as Balance from  TopXBalance order by case type
when 'Loans' then Balance*-1
else
Balance
end  desc
END
