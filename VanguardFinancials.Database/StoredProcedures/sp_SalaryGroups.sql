IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_SalaryGroups') BEGIN
   EXEC('CREATE PROC [dbo].[sp_SalaryGroups] as')
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_SalaryGroups] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT      dbo.vfin_SalaryGroups.Description, dbo.vfin_SalaryHeads.Description AS SalaryHead, 
				CASE 
				WHEN dbo.vfin_SalaryGroupEntries.Charge_FixedAmount>0 THEN 'Charge_FixedAmount'
				ELSE 'Charge_Percentage' END as Type,
				CASE 
				WHEN dbo.vfin_SalaryHeads.Category=1 THEN 'Earning'
				WHEN dbo.vfin_SalaryHeads.Category=2 THEN 'Deduction'
				END as CategoryDescription,dbo.vfin_SalaryHeads.Category
	FROM            dbo.vfin_SalaryGroupEntries INNER JOIN
							 dbo.vfin_SalaryGroups ON dbo.vfin_SalaryGroupEntries.SalaryGroupId = dbo.vfin_SalaryGroups.Id INNER JOIN
							 dbo.vfin_SalaryHeads ON dbo.vfin_SalaryGroupEntries.SalaryHeadId = dbo.vfin_SalaryHeads.Id 
	ORDER BY dbo.vfin_SalaryGroups.Description,dbo.vfin_SalaryHeads.Category
END

GO
