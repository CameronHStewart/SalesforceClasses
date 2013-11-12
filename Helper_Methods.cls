/*
 * This class contains a collection of helper methods
 */
public class Helper_Methods{
	/*
	 * This method will return a set if Ids on the list of objects passed in
	 * @Param Records The list of records the side of Id's will be generated from
	 */
	public static Set<Id> getIdSet(List<sObject> Records) {
		Set<Id> recordIds = new Set<Id>();
		for(sObject record : records) {
			if(!recordIds.contains(record.Id)) {
				recordIds.add(record.Id);
			}
		}
		return recordIds;
	}
	
	/*
	 * This method will return a map of field values relating to an object
	 * @Param Records A list of sObjects used to retrive the Ids from
	 */
	public static Map<String, sObject> getIdObjectMap(List<sObject> Records) {
		Map<String, sObject> objectMap = new Map<String, sObject>();
		for(sObject Record : Records) {
			objectMap.put(Record.Id, Record);
		}
		return objectMap;
	}
	
	/*
	 * This method will return a set if the specified field name on the list of objects passed in
	 * @Param Records The list of records the side of Id's will be generated from
	 * @Param FieldName The field name used to retrieve the values for the set
	 * @Note This method doesn't catch any exceptions. The field not existing will need to be delt with.
	 */
	public static Set<object> getIdSet(List<sObject> Records, String FieldName) {
		Set<object> recordIds = new Set<object>();
		for(sObject record : records) {
			if(!recordIds.contains(record.get(FieldName))) {
				recordIds.add(record.get(FieldName));
			}
		}
		return recordIds;
	}
	
	public static string getLookupFieldUpObjectType(List<sObject> Records, String FieldName) {
		/*
		 * Get field schema information
		 */
		Map<String, Schema.SObjectType> GlobalMap = Schema.getGlobalDescribe();
		sObject firstRecord = Records.get(0);
		Schema.DescribeSObjectResult obj = GlobalMap.get(string.valueOf(firstRecord.getSObjectType())).getDescribe();
		Schema.DescribeFieldResult FieldInformation = obj.Fields.getMap().get(FieldName).getDescribe();
		
		/*
		 * Check that the object is an external Id, Id or lookup and through an exception if not
		 */
		if(!FieldInformation.isIdLookup() && !FieldInformation.isNamePointing() && FieldInformation.getRelationshipName() == null) {
			throw new Custom_Exceptions.InvalidFieldException('The field specified needs to be an Id, External Id or a lookup to be used in the getFieldObjectMap method');
		}
		
		/*
		 * Get the name of the related object to the field
		 */
		return FieldInformation.getReferenceTo().size() == 0? string.valueOf(firstRecord.getSObjectType()) : string.valueOf(FieldInformation.getReferenceTo().get(0));
	}
	
	/*
	 * This method will return a map of field values relating to an object
	 * @Param Records A list of sObjects used to retrive the Ids from
	 * @Param FieldName The field name used to retrieve the keys for the map
	 * @Param FieldsNeeded The fields needed off the related object
	 * @TODO
	 * 		- Make the function work with external Ids
	 * @Note This method doesn't catch any exceptions. The field not existing will need to be delt with.
	 * @Exception InvalidFieldException
	 */
	public static Map<String, sObject> getFieldObjectMap(List<sObject> Records, String FieldName, String[] FieldsNeeded) {			
		/*
		 * Get the name of the related object to the field
		 */
		string relatedObject = getLookupFieldUpObjectType(Records, FieldName);
		
		Set<object> sObjectIds = getIdSet(records, FieldName);
		
		/*
		 * Implement building up the database query
		 */
		String fieldToSelect = String.Join(FieldsNeeded, ',');
		List<object> IdsList = new List<object>();
		IdsList.addAll(sObjectIds);
		String Ids = convertToQueryString(IdsList);
		
		/*
		 * Id is hard coded and will need to be changed to work with external Ids
		 */
		String query = 'Select ' + fieldToSelect + ' From ' + relatedObject + ' Where Id In ' + Ids;
		debugVariable('Cameron getIdObjectMap(', getIdObjectMap(Database.query(query)));
		return getIdObjectMap(Database.query(query));
	}
	
	public static String convertToQueryString(Set<object> setValues) {
		List<object> IdsList = new List<object>();
		IdsList.addAll(setValues);
		String Ids = '(\'' + String.Join(IdsList, '\',\'') + '\')';
		return Ids;
	}
	
	public static String convertToQueryString(List<object> ListValues) {
		String Ids = '(\'' + String.Join(ListValues, '\',\'') + '\')';
		return Ids;
	}
	
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
	 * This method will return a list of sObjects where a certain field of them has updated
     * @param List<sObject> A list of sObject to update
	 * @param List<sObject> A list of sObject before the triggers have changed them
	 * @Param String A field name to check if it has been changed
	 * @TODO Look at implementing a list of field names to compare against
	 */
	public static List<sObject> getAllRecordsThatHaveChanged(List<sObject> sObjectNew, List<sObject> sObjectOld, String FieldName) {
		/*
		 * Generate new sObject Map
		 */
		Map<String, sObject> sObjectMap = getIdObjectMap(sObjectNew);
		
		/*
		 * Check if the sObject has changed and add them to a list
		 */
		List<sObject> sObjectList = new List<sObject>();
		for(sObject sObjectRecord : sObjectOld) {
			if(sObjectMap.get(sObjectRecord.Id).get(FieldName) != sObjectRecord.get(FieldName)) {
				sObjectList.add(sObjectRecord);
			}	
		}
		return sObjectList;
	}
	
	/*
	 * This method will return a list of sObjects where a certain field of them has not updated
     * @param List<sObject> A list of sObject to update
	 * @param List<sObject> A list of sObject before the triggers have changed them
	 * @Param String A field name to check if it has been changed
	 * @TODO Look at implementing a list of field names to compare against
	 */
	public static List<sObject> getAllRecordsThatHaveNotChanged(List<sObject> sObjectNew, List<sObject> sObjectOld, String FieldName) {
		/*
		 * Remove all objects that have changed from the new sObject list
		 */
		Set<sObject> records = new Set<sObject>(sObjectNew);
		records.removeAll(getAllRecordsThatHaveChanged(sObjectNew, sObjectOld, FieldName));
		
		/*
		 * Return a list of records that haven't changed
		 */
		return new List<sObject>(records);
	}
}