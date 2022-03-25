IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_EmployerAttachmentReport') BEGIN
   EXEC('CREATE PROC [dbo].[sp_EmployerAttachmentReport] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_EmployerAttachmentReport]    Script Date: 9/13/2014 6:17:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 15.06.2014
-- Description:	sp_EmployerAttachmentReport
-- =============================================
--select * from vfin_PostingPeriods
---sp_EmployerAttachmentReport '0777363D-0845-C660-9E58-08D1336CB025',8
ALTER PROCEDURE [dbo].[sp_EmployerAttachmentReport] 
	-- Add the parameters for the stored procedure here
	@PostingPeriod Varchar(100), 
	@Month int = 1
AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT ROW_NUMBER() OVER(ORDER BY dbo.vw_CustomerAccounts.Reference2) AS SNo,'14701' as VoteCode,dbo.vw_CustomerAccounts.Individual_PayrollNumbers as PNum,dbo.vw_CustomerAccounts.FullName as Name,'2641' as SaccoCode,CASE  upper(Products_1.type)
			WHEN 'INVESTMENTS' THEN 'S' WHEN 'LOANS' THEN 'L' END+REPLACE(STR(Products_1.Code, 2), SPACE(1), '0') +REPLACE(STR(dbo.vw_CustomerAccounts.serialnumber, 5), SPACE(1), '0')+REPLACE(STR(dbo.vfin_DataAttachmentEntries.SequenceNumber, 2), SPACE(1), '0') 
			AS AccountNo,'938' as EDCode,dbo.vfin_DataAttachmentEntries.NewAmount, dbo.vfin_DataAttachmentEntries.CurrentAmount,dbo.vfin_DataAttachmentEntries.NewBalance, dbo.vfin_DataAttachmentEntries.CurrentBalance,dbo.vfin_DataAttachmentEntries.TransactionType as TransType,
			case dbo.vfin_DataAttachmentEntries.TransactionType WHEN 1 THEN 'FreshLoan' WHEN 2 THEN 'Adjustment' END as TransName, 0 as Interest, case dbo.vfin_DataAttachmentEntries.TransactionType
			WHEN 1 THEN 2 WHEN 2 THEN 1 END as Action, dbo.vfin_DataAttachmentEntries.NewAbility as Ability, dbo.vfin_DataAttachmentEntries.CurrentAbility as Variated_ability,dbo.vfin_Employers.Description as Dept,dbo.vfin_Employers.Id,dbo.vfin_DataAttachmentEntries.Remarks,

replace(convert(NVARCHAR, DATEADD(month, ((year(dbo.vfin_PostingPeriods.Duration_StartDate)-1900) * 12) + dbo.vfin_DataAttachmentPeriods.Month, -1), 103), ' ', '/') as PayDate


FROM            dbo.vfin_Stations INNER JOIN
                         dbo.vfin_Zones ON dbo.vfin_Stations.ZoneId = dbo.vfin_Zones.Id INNER JOIN
                         dbo.vfin_DataAttachmentPeriods INNER JOIN
                         dbo.vfin_DataAttachmentEntries ON dbo.vfin_DataAttachmentPeriods.Id = dbo.vfin_DataAttachmentEntries.DataAttachmentPeriodId INNER JOIN
                         dbo.vw_CustomerAccounts ON dbo.vfin_DataAttachmentEntries.CustomerAccountId = dbo.vw_CustomerAccounts.Id INNER JOIN
                         dbo.Products(0) AS Products_1 ON dbo.vw_CustomerAccounts.CustomerAccountType_TargetProductId = Products_1.id INNER JOIN
                         dbo.vfin_PostingPeriods ON dbo.vfin_DataAttachmentPeriods.PostingPeriodId = dbo.vfin_PostingPeriods.Id ON 
                         dbo.vfin_Stations.Id = dbo.vw_CustomerAccounts.StationId INNER JOIN
                         dbo.vfin_Divisions ON dbo.vfin_Zones.DivisionId = dbo.vfin_Divisions.Id INNER JOIN
                         dbo.vfin_Employers ON dbo.vfin_Divisions.EmployerId = dbo.vfin_Employers.Id


	WHERE dbo.vfin_DataAttachmentPeriods.PostingPeriodId= @PostingPeriod AND dbo.vfin_DataAttachmentPeriods.Month=@Month 
    -- Insert statements for procedure here
END
