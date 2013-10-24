/*
 * This class will be used to help build records for other classes
 * @Author Brightgen
 * @Created 2013/10/23
 * @LastUpdated 2013/10/23
 */
public with sharing class bg_Record_Builder {
	/*
	 * This method will return you the Id of the record type specified
	 * @Param sObjectName The name of the object the record type belongs to
	 * @Param RecordTypeName The name of the record type
	 */
	public static Id getRecordTypeId(String sObjectName, String RecordTypeName) {
		return [Select R.Name, R.Id, R.SobjectType from RecordType R Where R.SobjectType = :sObjectName And R.Name = :RecordTypeName].Id;
	}
	
	/*
	 * This method will print out a formatted version of your message and the variable you want to print
	 * @Param message The message you want to print out
	 * @Param Variable The variable to be printed out
	 */
	public static void debugVariable(String message, object Variable) {
		System.debug(message + '[' + Variable + ']');
	}
	
	/*
	 * This method will print out a formatted version of your message and the variable you want to print
	 * @Param message The message you want to print out
	 * @Param Variable The variable to be printed out
	 * @Param objectVariable The object representation of the class called from
	 * @Example debugVariable(this, 'Error', variable);
	 * @Note The this variable can only be used in instances of the class
	 */
	public static void debugVariable(object objectVariable, String message, object Variable) {
		//String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
		System.debug(String.valueOf(objectVariable).substring(0,String.valueOf(objectVariable).indexOf(':')) + ' ' + message + '[' + Variable + ']');
	}
	
	/*
	 * This method will create a booking with the minimum required fields to insert it
	 * @return A salesforce booking__c object
	 */
	public static Booking__c createMinimumBooking() {
		return new Booking__c();
	}
	
	/*
	 * This method will insert a booking with the minimum required fields to insert it
	 */
	public static void insertMinimumBooking() {
		insert createMinimumBooking();
	}
	
	/*
	 * This method will create an agency record with the minimum required fields to insert it
	 * @Param Name the name of the agency
	 * @return A salesforce Account object
	 */
	public static Account createMinimumAgency(String Name) {
		Account agency = new Account();
		agency.RecordTypeId = getRecordTypeId('Account', 'Agency');
		agency.Name = Name; //Required field
		
		return agency;
	}
	
	/*
	 * This method will insert an agency record with the minimum required fields to insert it
	 * @Param Name the name of the agency
	 */
	public static void insertMinimumAgency(String Name) {
		insert createMinimumAgency(Name);
	}
	
	/*
	 * This method will create a client record with the minimum required fields to insert it
	 * @Param Name the name of the client
	 * @return A salesforce Account object
	 */
	public static Account createMinimumClient(String Name) {
		Account agency = new Account();
		agency.RecordTypeId = getRecordTypeId('Account', 'Client');
		agency.Name = Name; //Required field
		
		return agency;
	}
	
	/*
	 * This method will insert a client record with the minimum required fields to insert it
	 * @Param Name the name of the client
	 */
	public static void insertMinimumClient(String Name) {
		insert createMinimumClient(Name);
	}
	
	/*
	 * This method will create a publication record with the minimum required fields to insert it. One of the 
	 * target audienced must me true;
	 * @Param Action Lad Is the target audience action lad
	 * @Param Action Man Is the target audience action man
	 * @Param Action Dad Is the target audience action dad
	 * @return A salesforce Account object
	 */
	public static Publications__c createMinimumPublication(boolean isActionLad, boolean isActionMan, boolean isActionDad) {
		Publications__c publication = new Publications__c();
		publication.Action_Lad_Target__c = true;
		publication.Action_Man_Targe__c = true;
		publication.Action_Dad_Target__c = true; //Required field
		
		return publication;
	}
	
	/*
	 * This method will create a publication record with the minimum required fields to insert it. One of the 
	 * target audienced must me true;
	 * @Param Action Lad Is the target audience action lad
	 * @Param Action Man Is the target audience action man
	 * @Param Action Dad Is the target audience action dad
	 * @Param Name the name of the client
	 */
	public static void insertMinimumPublication(boolean isActionLad, boolean isActionMan, boolean isActionDad) {
		insert createMinimumPublication(isActionLad, isActionMan, isActionDad);
	}
	
	/*
	 * This method will create a flat plan record with the minimum required fields to insert it
     * @return A salesforce Flat_Plan__c object
	 */
	public static Flat_Plan__c createMinimumFlatPlan() {
		Flat_Plan__c flatPlan = new Flat_Plan__c();
		return flatPlan;
	}
	
	/*
	 * This method will insert a flat plan record with the minimum required fields to insert it
	 */
	public static void insertMinimumFlatPlan() {
		insert createMinimumFlatPlan();
	}
	
	/*
	 * This method will create a flat plan position record with the minimum required fields to insert it
	 * @Param FlatPlanId The Id of the relate flat plan
     * @return A salesforce Flat_Plan__c object
	 */
	public static Flat_Plan_Position__c createMinimumFlatPlanPosition(Id FlatPlanId) {
		Flat_Plan_Position__c flatPlanPosition = new Flat_Plan_Position__c();
		flatplanposition.Flat_Plan__c = FlatPlanId; //Required field
		
		return flatplanposition;
	}
	
	/*
	 * This method will insert a flat plan position record with the minimum required fields to insert it
     * @Param FlatPlanId The Id of the relate flat plan
	 */
	public static void insertMinimumFlatPlanPosition(Id FlatPlanId) {
		insert createMinimumFlatPlanPosition(FlatPlanId);
	}
	
	/*
	 * This method will create an opportunity record with the minimum required fields to insert it
	 * @Param FlatPlanId The Id of the relate flat plan
     * @return A salesforce Flat_Plan__c object
	 */
	public static Opportunity createMinimumOpportunity(String Name, String StageName, Date CloseDate, Id Agency,
													   Id Client, Id Publication, String AdType, Id FlatPlanPosition) {
		Opportunity opportunity = new Opportunity();
		opportunity.Name = Name; //Required field
		opportunity.StageName = StageName; //Required field
		opportunity.CloseDate = CloseDate; //Required field
		opportunity.Agency__c = Agency; //Required field
		opportunity.Client__c = Client; //Required field
		opportunity.Publication__c = Publication; //Required field
		opportunity.Ad_Type__c = AdType; //Required field
		opportunity.Flat_Plan_Position__c = FlatPlanPosition; //Required field
		
		return opportunity;
	}
	
	/*
	 * This method will insert an opportunity record with the minimum required fields to insert it
     * @Param FlatPlanId The Id of the relate flat plan
	 */
	public static void insertMinimumOpportunity(String Name, String StageName, Date CloseDate, Id Agency,
											    Id Client, Id Publication, String AdType, Id FlatPlanPosition) {
		insert createMinimumOpportunity(Name, StageName, CloseDate, Agency, Client, Publication, AdType, FlatPlanPosition);
	}
}