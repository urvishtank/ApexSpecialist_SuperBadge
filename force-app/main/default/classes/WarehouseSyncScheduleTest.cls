/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-18-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private with sharing class WarehouseSyncScheduleTest {
    public static String cron_exp = '0 0 1 * * ?';
    @isTest
    private static void testScheduledJob(){
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock(200));
        Test.startTest();
            String jobId = System.schedule('ScheduledApexTest', cron_exp, new WarehouseSyncSchedule());
            System.assertEquals(0, [Select count() from Product2]);
         //   System.assertEquals(1, [Select count() from AsyncApexJob where status = 'Queued']);
         Test.stopTest();
        List<CronTrigger> cronJobId = [Select Id from CronTrigger where NextFireTime > Today];
        System.assertEquals(jobId, cronJobId[1].Id);
      //  System.assertEquals(0, [Select count() from AsyncApexJob where status = 'Queued']);
    }
    // implement scheduled code here
}