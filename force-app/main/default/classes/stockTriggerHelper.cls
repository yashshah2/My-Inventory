public class stockTriggerHelper {
    public static void manageStock( List<Stock__c> stocks ) {
     List<Stock__c> stockProducts =  [ SELECT Product__c,Id FROM Stock__c ];
   	 for( Stock__c checkProduct : stockProducts ) {
     	if(checkProduct.Product__c == stocks[0].Product__c	 ) {
        	Trigger.New[0].addError('The product stock already exists!!');
        }
      }
    }
}