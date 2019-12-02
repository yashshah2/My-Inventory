public class ProductController {
    @AuraEnabled
    public static List<Stock__c> getStock() {
        List<Stock__c> stocks = [SELECT Id, Name, 
                                 Product__r.Name, 
                                 Product__r.Category__r.Name, 
                                 Product__r.Brand__r.Name, 
                                 Product__r.Unit_Price__c, 
                                 Product__r.Supplier__r.Name, 
                                 Product__r.Supplier_Price__c
                                 FROM Stock__c ];
        return stocks;
    }
	@AuraEnabled
    public static List<Product__c> getProduct() {
        List<Product__c> products = [SELECT Id,
                                     Name,
                                     Brand__c,
                                     Category__c,
                                     Supplier__c,
                                     Supplier_Price__c,
                                     Unit_Price__c
                                     FROM Product__c];
        return products;
    }	
    
    @AuraEnabled
    public static List<Product__c> getProducts () {
        List<Product__c> product = [SELECT Id,Name, Unit_Price__c, Stock__c, Brand__r.Name, Category__r.Name FROM Product__c WHERE Stock__c>0 ORDER BY Name];
        return product;
    }
    
    @AuraEnabled
    public static Purchase_Order__c createPurchaseOrder(String serializedProducts, String serializedQuantities){
        List<Product__c> products = (List<Product__c>)JSON.deserialize(serializedProducts, List<Product__c>.class);
        Integer[] quantities = (Integer[])JSON.deserialize(serializedQuantities, Integer[].class);
        Integer index = 0;
        
        List<User> users = [SELECT Username, Contact.Id, Contact.AccountId, Contact.Name,Contact.Account.BillingAddress, Contact.Account.Name, Email FROM User WHERE Id=:UserInfo.getUserId()];
        
        Purchase_Order__c purchaseOrder = new Purchase_Order__c();
        purchaseOrder.Contact__c = users[0].ContactId;
        insert purchaseOrder;
        
        List<Purchase_Order_Item__c> purchaseItems = new List<Purchase_Order_Item__c>();
		String supplier;
        for(Product__c product : products){
            Purchase_Order_Item__c purchaseOrderItem = new Purchase_Order_Item__c();
            purchaseOrderItem.Name = product.Name;
            purchaseOrderItem.Unit_Price__c = product.Unit_Price__c;
            purchaseOrderItem.Quantity__c = quantities[index];
            purchaseOrderItem.Purchase_Order__c = purchaseOrder.Id;
            supplier += product.Supplier__c;
            purchaseItems.add(purchaseOrderItem);
            product.Stock__c -= quantities[index];
            index++;
        }
        update products;
        insert purchaseItems;
        
        
        //EmailTemplate et = [SELECT Id FROM EmailTemplate WHERE DeveloperName =:'Purchase complete'];
        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'pwcyash@gmail.com'];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if ( owea.size() > 0 ) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        List<String> toAddress = new List<String>();
        String userName = UserInfo.getUserName();
		User activeUser = [Select Email,Contact.Account.ShippingAddress From User where Username = : userName limit 1];
		String userEmail = activeUser.Email;
        Address add = activeUser.Contact.Account.ShippingAddress;
        String city = add.City;
        String ccode = add.countrycode;
        String con = add.country;
        String Strt = add.street;
            
        toAddress.add(userEmail);
        //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        //mail.setTemplateId(et.Id);
        mail.setToAddresses(toAddress);
        mail.setSubject('Order Placed');
        List<Purchase_Order_Item__c> items = [SELECT Id, Name,Quantity__c,Item_Total__c,Unit_Price__c FROM Purchase_Order_Item__c WHERE Purchase_Order__r.Id=:purchaseOrder.Id];
        String body = 'Dear <b>' +UserInfo.getName()+'</b><br/> Your order has been successfully placed.If you would like to view the status of your order or make any changes to it,please visit Your orders on Salesforce.com<br/>';
        body += '<b>Address</b>:' +strt+ ' ,'+city+','+con+'<br/>';
        body += '<b>Purchase id</b>:' + purchaseOrder.Id +'<br/><br/>' ;
        Double sum = 0;
        for(Purchase_Order_Item__c item : items){
            String name = item.Name;
            Double quant = item.Quantity__c;
            String quantity = String.valueOf(quant);
            Double unit = item.Unit_Price__c;
            String unitPrice = String.valueOf(unit);
            Double itemTtl = item.Item_Total__c;
            sum += itemTtl;
            String itemTotal = String.valueOf(itemTtl);
            body += '<b>Name</b>:' + name +'<br/><b>Quantity</b>:' +quantity +'<br/><b>Unit Price</b>:' + unitPrice + '<br/><b>Item Total</b>:'+ itemTotal + '<br/><br/><br/>';
          }
        String totalPrice = String.valueOf(sum);
        body += '<b>Total Price</b>:' +totalPrice + '<br/>';
        //body += '<b>Suppliers</b>:' +supplier+ '<br/><b>Thanks for purchasing..</b>';
        
        mail.setHtmlBody(body);
        //mail.setHtmlBody(purchaseOrder.Total_Amount__c);
        // mail.setTargetObjectId(primaryContact);
        //  mail.setWhatId(primaryAccount);
        mail.setSaveAsActivity(false);
        mail.setUseSignature(false);
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        allmsg.add(mail);
        
        try {
            Messaging.sendEmail(allmsg,true);
            //return;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        return(purchaseOrder);
    }
    
    @AuraEnabled
    public static List<Object> getCriteriaRecords(String criteria){
        if(criteria=='Brand'){
            return([SELECT Id, Name FROM Brand__c]);
        } else if(criteria=='Category'){
            return([SELECT Id, Name FROM Category__c]);
        }
        return(null);
    }
    
    @AuraEnabled
    public static List<Product__c> getProductsByCriteria(String id, String criteria){
        if(criteria=='Brand'){
            return([SELECT Id, Name, Unit_Price__c, Stock__c, Brand__r.Name, Category__r.Name FROM Product__c WHERE Stock__c>0 AND Brand__r.Id=:id]);
        } else if(criteria=='Category'){
            return([SELECT Id, Name, Unit_Price__c, Stock__c, Brand__r.Name, Category__r.Name FROM Product__c WHERE Stock__c>0 AND Category__r.Id=:id]);
        }
        return(null);
    }
    
    @AuraEnabled
    public static List<Purchase_Order_Item__c> getItems(Id recordId){
        List<Purchase_Order_Item__c> items = [SELECT Id, Name,Quantity__c,Item_Total__c,Unit_Price__c FROM Purchase_Order_Item__c WHERE Purchase_Order__r.Id=:recordId];
        return items;
    }
 
}