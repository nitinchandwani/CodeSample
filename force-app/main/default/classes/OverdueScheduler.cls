/**
@Name			:	OverdueScheduler
@Date			:	13 October 2019
@Description	:	Scheduler To send  email alert and add fine for Overdue books
@Developer		:	Nitin Chandwani
*/
public class OverdueScheduler implements System.Schedulable{
    public void execute( SchedulableContext sch ){
        Database.executeBatch( new OverdueBatch(), 10 );
    }
}