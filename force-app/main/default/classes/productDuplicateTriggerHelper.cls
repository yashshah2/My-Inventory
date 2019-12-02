public class productDuplicateTriggerHelper {
    public static void checkProduct ( List<Product__c> products ) {
        List<Product__c> getProducts = [ SELECT Name,Brand__c,Supplier__c FROM Product__c];
        for ( Product__c eachProduct : getProducts) {
            if(eachProduct.Name == products[0].Name
               && eachProduct.Brand__c == products[0].Brand__c
               && eachProduct.Supplier__c == products[0].Supplier__c ) {
                products[0].addError('The product already exists in the inventory!!');
            }
            	
        }
    }
}