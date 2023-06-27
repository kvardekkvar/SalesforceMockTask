@isTest
public class OrderManagerControllerTest {
	private class RestMock implements HttpCalloutMock {
		public HTTPResponse respond(HTTPRequest req)
			{
				HttpResponse res = new HttpResponse();
				res.setHeader('Content-Type', 'application/json');
				res.setBody('{"success": true, "word": "ololotrololo", "rowcount": 0, "data": [], "errormessage": ""}');
				res.setStatusCode(200);
				return res;
			}
	}

	@isTest
	static void getFilteredProductsReturnsCorrectValueWhenTwoFiltersAreSet() {
		Test.setMock(HttpCalloutMock.class, new RestMock());

		Product__c product = new Product__c();
		product.Type__c = 'Electronics';
		product.Family__c = 'Cheap';
		product.Price__c = 1;
		insert product;
		List< Product__c > products = OrderManagerController.getFilteredProducts('Electronics', 'Cheap');
		System.assertEquals(1, products.size());
		System.assertEquals(product.Id, products.get(0).Id);
	}

	@isTest
	static void getFilteredProductsReturnsCorrectValueWhenOnlyFamilyFilterIsSet() {
		Test.setMock(HttpCalloutMock.class, new RestMock());

		Product__c product = new Product__c();
		product.Type__c = 'Electronics';
		product.Family__c = 'Cheap';
		product.Price__c = 1;

		insert product;

		List< Product__c > products = OrderManagerController.getFilteredProducts('', 'Cheap');
		System.assertEquals(1, products.size());
		System.assertEquals(product.Id, products.get(0).Id);
	}

	@isTest
	static void getFilteredProductsReturnsCorrectValueWhenOnlyTypeFilterIsSet() {
		Test.setMock(HttpCalloutMock.class, new RestMock());

		Product__c product = new Product__c();
		product.Type__c = 'Electronics';
		product.Family__c = 'Cheap';
		product.Price__c = 1;

		insert product;

		List< Product__c > products = OrderManagerController.getFilteredProducts('Electronics', '');
		System.assertEquals(1, products.size());
		System.assertEquals(product.Id, products.get(0).Id);
	}

	@isTest
	static void getFilteredProductsReturnsCorrectValueWhenNoFiltersAreSet() {
		Test.setMock(HttpCalloutMock.class, new RestMock());

		Product__c product = new Product__c();
		product.Type__c = 'Electronics';
		product.Family__c = 'Cheap';
		product.Price__c = 1;

		insert product;

		List< Product__c > products = OrderManagerController.getFilteredProducts('', '');
		System.assertEquals(1, products.size());
		System.assertEquals(product.Id, products.get(0).Id);
	}
}