/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-10-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger MaintenanceRequest on Case (before update, after update) {
    if(Trigger.isUpdate && Trigger.isAfter){
        MaintenanceRequestHelper.updateWorkOrders(Trigger.new);
    }
    // ToDo: Call MaintenanceRequestHelper.updateWorkOrders
}