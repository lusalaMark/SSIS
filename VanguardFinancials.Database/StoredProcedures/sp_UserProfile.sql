IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_UserProfile') BEGIN
   EXEC('CREATE PROC [dbo].[sp_UserProfile] as')
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 13.06.2014
-- Description:	UserProfiles
-- =============================================
---sp_UserProfile 'bkimanga'
ALTER PROCEDURE [dbo].[sp_UserProfile] 
	-- Add the parameters for the stored procedure here
	@UserName varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	SELECT        dbo.vw_EmployeeRegisterwithUserID.FullName, dbo.vw_EmployeeRegisterwithUserID.IdentityCardNumber, 
							 dbo.vw_EmployeeRegisterwithUserID.MembershipNumber, dbo.vw_EmployeeRegisterwithUserID.EmploymentType, 
							 dbo.vw_EmployeeRegisterwithUserID.PersonalFileNumber, dbo.vw_EmployeeRegisterwithUserID.Designation, dbo.vw_EmployeeRegisterwithUserID.Reference1, 
							 dbo.aspnet_Roles.RoleName, dbo.aspnet_Membership.IsApproved, dbo.aspnet_Membership.IsLockedOut, dbo.aspnet_Membership.CreateDate, 
							 dbo.aspnet_Membership.LastLoginDate, dbo.aspnet_Membership.LastPasswordChangedDate, dbo.aspnet_Membership.LastLockoutDate, 
							 dbo.aspnet_Membership.FailedPasswordAttemptCount, dbo.aspnet_Membership.Comment, dbo.aspnet_Users.UserName, 
							 dbo.vfin_ModuleNavigationItems.ModuleDescription, dbo.vfin_ModuleNavigationItems.ParentItemDescription, 
							 dbo.vfin_ModuleNavigationItems.ItemDescription
	FROM            dbo.vfin_ModuleNavigationItemsInRoles INNER JOIN
							 dbo.vfin_ModuleNavigationItems ON dbo.vfin_ModuleNavigationItemsInRoles.ModuleNavigationItemId = dbo.vfin_ModuleNavigationItems.Id INNER JOIN
							 dbo.vw_EmployeeRegisterwithUserID INNER JOIN
							 dbo.aspnet_UsersInRoles ON dbo.vw_EmployeeRegisterwithUserID.UserId = dbo.aspnet_UsersInRoles.UserId INNER JOIN
							 dbo.aspnet_Roles ON dbo.aspnet_UsersInRoles.RoleId = dbo.aspnet_Roles.RoleId INNER JOIN
							 dbo.aspnet_Membership ON dbo.vw_EmployeeRegisterwithUserID.UserId = dbo.aspnet_Membership.UserId INNER JOIN
							 dbo.aspnet_Users ON dbo.aspnet_UsersInRoles.UserId = dbo.aspnet_Users.UserId ON 
							 dbo.vfin_ModuleNavigationItemsInRoles.RoleName = dbo.aspnet_Roles.RoleName
	WHERE dbo.aspnet_Users.UserName=@UserName
	END

GO
