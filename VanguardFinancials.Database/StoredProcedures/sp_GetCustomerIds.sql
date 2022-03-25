/****** Object:  StoredProcedure [dbo].[sp_GetCustomerIds]    Script Date: 9/4/2014 1:11:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,paul,>
-- Create date: <Create,4/9/2014,>
-- Description:	<Description,get customer ids,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetCustomerIds]
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [Id] FROM [dbo].[vfin_Customers] where IsLocked=0
END

GO
