IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_TellersRegister') BEGIN
   EXEC('CREATE PROC [dbo].[sp_TellersRegister] as')
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_TellersRegister] 
	-- Add the parameters for the stored procedure here
	--<@Param1, sysname, @p1> <Datatype_For_Param1, , int> = <Default_Value_For_Param1, , 0>, 
	---<@Param2, sysname, @p2> <Datatype_For_Param2, , int> = <Default_Value_For_Param2, , 0>
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 	id,
	(select 
			(SELECT
			Individual_FirstName+' '+
			Individual_LastName
			FROM [dbo].[vfin_Customers] 
			where Id=dbo.vfin_Employees.CustomerId)
		from [dbo].[vfin_Employees] 
		WHERE Id=vfin_Tellers.EmployeeId
	  ) as EmployeeName
      ,[Code]
      ,'Teller Code: '+[Description] +' Teller Name '+
	  (select 
			(SELECT
			Individual_FirstName+' '+
			Individual_LastName
			FROM [dbo].[vfin_Customers] 
			where Id=dbo.vfin_Employees.CustomerId)
		from [dbo].[vfin_Employees] 
		WHERE Id=vfin_Tellers.EmployeeId
	  ) as DisplayName

  FROM [dbo].[vfin_Tellers]
 
END






GO
