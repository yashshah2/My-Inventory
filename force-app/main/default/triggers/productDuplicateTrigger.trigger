trigger productDuplicateTrigger on Product__c (before insert) {
    if( Trigger.isInsert ) {
        productDuplicateTriggerHandler.beforeInsert ( Trigger.New );
    }
}