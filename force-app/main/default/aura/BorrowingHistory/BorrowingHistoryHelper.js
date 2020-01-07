({
    init : function( component ){
        var employeeId = component.get( 'v.employeeId' );
        if( employeeId != '' && employeeId != null ){
            var action = component.get( 'c.getBorrowingHistory' );
            action.setParams({
                employeeId : employeeId
            });
            action.setCallback( this, function(resp){
                let borrowingHistories = resp.getReturnValue();
                borrowingHistories.forEach( function( borrowingHistory ){
                    if ( borrowingHistory.Item__c ){
                        borrowingHistory.ItemName = borrowingHistory.Item__r.Item_Name__c;
                        borrowingHistory.ItemCode = borrowingHistory.Item__r.Name;
                    }
                });
                component.set( 'v.borrowingHistory' , borrowingHistories );
            });
            $A.enqueueAction( action );
        }
        else{
            component.set( 'v.borrowingHistory' , [] );
        }
    },
	returnItems : function( component ) {
		var selectedRows = component.find( 'borrowingHistory').getSelectedRows();
        console.log( selectedRows );
        if( selectedRows && selectedRows.length > 0 ){
            var action = component.get( 'c.returnItems ');
            action.setParams({
                borrowingHistories : selectedRows
            });
            action.setCallback( this, function( resp ){
                console.log( resp.getReturnValue() );
                if( resp.getReturnValue() == true ){
                    this.showToast( component, 'SUCCESS', 'SUCCESS', 'Returned Successfully');
                    this.init( component );
                }else{
                    
                }
            });
            $A.enqueueAction(action);
        }
	},
    showToast : function( component, type, title, msg) {
		var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": msg,
            "type": type
        });
        toastEvent.fire();
	}
})