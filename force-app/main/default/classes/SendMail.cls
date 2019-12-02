public class SendMail {


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