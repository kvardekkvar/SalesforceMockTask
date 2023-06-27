@isTest
public class OrderServiceTest {
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
	static void createOrderSetsCorrectValues(){
		Test.setMock(HttpCalloutMock.class, new RestMock());

		Account account = new ACCOUNT();
		account.Name = 'Ololo trololo';
		insert account;
		Id accountId = account.Id;

		Product__c product = new Product__c();
		product.Price__c = 123;
		insert product;

		List<Map<String, Object>> cart = new List<Map<String, Object>>();
		Map<String, Object> cartItem = new Map<String, Object>();
		cartItem.put('id', product.Id);
		cartItem.put('quantity', 10);
		cart.add(cartItem);

		Id orderId = OrderService.createOrder(accountId, cart);

		System.assertNotEquals(NULL, orderId);
		Order__c createdOrder = [SELECT Id, AccountId__c FROM Order__c];
		System.assertEquals(accountId, createdOrder.AccountId__c);
	}
}