GO
/****** Object:  StoredProcedure [dbo].[sp_BranchListing]    Script Date: 9/13/2014 3:24:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 13/09/2014 
-- Description:	<Description,,>
-- =============================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_BranchListing') BEGIN
   EXEC('CREATE PROC [dbo].[sp_BranchListing] as')
END
GO
ALTER PROCEDURE [dbo].[sp_BranchListing]
	-- Add the parameters for the stored procedure here
--	<@Param1, sysname, @p1> <Datatype_For_Param1, , int> = <Default_Value_For_Param1, , 0>, 
---	<@Param2, sysname, @p2> <Datatype_For_Param2, , int> = <Default_Value_For_Param2, , 0>
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  /****** Script for SelectTopNRows command from SSMS  ******/
SELECT id,[Code]
      ,[Description]
  FROM [dbo].[vfin_Branches]
END





