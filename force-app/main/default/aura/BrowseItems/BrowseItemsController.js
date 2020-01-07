({
    doinit : function(component, event, helper) {
        var columns = [
            { label : "Item Code", fieldName : "Name"},
            { label : "Item Name", fieldName : "Item_Name__c"},
            { label : "Type", fieldName : "RecordTypeName"},
            { label : "Action", type : "button", 
            	typeAttributes: { 
                    label: 'Add', 
                    name: 'add_item', 
                    title: 'Click to Add Item'
                }
            }
        ];
        component.set('v.columns', columns);
    },
    handleBrowse : function(component, event, helper) {
        component.set( 'v.showBrowseItem', true );
    },
    handleCancel : function(component, event, helper) {
        helper.close( component );
    },
    handleSearch : function(component, event, helper) {
        helper.searchItems( component );
    },
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'add_item':
                helper.addItem( component, row);
                break;
        }
    }
})