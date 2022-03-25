IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_MicroCreditGroupMembers') BEGIN
   EXEC('CREATE PROC [dbo].[sp_MicroCreditGroupMembers] as')
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
---sp_MicroCreditGroupMembers '420AA919-1E36-CEB1-7368-08D1A69A1873'
alter PROCEDURE sp_MicroCreditGroupMembers
	@GroupID varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT        dbo.vw_Customers.FullName, 
                         CASE dbo.vfin_MicroCreditGroupMembers.Designation WHEN 1 THEN 'Chairperson' WHEN 2 THEN 'Deputy Chairperson' WHEN 4 THEN 'Secretary' WHEN 8 THEN 'Deputy Secretary'
                          WHEN 16 THEN 'Treasurer' WHEN 32 THEN 'Ordinary Member' END AS MicroCreditGroupMemberDesignation, dbo.vw_Customers.Gender, 
                         dbo.vw_Customers.Individual_IdentityCardNumber, dbo.vw_Customers.MembershipNumber, dbo.vfin_MicroCreditGroupMembers.LoanCycle
	FROM            dbo.vfin_MicroCreditGroupMembers INNER JOIN
                         dbo.vw_Customers ON dbo.vfin_MicroCreditGroupMembers.CustomerId = dbo.vw_Customers.Id
	WHERE MicroCreditGroupId=@GroupID
END
GO