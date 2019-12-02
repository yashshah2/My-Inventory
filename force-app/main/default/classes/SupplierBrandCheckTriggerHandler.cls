public class SupplierBrandCheckTriggerHandler {
    public static void beforeInsert ( List<Supplier__c> suppliers) {
        SupplierBrandCheckTriggerHelper.checkSameBrand ( suppliers );
        
    }
}