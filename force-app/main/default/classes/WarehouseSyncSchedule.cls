/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-15-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class WarehouseSyncSchedule implements Schedulable {
    public void execute(SchedulableContext sc){
        System.enqueueJob(new WarehouseCalloutService());
    }
    // implement scheduled code here
}