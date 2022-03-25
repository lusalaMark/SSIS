IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='fnReportTemplate') BEGIN
   EXEC('CREATE function [dbo].[fnReportTemplate] as')
END
GO

/****** Object:  UserDefinedFunction [dbo].[fnReportTemplate]    Script Date: 9/14/2014 7:14:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--select Row_number() OVER(ORDER BY (SELECT 1)),* from vfin_Customers
----select * from dbo.fnReportTemplate('83D39FF9-9BD3-C1AC-03A2-08D126896BE9') order by rownumber
ALTER function [dbo].[fnReportTemplate] 
(
	@ID VARCHAR(50)
) 
RETURNS TABLE 
AS 
RETURN 

WITH
  cteReports (ID, DESCRIPTION,SpreadsheetCellReference)
  AS
  (
    SELECT ID, space(depth)+DESCRIPTION as Description,SpreadsheetCellReference
    FROM vfin_ReportTemplates
    WHERE ParentId IS NULL and id=@ID 
    UNION ALL
    SELECT e.ID, space(depth)+e.Description as Description ,e.SpreadsheetCellReference
    FROM vfin_ReportTemplates e
      INNER JOIN cteReports r
        ON e.ParentId = r.ID
  )

SELECT       cteReports.id, cteReports.DESCRIPTION, cteReports.SpreadsheetCellReference, right(cteReports.id,12)  AS 'RowNumber',
iif(dbo.vfin_ChartOfAccounts.AccountCode is null,'',isnull(left(ltrim(rtrim(str(dbo.vfin_ChartOfAccounts.AccountType))),1),'')+'-'+isnull(ltrim(rtrim(str(dbo.vfin_ChartOfAccounts.AccountCode))),'')) as AccountCode, 
                         isnull(dbo.vfin_ChartOfAccounts.AccountName,'') as AccountName, isnull(dbo.vfin_ChartOfAccounts.AccountType,0) as AccountType
FROM            dbo.vfin_ChartOfAccounts INNER JOIN
                         dbo.vfin_ReportTemplateEntries ON dbo.vfin_ChartOfAccounts.Id = dbo.vfin_ReportTemplateEntries.ChartOfAccountId RIGHT OUTER JOIN
                        cteReports ON dbo.vfin_ReportTemplateEntries.ReportTemplateId = cteReports.ID
						


GO


