/*
 * This class will test the record builder methods
 */
@isTest
private class Record_Builder_Tests {
	/*
	 * Account CRUD Tests
	 */
	static testMethod void CreateAccountTest() {
		Record_Builder.insertMinimumAccount('Test Account');
		
		List<Account> accounts = [Select Id, Name From account Where Name = 'Test Account'];
		
		System.assertEquals(1, accounts.Size(), 'Incorrect number of accounts found');
	}
	static testMethod void UpdateAccountTest() {
		Record_Builder.insertMinimumAccount('Test Account');
		
		List<Account> accounts = [Select Id, Name From account Where Name = 'Test Account'];
		accounts.get(0).Name = 'Test Account Updated';
		upsert accounts;
		
		accounts = [Select Id, Name From account Where Name = 'Test Account Updated'];
		
		System.assertEquals(1, accounts.size(), 'Incorrect number of accounts found');
	}
	static testMethod void DeleteAccountTest() {
		Record_Builder.insertMinimumAccount('Test Account');
		
		List<Account> accounts = [Select Id, Name From account Where Name = 'Test Account'];
		delete accounts;
		
		accounts = [Select Id, Name From account Where Name = 'Test Account'];
		
		System.assertEquals(0, accounts.size(), 'Incorrect number of accounts found');
	}
	static testMethod void BulkCreateAccountTest() {
		List<Account> accounts = new List<Account>();
		for(Integer i = 0; i < 500; i++) {
			accounts.add(Record_Builder.createMinimumAccount('Test Account' + i));
		}
		
		insert accounts;
		
		List<Account> insertedAccounts = [Select Id, Name From account];
		
		System.assertEquals(500, insertedAccounts.size(), 'Incorrect number of accounts found');
	}
	static testMethod void BulkUpdateAccountTest() {
		List<Account> accounts = new List<Account>();
		for(Integer i = 0; i < 500; i++) {
			accounts.add(Record_Builder.createMinimumAccount('Test Account' + i));
		}
		
		insert accounts;
		
		List<Account> insertedAccounts = [Select Id, Name From account];
		
		for(Account account : insertedAccounts) {
			account.Name = 'Updated Account';
		}
		
		upsert insertedAccounts;
		List<Account> updatedAccounts = [Select Id, Name From account Where Name = 'Updated Account'];
		
		System.assertEquals(500, updatedAccounts.size(), 'Incorrect number of accounts found');
	}
	static testMethod void BulkDeleteAccountTest() {
		List<Account> accounts = new List<Account>();
		for(Integer i = 0; i < 500; i++) {
			accounts.add(Record_Builder.createMinimumAccount('Test Account' + i));
		}
		
		insert accounts;
		
		delete [Select Id, Name From account];
		
		List<Account> deletedAccounts = [Select Id, Name From account];
		
		System.assertEquals(0, deletedAccounts.size(), 'Incorrect number of accounts found');
	}
}