public class Lookup_Content_Rollup{
	/*
	 * This method is to be used on the insert and update of a record to provide the same value of the content roll up count on a lookup field
	 * @Param records This is the list of records that have a related object with a count field to update
	 * @Param countField This is the api field name on the related object that needs to be updated
	 * @Param This is the field that is used to lookup the related object on the records
	 */
	public static void contentRollUpSum(List<sObject> records, String localSumField , String relatedSumField, String lookUpField) {
		/*
		 * Generate the list of booking Ids
		 */
        Set<object> RelatedObjectIds = new Set<object>();
		Set<object> CurrentObjectIds = new Set<object>();
		Map<String, double> RelatedObjectTotalMap = new Map<string, double>();
        for(sObject record : records) {
			Id currentRelatedObjectIdValue = (Id) record.get(lookUpField);
            if(!RelatedObjectIds.contains(currentRelatedObjectIdValue)) {
                RelatedObjectIds.add(currentRelatedObjectIdValue);
				CurrentObjectIds.add(record.Id);
				if(RelatedObjectTotalMap.containsKey(currentRelatedObjectIdValue)) {
					Decimal total = RelatedObjectTotalMap.get(currentRelatedObjectIdValue) + (Decimal) record.get(localSumField);
					//Line added to fix potential issue
					RelatedObjectTotalMap.put(currentRelatedObjectIdValue, total);
				} else {
					if(opportunity.Amount == null) {
						RelatedObjectTotalMap.put(currentRelatedObjectIdValue, 0);
					} else {
						RelatedObjectTotalMap.put(currentRelatedObjectIdValue, (Decimal) record.get(localSumField));
					}
				}
            }
        }
		
		/*
		 * Retrieve the opportunity totals for each booking
		 */
		String relatedObjectName = Helper_Methods.getLookupFieldUpObjectType(records, lookUpField);
		String currentObjectName = Helper_Methods.getLookupFieldUpObjectType(records, 'Id');
		String query = 'Select ' + lookUpField +',sum(' + localSumField + ') Amount_Sum From '+ currentObjectName +' Where Id not In ' + Helper_Methods.convertToQueryString(CurrentObjectIds) + ' And ' +
						localSumField + ' != null Group By ' + lookUpField;
        AggregateResult[] RelatedObjectTotals = Database.query(query);
		System.debug('Cameron RelatedObjectTotals [' + RelatedObjectTotals + ']');
        for (AggregateResult RelatedObjectTotal : RelatedObjectTotals)  {
			if(RelatedObjectTotalMap.containsKey(string.valueOf(RelatedObjectTotal.get(lookUpField)))) {
				Decimal total = RelatedObjectTotalMap.get(string.valueOf(RelatedObjectTotal.get(lookUpField))) + (Decimal) RelatedObjectTotal.get('Amount_Sum');
				//Line added to fix potential issue
				RelatedObjectTotalMap.put(string.valueOf(RelatedObjectTotal.get(lookUpField)), total);
			} else {
				RelatedObjectTotalMap.put(string.valueOf(RelatedObjectTotal.get(lookUpField)), double.valueOf(RelatedObjectTotal.get('Amount_Sum')));
			}
        }
		
		/*
		 * Update the total in the booking and upsert all the bookings
		 */ 
		query = 'Select Id, ' + relatedSumField + ' From ' + relatedObjectName + ' Where Id In ' + Helper_Methods.convertToQueryString(RelatedObjectIds);
        List<sObject> relatedObjects = database.query(query);
        for(sObject relatedObject : relatedObjects) {
			if(relatedObject.get(relatedSumField) == null) {
				relatedObject.put(relatedSumField, 0.0);
			}
            if(RelatedObjectTotalMap.ContainsKey((Id) relatedObject.get('Id')) && RelatedObjectTotalMap.get((Id) relatedObject.get('Id')) != null) {
				double total = (Decimal) relatedObject.get(relatedSumField) + (Decimal) RelatedObjectTotalMap.get((Id) relatedObject.get('Id'));
				relatedObject.put(relatedSumField, total);
            }
        }
		
		System.debug('Cameron [' + relatedObjects +']');
        upsert relatedObjects;
	}
}