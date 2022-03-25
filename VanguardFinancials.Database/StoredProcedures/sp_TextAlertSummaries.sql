IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_TextAlertSummaries') BEGIN
   EXEC('CREATE PROC [dbo].[sp_TextAlertSummaries] as')
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
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
alter PROCEDURE sp_TextAlertSummaries 
	-- Add the parameters for the stored procedure here
	@StartDate DateTime,
	@EndDate DateTime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));

with CTEMessages (TextMessage_Recipient,TextMessage_DLRStatus)
as
(
SELECT [TextMessage_Recipient],
	  Case [TextMessage_DLRStatus]
	  When 1 then 'UnKnown' 
	  When 2 then 'Failed'
	  When 4 then 'Pending'
	  When 8 then 'Delivered'
	  When 16 then 'Not Applicable'
	  end as [TextMessage_DLRStatus]
  FROM [VanguardFinancialsDB].[dbo].[vfin_TextAlerts] where CreatedDate between @StartDate and @EndDate )

  select count(*) as Count,TextMessage_DLRStatus from CTEMessages group by TextMessage_DLRStatus
 END
GO
