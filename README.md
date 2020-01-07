#Overview
ConForceSo Corporation wants to create a system to track books and AV equipment that employees can borrow from a library.
System should have ability to create, search, borrow, return items.
System should prevent re-borrowing same item.
Should have reports and dashboard to track borrows. 

#Implementation
Created an app, for ConForceSo Corporation with various tabs( Dashboard, Employees, Items, Borrow/Check-Out, Return Items, Reports)  
Renamed “Contact” to “Employee” and created two custom objects “Item” and “Borrowing History”
User can create, edit, search, view employees and items on the fly using lightning layouts.
Created custom lightning component to borrow and return items.
Created trigger on Borrowing History to update item status.
Created two reports basic reports and charts.

#Code Review
Aura Component Bundle
BorrowItems
ReturnItems
Apex Classes
BorrowItemsController
BorrowingHistoryHelper
OverdueScheduler, OverdueBatch
TestBorrowItemsController
Apex Trigger
BorrowingHistoryTrigger

#Future Scope
Can add images for each item.
Delete item from check-out list before check-out.
Reissue can be implemented with return items.
Reports and Dashboards can be added for better insight.