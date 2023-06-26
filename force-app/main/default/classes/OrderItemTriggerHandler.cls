public class OrderItemTriggerHandler {


	public static void populateOrderItemPriceField(List<OrderItem__c> records) {

		List<Id> productIds = new List<Id>();

		for (OrderItem__c orderItem : records) {
			productIds.add(orderItem.ProductId__c);
		}

		List<Product__c> products = [
				SELECT id, Price__c
				FROM Product__c
				WHERE Id IN :productIds
		];

		for (OrderItem__c orderItem : records) {
			Product__c orderItemProduct = null;
			for (Product__c product : products) {
				if (product.Id == orderItem.ProductId__c) {
					orderItemProduct = product;
					break;
				}
			}

			if (orderItem.Price__c == null) {
				orderItem.Price__c = orderItemProduct.Price__c;
			} else {
				orderItem.Price__c += orderItemProduct.Price__c;
			}

		}
	}

	public static void populateOrderTotalFields(List<OrderItem__c> records) {
		Decimal totalProductCount = 0;
		Decimal totalPrice = 0;

		for (OrderItem__c orderItem : records) {
			Decimal quantity = (Decimal) orderItem.get('Quantity__c');
			Decimal pricePerUnit = (Decimal) orderItem.get('Price__c');
			Decimal price = 0;
			if (quantity != null && pricePerUnit != null) {
				price = quantity * pricePerUnit;
			}
			totalProductCount = totalProductCount + quantity;
			totalPrice = totalPrice + price;
		}

		ID orderId = (ID) records.get(0).get('OrderId__c');

		Order__c order = [
				SELECT ID, TotalPrice__c, TotalProductCount__c
				FROM Order__c
				WHERE Id = :orderId
				WITH SECURITY_ENFORCED
				LIMIT 1
		];

		order.TotalPrice__c = totalPrice;
		order.TotalProductCount__c = totalProductCount;

		update order;
	}
}