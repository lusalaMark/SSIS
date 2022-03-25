IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_DailyRoutine') BEGIN
   EXEC('CREATE PROC [dbo].[sp_DailyRoutine] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_DailyRoutine]    Script Date: 9/13/2014 4:01:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[sp_DailyRoutine] as
update vfin_Journals set CreatedDate=DATEADD(ms,1,CreatedDate) where CONVERT(varchar(10),CreatedDate,103)=CONVERT(varchar(10),getdate(),103)
update vfin_JournalEntries set CreatedDate=DATEADD(ms,1,CreatedDate) where CONVERT(varchar(10),CreatedDate,103)=CONVERT(varchar(10),getdate(),103)
update vfin_CreditBatchEntries set CreatedDate=DATEADD(ms,1,CreatedDate) where CONVERT(varchar(10),CreatedDate,103)=CONVERT(varchar(10),getdate(),103)
