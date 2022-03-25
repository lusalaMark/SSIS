IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_UnclearedCheques') BEGIN
   EXEC('CREATE PROC [dbo].[sp_UnclearedCheques] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_AtmTransactionsFrequency]    Script Date: 9/13/2014 3:10:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[sp_UnclearedCheques]    Script Date: 1/31/2015 7:52:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



---sp_UnclearedCheques '01/31/2015'
ALTER procedure [dbo].[sp_UnclearedCheques] 
(@EndDate DateTime)
as
---set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));

SELECT        dbo.vfin_ExternalCheques.Number, dbo.vfin_ExternalCheques.Amount, dbo.vfin_ExternalCheques.Drawer, dbo.vfin_ExternalCheques.DrawerBank, 
                         dbo.vfin_ExternalCheques.DrawerBankBranch, dbo.vfin_ExternalCheques.WriteDate, dbo.vfin_ChequeTypes.Description as ChequeType, 
                         dbo.vfin_ExternalCheques.MaturityDate, dbo.vfin_ExternalCheques.Remarks, dbo.vfin_ExternalCheques.IsCleared, dbo.vfin_ExternalCheques.ClearedBy, 
                         dbo.vfin_ExternalCheques.ClearedDate, dbo.vfin_ExternalCheques.IsBanked, dbo.vfin_ExternalCheques.BankedBy, dbo.vfin_ExternalCheques.BankedDate, 
                         dbo.vfin_ExternalCheques.IsTransferred, dbo.vfin_ExternalCheques.TransferredBy, dbo.vfin_ExternalCheques.TransferredDate, 
                         dbo.vfin_ExternalCheques.CreatedBy, dbo.vfin_ExternalCheques.CreatedDate, dbo.vw_CustomerAccounts.FullName, dbo.vw_CustomerAccounts.AccountName, 
                         dbo.vw_CustomerAccounts.Reference1, dbo.vfin_ExternalCheques.Id
FROM            dbo.vfin_ExternalCheques INNER JOIN
                         dbo.vw_CustomerAccounts ON dbo.vfin_ExternalCheques.CustomerAccountId = dbo.vw_CustomerAccounts.Id
						 INNER JOIN 
						dbo.vfin_ChequeTypes On dbo.vfin_ChequeTypes.id = dbo.vfin_ExternalCheques.ChequeTypeId
WHERE        (dbo.vfin_ExternalCheques.CustomerAccountId IS NOT NULL) and isnull(dbo.vfin_ExternalCheques.ClearedDate,@EndDate)>=@EndDate

