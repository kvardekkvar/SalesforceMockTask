@isTest
public class OrderItemServiceTest {
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
	static void oneProductCreated() {
		Test.setMock(HttpCalloutMock.class, new RestMock());

		Order__c order = new Order__c();
		insert order;
		ID orderId = order.Id;

		Product__c product = new Product__c();
		product.Price__c = 10;
		insert product;

		Map<Id, Integer> quantities = new Map<Id, Integer>();
		quantities.put(product.Id, 5);

		OrderItemService.createOrderItems(quantities, orderId);

		List<OrderItem__c> createdRecords = [SELECT Id, Quantity__c FROM OrderItem__c WHERE OrderId__c = :orderId];
		System.assertEquals(createdRecords.size(), 1);
		System.assertEquals(createdRecords.get(0).Quantity__c, 5);
	}

	@isTest
	static void severalProductsCreated() {
		Integer numberOfProducts = 50;
		Test.setMock(HttpCalloutMock.class, new RestMock());

		Order__c order = new Order__c();
		insert order;
		ID orderId = order.Id;

		List<Product__c> products = new List<Product__c>();
		for (Integer i = 0; i < numberOfProducts; i++) {
			Product__c product = new Product__c();
			product.Price__c = 10;
			products.add(product);
		}
		insert products;

		Map<Id, Integer> quantities = new Map<Id, Integer>();

		for (Product__c product : products) {
			quantities.put(product.Id, 5);
		}
		OrderItemService.createOrderItems(quantities, orderId);

		List<OrderItem__c> createdRecords = [SELECT Id, Quantity__c FROM OrderItem__c WHERE OrderId__c = :orderId];
		System.assertEquals(createdRecords.size(), numberOfProducts);
		System.assertEquals(createdRecords.get(0).Quantity__c, 5);
	}
	@isTest
	static void zeroProductsCreated() {
		Test.setMock(HttpCalloutMock.class, new RestMock());

		Order__c order = new Order__c();
		insert order;
		ID orderId = order.Id;

		Map<Id, Integer> quantities = new Map<Id, Integer>();

		OrderItemService.createOrderItems(quantities, orderId);

		List<OrderItem__c> createdRecords = [SELECT Id, Quantity__c FROM OrderItem__c WHERE OrderId__c = :orderId];
		System.assertEquals(createdRecords.size(), 0);
	}

}