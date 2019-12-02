public class SupplierBrandCheckTriggerHelper {
    public static void checkSameBrand ( List<Supplier__c> suppliers ) {
        List<Supplier__c> getSuppliers = [ SELECT Name,Email__c,Brand__c FROM Supplier__c];
        for( Supplier__c supplierCheck : getSuppliers ) {
            if( supplierCheck.Brand__c == suppliers[0].Brand__c && supplierCheck.Email__c == suppliers[0].Email__c ) {
                suppliers[0].addError('The brand is already registered by the Supplier using the entered MailId!!');
            }
        }
    }
}