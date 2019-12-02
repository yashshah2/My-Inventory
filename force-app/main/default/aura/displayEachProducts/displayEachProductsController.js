({
	navToObj : function(component, event, helper) {
        var nav = $A.get("e.force:navigateToSObject");
        nav.setParams({
            "recordId": component.get("v.product.Id")
        });
        nav.fire();
		
	},
    editRecord : function(component, event, helper) {
        helper.showHide(component);
    },
    handleSuccess : function(component, event, helper) {
    	 var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The Product info has been updated.",
            "type": "success"
        });
        toastEvent.fire();
        var recUpdate = $A.get("e.c:recordUpdated");
		recUpdate.fire();
        helper.showHide(component);
	},
    handleCancel : function(component, event, helper) {
        helper.showHide(component);
        event.preventDefault();
    },
    deleteProduct : function(component,event, helper) {
        component.find("recordHandler").deleteRecord($A.getCallback(function(deleteResult) {
            if (deleteResult.state === "SUCCESS" || deleteResult.state === "DRAFT") {
                console.log("Record is deleted.");
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Deleted",
                    "message": "The record was deleted."
                    
                });
                var recDelete = $A.get("e.c:recordUpdated");
				recDelete.fire();
                resultsToast.fire();
            }
            else if (deleteResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            }
            else if (deleteResult.state === "ERROR") {
                console.log('Problem deleting record, error: ' +
                            JSON.stringify(deleteResult.error));
            }
            else {
                console.log('Unknown problem, state: ' + deleteResult.state +
                            ', error: ' + JSON.stringify(deleteResult.error));
            }
    	}));
    }
})