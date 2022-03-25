IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_Procedure') BEGIN
   EXEC('CREATE PROC [dbo].[sp_Procedure] as')
END
GO

--select * from temploanposting
ALTER procedure [dbo].[sp_Procedure] 

as
begin
	declare @JournalID uniqueidentifier =newid()

	insert into vfin_Journals (Id, PostingPeriodId, BranchId, JournalVoucherId, FiscalCountId, DebitCardLogId, TotalValue, PrimaryDescription, SecondaryDescription, Reference, 
                         ApplicationUserName, EnvironmentUserName, EnvironmentMachineName, EnvironmentDomainName, EnvironmentOSVersion, EnvironmentMACAddress, 
                         EnvironmentMotherboardSerialNumber, EnvironmentProcessorId, ModuleNavigationItemCode, IsLocked, CreatedDate)
	
	SELECT        JournalID, PostingPeriodId, BranchId, JournalVoucherId, FiscalCountId, DebitCardLogId, TotalValue, primaryDescription, SecondaryDescription, Reference, 
							 ApplicationUserName, EnvironmentUserName, EnvironmentMachineName, EnvironmentDomainName, EnvironmentOSVersion, EnvironmentMACAddress, 
							 EnvironmentMotherboardSerialNumber, EnvironmentProcessorId, ModuleNavigationItemCode, IsLocked, CreatedDate 
	 FROM            tempLoanPosting

	insert into   vfin_JournalEntries(Id, JournalId, ChartOfAccountId, ContraChartOfAccountId, CustomerAccountId, Amount, CreatedDate)
	SELECT        newid(), JournalID, ChartOfAccountId, '3F0E3661-52EA-C90C-A2AE-08D10CB839E9', CustomerAccountId, TotalValue*-1, CreatedDate
	FROM           tempLoanPosting

	insert into   vfin_JournalEntries(Id, JournalId, ChartOfAccountId, ContraChartOfAccountId, CustomerAccountId, Amount, CreatedDate)
	SELECT        newid(), JournalID,  '3F0E3661-52EA-C90C-A2AE-08D10CB839E9', ChartOfAccountId, CustomerAccountId, TotalValue, CreatedDate
	FROM            tempLoanPosting



end


---delete from vfin_journals where id in (select id from tempLoanPosting)
---delete from vfin_journalentries where journalid in (select id from tempLoanPosting)
---select * from vfin_JournalEntries
---update tempLoanPosting set journalid=newid()
---delete from vfin_Journalentries where JournalId in (select JournalId from tempLoanPosting)
---delete from vfin_Journals where id in (select JournalId from tempLoanPosting)
GO
