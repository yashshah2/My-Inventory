({
    cancelDialog : function(component,helper) {
        var homeEvt = $A.get("e.force:navigateToObjectHome");
        homeEvt.setParams({
            "scope":"Product__c"
        });
        homeEvt.fire();
        
    },
    handleSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({"title": "Success!",
                              "message": "The Product has been added.",
                              "type": "success"});
        toastEvent.fire();
       
        var recUpdate = $A.get("e.c:recordUpdated");
		recUpdate.fire();
        component.set("v.truth", false);
        component.set("v.truth", true);
        
    }

})