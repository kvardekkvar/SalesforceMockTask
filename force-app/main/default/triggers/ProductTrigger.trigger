trigger ProductTrigger on Product__c (after insert) {

	if (Trigger.isAfter && Trigger.isInsert) {

		if(ProductTriggerHandler.isFirstRun){
			ProductTriggerHandler.isFirstRun = false;
			ProductTriggerHandler.populateImageField(Trigger.new);
		}
	}
}