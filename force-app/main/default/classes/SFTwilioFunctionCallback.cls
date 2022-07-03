public class SFTwilioFunctionCallback implements functions.FunctionCallback {
     
    public void handleResponse(functions.FunctionInvocation invocation) {
        try {
            functions.FunctionInvocationStatus status = invocation.getStatus();
            switch on status {
                when SUCCESS {
                    handleSuccess(invocation.getResponse());
                }
                when ERROR {
                    handleFailure( invocation );
                }
            }
        } catch (Exception e) {
            // Handle Exception 
        }
    }
    
    private void handleSuccess(String rawResponse) {
        try {
            TwilioResponse response = (TwilioResponse)JSON.deserialize(rawResponse, TwilioResponse.class);
            System.debug('sid: '+response.sid);
        } catch (Exception e) {
            throw new FunctionException(
                'failed to parse JSON response: ' + rawResponse
            );
        }
    }
    
    private void handleFailure(functions.FunctionInvocation invocation) {
        // Handle failure 
        throw new FunctionException(invocation.getError().getMessage());
    }
    
    public class FunctionException extends Exception {
    }
    
    public class TwilioResponse{
        public String body;
        public String direction;
        public String to;
        public String uri;
        public String accountSid;
        public String sid;
        public String errorMessage;
        public String status;
        public String errorCode;
        public String messagingServiceSid;
    }
}