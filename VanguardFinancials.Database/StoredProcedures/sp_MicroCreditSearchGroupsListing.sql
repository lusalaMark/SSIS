IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_MicroCreditSearchGroupsListing') BEGIN
   EXEC('CREATE PROC [dbo].[sp_MicroCreditSearchGroupsListing] as')
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Jeff>
-- Create date: <28/09/2014>
-- Description:	<Listing Micro-Credit Groups>
-- =============================================
---sp_MicroCreditSearchGroupsListing 'Group'
alter PROCEDURE sp_MicroCreditSearchGroupsListing (@SearchStrg varchar(50))
AS
BEGIN
	SET NOCOUNT ON;
		set @SearchStrg=upper(@SearchStrg)
	SELECT       SerialNumber = REPLACE(STR(dbo.vfin_Customers.SerialNumber, 6), SPACE(1), '0')  , dbo.vfin_Customers.NonIndividual_Description as GroupName, 
	dbo.vfin_MicroCreditGroups.Id
	FROM            dbo.vfin_MicroCreditGroups INNER JOIN
							 dbo.vfin_Customers ON dbo.vfin_MicroCreditGroups.CustomerId = dbo.vfin_Customers.Id 							 
	 WHERE (upper(dbo.vfin_Customers.NonIndividual_Description) like '%'+@SearchStrg+'%')
	  order by REPLACE(STR(dbo.vfin_Customers.SerialNumber, 6), SPACE(1), '0')
END

GO
