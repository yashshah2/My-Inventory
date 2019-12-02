({
    fetchData: function (cmp) {
        var action = cmp.get("c.getProducts");
        $A.enqueueAction(action);
        action.setCallback(this, function(response){
            var data = response.getReturnValue();
            var rows = response.getReturnValue();
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                if (row.Brand__r) row.Brand = row.Brand__r.Name;
                if (row.Category__r) row.Category = row.Category__r.Name;
            }
            cmp.set("v.data", rows);
            cmp.set("v.filteredData", rows);
        });
    },
    
    regexFunction: function(component, term){
        var data = component.get("v.data"),
            results = data, regex;
        try {
            regex = new RegExp(term, "i");
            // filter checks each row, constructs new array where function returns true
            results = data.filter(row=>regex.test(row.Name));
        } catch(e) {
            // invalid regex, use full list
        }
        component.set("v.filteredData", results);
    },
});