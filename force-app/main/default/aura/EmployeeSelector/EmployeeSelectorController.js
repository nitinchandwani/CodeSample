({
	handleEmployeeChange : function(component, event, helper) {
		component.set( 'v.employeeId', component.find('employeeId').get('v.value') );
        component.find('employeeId').set('v.disabled', true );
	},
    handleChangeEmployee : function(component, event, helper) {
        component.set( 'v.employeeId', null );
        component.find('employeeId').set('v.value', null );
        component.find('employeeId').set('v.disabled', false );
        component.get( 'v.parent' ).removeEmployee();
    },
    handleLoad: function(component , event, helper) {
        let employeeId = component.get( 'v.employeeId' );
        component.find('employeeId').set('v.value', component.get( 'v.employeeId' ) );
        if( employeeId != null ){
            component.find('employeeId').set('v.disabled', true );
        }
    }
})