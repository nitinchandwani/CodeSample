({	
    doinit : function(component, event, helper) {
        var columns = [
            { label : "Item Code", fieldName : "Name"},
            { label : "Item Name", fieldName : "Item_Name__c"},
            { label : "Type", fieldName : "RecordTypeName"}
        ];
        component.set('v.columns', columns);
    },
	handleAddItem : function(component, event, helper) {
        if(event.keyCode == 13){
            var itemCode = component.find( 'itemCode' ).get('v.value');
            if( itemCode != '' ){
                helper.addNewItem( component, itemCode );
            }
        }
	},
    handleCheckOut : function(component, event, helper) {
        let items = component.get('v.items');
        let employeeId = component.get( 'v.employeeId');
        if( items != null && items.length > 0 ){
            let action = component.get('c.createBorrowingHistory');
            action.setParams({
                employeeId : employeeId,
                items : items
            });
            action.setCallback( this, function( resp ){
                if( resp.getReturnValue() == true ){
                    helper.showToast( component, 'Success', 'Success', `Items checked out successfully.` );
                    component.set( 'v.items', new Array() );
                    component.set( 'v.pendingItems', new Array() );
                    component.set( 'v.employeeId', component.get('v.employeeId') );
                    component.find('borrowingHistory').reload();
                }
            });
            $A.enqueueAction(action);
            
        }
        
    },
    removeEmployee : function(component, event, helper) {
        
        component.set( 'v.employeeId', null );
        component.set( 'v.items', new Array() );
        console.log( component.find('borrowingHistory') );
        component.find('borrowingHistory').reload();
    }
})