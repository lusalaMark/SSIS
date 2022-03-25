IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_RoleApplication') BEGIN
   EXEC('CREATE PROC [dbo].[sp_RoleApplication] as')
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 13.06.2014
-- Description:	RoleApplication
-- =============================================
ALTER PROCEDURE [dbo].[sp_RoleApplication] 
AS
BEGIN
	SET NOCOUNT ON;
	SELECT        dbo.aspnet_Roles.RoleName, dbo.vfin_ModuleNavigationItems.ModuleDescription, dbo.vfin_ModuleNavigationItems.ParentItemDescription, 
							 dbo.vfin_ModuleNavigationItems.ItemDescription
	FROM            dbo.aspnet_Roles INNER JOIN
							 dbo.vfin_ModuleNavigationItemsInRoles INNER JOIN
							 dbo.vfin_ModuleNavigationItems ON dbo.vfin_ModuleNavigationItemsInRoles.ModuleNavigationItemId = dbo.vfin_ModuleNavigationItems.Id ON 
							 dbo.aspnet_Roles.RoleName = dbo.vfin_ModuleNavigationItemsInRoles.RoleName
	ORDER BY dbo.aspnet_Roles.RoleName,dbo.vfin_ModuleNavigationItems.ModuleDescription,dbo.vfin_ModuleNavigationItems.ParentItemDescription,dbo.vfin_ModuleNavigationItems.ItemDescription
END

GO
