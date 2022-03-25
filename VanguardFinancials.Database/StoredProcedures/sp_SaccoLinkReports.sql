IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_SaccoLinkReports') BEGIN
   EXEC('CREATE PROC [dbo].[sp_SaccoLinkReports] as')
END
GO

/****** Object:  StoredProcedure [dbo].[sp_SaccoLinkReports]    Script Date: 8/12/2014 10:08:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--sp_SaccoLinkReports '06/01/2014','06/30/2014'
ALTER PROCEDURE [dbo].[sp_SaccoLinkReports]
	-- Add the parameters for the stored procedure here
	@StartDate DateTime,
	@EndDate Datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));

    -- Insert statements for procedure here
SELECT        dbo.vw_CustomerAccounts.FullAccount, dbo.vw_CustomerAccounts.FullName, dbo.vfin_JournalEntries.Amount, convert(varchar(10),dbo.vfin_JournalEntries.CreatedDate,101) as TrxDate, 
                         dbo.vfin_Journals.PrimaryDescription, dbo.vfin_Journals.SecondaryDescription, dbo.vfin_Journals.Reference, dbo.Character_Mask(dbo.vfin_AlternateChannels.CardNumber,6,'X') as CardNumber
FROM            dbo.vfin_JournalEntries INNER JOIN
                         dbo.vfin_ChartOfAccounts ON dbo.vfin_JournalEntries.ContraChartOfAccountId = dbo.vfin_ChartOfAccounts.Id INNER JOIN
                         dbo.vw_CustomerAccounts ON dbo.vfin_JournalEntries.CustomerAccountId = dbo.vw_CustomerAccounts.Id INNER JOIN
                         dbo.vfin_Journals ON dbo.vfin_JournalEntries.JournalId = dbo.vfin_Journals.Id INNER JOIN
                         dbo.vfin_AlternateChannels ON dbo.vw_CustomerAccounts.Id = dbo.vfin_AlternateChannels.CustomerAccountId
WHERE        (dbo.vfin_JournalEntries.ChartOfAccountId = '7F2F04D2-BDFC-C8BA-2130-08D10CAE7E33') and vfin_AlternateChannels.Type=1 and PrimaryDescription +SecondaryDescription not like '%Sacco link%' and  PrimaryDescription +SecondaryDescription not like '%charge%'
and  PrimaryDescription +SecondaryDescription not like '%Withdraw From Agent%' and vfin_JournalEntries.CreatedDate>=@StartDate and vfin_JournalEntries.CreatedDate<=@EndDate order by vfin_AlternateChannels.CardNumber 
END

GO
