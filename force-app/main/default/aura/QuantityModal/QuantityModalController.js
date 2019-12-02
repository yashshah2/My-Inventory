({
    doInit: function(component, event, helper) {
    },

    closeModal: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
    },
    
    updateTotal: function(component, event, helper) {
        var quantities = [];
        const cmps = component.find("quantities");
        if (!cmps) return;
        if ($A.util.isArray(cmps)) {
            cmps.forEach(cmp => {
                quantities.push(parseInt(cmp.get("v.value")));
            });
        } else {
            quantities.push(parseInt(cmps.get("v.value")));
        }
        var total = 0;
        var selectedRows = component.get("v.products");
        for(var i=0; i<quantities.length; i++){
            if(!Number.isNaN(quantities[i])){
                total += quantities[i]*selectedRows[i].Unit_Price__c;
            }
        }
        component.set("v.total", total);
    },

    submitDetails: function(component, event, helper) {
        var action = component.get("c.createPurchaseOrder");
        var quantities = [];
        const cmps = component.find("quantities");
        if (!cmps) return;
        if ($A.util.isArray(cmps)) {
            cmps.forEach(cmp => {
                quantities.push(parseInt(cmp.get("v.value")));
            });
        } else {
            quantities.push(parseInt(cmps.get("v.value")));
        }
        var selectedRows = component.get("v.products");

        action.setParams({
            "serializedProducts": JSON.stringify(selectedRows),
            "serializedQuantities": JSON.stringify(quantities)
        });

        action.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                console.log('SUCCESSSS');
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": response.getReturnValue().Id
                });
                navEvt.fire();
                console.log('Purchase Complete',JSON.stringify(response.getReturnValue()));
            } else {
                console.log('FAILLLL');
            }
        });
        console.log('set callback');
        $A.enqueueAction(action);
    },
})