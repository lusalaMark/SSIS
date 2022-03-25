IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_UserActivityProfile') BEGIN
   EXEC('CREATE PROC [dbo].[sp_UserActivityProfile] as')
END
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 01/10/2014
-- Description:	User Activity
-- =============================================
-- sp_UserActivityProfile
alter PROCEDURE sp_UserActivityProfile 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

	SELECT        dbo.vw_EmployeeRegisterwithUserID.FullName, dbo.vw_aspnet_MembershipUsers.LoweredEmail, dbo.vw_aspnet_MembershipUsers.IsApproved, 
                         dbo.vw_aspnet_MembershipUsers.IsLockedOut, dbo.vw_aspnet_MembershipUsers.CreateDate, dbo.vw_aspnet_MembershipUsers.LastLoginDate, 
                         dbo.vw_aspnet_MembershipUsers.LastPasswordChangedDate, CASE dbo.vw_aspnet_MembershipUsers.LastLockoutDate WHEN '1754-01-01 00:00:00.000' THEN '' END
						 as  LastLockoutDate,
                         dbo.vw_aspnet_MembershipUsers.FailedPasswordAttemptCount, 
                         dbo.vw_aspnet_MembershipUsers.UserName, dbo.vw_aspnet_MembershipUsers.LastActivityDate
	FROM            dbo.vw_aspnet_MembershipUsers INNER JOIN
                         dbo.vw_EmployeeRegisterwithUserID ON dbo.vw_aspnet_MembershipUsers.UserId = dbo.vw_EmployeeRegisterwithUserID.UserId

END
GO
