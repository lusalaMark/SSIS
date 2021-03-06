IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_NextOfKinSchedule') BEGIN
   EXEC('CREATE PROC [dbo].[sp_NextOfKinSchedule] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_NextOfKinSchedule]    Script Date: 6/18/2015 8:52:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_NextOfKinSchedule]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT        ltrim(rtrim(dbo.vfin_Customers.Individual_FirstName))+' '+ LTRIM(RTRIM(dbo.vfin_Customers.Individual_LastName)) AS CustomerName, dbo.vfin_Customers.Individual_IdentityCardNumber, dbo.vfin_Customers.Individual_PayrollNumbers, 
                         dbo.vfin_Customers.Reference1, dbo.vfin_Customers.Reference2, dbo.vfin_Customers.Reference3, LTRIM(rtrim(dbo.vfin_NextOfKin.FirstName))+' '+ ltrim(rtrim(dbo.vfin_NextOfKin.LastName)) as NextOfKinName, dbo.vfin_NextOfKin.IdentityCardNumber, 
                         
						 case dbo.vfin_NextOfKin.Relationship
						 When '53456' then 'Father'
						 When '53457' then 'Mother'
						 When '53458' then 'Brother'
						 When '53459' then 'Sister'
						 When '53460' then 'Wife'
						 When '53461' then 'Husband'
						 When '53462' then 'Son'
						 When '53463' then 'Daughter'
						 When '53464' then 'Other'
						 end as Relationship
						 , dbo.vfin_NextOfKin.Address_AddressLine1, dbo.vfin_NextOfKin.Address_AddressLine2, dbo.vfin_NextOfKin.Address_Street, 
                         dbo.vfin_NextOfKin.Address_PostalCode, dbo.vfin_NextOfKin.Address_City, dbo.vfin_NextOfKin.Address_Email, dbo.vfin_NextOfKin.Address_LandLine, dbo.vfin_NextOfKin.Address_MobileLine, 
                         dbo.vfin_NextOfKin.NominatedPercentage
	FROM            dbo.vfin_Customers INNER JOIN
                         dbo.vfin_NextOfKin ON dbo.vfin_Customers.Id = dbo.vfin_NextOfKin.CustomerId order by Reference2
END
