IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_CustomerAccountBalanceAvailable') BEGIN
   EXEC('CREATE PROC [dbo].[sp_CustomerAccountBalanceAvailable] as')
END
GO

-- =============================================
-- Author:		Centrino
-- Create date: 01.06.2014
-- Description:	Customer AccountBalance Available
-- =============================================

GO
/****** Object:  StoredProcedure [dbo].[sp_CustomerAccountBalanceAvailable]    Script Date: 9/30/2015 11:58:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 01.06.2014
-- Description:	Customer AccountBalance Available
-- ===============
GO
/****** Object:  StoredProcedure [dbo].[sp_CustomerAccountBalanceAvailable]    Script Date: 9/30/2015 1:40:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 01.06.2014
-- Description:	Customer AccountBalance Available
-- =============================================

GO
/****** Object:  StoredProcedure [dbo].[sp_CustomerAccountBalanceAvailable]    Script Date: 10/1/2015 11:41:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 01.06.2014
-- Description:	Customer AccountBalance Available
-- =============================================
---sp_CustomerAccountBalanceAvailable '3e9ae149-658f-caba-2682-08d1ad7d0c72','01/11/2013'

ALTER PROCEDURE [dbo].[sp_CustomerAccountBalanceAvailable] 
	-- Add the parameters for the stored procedure here
	@CustomerAccountID UniqueIdentifier,
	@CutoffDate Datetime ,
	@CustomerAccountType_TargetProductId Uniqueidentifier,
	@CustomerAccountType_ProductCode Int
AS
	Declare @Balance numeric(18,2)
	Declare @MinBalance numeric(18,2),@SavingsChartOfAccountID UniqueIdentifier,@ProducID UniqueIdentifier=@CustomerAccountType_TargetProductId

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--	set @ProducID=(select CustomerAccountType_TargetProductId 
---						from vfin_CustomerAccounts where id=@CustomerAccountID)
	set @SavingsChartOfAccountID=(SELECT TOP 1 ChartOfAccountId FROM vfin_SavingsProducts where id=@ProducID)
	set @CutoffDate=	(select DATEADD(day, DATEDIFF(day, 0, @CutoffDate), '23:59:59'));
	SELECT @Balance = 

				isnull((
						Select SUM(dbo.vfin_JournalEntries.Amount) ---Products_1.MinBalance
						FROM   dbo.vfin_JournalEntries WITH (NOLOCK) 
						WHERE CustomerAccountId =@CustomerAccountId and ChartOfAccountId =@SavingsChartOfAccountID
						 and CreatedDate<=@CutoffDate
						
				),0)

			  SET @MinBalance=
			  ISNULL((
						SELECT MinimumBalance
						FROM vfin_SavingsProducts WHERE ID =@ProducID
					),0)
			set @Balance=@Balance-@MinBalance
	
SELECT ISNULL(@Balance,0) as Balance
END





