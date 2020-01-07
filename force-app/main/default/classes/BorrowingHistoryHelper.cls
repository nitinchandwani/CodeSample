/**
@Name			:		BorrowingHistoryHelper
@Date			:		13 Oct 2019
@Description	:		Trigger Helper to update item if return date is not null
@Developer		:		Nitin Chandwani
*/
public class BorrowingHistoryHelper {
    
    //Mark all associated Items as available
    public static void updateItems( Set<Id> itemIds ){
        if( itemIds != NULL && itemIds.size() > 0 ){
            List<Item__c> items = new List<Item__c>();
            for( Item__c item : getItems( itemIds ) ){
                item.Status__c = 'Available';
                item.Current_Borrower__c = NULL;
                items.add( item );
            }
            if( items != NULL && items.size() > 0 ){
                UPDATE items;
            }
        }
    }
    
    //Get Items
    private static List<Item__c> getItems( Set<Id> itemIds ){
        if( itemIds != NULL && itemIds.size() > 0 ){
            return [SELECT Id, Status__c FROM Item__c WHERE Id IN: itemIds ];
        }
        return NULL;
    }
}