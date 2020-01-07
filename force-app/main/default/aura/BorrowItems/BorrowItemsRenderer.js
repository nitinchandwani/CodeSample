({
    afterRender: function ( component, helper) {
        this.superAfterRender();
        let employeeId = component.get( 'v.employeeId');
        if( employeeId != null){
            /*window.setTimeout(
                $A.getCallback(function () {
                    component.find("itemCode").focus();
                }),1
            );*/
            component.find("itemCode").focus();
        }
    }
    
})