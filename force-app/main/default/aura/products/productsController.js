({
	myInit : function(component, event, helper) {
		var action = component.get("c.getProduct")
        action.setCallback (this,function(response){
            var product = response.getReturnValue();
           
            component.set("v.products",product);
        });
        $A.enqueueAction(action);
	}
})