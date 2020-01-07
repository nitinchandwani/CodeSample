({
    addNewItem : function( component, itemCode ){
        var action = component.get('c.getItem');
        action.setParams({
            itemCode : itemCode
        });
        action.setCallback(this, function( resp ){
            var item = resp.getReturnValue();
            if( item != null ){
                if( item.Status__c == 'Available'){
                    var itemSet = component.get( 'v.pendingItems' );
                    if( itemSet.includes(item.Id) ){
                        this.showToast( component, 'Error', 'Error', `Item ${itemCode} is already added in the list.` );
                    }else{
                        var items = component.get('v.items');
                        if (item.RecordType) item.RecordTypeName = item.RecordType.Name;
                        itemSet.push( item.Id );
                        items.push( item );
                        console.log( items );
                        component.set('v.items', items);
                        //this.showToast( component, 'Success', 'Success', `Item ${itemCode} added successfully.` );
                    }
                }else{
                    this.showToast( component, 'Error', 'Error', `Item ${itemCode} is unavailable at the moment.` );
                }
                
            }else{
                this.showToast( component, 'Error', 'Error', `Item ${itemCode} not found.` );
            }
            
            component.find( 'itemCode' ).set('v.value', '' );
            component.find( 'itemCode' ).focus();
        });
        $A.enqueueAction( action );
    },
    showToast : function( component, type, title, msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": msg,
            "type": type,
            "duration": '1000'
        });
        toastEvent.fire();
    }
})