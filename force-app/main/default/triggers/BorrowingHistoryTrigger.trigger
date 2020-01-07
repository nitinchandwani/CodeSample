trigger BorrowingHistoryTrigger on Borrowing_History__c (after insert, after update) {
    if( Trigger.isAfter ){
        Set<Id> itemIds = new Set<Id>();
        if( Trigger.isInsert ){
            for( Borrowing_History__c borrowingHistory : Trigger.new ){
                if( borrowingHistory.Return_Date__c != NULL && borrowingHistory.Item__c != NULL ){
                    itemIds.add( borrowingHistory.Item__c ); 
                }
            }
        }
        if( Trigger.isUpdate ){
            for( Borrowing_History__c borrowingHistory : Trigger.new ){
                if( borrowingHistory.Return_Date__c != NULL && 
                   	borrowingHistory.Item__c != NULL &&
                   	borrowingHistory.Return_Date__c != Trigger.oldMap.get( borrowingHistory.Id ).Return_Date__c ){
                    itemIds.add( borrowingHistory.Item__c ); 
                }
            }
        }
        
        if( itemIds != NULL && itemIds.size() > 0 ){
            BorrowingHistoryHelper.updateItems( itemIds );
        }
    }
}