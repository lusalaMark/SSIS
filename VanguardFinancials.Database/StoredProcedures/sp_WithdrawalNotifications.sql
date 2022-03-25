IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_WithdrawalNotifications') BEGIN
   EXEC('CREATE PROC [dbo].[sp_WithdrawalNotifications] as')
END
GO

/****** Object:  StoredProcedure [dbo].[sp_WithdrawalNotifications]    Script Date: 8/12/2014 10:08:16 AM ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 05.06.2014
-- Description:	WithdrawalNotifications
-- =============================================

---[sp_WithdrawalNotifications] '01/01/2014','06/30/2014'
ALTER PROCEDURE [dbo].[sp_WithdrawalNotifications] 
	-- Add the parameters for the stored procedure here
	@StartDate DateTime  , 
	@EndDate DateTime 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	SELECT        dbo.vfin_Branches.Description AS ReceivingBranch, ltrim(rtrim(dbo.vw_MemberRegister.Individual_FirstName))+' '+ltrim(rtrim(dbo.vw_MemberRegister.Individual_LastName)) as Name, dbo.vw_MemberRegister.Gender, dbo.vw_MemberRegister.Individual_IdentityCardNumber, 
							 dbo.vw_MemberRegister.MembershipNumber, dbo.vw_MemberRegister.Individual_PayrollNumbers, dbo.vfin_MembershipWithdrawalNotifications.CreatedBy, 
							 dbo.vfin_MembershipWithdrawalNotifications.CreatedDate, dbo.vw_MemberRegister.Zone,
							 CASE dbo.vfin_MembershipWithdrawalNotifications.Status
							 WHEN 1 THEN 'Open'
							 WHEN 2 THEN 'Closed'
							 WHEN 4 THEN 'Suspended'
							 END AS Status,
							 CASE dbo.vfin_MembershipWithdrawalNotifications.Category
							 WHEN 1792 THEN 'Deceased'
							 WHEN 1793 THEN 'Back Office'
							 WHEN 1994 THEN 'Front Office'
							 END AS Category
	FROM            dbo.vfin_MembershipWithdrawalNotifications INNER JOIN
							 dbo.vw_MemberRegister ON dbo.vfin_MembershipWithdrawalNotifications.CustomerId = dbo.vw_MemberRegister.Id INNER JOIN
							 dbo.vfin_Branches ON dbo.vfin_MembershipWithdrawalNotifications.BranchId = dbo.vfin_Branches.Id

	WHERE vfin_MembershipWithdrawalNotifications.CreatedDate BETWEEN  @StartDate AND @EndDate
END

GO
