/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-18-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global class WarehouseCalloutServiceMock implements HttpCalloutMock {
    public static String resJson = '[{"_id":"55d66226726b611100aaf741","replacement":false,"quantity":5,"name":"Generator 1000 kW","maintenanceperiod":365,"lifespan":120,"cost":5000,"sku":"100002"}]' ;
    private Integer statusCode ;
    global WarehouseCalloutServiceMock(Integer code){
        this.statusCode = code;
    }
    global HttpResponse respond(HttpRequest req){
        System.assertEquals('https://th-superbadge-apex.herokuapp.com/equipment', req.getEndpoint());

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type','application/json');
        res.setBody(resJson);
        res.setStatusCode(this.statusCode);
        return res;
    }
    // implement http mock callout
}