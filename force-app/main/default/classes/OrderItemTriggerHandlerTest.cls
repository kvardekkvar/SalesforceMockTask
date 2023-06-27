@isTest
public class OrderItemTriggerHandlerTest {
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
	static void populateOrderItemPriceFieldSetsCorrectValue(){
		Test.setMock(HttpCalloutMock.class, new RestMock());

		Integer numberOfOrderItems = 200;
		Order__c order = new Order__c();
		insert order;
		ID orderId = order.Id;

		Product__c product = new Product__c();
		product.Price__c=2;
		insert product;

		List<OrderItem__c> orderItems = new List<OrderItem__c>();

		for(Integer i = 0; i<numberOfOrderItems; i++){
			OrderItem__c orderItem = new OrderItem__c();
			orderItem.ProductId__c = product.Id;
			orderItem.OrderId__c = order.Id;
			orderItem.Quantity__c = 10;
			orderItems.add(orderItem);
		}
		insert orderItems;
		List<OrderItem__c> createdRecords = [SELECT Id, Price__c FROM OrderItem__c WHERE OrderId__c=:orderId];
		for (OrderItem__c orderItem : createdRecords){
			System.assertEquals(2, orderItem.Price__c);
		}
	}

	@isTest
	static void populateOrderTotalFieldsSetsCorrectValues(){
		Test.setMock(HttpCalloutMock.class, new RestMock());
		Integer numberOfOrderItems = 200;
		Order__c order = new Order__c();
		insert order;
		ID orderId = order.Id;

		Product__c product = new Product__c();
		product.Price__c=2;
		insert product;

		List<OrderItem__c> orderItems = new List<OrderItem__c>();

		for(Integer i = 0; i<numberOfOrderItems; i++){
			OrderItem__c orderItem = new OrderItem__c();
			orderItem.ProductId__c = product.Id;
			orderItem.OrderId__c = order.Id;
			orderItem.Quantity__c = 10;
			orderItems.add(orderItem);
		}
		insert orderItems;

		order = [SELECT Id, TotalProductCount__c, TotalPrice__c FROM Order__c WHERE Id = :orderId];
		System.assertEquals(4000,order.TotalPrice__c);
		System.assertEquals(2000, order.TotalProductCount__c);

	}
}