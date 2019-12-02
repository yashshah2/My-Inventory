public with sharing class AllProductsController {
    @AuraEnabled
    public static List<Stock__c> getProducts () {
        List<Stock__c> stocks = [SELECT Id, Name, 
                                 Product__r.Name, 
                                 Product__r.Category__r.Name, 
                                 Product__r.Brand__r.Name, 
                                 Product__r.Unit_Price__c, 
                                 Product__r.Supplier__r.Name, 
                                 Product__r.Supplier_Price__c
                                 FROM Stock__c ORDER BY Product__r.Name];
        return stocks;
    }
}