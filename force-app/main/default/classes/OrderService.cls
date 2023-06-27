public class OrderService {

	@AuraEnabled
	public static ID createOrder(String accountIdString, List<Map<String, Object>> cart){
		List<ID> productIds = new List<Id>();
		Map<ID, Integer> productsQuantities = new Map<Id, Integer>();
		ID accountId = (ID) accountIdString;

		for(Map<String, Object> cartItem : cart){
			ID productId =  (ID) cartItem.get('id');
			Integer productQuantity = Integer.valueOf(cartItem.get('quantity'));
			productIds.add(productId);
			productsQuantities.put(productId, productQuantity);
		}

		Order__c order = new Order__c();
		order.AccountId__c = accountId;
		insert order;

		ID orderId = order.Id;
		OrderItemService.createOrderItems(productsQuantities, orderId);

		return orderId;
	}

}