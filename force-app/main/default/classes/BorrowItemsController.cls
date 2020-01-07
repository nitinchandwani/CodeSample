/**
 @Name			:		BorrowItemsController
 @Date			:		08 October 2019
 @Developer		:		Nitin Chandwani
 @Description	:		Controller to fetch, upsert data for borrow Items controller
*/
public class BorrowItemsController {
    
	@AuraEnabled
    public static Item__c getItem( String itemCode ){
        if( String.isNotBlank( itemCode ) ){
            List<Item__c> items = [SELECT Id, Name, Item_Name__c, RecordType.Name, Borrowable_Days__c, Status__c FROM Item__c WHERE Name =: itemCode LIMIT 1];
            if( items != NULL && items.size() > 0  ){
                return items[0];
            }
        }
        return NULL;
    }
    
    @AuraEnabled
    public static List<Borrowing_History__c> getBorrowingHistory( String employeeId ){
        if( String.isNotBlank( employeeId ) ){
            return [SELECT Id, Employee__c, Issue_Date__c, Item__r.Name, Item__r.Item_Name__c, Due_Date__c FROM Borrowing_History__c WHERE Employee__c =: employeeId AND Status__c = 'Borrowed'];
        }
        return NULL;
    }
    
    @AuraEnabled
    public static boolean createBorrowingHistory( String employeeId, List<Item__c> items ){
        if( String.isNotBlank( employeeId ) && items != NULL && items.size() > 0 ){
            List<Borrowing_History__c> borrowingHistories =  new List<Borrowing_History__c>();
            for( Item__c item : items ){
                item.Status__c = 'Borrowed';
                item.Current_Borrower__c = employeeId;
                //Borrow Item
                Borrowing_History__c borrowingHistory = new Borrowing_History__c();
                borrowingHistory.Employee__c = employeeId;
                borrowingHistory.Issue_Date__c = System.today();
                borrowingHistory.Fine__c = 0;
                borrowingHistory.Item__c = item.Id;
                if( item.Borrowable_Days__c != NULL ){
                    borrowingHistory.Due_Date__c = borrowingHistory.Issue_Date__c + (Integer)item.Borrowable_Days__c;
                }
                borrowingHistories.add( borrowingHistory );
            }
            if( borrowingHistories != NULL ){
                Savepoint sv = Database.setSavepoint();
                try{
                    INSERT borrowingHistories;
                    UPDATE items;
                    return TRUE;
                }catch( Exception excep ){
                    Database.rollback( sv );
                }
            }
        }
        return FALSE;
    }
	@AuraEnabled
    public static boolean returnItems( List<Borrowing_History__c> borrowingHistories ){
        if( borrowingHistories != NULL && borrowingHistories.size() > 0 ){
            List<Item__c> items =  new List<Item__c>();
            for( Borrowing_History__c borrowingHistory : borrowingHistories ){
                borrowingHistory.Return_Date__c = System.today();
            }
            Savepoint sv = Database.setSavepoint();
            try{
                UPDATE borrowingHistories;
                return TRUE;
            }catch( Exception excep ){
                Database.rollback( sv );
            }
        }
        return false;
    }    
    
    @AuraEnabled
    public static List<Item__c> searchItems( String keyword ){
        if( String.isNotBlank( keyword ) ){
            keyword = '%' + keyword + '%';
            return [SELECT Id, Name, Item_Name__c, RecordType.Name, 
                    Borrowable_Days__c, Status__c FROM Item__c WHERE ( Name LIKE: keyword OR
                   	Item_Name__c LIKE: keyword OR RecordType.Name LIKE: keyword ) AND 
                   	Status__c = 'Available' ];
        }
        return NULL; 
    }
}