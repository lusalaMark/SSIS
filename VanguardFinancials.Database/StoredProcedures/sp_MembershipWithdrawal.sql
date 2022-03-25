IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_MembershipWithdrawal') BEGIN
   EXEC('CREATE PROC [dbo].[sp_MembershipWithdrawal] as')
END
GO


/****** Object:  StoredProcedure [dbo].[sp_MembershipWithdrawal]    Script Date: 8/12/2014 10:08:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_MembershipWithdrawal]
	-- Add the parameters for the stored procedure here
	@StartDate DateTime,
	@EndDate DateTime,
	@Status int,
	@Category int

AS
BEGIN
set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT        ltrim(rtrim(dbo.vw_MemberRegister.Salutation)) +' ' +ltrim(rtrim(dbo.vw_MemberRegister.Individual_FirstName)) + ' '+ ltrim(rtrim(dbo.vw_MemberRegister.Individual_LastName)) as FullName, 
							 dbo.vw_MemberRegister.Gender, dbo.vw_MemberRegister.MembershipNumber, dbo.vw_MemberRegister.Individual_PayrollNumbers, 
							 case 
							 dbo.vfin_MembershipWithdrawalNotifications.Category
							 when 1792 THEN 'Deceased'
							 when 1793 THEN 'Bosa Withdrawal'
							 when 1794 THEN 'Fosa Withdrawal'
							 End as Category
							 , 
							 CASE dbo.vfin_MembershipWithdrawalNotifications.Status
							 WHEN 1 THEN 'Registered'
							 WHEN 2 THEN 'Approved'
							 WHEN 4 THEN 'Audited'
							 WHEN 8 THEN 'Withdrawal Settled'
							 WHEN 16 THEN 'Differred'
							 WHEN 32 THEN 'Death Claim Settled' END AS STATUS, 
							 dbo.vfin_MembershipWithdrawalNotifications.Remarks, dbo.vfin_MembershipWithdrawalNotifications.CreatedBy, 
							 dbo.vfin_MembershipWithdrawalNotifications.CreatedDate, dbo.vfin_MembershipWithdrawalNotifications.MaturityDate, 
							 dbo.vfin_MembershipWithdrawalNotifications.ApprovedBy, dbo.vfin_MembershipWithdrawalNotifications.ApprovedDate, 
							 dbo.vfin_MembershipWithdrawalNotifications.ApprovalRemarks, dbo.vfin_MembershipWithdrawalNotifications.AuditedBy, 
							 dbo.vfin_MembershipWithdrawalNotifications.AuditedDate, dbo.vfin_MembershipWithdrawalNotifications.AuditRemarks, 
							 dbo.vfin_MembershipWithdrawalNotifications.SettledBy, dbo.vfin_MembershipWithdrawalNotifications.SettledDate,vfin_MembershipWithdrawalSettlements.Principal,vfin_MembershipWithdrawalSettlements.Reference
	FROM            dbo.vfin_MembershipWithdrawalNotifications INNER JOIN
							 dbo.vw_MemberRegister ON dbo.vfin_MembershipWithdrawalNotifications.CustomerId = dbo.vw_MemberRegister.Id
						INNER JOIN
                         dbo.vfin_MembershipWithdrawalSettlements ON 
                         dbo.vfin_MembershipWithdrawalNotifications.Id = dbo.vfin_MembershipWithdrawalSettlements.WithdrawalNotificationId
						 INNER JOIN
                         dbo.vfin_CustomerAccounts ON dbo.vfin_MembershipWithdrawalSettlements.CustomerAccountId = dbo.vfin_CustomerAccounts.Id
	WHERE
	dbo.vfin_MembershipWithdrawalNotifications.Category=@Category AND
	CASE @Status
				WHEN 1 THEN dbo.vfin_MembershipWithdrawalNotifications.CreatedDate
				WHEN 2 THEN dbo.vfin_MembershipWithdrawalNotifications.ApprovedDate
				WHEN 4 THEN dbo.vfin_MembershipWithdrawalNotifications.AuditedDate
				WHEN 8 THEN dbo.vfin_MembershipWithdrawalNotifications.SettledDate
				WHEN 32 THEN dbo.vfin_MembershipWithdrawalNotifications.SettledDate				
	end Between @StartDate and @EndDate and vfin_CustomerAccounts.CustomerAccountType_ProductCode=1 order by vw_MemberRegister.SerialNumber 
	 
END

GO
