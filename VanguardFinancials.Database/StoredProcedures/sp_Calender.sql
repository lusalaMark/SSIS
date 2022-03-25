IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_Calender') BEGIN
   EXEC('CREATE PROC [dbo].[sp_Calender] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_Calender]    Script Date: 9/13/2014 3:36:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---dbo.Calender 02,2004
ALTER PROCEDURE [dbo].[sp_Calender]
(
 @month tinyint,
 @year int
)
as
Begin

---------- Declare Valiables

Declare @date1 date, @enddate date, @day1 varchar(10), @weekid tinyint, @currdate date

Select @currdate= convert(date,(CAST(@year as char(4))+'-'+CAST(@month as varchar(2))+'-15'))

Select @date1=convert(date,dbo.[f_FirstDayOfMonth](@currdate)), @enddate=convert(date,dbo.[f_LastdayOfMonth](@currdate))

Select @day1= DATENAME(WEEKDAY, @date1)

---------- Recursive CTE to get Days and Dates for the month

;with cte_cal ([Date], [Day], [weekid])
as
(
 Select @date1, @day1, case when DATEPART(WEEKDAY,@date1)=1 then cast(DATEPART(WW,@date1)  as tinyint)-1
                            else DATEPART(WW,@date1) end as weekid
 union all
 Select DATEADD(DD,1,[Date]), cast(DATENAME(WEEKDAY, DATEADD(DD,1,[Date])) as varchar(10)),  
                              case when DATEPART(WEEKDAY,DATEADD(DD,1,[Date]))=1 then 
                              cast(DATEPART(WW,DATEADD(DD,1,[Date]))  as tinyint)-1
                              else DATEPART(WW,DATEADD(DD,1,[Date])) end as weekid
 from cte_cal
 where [Date] < @enddate 
)

------- Use Pivot to display the result in calender format

Select  [weekid], [Monday], [Tuesday], [Wednesday], [Thursday], [Friday], [Saturday], [Sunday] 
from
(
 Select [Weekid], [Date], [DAY] from cte_cal
)
pvt
Pivot
(
 max([Date]) for [Day] in ([Monday], [Tuesday], [Wednesday], [Thursday], [Friday], [Saturday], [Sunday] )
)
Pvttab

End 





