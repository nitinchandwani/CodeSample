/**
@Name			:	OverdueScheduler
@Date			:	13 October 2019
@Description	:	Scheduler To send  email alert and add fine for Overdue books
@Developer		:	Nitin Chandwani
*/
public class OverdueBatch implements Database.Batchable<Sobject> {
    
    private String query, status;
    
    public OverdueBatch(){
        status = Label.OverdueStatus;
        query = 'SELECT Employee__c, Employee__r.Email From Borrowing_History__c ';
        query += 'WHERE Status__c =:status  AND Due_Date__c >= TODAY';
    }
    
    public Database.QueryLocator start( Database.BatchableContext bc ){
        return Database.getQueryLocator( query );
    }
    public void execute( Database.BatchableContext bc, List<Borrowing_History__c> borrowingHistories ){
        if( borrowingHistories != NULL && borrowingHistories.size() > 0 ){
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            Id templateId = getEmailTemplateId( 'Overdue_Reminder' );
            if( templateId != NULL ){
                for( Borrowing_History__c borrowingHistory : borrowingHistories ){
                    borrowingHistory.Fine__c = 10;
                    if( String.isNotBlank( borrowingHistory.Employee__r.Email ) ){
                        Messaging.SingleEmailMessage email = generateEmail( templateId, borrowingHistory );
        				if( email != NULL ) emails.add( email );
                    }
                }
                Database.update( borrowingHistories, false );
                if( emails != NULL && emails.size() > 0 ){
                    Messaging.sendEmail( emails );
                }
            }
        }
    }
	public void finish( Database.BatchableContext bc ){
        
    }
    
    private Messaging.SingleEmailMessage generateEmail( Id templateId, Borrowing_History__c borrowingHistory ){
        Messaging.SingleEmailMessage email;
        if( templateId != NULL && borrowingHistory != NULL){
            email = new Messaging.SingleEmailMessage();
            email.setTargetObjectId( borrowingHistory.Employee__c );
            email.setSaveAsActivity( true );
            email.setWhatId( borrowingHistory.Id );
            email.setTemplateId( templateId );
        }
        return email;
    }
    
    //Get Email Template
    private static Id getEmailTemplateId( String templateName ){
        if( String.isNotBlank( templateName ) ){
            List<EmailTemplate> emailTemplates = [SELECT Id FROM EmailTemplate WHERE DeveloperName  =: templateName ];
            if( emailTemplates != NULL && emailTemplates.size() > 0 ){
                return emailTemplates[0].Id;
            }
        }
        return NULL;
    }
}