USE [VanguardFinancialsDB_Gusii]
GO
/****** Object:  StoredProcedure [dbo].[sp_AlternateChannels]    Script Date: 2/18/2016 10:55:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Patrick>
-- Create date: <2016/02/16>
-- Description:	<Alternate Channels Report>
-- =============================================
ALTER PROCEDURE [dbo].[sp_AlternateChannels]
	@Type int,
	@StartDate datetime,
	@EndDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
SELECT        dbo.vfin_AlternateChannels.CardNumber, dbo.vfin_Customers.Reference2, dbo.vfin_Customers.Reference3, dbo.vfin_AlternateChannels.Type, 
                         LTRIM(RTRIM(dbo.vfin_Customers.Individual_FirstName)) + '  ' + LTRIM(RTRIM(dbo.vfin_Customers.Individual_LastName)) AS Fullnames, 
                         dbo.vfin_Customers.Individual_IdentityCardNumber
FROM            dbo.vfin_AlternateChannels INNER JOIN
                         dbo.vfin_CustomerAccounts ON dbo.vfin_AlternateChannels.CustomerAccountId = dbo.vfin_CustomerAccounts.Id INNER JOIN
                         dbo.vfin_Customers ON dbo.vfin_CustomerAccounts.CustomerId = dbo.vfin_Customers.Id

						 where @Type=dbo.vfin_AlternateChannels.Type and dbo.vfin_AlternateChannels.CreatedDate between @StartDate and @EndDate
END