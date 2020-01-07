@isTest
public class TestBorrowItemsController {

    @TestSetup
    public static void dataSetup(){
        //Insert employeess
        List<Contact> contacts = new List<Contact>();
        for( Integer i = 0; i < 5 ; i ++ ){
            Contact con = new Contact();
            con.LastName  = 'Test ' + i ;
            contacts.add( con );
        }
        INSERT contacts;
        //Insert Items
        List<Item__c> items = new List<Item__c>();
        for( Integer i = 0; i < 10 ; i ++ ){
            //Books
            Item__c book = new Item__c();
            book.Item_Name__c = 'Book ' + i;
            book.Borrowable_Days__c = 5;
            book.Status__c = 'Available';
            book.RecordTypeId = Schema.SObjectType.Item__c.getRecordTypeInfosByName().get('Book').getRecordTypeId();
            items.add( book );
            //AV Equipments
            Item__c avEquipments = new Item__c();
            avEquipments.Item_Name__c = 'AV Equipments ' + i;
            avEquipments.Borrowable_Days__c = 5;
            avEquipments.Status__c = 'Available';
            avEquipments.RecordTypeId = Schema.SObjectType.Item__c.getRecordTypeInfosByName().get('AV Equipment').getRecordTypeId();
            items.add( avEquipments );
        }
        INSERT items;
    }
    @isTest
    public static void unitTest1(){
        
        
        //Get Borrowing History
        List<Borrowing_History__c> borrowingHistories = BorrowItemsController.getBorrowingHistory( '' );
        System.assertEquals( NULL, borrowingHistories);
        Contact con = [SELECT Id FROM Contact LIMIT 1];
        borrowingHistories = BorrowItemsController.getBorrowingHistory( con.Id );
        //get Item
        Item__c item = BorrowItemsController.getItem('TEST');
        System.assertEquals( NULL, item);
        Item__c tempItem = [SELECT Name FROM Item__c WHERE RecordType.Name = 'Book' LIMIT 1 ];
        Item__c item1 = BorrowItemsController.getItem( tempItem.Name );
        System.assertEquals( tempItem.Id, item1.Id);
        tempItem = [SELECT Name FROM Item__c WHERE RecordType.Name = 'AV Equipment' LIMIT 1 ];
        Item__c item2 = BorrowItemsController.getItem( tempItem.Name );
        System.assertEquals( tempItem.Id, item2.Id);
        //Borrow Item
        BorrowItemsController.createBorrowingHistory( '', NULL );
        BorrowItemsController.createBorrowingHistory( con.Id , NULL );
        Boolean result = BorrowItemsController.createBorrowingHistory( con.Id , new List<Item__c>{item1, item2});
        System.assertEquals( TRUE, result );
        //Prevent Borrowing Same item
        BorrowItemsController.createBorrowingHistory( con.Id , new List<Item__c>{item1, item2});
        
        //Return Item
        borrowingHistories = BorrowItemsController.getBorrowingHistory( con.Id );
        System.assertEquals( 2, borrowingHistories.size() );
        BorrowItemsController.returnItems( borrowingHistories );
        
        //Search Items
        BorrowItemsController.searchItems( '' );
        List<Item__c> searchResult = BorrowItemsController.searchItems( 'Book' );
        System.assertEquals( 10, searchResult.size() );
    }
}