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
-- =============================================
---select * from vfin_ChartOfAccounts where id='36206afb-23d0-cbc4-72d9-08d10cad4b96'
---sp_AtmTransactions 1,'01/01/2014', '12/31/2014'
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_ExternalChequesUnclearedORUnbanked') BEGIN
   EXEC('CREATE PROC [dbo].[sp_ExternalChequesUnclearedORUnbanked] as')
END
GO

alter PROCEDURE [dbo].[sp_ExternalChequesUnclearedORUnbanked]
	@DisplayField varchar(50)
AS
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
                          ELSE '' END + ' ' + isnull(dbo.vfin_Customers.Individual_FirstName,'') + ' ' + isnull(dbo.vfin_Customers.Individual_LastName,'') + ltrim(rtrim(isnull(dbo.vfin_Customers.NonIndividual_Description,''))) AS FullName, dbo.vfin_Tellers.Description AS ReceivedBy, 
                         dbo.vfin_ExternalCheques.Number,dbo.vfin_Customers.Reference1, dbo.vfin_ExternalCheques.Amount, dbo.vfin_ExternalCheques.Drawer, dbo.vfin_ExternalCheques.DrawerBank, 
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
	WHEN @DisplayField='ClearedDate' then dbo.vfin_ExternalCheques.ClearedDate
end
is null
order by RIGHT('00' + CAST(LTRIM(RTRIM(dbo.vfin_Branches.Code)) AS VARCHAR(3)), 3) + '-' + RIGHT('000000' + CAST(LTRIM(RTRIM(dbo.vfin_Customers.SerialNumber))
                          AS VARCHAR(6)), 6) + '-' + RIGHT('00' + CAST(LTRIM(RTRIM(dbo.vfin_CustomerAccounts.CustomerAccountType_ProductCode)) AS VARCHAR(5)), 5) 
                         + '-' + RIGHT('00' + CAST(LTRIM(RTRIM(dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductCode)) AS VARCHAR(5)), 5) 
END




