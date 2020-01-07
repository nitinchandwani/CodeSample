({
	searchItems : function( component ) {
		let keyword = component.find( 'searchKeyword' ).get('v.value' );
        if( keyword != '' ){
            let action = component.get( 'c.searchItems' ); 
            action.setParams({
                keyword : keyword
            });
            action.setCallback( this, function( resp ){
                let items = resp.getReturnValue();
                items.forEach( function( item ){
                    if ( item.RecordType ){
                        item.RecordTypeName = item.RecordType.Name;
                    }
                });
                component.set( 'v.searchedItems', items ) ;
            });
            $A.enqueueAction( action );
        }else{
            component.set( 'v.searchedItems', new Array() ) ;
        }
	},
    addItem : function( component, row ){
        let items = component.get( 'v.items' );
        let pendingItems =  component.get( 'v.pendingItems' );
        if( pendingItems.includes(row.Id) ){
            this.showToast( component, 'Error', 'Error', `Item is already added in the list.` );
        }else{
            pendingItems.push( row.Id );
            items.push( row );
            component.set( 'v.items', items );
            component.set( 'v.pendingItems', pendingItems );
            this.close( component );
        }
    },
    close : function( component ){
        component.set( 'v.showBrowseItem', false );
        component.find( 'searchKeyword' ).set( 'v.value', '' );
        component.set( 'v.searchedItems', new Array() ) ;
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