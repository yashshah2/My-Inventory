({
	onFilterChange : function(component, event, helper) {
		var updateProductList = $A.get("e.c:updateProductList");
        var selectedRecordId = event.getSource().get("v.value");
        updateProductList.setParams({"selectedRecordId": selectedRecordId});
        updateProductList.fire();
	}
})