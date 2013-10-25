/*
 * This class will be used to test the record builder methods
 * @Author Brightgen
 * @Created 2013/10/35
 * @LastUpdated 2013/10/25
 */
@isTest
private class bg_Record_Builder_Tests {
	/*
	 * This test method is tesing that a map of Id's to record for the same record can be created
	 */
	static testMethod void TestGenerationOfObjectMap() {
		/*
		 * Test setup
		 */
		bg_Record_Builder.insertMinimumAccount('Test Account 1');
		
		/*
		 * Get a list of accounts to use in the getFieldObjectMap function
		 */
		List<Account> accounts = [Select Id, OwnerId, Name From Account Where Name = 'Test Account 1'];
		
		/*
		 * Generate the fields map
		 */
		Map<string, object> fieldMap = bg_Record_Builder.getFieldObjectMap(accounts, 'Id', new String[] {'Id'});
		
		/*
		 * Assert 1 - Check that the map has been create correctly
		 */
		System.assertEquals(1, fieldMap.size(), 'Incorrect number of Map records created');
	}
	
	/*
	 * This test method is tesing that a map of Id's to record for a different record
	 */
	static testMethod void TestGenerationOfObjectMapForRelatedObject() {
		/*
		 * Test setup
		 */
		bg_Record_Builder.insertMinimumAccount('Test Account 1');
		
		/*
		 * Get a list of accounts to use in the getFieldObjectMap function
		 */
		List<Account> accounts = [Select Id, OwnerId, Name From Account Where Name = 'Test Account 1'];
		
		/*
		 * Generate the fields map
		 */
		Map<string, object> fieldMap = bg_Record_Builder.getFieldObjectMap(accounts, 'OwnerId', new String[] {'Id'});
		
		/*
		 * Assert 1 - Check that the map has been create correctly
		 */
		System.assertEquals(1, fieldMap.size(), 'Incorrect number of Map records created');
	}
}