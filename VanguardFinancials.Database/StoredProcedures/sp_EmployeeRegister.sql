IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_EmployeeRegister') BEGIN
   EXEC('CREATE PROC [dbo].[sp_EmployeeRegister] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_EmployeeRegister]    Script Date: 9/13/2014 4:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_EmployeeRegister] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 /****** Script for SelectTopNRows command from SSMS  ******/
SELECT  

	(SELECT
		SerialNumber
		FROM [dbo].[vfin_Customers] where Id=dbo.vfin_Employees.CustomerId) as PersonalFileNumber,
	(SELECT
		Individual_IdentityCardNumber
		FROM [dbo].[vfin_Customers] where Id=dbo.vfin_Employees.CustomerId) as IdentityCardNumber,
	(SELECT
		RIGHT('00000'+CAST(ltrim(rtrim(SerialNumber)) AS VARCHAR(6)),6) 
		FROM [dbo].[vfin_Customers] where Id=dbo.vfin_Employees.CustomerId) as MembershipNumber,
	(SELECT
		[Individual_FirstName]+' '+
		[Individual_LastName]
		FROM [dbo].[vfin_Customers] where Id=dbo.vfin_Employees.CustomerId) as EmployeeName,
	(SELECT [Description]
		FROM [dbo].[vfin_Branches] where id=dbo.vfin_Employees.BranchId) as BranchName,
	(SELECT 
		[Description]
		FROM [dbo].[vfin_Designations] where id=dbo.vfin_Employees.DesignationId) as Designation,  
	(SELECT
		[Description]
		FROM [dbo].[vfin_Departments] where id=dbo.vfin_Employees.DepartmentId) as Department,
		[Type] =
			CASE [Type]
				WHEN 1 THEN 'Full-Time'
				WHEN 2 THEN 'Part-Time'
				WHEN 4 THEN 'Contract'
				ELSE 'UnKnown'
			END
      ,[PersonalIdentificationNumber]
      ,[NationalSocialSecurityFundNumber]
      ,[NationalHospitalInsuranceFundNumber],
	   [BloodGroup] =
			CASE [BloodGroup]
				WHEN 0 THEN 'Unknown'
				WHEN 1 THEN 'A-'
				WHEN 2 THEN 'A+'
				WHEN 0 THEN 'B-'
				WHEN 1 THEN 'B+'
				WHEN 2 THEN 'AB-'
				WHEN 0 THEN 'AB+'
				WHEN 1 THEN 'O-'
				WHEN 2 THEN 'O+'
			END
      ,[Remarks]
      ,[IsLocked]
      ,[CreatedBy]
      ,[CreatedDate]
  FROM [dbo].[vfin_Employees]
END






