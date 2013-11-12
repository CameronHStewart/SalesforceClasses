/*
 * This class will be used to help build records for other classes
 * @Author Brightgen
 * @Created 2013/10/23
 * @LastUpdated 2013/10/25
 */
public with sharing class Record_Builder {
	/*
	 * This method will create an account record with the minimum required fields to insert it
	 * @Param Name the name of the account
	 * @return A salesforce Account object
	 */
	public static Account createMinimumAccount(String Name) {
		Account account = new Account();
		account.Name = Name; //Required field
		
		return account;
	}
	
	/*
	 * This method will insert an account record with the minimum required fields to insert it
	 * @Param Name the name of the account
	 */
	public static void insertMinimumAccount(String Name) {
		insert createMinimumAccount(Name);
	}

	/*
	 * This method will create an opportunity record with the minimum required fields to insert it
	 * @Param Name the name of the opportunity
	 * @return A salesforce Account object
	 */
	public static Opportunity createMinimumOpportunity(String Name, String Stage, Date CloseDate) {
		Opportunity opportunity = new Opportunity();
		opportunity.Name = Name; //Required field
		opportunity.StageName = Stage;
		opportunity.CloseDate = CloseDate;
		
		return opportunity;
	}
	
	/*
	 * This method will insert an opportunity record with the minimum required fields to insert it
	 * @Param Name the name of the opportunity
	 */
	public static void insertMinimumOpportunity(String Name, String Stage, Date CloseDate) {
		insert createMinimumOpportunity(Name, Stage, CloseDate);
	}

}