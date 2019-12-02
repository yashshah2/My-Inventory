public class EditController {
    
    @AuraEnabled
    //public static void updateProductStock(Id recordId, String quantity, String name, String brand, String category, String supplier, Decimal supplierPrice, Decimal unitPrice){
    public static void updateProductStock(Id recordId, Product__c product, Stock__c stock){
        /*Stock__c stock = [SELECT Id, Name,
                          Product__r.Name, 
                          Product__r.Category__r.Name, 
                          Product__r.Brand__r.Name, 
                          Product__r.Unit_Price__c, 
                          Product__r.Supplier__r.Name, 
                          Product__r.Supplier_Price__c
                          FROM Stock__c WHERE Id=:recordId];
        */
        
        
        Stock__c stockFromDB = [SELECT Id, Name,Product__c FROM Stock__c WHERE Id=:recordId];
        stockFromDB = stock;
        stockFromDB.Product__c = product.Id;
        
        /*stock.Name = quantity;
        stock.Product__r.Name = name;
        stock.Product__r.Brand__r.Name = brand;
        stock.Product__r.Category__r.Name = category;
        stock.Product__r.Unit_Price__c = unitPrice;
        stock.Product__r.Supplier__r.Name = supplier;
        stock.Product__r.Supplier_Price__c = supplierPrice;
		*/        

        update stockFromDB;
        update stockFromDB.Product__r;
        //update stock.Product__r.Brand__r;
        //update stock.Product__r.Category__r;
        //update stock.Product__r.Supplier__r;
    }
}