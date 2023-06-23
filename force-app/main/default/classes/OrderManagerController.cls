public with sharing class OrderManagerController {

	@AuraEnabled(cacheable = true)
	public static List<Product__c> getFilteredProducts(String filterType,
													   String filterFamily) {

		Boolean hasFilterType = !(filterType == null || filterType =='');
		Boolean hasFilterFamily = !(filterFamily == null || filterFamily =='');

		List<Product__c> products = new List<Product__c>();

		if(hasFilterType && hasFilterFamily) {
		products =	[
					SELECT ID, Name, Type__c, Family__c, Description__c, Price__c, Image__c
					FROM Product__c
					WHERE Type__c=:filterType AND Family__c=:filterFamily
					WITH SECURITY_ENFORCED
					LIMIT 40
			];
		} else if (!hasFilterType && hasFilterFamily) {
			products =	[
					SELECT ID, Name, Type__c, Family__c, Description__c, Price__c, Image__c
					FROM Product__c
					WHERE Family__c=:filterFamily
					WITH SECURITY_ENFORCED
					LIMIT 40
			];

		} else if (hasFilterType && !hasFilterFamily){
			products = [
					SELECT ID, Name, Type__c, Family__c, Description__c, Price__c, Image__c
					FROM Product__c
					WHERE Type__c=:filterType
					WITH SECURITY_ENFORCED
					LIMIT 40
			];
		} else {
			products = [
					SELECT ID, Name, Type__c, Family__c, Description__c, Price__c, Image__c
					FROM Product__c
					WITH SECURITY_ENFORCED
					LIMIT 40
			];
		}
		return products;
	}
}