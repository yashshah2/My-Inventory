public class stockTriggerHandler {
    public static void beforeInsert ( List<Stock__c> stocks ) {
        stockTriggerHelper.manageStock( stocks );
    }
}