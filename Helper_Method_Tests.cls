/*
 * This class will be used to facilitate the trigger creation of ASP objects from the case
 * @Author: Brightgen
 * @Created 2013/11/12
 */
public with sharing class bg_Case_ASP_Creation_Helper{
	private static List<Case> checkChangeCriteria(List<Case> newCases, List<Case> oldCases) {
		return (List<Case>) bg_Helper_Methods.getAllRecordsThatHaveChanged(newCases, oldCases, new String[] {'Status'});
	}
	
	public static void createNeededASPRecords(List<Case> newCases, List<Case> oldCases) {
		createNeededASPRecords(checkChangeCriteria(newCases, oldCases));
	}
	public static void createNeededASPRecords(List<Case> newCases) {
		List<Case> ASPCases = new List<Case>();
		/*
		 * Genreate a list of cases that need to have asp records created for them
		 */
		Map<String, object[]> recordMatchingMap = new Map<String, object[]>();
		recordMatchingMap.put('Status', new object[] {'Approved'});
		recordMatchingMap.put('RecordTypeId', new object[] {bg_Helper_Methods.getRecordTypeId('Case', 'Request_For_ASP')});
		ASPCases = bg_Helper_Methods.getAllRecordsThatHaveValues(newCases, recordMatchingMap);
		/*
		 * Generate CHI Lead Map  and Quotes Map
		 */
		Map<string, sObject> genericCHILeadMap = bg_Helper_Methods.getFieldObjectMap(ASPCases, 'CHI_Lead__c', new String[] {'Id'});
		/*
		 * Change this to pull Quotes linking to the opportunity
		 */
		Map<String, object[]> QuoteFilter = new Map<String, object[]>();
		QuoteFilter.put('Is_Primary__c', new object[] {true});
		Map<string, sObject> genericQuoteMap = bg_Helper_Methods.getFieldChildObjectMapAndFilter(genericCHILeadMap.values(), 'BigMachines_Quote__c', 'Opportunity__c', new String[] {'Id', 'Opportunity__c', 'Is_Primary__c'},QuoteFilter);

		/*
		 * Create asp records for those cases
		 */
		List<ASP__c> casesToInsert = new List<ASP__c>();
		Map<string, sObject> genericASPMap = bg_Helper_Methods.getFieldChildObjectMap(ASPCases, 'ASP__c', 'Related_CHI_Lead__c', new String[] {'Id'});
		
		for(Case ASPCase : ASPCases) {
			if(!genericASPMap.containsKey(ASPCase.Id)) {
				ASP__c asp = new ASP__c();
				asp.Function__c = ASPCase.Function__c;
				asp.Definition__c = ASPCase.Definition__c;
				asp.Material_Return_Info__c = ASPCase.Material_Return_Info__c;
				asp.Picklist__c = ASPCase.Reason__c;
				asp.Charge_to_Customer__c = ASPCase.Charge_to_Customer__c;
				asp.Request_For_ASP__c = ASPCase.Id;
				/*
				 * Populate the case Id from the opportunity and case
				 */
				Id CHILeadId;
				if(genericCHILeadMap.containsKey(ASPCase.CHI_Lead__c)) {
					CHILeadId = genericCHILeadMap.get(ASPCase.CHI_Lead__c).Id;
				}
				Id QuoteId;
				Map<string, sObject> filteredQuotes = bg_Helper_Methods.FilterMap(genericQuoteMap, QuoteFilter);
				if(filteredQuotes.values().size() > 0) {
					QuoteId = filteredQuotes.values().get(0).Id;
				} 
				asp.Quote__c = QuoteId;
				casesToInsert.add(asp);
			}
		}
		insert casesToInsert;
	}
}