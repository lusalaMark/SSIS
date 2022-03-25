IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_InhouseCheques') BEGIN
   EXEC('CREATE PROC [dbo].[sp_InhouseCheques] as')
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
--select * from vfin_JournalEntries
---select * from vfin_PostingPeriods
--sp_GlAccountStatement '8549203B-6B92-C783-28B7-08D10CCD4BC3','03/01/2014','04/30/2014','28C1F651-CFFE-C466-553E-08D0FC697DC8'
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
-- Create date: 06/10/2014
-- Description:	sp_InhouseCheques
-- =============================================
alter PROCEDURE sp_InhouseCheques 
	-- Add the parameters for the stored procedure here
	@StartDate datetime , 
	@EndDate datetime,
	@FilterField varchar(50) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
			set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));

    -- Insert statements for procedure here
	SELECT        dbo.vfin_ChartOfAccounts.AccountCode, dbo.vfin_ChartOfAccounts.AccountName, dbo.vw_CustomerAccounts.FullName, dbo.vw_CustomerAccounts.FullAccount, 
                         dbo.vfin_InHouseCheques.Amount, dbo.vfin_InHouseCheques.Payee, dbo.vfin_InHouseCheques.Reference, dbo.vfin_InHouseCheques.IsPrinted, 
                         dbo.vfin_InHouseCheques.PrintedNumber, dbo.vfin_InHouseCheques.PrintedBy, dbo.vfin_InHouseCheques.PrintedDate, dbo.vfin_InHouseCheques.CreatedBy, 
                         dbo.vfin_InHouseCheques.CreatedDate, dbo.vfin_Branches.Description
	FROM            dbo.vfin_InHouseCheques INNER JOIN
                         dbo.vw_CustomerAccounts ON dbo.vfin_InHouseCheques.DebitCustomerAccountId = dbo.vw_CustomerAccounts.Id INNER JOIN
                         dbo.vfin_ChartOfAccounts ON dbo.vfin_InHouseCheques.DebitChartOfAccountId = dbo.vfin_ChartOfAccounts.Id INNER JOIN
                         dbo.vfin_Branches ON dbo.vfin_InHouseCheques.BranchId = dbo.vfin_Branches.Id
	WHERE 
	CASE 
		WHEN @FilterField='CreatedDate' then dbo.vfin_InHouseCheques.CreatedDate
		WHEN @FilterField='PrintedDate' then dbo.vfin_InHouseCheques.PrintedDate
	end
	between @StartDate and @EndDate


END
GO
