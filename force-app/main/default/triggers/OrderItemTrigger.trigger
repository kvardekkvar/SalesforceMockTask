trigger OrderItemTrigger on OrderItem__c (after insert, before insert) {

	if (Trigger.isBefore && Trigger.isInsert) {
		OrderItemTriggerHandler.populateOrderItemPriceField(Trigger.new);
	}

	if (Trigger.isAfter && Trigger.isInsert) {
		OrderItemTriggerHandler.populateOrderTotalFields(Trigger.new);
	}
}