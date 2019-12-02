({
    myInit : function(component, event, helper) {
        var action = component.get("c.getProducts");
        action.setCallback(this,function(response){
            var findProducts = response.getReturnValue();
            console.log(findProducts)
            component.set("v.products", findProducts);
        });
        $A.enqueueAction(action);
    },
    
})