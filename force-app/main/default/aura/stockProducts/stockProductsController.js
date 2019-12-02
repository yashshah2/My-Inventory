({
	myInit : function(component, event, helper) {
		var action = component.get("c.getStock")
        action.setCallback (this,function(response){
            var stock = response.getReturnValue();
           
            component.set("v.stockProduct",stock);
        });
        $A.enqueueAction(action);
	}
})