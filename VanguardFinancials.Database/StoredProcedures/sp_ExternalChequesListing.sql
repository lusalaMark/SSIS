IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_ExternalChequesListing') BEGIN
   EXEC('CREATE PROC [dbo].[sp_ExternalChequesListing] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_ExternalChequesListing]    Script Date: 9/13/2014 6:21:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
---sp_ExternalChequesBankedListing '01/01/2014','04/04/2014'
---[sp_ExternalChequesListing] '01/01/2014','04/30/2014','BankDate'
ALTER PROCEDURE [dbo].[sp_ExternalChequesListing]
	@StartDate Datetime,
	@EndDate Datetime,
	@DisplayField varchar(50)
AS
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 SELECT        
						 RIGHT('00' + CAST(LTRIM(RTRIM(dbo.vfin_Branches.Code)) AS VARCHAR(3)), 3) + '-' + RIGHT('000000' + CAST(LTRIM(RTRIM(dbo.vfin_Customers.SerialNumber))
                          AS VARCHAR(6)), 6) + '-' + RIGHT('00' + CAST(LTRIM(RTRIM(dbo.vfin_CustomerAccounts.CustomerAccountType_ProductCode)) AS VARCHAR(5)), 5) 
                         + '-' + RIGHT('00' + CAST(LTRIM(RTRIM(dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductCode)) AS VARCHAR(5)), 5) AS FullAccount, 
						CASE dbo.vfin_Customers.Individual_Salutation WHEN '48814' THEN 'Mr' WHEN '48815' THEN 'Mrs' WHEN '48816' THEN 'Miss' WHEN '48817' THEN 'Dr' WHEN '48818' THEN
                          'Prof' WHEN '48819' THEN 'Rev' WHEN '48820' THEN 'Eng' WHEN '48821' THEN 'Hon' WHEN '48822' THEN 'Cllr' WHEN '48823' THEN 'Sir' WHEN '48824' THEN 'Ms'
                          ELSE 'UnKnown' END + ' ' + dbo.vfin_Customers.Individual_FirstName + ' ' + dbo.vfin_Customers.Individual_LastName AS FullName, dbo.vfin_Tellers.Description AS ReceivedBy, 
                         dbo.vfin_ExternalCheques.Number, dbo.vfin_ExternalCheques.Amount, dbo.vfin_ExternalCheques.Drawer, dbo.vfin_ExternalCheques.DrawerBank, 
                         dbo.vfin_ExternalCheques.DrawerBankBranch, dbo.vfin_ExternalCheques.WriteDate, dbo.vfin_ChequeTypes.Description as ChequeType, 
                         dbo.vfin_ExternalCheques.IsCleared, dbo.vfin_ExternalCheques.ClearedBy, dbo.vfin_ExternalCheques.MaturityDate, 
                         dbo.vfin_ExternalCheques.IsBanked, dbo.vfin_ExternalCheques.BankedBy, dbo.vfin_ExternalCheques.ClearedDate, dbo.vfin_ExternalCheques.IsTransferred, 
                         dbo.vfin_ExternalCheques.TransferredBy, dbo.vfin_ExternalCheques.TransferredDate , dbo.vfin_ExternalCheques.CreatedBy, 
                         dbo.vfin_ExternalCheques.CreatedDate ,dbo.vfin_ExternalCheques.BankedDate 

FROM            dbo.vfin_ExternalCheques INNER JOIN
                         dbo.vfin_CustomerAccounts ON dbo.vfin_ExternalCheques.CustomerAccountId = dbo.vfin_CustomerAccounts.Id INNER JOIN
                         dbo.vfin_Customers ON dbo.vfin_CustomerAccounts.CustomerId = dbo.vfin_Customers.Id INNER JOIN
                         dbo.vfin_Tellers ON dbo.vfin_ExternalCheques.TellerId = dbo.vfin_Tellers.Id INNER JOIN
                         dbo.vfin_Branches ON dbo.vfin_CustomerAccounts.BranchId = dbo.vfin_Branches.Id INNER JOIN 
						 dbo.vfin_ChequeTypes On dbo.vfin_ChequeTypes.id = dbo.vfin_ExternalCheques.ChequeTypeId

Where 
CASE 
	WHEN @DisplayField='BankedDate' then dbo.vfin_ExternalCheques.BankedDate
	WHEN @DisplayField='TransferredDate' then dbo.vfin_ExternalCheques.TransferredDate
	WHEN @DisplayField='CreatedDate' then dbo.vfin_ExternalCheques.CreatedDate
	WHEN @DisplayField='ClearedDate' then dbo.vfin_ExternalCheques.ClearedDate
	WHEN @DisplayField='MaturityDate' then dbo.vfin_ExternalCheques.MaturityDate

end
between @StartDate and @EndDate


END




