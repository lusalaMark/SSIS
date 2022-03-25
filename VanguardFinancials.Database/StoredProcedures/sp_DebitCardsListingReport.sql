IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_DebitCardsListingReport') BEGIN
   EXEC('CREATE PROC [dbo].[sp_DebitCardsListingReport] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_DebitCardsListingReport]    Script Date: 9/13/2014 4:13:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--[sp_DebitCardsListingReport] 1 '01/01/2013','04/03/2014'
ALTER PROCEDURE [dbo].[sp_DebitCardsListingReport]
	-- Add the parameters for the stored procedure here
@Type int 
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT        RIGHT('00' + CAST(LTRIM(RTRIM(dbo.vfin_Branches.Code)) AS VARCHAR(6)), 6) + '-' + RIGHT('000000' + CAST(LTRIM(RTRIM(dbo.vfin_Customers.SerialNumber))
                          AS VARCHAR(6)), 6) + '-' + RIGHT('00' + CAST(LTRIM(RTRIM(dbo.vfin_CustomerAccounts.CustomerAccountType_ProductCode)) AS VARCHAR(5)), 5) 
                         + '-' + RIGHT('00' + CAST(LTRIM(RTRIM(dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductCode)) AS VARCHAR(5)), 5) AS FullAccount, 
                         CASE [Individual_Salutation] WHEN '48814' THEN 'Mr' WHEN '48815' THEN 'Mrs' WHEN '48816' THEN 'Miss' WHEN '48817' THEN 'Dr' WHEN '48818' THEN 'Prof' WHEN '48819'
                          THEN 'Rev' WHEN '48820' THEN 'Eng' WHEN '48821' THEN 'Hon' WHEN '48822' THEN 'Cllr' WHEN '48823' THEN 'Sir' WHEN '48824' THEN 'Ms' ELSE 'UnKnown' END
                          + ' ' + dbo.vfin_Customers.Individual_FirstName + ' ' + dbo.vfin_Customers.Individual_LastName AS FullName, dbo.vfin_DebitCards.Type,dbo.Character_Mask(CardNumber,5,'X') as CardNumber, 
                         dbo.vfin_DebitCards.ValidFrom, dbo.vfin_DebitCards.Expires, dbo.vfin_DebitCards.DailyLimit, 
                         dbo.vfin_DebitCards.Remarks, dbo.vfin_DebitCards.IsLocked, dbo.vfin_DebitCards.CreatedBy, dbo.vfin_DebitCards.CreatedDate, 
                         dbo.vfin_Branches.Description AS Branch, dbo.vfin_Customers.Individual_IdentityCardNumber, dbo.vfin_Customers.Individual_PayrollNumbers
FROM            dbo.vfin_DebitCards INNER JOIN
                         dbo.vfin_CustomerAccounts ON dbo.vfin_DebitCards.CustomerAccountId = dbo.vfin_CustomerAccounts.Id INNER JOIN
                         dbo.vfin_Customers ON dbo.vfin_CustomerAccounts.CustomerId = dbo.vfin_Customers.Id INNER JOIN
                         dbo.vfin_Branches ON dbo.vfin_CustomerAccounts.BranchId = dbo.vfin_Branches.Id
WHERE dbo.vfin_DebitCards.Type=@Type
END





