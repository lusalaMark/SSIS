IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_JournalVoucherListing') BEGIN
   EXEC('CREATE PROC [dbo].[sp_JournalVoucherListing] as')
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 14.06.2014
-- Description:	JournalVouchersListing
-- =============================================
ALTER PROCEDURE [dbo].[sp_JournalVoucherListing] 
	-- Add the parameters for the stored procedure here
	@StartDate DateTime  , 
	@EndDate DateTime 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));
	SET NOCOUNT ON;
	SELECT        VoucherNumber
	FROM            vfin_JournalVouchers
	WHERE        (CreatedDate BETWEEN @StartDate AND @EndDate)
    -- Insert statements for procedure here
END

GO
