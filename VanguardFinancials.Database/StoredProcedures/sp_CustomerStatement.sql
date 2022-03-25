IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_CustomerStatement') BEGIN
   EXEC('CREATE PROC [dbo].[sp_CustomerStatement] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CustomerStatement]    Script Date: 9/13/2014 3:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---sp_CustomerStatement 20765,'04/01/2014','04/30/2014'
ALTER PROCEDURE [dbo].[sp_CustomerStatement] 
(
	@MemberShipNumber varchar(10),@StartDate datetime, @Enddate datetime
)
as
SELECT  
dbo.vfin_JournalEntries.Id,      
isnull(case
when amount<0 then amount*-1 
end ,0) as Debit,
isnull(case
when amount>0 then amount
end ,0) as Credit,amount ,dbo.vfin_JournalEntries.CreatedDate, dbo.vfin_Journals.PrimaryDescription, dbo.vfin_Journals.SecondaryDescription, 
                         dbo.vfin_Journals.Reference, Products_1.Description
 INTO #temp FROM            dbo.Products(1) AS Products_1 INNER JOIN
                         dbo.vfin_JournalEntries ON Products_1.ChartOfAccountId = dbo.vfin_JournalEntries.ChartOfAccountId INNER JOIN
                         dbo.vfin_CustomerAccounts INNER JOIN
                         dbo.vfin_Customers ON dbo.vfin_CustomerAccounts.CustomerId = dbo.vfin_Customers.Id INNER JOIN
                         dbo.vfin_Branches ON dbo.vfin_CustomerAccounts.BranchId = dbo.vfin_Branches.Id ON 
                         dbo.vfin_JournalEntries.CustomerAccountId = dbo.vfin_CustomerAccounts.Id INNER JOIN
                         dbo.vfin_Journals ON dbo.vfin_JournalEntries.JournalId = dbo.vfin_Journals.Id
WHERE        (dbo.vfin_Customers.serialnumber = @MemberShipNumber) 

select *,
(SELECT SUM(b.Amount) 
                           FROM #temp b
                               WHERE b.CreatedDate <= a.CreatedDate
                               AND b.Description = a.Description)
AS RunningTotal into #temp2    from #temp a order by Description,CreatedDate

select * from #temp2 where Createddate between @StartDate and @Enddate
--SELECT * FROM vfin_JournalEntries WHERE ID='84D76F19-BE25-C14F-42AC-08D11C4BED7D'



