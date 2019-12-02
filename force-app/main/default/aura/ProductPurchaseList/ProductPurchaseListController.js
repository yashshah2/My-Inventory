({
    init: function(cmp, event, helper) {
        cmp.set('v.columns', [
            { label: 'Product Name', fieldName: 'Name', type: 'text' },
            { label: 'Unit Price', fieldName: 'Unit_Price__c', type: 'currency', cellAttributes: { alignment: 'left' } },
            { label: 'Available Quantity', fieldName: 'Stock__c', type: 'number', cellAttributes: { alignment: 'left' } },
            { label: 'Brand', fieldName: 'Brand', type: 'text' },
            { label: 'Category', fieldName: 'Category', type: 'text' },
        ]);

        helper.fetchData(cmp);
    },

    updateSelectedText: function(cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        cmp.set('v.selectedRowsCount', selectedRows.length);
    },

    submitDetails: function(cmp, event, helper) {
        var selectedRows = cmp.find("table").getSelectedRows();
        var action = cmp.get("c.createPurchaseOrder");
        action.setParams({ "serializedProducts": JSON.stringify(selectedRows) });

        $A.enqueueAction(action);

        action.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                console.log(response.getReturnValue());
            } else {
                console.log('FAIL');
            }
        });
    },

    openModal: function(cmp, event, helper) {
        var modal = cmp.find("quantityModal")
        modal.set("v.products", cmp.find("table").getSelectedRows());
        modal.set("v.total",0);
        modal.set("v.isModalOpen", true);
        
    },
    onChange: function(cmp, event, helper) {
        var criteria = cmp.find("criteria").get("v.value");
        var dropDown = cmp.find("dropDown");
        var options = [{ value: "", label: "None" }];
        var criteriaRecords = [];
                cmp.set("v.showFilter", false);
        if(criteria==''){
            cmp.set("v.filteredData", cmp.get("v.data"));
            cmp.set("v.body", []);
            return;
        }
        
        if(criteria=='Product'){
            cmp.set("v.body", []);
            cmp.set("v.showFilter", true);
            cmp.set("v.filteredData", cmp.get("v.data"));
            return;
        }

        var action = cmp.get("c.getCriteriaRecords");
        action.setParams({ "criteria": criteria });
        $A.enqueueAction(action);
        action.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                criteriaRecords = response.getReturnValue();
                criteriaRecords.forEach(function(item) {
                    var obj = {};
                    obj.value = item.Id;
                    obj.label = item.Name;
                    options.push(obj);
                });
                if (dropDown === undefined) {
                    $A.createComponent(
                        "c:Dropdown", {
                            "name": "dropDown",
                            "aura:id": "dropDown",
                            "label": criteria,
                            "value": "None",
                            "options": options
                        },
                        function(newButton, status, errorMessage) {
                            //Add the new button to the body array
                            if (status === "SUCCESS") {
                                var body = cmp.get("v.body");
                                body.push(newButton);
                                cmp.set("v.body", body);
                            } else if (status === "INCOMPLETE") {
                                console.log("No response from server or client is offline.")
                                // Show offline error
                            } else if (status === "ERROR") {
                                console.log("Error: " + errorMessage);
                                // Show error message
                            }
                        });
                } else {
                    dropDown.set("v.label", criteria);
                    dropDown.set("v.options", options);
                }
            } else {
                console.log('FAILLL');
            }
            
        });
    },

    updateProducts: function(cmp, event, helper) {
        var id = event.getParams().selectedRecordId;
        var action = cmp.get("c.getProductsByCriteria");
        var criteria = cmp.find("criteria").get("v.value");
        action.setParams({
            "id": id,
            "criteria": criteria
        });
        console.log('action param set');
        $A.enqueueAction(action);
        action.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                console.log('SUCCESSSSSS');
                var filteredProducts = response.getReturnValue();
                var rows = response.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    if (row.Brand__r) row.Brand = row.Brand__r.Name;
                    if (row.Category__r) row.Category = row.Category__r.Name;
                }
                cmp.set("v.filteredData", rows);
            } else {
                console.log('FAILLLLL');
            }
        });
    },
    filter: function(component, event, helper) {
        var term = component.get("v.filter");
        helper.regexFunction(component, term);
    }
})