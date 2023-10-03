/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-18-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@IsTest
private class WarehouseCalloutServiceTest {

    @isTest
    static void test(){
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock(200));
        WarehouseCalloutService w = new WarehouseCalloutService();
        Test.startTest();
        System.enqueueJob(w);
        Test.stopTest();
        System.assertEquals(1,[Select count() from Product2]);
    }
    // implement your mock callout test here
    @isTest
    static void testNegative(){
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock(401));
        WarehouseCalloutService w = new WarehouseCalloutService();
        Test.startTest();
        System.enqueueJob(w);
        Test.stopTest();
        System.assertEquals(0,[Select count() from Product2]);
    }
}