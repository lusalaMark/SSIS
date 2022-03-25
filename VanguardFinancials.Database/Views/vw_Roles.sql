IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='vw_Roles') BEGIN
   EXEC('CREATE view [dbo].[vw_Roles] as  select top 1 * from vfin_customers')
END
GO

/****** Object:  View [dbo].[vw_Roles]    Script Date: 9/14/2014 6:47:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [dbo].[vw_Roles]
AS
SELECT        dbo.vfin_ModuleNavigationItemsInRoles.RoleName, dbo.vfin_ModuleNavigationItems.ModuleDescription, dbo.vfin_ModuleNavigationItems.ParentItemDescription, 
                         dbo.vfin_ModuleNavigationItems.ItemDescription, dbo.vw_aspnet_Roles.LoweredRoleName
FROM            dbo.vfin_ModuleNavigationItemsInRoles INNER JOIN
                         dbo.vfin_ModuleNavigationItems ON dbo.vfin_ModuleNavigationItemsInRoles.ModuleNavigationItemId = dbo.vfin_ModuleNavigationItems.Id INNER JOIN
                         dbo.vw_aspnet_Roles ON dbo.vfin_ModuleNavigationItemsInRoles.RoleName = dbo.vw_aspnet_Roles.RoleName




GO


