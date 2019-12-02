public with sharing class productsController {
    //This controller will list the product and its stock inorder to display,create,edit and delete a new product.
    @AuraEnabled
    public static List<Product__c> getProducts ( ) {
        List<Product__c> products = [SELECT Name,Id FROM Product__c ];
        return products;
    }
    
     public static void sendLeadOverlapCompleteNotification(){
  		OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress limit 1];
		EmailTemplate templateId = [Select id from EmailTemplate where name = 'Purchase complete'];
		List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		mail.setTemplateID(templateId.Id);
		mail.setSaveAsActivity(false);
		mail.setOrgWideEmailAddressId(owa.id);
		allmsg.add(mail);
		Messaging.sendEmail(allmsg,false);
}
}