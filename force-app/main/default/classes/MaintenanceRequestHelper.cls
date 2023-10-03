/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-17-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(List<Case> cases) {
        Set<Id> lstOfIds = new Set<Id>();
        Map<String,Integer> dueDateMap = getDueDate(cases);
        System.debug('map is '+dueDateMap);
        List<Case> casesToBeUpdated = new List<Case>();
        for(Case c : cases){
            // checking for Repair and Routine Maintenance Cases which are closed
            if(c.Type.equals('Repair') || c.Type.equals('Routine Maintenance') && c.IsClosed){
                //  casesToBeUpdated.add(c); 
              lstOfIds.add(c.Id);
              
              Case createNewCase = new Case();
              createNewCase.Subject = 'Future Routine Maintenance';
              createNewCase.Status = 'New';
              createNewCase.ParentId = c.Id;
              createNewCase.Date_Reported__c = Date.today();
              createNewCase.Type = 'Routine Maintenance';
              createNewCase.Vehicle__c = c.Vehicle__c;
              createNewCase.ProductId = c.ProductId;
              System.debug('final map is '+dueDateMap.get(c.Id));
              if(dueDateMap.get(c.Id)!=null){
                createNewCase.Date_Due__c = Date.today().addDays(dueDateMap.get(c.Id));
              }
              else{
                createNewCase.Date_Due__c = Date.today();
              }
              casesToBeUpdated.add(createNewCase); 
            }

        }
        if(casesToBeUpdated.size() > 0){

        //     Map<Id,Case> casesToBeUpdated = new Map<Id,Case>();
        //   //  [Select Status, Subject, Type,Vehicle__c from Case ]
        //     Map<Id,Decimal> dueDateMap = new Map<Id,Decimal>();
        //     for(Equipment_Maintenance_Item__c re : [Select Maintenance_Request__c,Min(Equipment__r.Maintenance_Cycle__c)minCycle from Equipment_Maintenance_Item__c where Maintenance_Request__c IN :lstOfIds GROUP BY Maintenance_Request__c]){
        //         dueDateMap.put(re.Maintenance_Request__c,re.minCycle);
        //     }

             Insert casesToBeUpdated;
    
        List<Equipment_Maintenance_Item__c> EMIToBeAdded = mapExistingEquipment(casesToBeUpdated,lstOfIds);
        if(EMIToBeAdded.size()>0){
          insert EMIToBeAdded;
        }
       //[Select Id, Equipment__c, Vehicle__c,Equipment__r.Maintenance_Cycle__c from Case
     
    
        // TODO: Complete the method to update workorders

    }
}     

  Public static List<Equipment_Maintenance_Item__c> mapExistingEquipment (List<Case> lstOfNewCases,Set<Id> closedCaseIds){
   // Set<Id> lstOfIds = (new Map<Id,Object> (lstOfNewCases)).keySet(); 
   Map<Id,Case> closedCases = new Map<Id,Case>([Select Id, (select Id, Equipment__c, Quantity__c 
   FROM Equipment_Maintenance_Items__r) from Case where Id IN:closedCaseIds]);
    //List<Equipment_Maintenance_Item__c> res = [Select Id, Maintenance_Request__c from Equipment_Maintenance_Item__c Where Maintenance_Request__c IN :lstOfNewCases.get('')];
    List<Equipment_Maintenance_Item__c> EMICopy  = new List<Equipment_Maintenance_Item__c>(); 
    for(Case c: lstOfNewCases){
      for(Equipment_Maintenance_Item__c q : closedCases.get(c.ParentId).Equipment_Maintenance_Items__r){
        Equipment_Maintenance_Item__c EMI = q.clone();
        EMI.Maintenance_Request__c = c.Id;
        EMICopy.add(EMI);
      }
    }
      return EMICopy;
  }
    public static Map<String,Integer> getDueDate(List<Case> cases){
        Map<String,Integer> result = new Map<String,Integer>();
        Map<Id,Case> lstOfIds = new Map<Id,Case>(cases);   
        for(AggregateResult re : [Select Maintenance_Request__c,Min(Equipment__r.Maintenance_Cycle__c)minCycle from Equipment_Maintenance_Item__c where  Maintenance_Request__c IN :lstOfIds.keySet() GROUP BY  Maintenance_Request__c]){
      //      dueDateMap.put(re.Maintenance_Request__c,re.minCycle);
            if(re.get('minCycle')!=null){
                result.put((String)re.get('Maintenance_Request__c'), Integer.valueOf(re.get('minCycle')));
            }
        }
        return result;
    }
    
}