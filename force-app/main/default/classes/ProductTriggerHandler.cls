public class ProductTriggerHandler {

	public static Boolean isFirstRun = true;

	public static void populateImageField(List<Product__c> records) {
		for (Product__c record : records) {
			if (record.Image__c == null || record.Image__c == '') {
				GlyffixService.getImageUrl(record.ID);
			}
		}
	}
}