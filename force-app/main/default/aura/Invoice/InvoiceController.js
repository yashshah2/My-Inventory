({
	doInit : function(component, event, helper) {
        
        var action = component.get("c.getItems");
        action.setParams({
            recordId: component.get("v.recordId")
        });
        
        action.setCallback(this,function(response){
            var items = response.getReturnValue()
            	console.log(items);
                component.set("v.items",items);
            }
        );
        
        $A.enqueueAction(action);
        
	}
})