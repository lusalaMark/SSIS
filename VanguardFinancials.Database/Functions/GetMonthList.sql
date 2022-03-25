IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='GetMonthList') BEGIN
   EXEC('CREATE function [dbo].[GetMonthList] as')
END
GO

/****** Object:  UserDefinedFunction [dbo].[GetMonthList]    Script Date: 9/14/2014 7:35:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER function [dbo].[GetMonthList] 
(
	@Date DATE, 
    @inc INT 
)
RETURNS TABLE
AS
RETURN  
(
with cte as
(
    SELECT Inc              = @inc                 
          ,[MonthName]      = DATENAME(mm ,@Date)  
          ,[MonthNumber]    = DATEPART(mm ,@Date)  
          ,[MonthYear]      = DATEPART(yy ,@Date)
		  ,[StartDate]		=DATEADD(MONTH, 0, @Date)  
    UNION ALL
    SELECT inc + 1
          ,DATENAME(mm ,DATEADD(mm ,inc + 1 ,@Date))
          ,DATEPART(mm ,DATEADD(mm ,inc + 1 ,@Date))
          ,CASE WHEN [MonthNumber] = 12 THEN [MonthYear] + 1 ELSE [MonthYear] END
		  ,DATEADD(MONTH, inc+1 , @Date)
		
    FROM    cte
    WHERE  inc < 12
)
select [MonthName],[MonthNumber],[MonthYear],[StartDate],  DATEADD(day, DATEDIFF(day, 0, EOMONTH ([StartDate])), '23:59:59')   as EndDate from cte where [MonthYear]=year(@Date)


)


GO


