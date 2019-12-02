trigger SupplierBrandCheckTrigger on Supplier__c (before insert) {
    if( Trigger.isInsert ) {
        SupplierBrandCheckTriggerHandler.beforeInsert ( Trigger.New );
    }
}