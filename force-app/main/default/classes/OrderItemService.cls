public class OrderItemService {


	public static void createOrderItems(Map<Id, Integer> productsQuantities, Id orderId){
		List<OrderItem__c> orderItems = new List<OrderItem__c>();
		Set<ID> productIds = productsQuantities.keySet();

		for (ID productId : productIds){
			OrderItem__c orderItem = new OrderItem__c();
			orderItem.ProductId__c = productId;
			orderItem.Quantity__c = productsQuantities.get(productId);
			orderItem.OrderId__c = orderId;
			orderItems.add(orderItem);
		}

		insert orderItems;
	}
}