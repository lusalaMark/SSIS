IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='vw_UsersandRoles') BEGIN
   EXEC('CREATE view [dbo].[vw_UsersandRoles] as  select top 1 * from vfin_customers')
END
GO


/****** Object:  View [dbo].[vw_UsersandRoles]    Script Date: 9/14/2014 6:51:57 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [dbo].[vw_UsersandRoles]
AS
SELECT        dbo.vw_aspnet_Users.UserName, dbo.vw_aspnet_Roles.RoleName
FROM            dbo.vw_aspnet_UsersInRoles INNER JOIN
                         dbo.vw_aspnet_Roles ON dbo.vw_aspnet_UsersInRoles.RoleId = dbo.vw_aspnet_Roles.RoleId INNER JOIN
                         dbo.vw_aspnet_Users ON dbo.vw_aspnet_UsersInRoles.UserId = dbo.vw_aspnet_Users.UserId




GO


