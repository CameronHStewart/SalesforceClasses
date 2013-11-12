/*
 * This class tests the functionality of the content toll up class
 */
@isTest
private class Lookup_Content_Roll_Up_Tests {
	public static void insertOpportunityWithAmountAndAccountLookup(String Name, String Stage, Date CloseDate, Decimal Amount, Id Id) {
		Opportunity opportunity = Record_Builder.createMinimumOpportunity(Name, Stage, CloseDate);
		opportunity.Amount = Amount;
		opportunity.AccountId = Id;
		insert opportunity;
	}
	static testMethod void myUnitTest() {
		Record_Builder.insertMinimumAccount('Test Account 1');
		Opportunity op = new Opportunity();
		
		Id accountId = [Select Id From Account Where Name = 'Test Account 1' limit 1].Id;
		
		insertOpportunityWithAmountAndAccountLookup('Test Opportunity 1', 'New', Date.newInstance(2013,10,10), 10.0, accountId);
		Account account = [Select AnnualRevenue From Account Where Name = 'Test Account 1' limit 1];
		System.assertEquals(10, account.AnnualRevenue);
		
		insertOpportunityWithAmountAndAccountLookup('Test Opportunity 2', 'New', Date.newInstance(2013,10,10), 11.0, accountId);
		account = [Select AnnualRevenue From Account Where Name = 'Test Account 1' limit 1];
		System.assertEquals(21, account.AnnualRevenue);
		
		insertOpportunityWithAmountAndAccountLookup('Test Opportunity 3', 'New', Date.newInstance(2013,10,10), 12.0, accountId);
		account = [Select AnnualRevenue From Account Where Name = 'Test Account 1' limit 1];
		System.assertEquals(33, account.AnnualRevenue);
		
		insertOpportunityWithAmountAndAccountLookup('Test Opportunity 4', 'New', Date.newInstance(2013,10,10), 13.0, accountId);
		account = [Select AnnualRevenue From Account Where Name = 'Test Account 1' limit 1];
		System.assertEquals(46, account.AnnualRevenue);
		
		insertOpportunityWithAmountAndAccountLookup('Test Opportunity 5', 'New', Date.newInstance(2013,10,10), 14.0, accountId);
		account = [Select AnnualRevenue From Account Where Name = 'Test Account 1' limit 1];
		System.assertEquals(60, account.AnnualRevenue);
	}
}