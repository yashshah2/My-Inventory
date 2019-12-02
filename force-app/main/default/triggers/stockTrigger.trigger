//This trigger is used to check if the product has more than one stock. 
//If so, it'll display on alert message saying - the product already exists.
trigger stockTrigger on Stock__c ( before insert ) {
    if( Trigger.isInsert ) {
        stockTriggerHandler.beforeInsert( Trigger.New );
    }
}