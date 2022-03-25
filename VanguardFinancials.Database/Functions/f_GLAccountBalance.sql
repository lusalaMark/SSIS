IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='f_GLAccountBalance') BEGIN
   EXEC('CREATE function [dbo].[f_GLAccountBalance] as')
END
GO


/****** Object:  UserDefinedFunction [dbo].[f_GLAccountBalance]    Script Date: 9/14/2014 7:05:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--select * from f_GLAccountBalance('389781E6-0273-C568-AF28-08D115F76AD9','04/30/2014')

ALTER function [dbo].[f_GLAccountBalance] 
(	
	-- Add the parameters for the function here
	@ChartOfAccountId Varchar(MAX), 
	@StartDate Datetime
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
		SELECT isnull(sum(amount),0) Balance
		FROM [dbo].[vfin_JournalEntries] 
		WHERE ChartOfAccountId=@ChartOfAccountId and CreatedDate<@StartDate

)


GO


