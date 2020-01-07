({
	doinit : function(component, event, helper) {
        
        var columns = [
            { label : "Item Code", fieldName : "ItemCode"},
            { label : "Item Name", fieldName : "ItemName"},
            { label : "Issue Date", fieldName : "Issue_Date__c"},
            { label : "Due Date", fieldName : "Due_Date__c"}
        ];
        component.set( 'v.columns' , columns );
        helper.init( component );
	},
    handleReturn : function( component, event, helper ){
        helper.returnItems( component );
    }, 
    handleRowSelect : function( component, event, helper ){
        var selectedRows = event.getParam('selectedRows');
    }
})