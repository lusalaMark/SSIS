IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_CustomerTransactionAuthRequest') BEGIN
   EXEC('CREATE PROC [dbo].[sp_CustomerTransactionAuthRequest] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CustomerTransactionAuthRequest]    Script Date: 9/13/2014 3:59:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--sp_CustomerTransactionAuthRequestsAuthorizedByDate '01/01/2014' ,'04/30/2014'

--[sp_CustomerTransactionAuthRequest] 'Authorized Date','01/13/2014','04/30/2014'
ALTER PROCEDURE [dbo].[sp_CustomerTransactionAuthRequest]
@DisplayField varchar(50),
@FilterDate1 Datetime,
@FilterDate2 Datetime

AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
  SELECT        REPLACE(STR(dbo.vfin_Branches.Code, 3), SPACE(1), '0') + '-' + REPLACE(STR(dbo.vfin_Customers.SerialNumber, 6), SPACE(1), '0') 
                         + '-' + REPLACE(STR(dbo.vfin_CustomerAccounts.CustomerAccountType_ProductCode, 3), SPACE(1), '0') 
                         + '-' + REPLACE(STR(dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductCode, 3), SPACE(1), '0') AS FullAccount, 
                         CASE Individual_Salutation WHEN '48814' THEN 'Mr' WHEN '48815' THEN 'Mrs' WHEN '48816' THEN 'Miss' WHEN '48817' THEN 'Dr' WHEN '48818' THEN 'Prof' WHEN '48819'
                          THEN 'Rev' WHEN '48820' THEN 'Eng' WHEN '48821' THEN 'Hon' WHEN '48822' THEN 'Cllr' WHEN '48823' THEN 'Sir' WHEN '48824' THEN 'Ms' ELSE 'UnKnown' END
                          + ' ' + dbo.vfin_Customers.Individual_FirstName + ' ' + dbo.vfin_Customers.Individual_LastName AS FullName, 
                         CASE dbo.vfin_CustomerTransactionAuthRequests.Type WHEN 1 THEN 'Withdrawal Within Limits' WHEN 2 THEN 'Withdrawal Above Maximum Allowed' WHEN 4 THEN 'Withdrawal Below Minimum Balance' ELSE
                          'UnKnown' END AS Type, 
                         CASE [Status] WHEN 1 THEN 'Pending' WHEN 2 THEN 'Authorized' WHEN 4 THEN 'Rejected' WHEN 8 THEN 'Paid' ELSE 'UnKnown' END AS Status, 
                         dbo.vfin_CustomerTransactionAuthRequests.Amount, dbo.vfin_CustomerTransactionAuthRequests.AuthorizedBy, 
                         dbo.vfin_CustomerTransactionAuthRequests.AuthorizationRemarks, dbo.vfin_CustomerTransactionAuthRequests.AuthorizedDate, 
                         dbo.vfin_CustomerTransactionAuthRequests.PaidBy, dbo.vfin_CustomerTransactionAuthRequests.PaidDate, dbo.vfin_CustomerTransactionAuthRequests.CreatedBy, 
                         dbo.vfin_CustomerTransactionAuthRequests.CreatedDate
FROM            dbo.vfin_CustomerTransactionAuthRequests INNER JOIN
                         dbo.vfin_CustomerAccounts ON dbo.vfin_CustomerTransactionAuthRequests.CustomerAccountId = dbo.vfin_CustomerAccounts.Id INNER JOIN
                         dbo.vfin_Customers ON dbo.vfin_CustomerAccounts.CustomerId = dbo.vfin_Customers.Id INNER JOIN
                         dbo.vfin_Branches ON dbo.vfin_CustomerAccounts.BranchId = dbo.vfin_Branches.Id

Where 
CASE 
	WHEN @DisplayField='AuthorizedDate' then dbo.vfin_CustomerTransactionAuthRequests.AuthorizedDate
	WHEN @DisplayField='PaidDate' then dbo.vfin_CustomerTransactionAuthRequests.PaidDate
	WHEN @DisplayField='CreatedDate' then dbo.vfin_CustomerTransactionAuthRequests.CreatedDate
end
between @FilterDate1 and @FilterDate2
END


---SELECT * FROM vfin_CustomerTransactionAuthRequests




