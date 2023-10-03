/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-15-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class WarehouseCalloutService implements Queueable , Database.AllowsCallouts{
    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';

    public void execute(QueueableContext qc){
        HttpResponse response = makeGetCallout();
        if(null!=response){
            List<Object> result = (List<Object>) JSON.deserializeUntyped(response.getBody());
            List<Product2> lstOfProduct  = new List<Product2>();
            for(Object itemObj : result){
                Map<String,Object> item = (Map<String,Object>)itemObj;
                   Product2 eqp = new Product2();
               //    eqp.Id = (String)item.get('_id');
                   eqp.Replacement_Part__c =(Boolean)item.get('replacement'); 
                   eqp.Current_Inventory__c = (Double)item.get('quantity');
                   eqp.Name = (String) item.get('name');
                   eqp.Cost__c = (Double)item.get('cost');
                   eqp.Lifespan_Months__c	= (Integer)item.get('lifespan');
                   eqp.Maintenance_Cycle__c = (Integer)item.get('maintenanceperiod');
                   eqp.Warehouse_SKU__c = (String)item.get('sku');
                   lstOfProduct.add(eqp);
            }
            if(lstOfProduct.size() > 0){
                upsert lstOfProduct Warehouse_SKU__c;
            }
        }
    }

    
    private static HttpResponse makeGetCallout(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200){
            return response;
        }
        return null;
    }


    
}