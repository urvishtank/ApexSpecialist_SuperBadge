/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-17-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class MaintenanceRequestHelperTest {
    static final String TYPE_ROUTINE_MAINTENANCE = 'Routine Maintenance';

    @TestSetup
    static void makeData(){
        List<Vehicle__c> vehicles = new List<Vehicle__c>(); 
        List<Product2> Equipments = new List<Product2>();
     
        vehicles= CreateDefaultData.createVehicles();
        Equipments = CreateDefaultData.createEquipment();
        
        List<Case> maintenanceRequests = new List<Case>();
  
       for(Integer i =0;i<300;i++){
        Case maintenanceReq = new Case();
        maintenanceReq.Subject = 'Routine Maintenance Test';
        maintenanceReq.Type = 'Other';
        maintenanceReq.Status = 'New';
        maintenanceReq.ProductId = Equipments.get(0).Id;
        maintenanceReq.Date_Reported__c = Date.today();
        if(math.mod(i, 2) == 0){
            maintenanceReq.vehicle__c = vehicles.get(0).Id;
        }else{
            maintenanceReq.vehicle__c = vehicles.get(1).Id;
        }
        maintenanceRequests.add(maintenanceReq);
       }
       if(maintenanceRequests.size()>0){
            insert maintenanceRequests;
       }
       List<Equipment_Maintenance_Item__c> joinRecords = new List<Equipment_Maintenance_Item__c>();
       for(Case c: [Select Id, Subject ,vehicle__c from Case where Subject = 'Routine Maintenance Test' LIMIT 300]){
            if(c.vehicle__c == vehicles.get(1).Id){
                joinRecords.add(new Equipment_Maintenance_Item__c(Equipment__c = Equipments.get(1).Id, Maintenance_Request__c = c.Id));
            }
            else{   
                joinRecords.add(new Equipment_Maintenance_Item__c(Equipment__c = Equipments.get(0).Id, Maintenance_Request__c = c.Id));
            }
        }
        if(joinRecords.size() > 0 ){
            insert joinRecords;
        }    
    }
    @isTest
    private static void PositiveTests(){
        List<Vehicle__c> vehicles  = [Select Id from Vehicle__c LIMIT 5];
        List<Product2> Equipments = [Select Id from Product2 LIMIT 5];
        System.assertEquals(4,vehicles.size());
        System.assertEquals(4,Equipments.size());
        List<Case> maintenanceRequests  = [Select Id, Subject,vehicle__c,Type,Status from Case where Subject = 'Routine Maintenance Test' LIMIT 300];
        List<Case> casesToBeUpdated = new List<Case>();
        for(Case c:maintenanceRequests){
                c.Status = 'Closed';
                c.Type = 'Repair';
                casesToBeUpdated.add(c);
        }
        Test.startTest();
        if(casesToBeUpdated.size()>0){
            update casesToBeUpdated;
        }
        Test.stopTest();
        List<Case> testLstOfCases = [Select Id, Subject,vehicle__c,Type,Status,IsClosed,ProductId from Case where Subject = 'Routine Maintenance Test' AND IsClosed = true LIMIT 300];
        System.assertEquals(300,testLstOfCases.size());
        System.assertEquals('Repair',testLstOfCases[0].Type);
        
        //newly created records
        List<Case> newCreatedCase = [Select Id, Subject, Status,Type,Vehicle__c,ProductId,Date_Due__c,ParentId from Case where Subject = 'Future Routine Maintenance' AND Type =:TYPE_ROUTINE_MAINTENANCE LIMIT 300];
        System.assertEquals(300,newCreatedCase.size());
        // System.assertEquals(testLstOfCases[0].Vehicle__c,newCreatedCase[0].Vehicle__c); // vehicle mapping
        // System.assertEquals(testLstOfCases[0].ProductId,newCreatedCase[0].ProductId); // Equipment mapping
        System.assertEquals(Date.today().addDays(100),newCreatedCase[0].Date_Due__c); // Due date calculation 
     }
    @isTest
    private static void negativeTests(){
        List<Case> newMaintenanceReq  = new  List<Case>();
        newMaintenanceReq.add(new Case(Type = 'Mechanical', Status = 'New',Date_Reported__c = Date.today()));
        newMaintenanceReq.add(new Case(Type = 'Mechanical', Status = 'New', Date_Reported__c = Date.today()));
        Test.startTest();
            insert newMaintenanceReq;


        List<Case> toBeUpdated  = [Select Id, Type from Case where Type = 'Mechanical' LIMIT 10];
        toBeUpdated[0].Type = 'Electrical'; 
        toBeUpdated[0].Status = 'Closed';
        toBeUpdated[1].Type = TYPE_ROUTINE_MAINTENANCE; 
        toBeUpdated[1].Status = 'Closed';
        List<Case> newCaselst =new List<Case>(toBeUpdated); 
        if(newCaselst.size()>0){
            update newCaselst;
        }
        Test.stopTest();
        List<Case> testLstOfCases = [Select Id, Subject,vehicle__c,Type,Status,IsClosed,ProductId from Case where Type = 'Electrical' AND IsClosed = true LIMIT 5];
        System.assertEquals(1,testLstOfCases.size());
        System.assertEquals(1, [Select count() from Case where Type =:TYPE_ROUTINE_MAINTENANCE LIMIT 1]);
    }
   
}