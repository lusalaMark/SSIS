IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_ValidateGracePeriodComputation') BEGIN
   EXEC('CREATE PROC [dbo].[sp_ValidateGracePeriodComputation] as')
END
GO

GO
/****** Object:  StoredProcedure [dbo].[sp_ValidateGracePeriodComputation]    Script Date: 10/21/2014 4:49:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 23.07.2014
-- Description:	ValidateGracePeriodComputation
-- =============================================
---sp_ValidateGracePeriodComputation '358BC92E-13B2-CC6E-9724-08D13F32F803',1

/****** Object:  StoredProcedure [dbo].[sp_ValidateGracePeriodComputation]    Script Date: 5/7/2015 4:40:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 23.07.2014
-- Description:	ValidateGracePeriodComputation
-- =============================================
---sp_ValidateGracePeriodComputation 'C0038028-75C8-C527-AB15-08D1D39B7B25',5
GO
/****** Object:  StoredProcedure [dbo].[sp_ValidateGracePeriodComputation]    Script Date: 9/24/2015 12:37:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---sp_ValidateGracePeriodComputation 'D885812F-639F-C04F-29C9-08D13F39DD62',9
ALTER PROCEDURE [dbo].[sp_ValidateGracePeriodComputation] 
	-- Add the parameters for the stored procedure here
	@CustomerAccountID varchar(100) , 
	@Month int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @CustomerID varchar(100),
			@LoanProductID	varchar(100),	
			@GracePeriod int, @LoanDays int,
			@MonthName varchar(20),
			@Value int=0,
			@Compute int=0
	select @CustomerID =(select top 1 CustomerId from vfin_CustomerAccounts where CustomerId=@CustomerAccountID)
	select @LoanProductID =(select top 1 CustomerAccountType_TargetProductId from vfin_CustomerAccounts where CustomerId=@CustomerAccountID)
	select @GracePeriod=(select LoanRegistration_GracePeriod from vfin_LoanProducts where id=@LoanProductID)
	select @LoanDays=(select top 1 DATEDIFF(d,AuditedDate,getdate()) from vfin_LoanCases where CustomerId=@LoanProductID and LoanProductId=@LoanProductID order by AuditedDate desc)
	select @MonthName=(select MonthName from dbo.GetMonthList('01/01/2014',1) where MonthNumber=@Month)
		

		   SET  @Value= 
		   (  SELECT top 1 1
				FROM            dbo.vfin_Journals INNER JOIN
				dbo.vfin_JournalEntries ON dbo.vfin_Journals.Id = dbo.vfin_JournalEntries.JournalId where vfin_JournalEntries.CustomerAccountId=@CustomerAccountID and vfin_Journals.Reference=@MonthName and vfin_Journals.PrimaryDescription like '%Interest Charged%' 
				and vfin_Journals.PostingPeriodId in (select top 1 id from vfin_PostingPeriods where IsActive=1)	   
		   )
		   SET @Value=isnull(@Value,0)

	if @value=0
		begin
			select @value= iif(@LoanDays<@GracePeriod,1,0)
		end
	select @value
END