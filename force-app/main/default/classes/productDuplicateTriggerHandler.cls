public class productDuplicateTriggerHandler {
    public static void beforeInsert ( List<Product__c> products ) {
        productDuplicateTriggerHelper.checkProduct ( products );
    }
}