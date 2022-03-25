IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_CustomerAccountBalanceAvailable') BEGIN
   EXEC('CREATE PROC [dbo].[sp_CustomerAccountBalanceAvailable] as')
END
GO
-- =============================================
-- Author:		Centrino
-- Create date: 01.06.2014
-- Description:	Customer AccountBalance Available
-- =============================================

ALTER PROCEDURE [dbo].[sp_CustomerAccountBalance] 
	-- Add the parameters for the stored procedure here
	@CustomerAccountID Varchar(100) = 0, 
	@Type int = 0,
	@considerMaturityPeriodForInvestmentAccounts bit =0,
	@CutoffDate DateTime,
	@CustomerAccountType_TargetProductId Uniqueidentifier,
	@CustomerAccountType_ProductCode Int
AS
	Declare @Balance numeric(18,2)
	Declare @MinBalance numeric(18,2)

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
		set @CutoffDate=	(select DATEADD(day, DATEDIFF(day, 0, @CutoffDate), '23:59:59'));

	SET NOCOUNT ON;

	Declare @ProductID uniqueidentifier=@CustomerAccountType_TargetProductId,
			@Days int,
			@EndDate Datetime,
			@unMaturedAmount Numeric(18,2),
			@UnclearedCheques Numeric(18,2),
			@UnclearedChequesChartOfAccountID uniqueidentifier,
			@InterestReceivableChartOfAccountID Uniqueidentifier,
			@ChartOfAccountID UniqueIdentifier

	set @InterestReceivableChartOfAccountID=(SELECT InterestReceivableChartOfAccountId FROM vfin_LoanProducts WHERE ID =@ProductID)

	set @ChartOfAccountID= (
		SELECT case 
		when @CustomerAccountType_ProductCode=1 then 
		(select       ChartOfAccountId FROM vfin_SavingsProducts  WHERE        (id =@ProductID))
		when @CustomerAccountType_ProductCode=2 then 
		(select       ChartOfAccountId FROM vfin_LoanProducts  WHERE        (id =@ProductID))
		when @CustomerAccountType_ProductCode=3 then 
		(select       ChartOfAccountId FROM vfin_InvestmentProducts  WHERE        (id =@ProductID))
		end)
	set @UnclearedChequesChartOfAccountID=
							(
							  SELECT[ChartOfAccountId]
							  FROM [dbo].[vfin_SystemGeneralLedgerAccountMappings] 
							  WHERE SystemGeneralLedgerAccountCode=48827
						)
	set @days=iif(@considerMaturityPeriodForInvestmentAccounts=1,(select MaturityPeriod from vfin_InvestmentProducts where id=@ProductID),0)

	set @EndDate=Dateadd(d,@days*-1,@CutoffDate)
	set @unMaturedAmount=
	isnull((SELECT        SUM(dbo.vfin_JournalEntries.Amount) AS Expr1
			FROM         dbo.vfin_JournalEntries WITH (NOLOCK) INNER JOIN
                         dbo.vfin_Journals ON dbo.vfin_JournalEntries.JournalId = dbo.vfin_Journals.Id INNER JOIN
                         dbo.vfin_CustomerAccounts ON dbo.vfin_JournalEntries.CustomerAccountId = dbo.vfin_CustomerAccounts.Id INNER JOIN
                         dbo.vfin_InvestmentProducts ON dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductId = dbo.vfin_InvestmentProducts.Id AND 
                         dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_InvestmentProducts.ChartOfAccountId
			WHERE        (dbo.vfin_JournalEntries.CustomerAccountId = @CustomerAccountID)  AND (dbo.vfin_InvestmentProducts.Id = @ProductID) AND 
                         (dbo.vfin_Journals.CreatedDate >= @EndDate)
						 AND  (dbo.vfin_Journals.ModuleNavigationItemCode <> ('64426'))),0)

	Select @UnclearedCheques= 
	isnull((
						(
					SELECT        SUM(dbo.vfin_JournalEntries.Amount) AS Expr1
					FROM            dbo.vfin_JournalEntries WITH (NOLOCK) INNER JOIN
											 dbo.vfin_Journals ON dbo.vfin_JournalEntries.JournalId = dbo.vfin_Journals.Id
					WHERE        (dbo.vfin_JournalEntries.CustomerAccountId = @CustomerAccountID) 
					and ChartOfAccountId  =@UnclearedChequesChartOfAccountID
				)

	),0)
	SELECT @Balance = 
		CASE 
			WHEN @Type=1 THEN ---Account Balance
				(
					SELECT        SUM(dbo.vfin_JournalEntries.Amount) AS Expr1
					FROM            dbo.vfin_JournalEntries WITH (NOLOCK) INNER JOIN
											 dbo.vfin_Journals ON dbo.vfin_JournalEntries.JournalId = dbo.vfin_Journals.Id
					WHERE        (dbo.vfin_JournalEntries.CustomerAccountId = @CustomerAccountID) 
					AND (dbo.vfin_JournalEntries.ChartOfAccountId =@ChartOfAccountID)
					and vfin_Journals.CreatedDate<=@CutoffDate
				)
			 ELSE  --- AccountInterest

				(		SELECT SUM(dbo.vfin_JournalEntries.Amount) 
						FROM   dbo.vfin_JournalEntries WITH (NOLOCK)
						WHERE CustomerAccountId =@CustomerAccountId 
						 and ChartOfAccountId =@InterestReceivableChartOfAccountID
						 and CreatedDate<=@CutoffDate
				)
			  END 
			  select @Balance= CASE 
			  WHEN @considerMaturityPeriodForInvestmentAccounts=1 THEN  @Balance-@unMaturedAmount
			  ELSE
				   @Balance+isnull(@UnclearedCheques,0)
			  END 
SELECT ISNULL(@Balance,0) as Balance
END

