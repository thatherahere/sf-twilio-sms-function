@isTest
private class SFTwilioFunctionDemoTest {
	private static final String SF_TWILIO_IMPORT_FUNCTION = 'SFTWILIOSMSFUNCTION.sftwiliosms'; 
    @isTest
    static void positiveTest() {
        // Prepare mock function (not testing callback)
        SFTwilioFunctionMock mockFunction = new SFTwilioFunctionMock();
        Test.setMock(functions.FunctionInvokeMock.class, mockFunction);
	
        Test.startTest();
        SFTwilioFunctionDemo.sendSMS('+1XXXXXXXXXX', 'This sms was sent from twili using Salesforce Function.');
        Test.stopTest();
    }
    
    @isTest
    static void negativeTest() {
        // Prepare mock function (not testing callback)
        SFTwilioFunctionMock mockFunction = new SFTwilioFunctionMock();
        mockFunction.throwError = true;
        Test.setMock(functions.FunctionInvokeMock.class, mockFunction);
        
        Test.startTest();
        try{
            functions.Function mockedFunction = functions.Function.get( SF_TWILIO_IMPORT_FUNCTION );
            mockedFunction.invoke('{}', new SFTwilioFunctionCallback());
	        //SFTwilioFunctionDemo.sendSMS('+1XXXXXXXXXX', 'This sms was sent from twili using Salesforce Function.');
        }catch( Exception ex){
            System.assert( ex.getMessage().contains('Function returned an error.') );
        }
        Test.stopTest();
    }
    
    public class SFTwilioFunctionMock implements functions.FunctionInvokeMock {
        public String response = '{"body":"Sent from your Twilio trial account - This sms was sent from twili using Salesforce Function.","numSegments":"1","direction":"outbound-api","from":"+1XXXXXXXXXX","to":"+1XXXXXXXXXX","dateUpdated":"2022-07-03T08:48:28.000Z","price":null,"errorMessage":null,"uri":"/2010-04-01/Accounts/XXXXXXXXXXXXXXXX/Messages/XXXXXXXXXXXXXXXX.json","accountSid":"XXXXXXXXXXXXXXXX","numMedia":"0","status":"queued","messagingServiceSid":null,"sid":"XXXXXXXXXXXXXXXX","dateSent":null,"dateCreated":"2022-07-03T08:48:28.000Z","errorCode":null,"priceUnit":"USD","apiVersion":"2010-04-01","subresourceUris":{"media":"/2010-04-01/Accounts/XXXXXXXXXXXXXXXX/Messages/XXXXXXXXXXXXXXXX/Media.json"}}';
        public String error = 'Function returned an error.';
        public Boolean throwError = false;
        public String requestPayload = '';

        public functions.FunctionInvocation respond(
            String functionName,
            String requestPayload
        ) {
            this.requestPayload = requestPayload;

            if (throwError) {
                return functions.MockFunctionInvocationFactory.createErrorResponse(
                    '000000000000000',
                    functions.FunctionErrorType.RUNTIME_EXCEPTION ,
                    error
                );
            }

            return functions.MockFunctionInvocationFactory.createSuccessResponse(
                '000000000000000',
                response
            );
        }
    }
}