public class SFTwilioFunctionDemo {
    // SFTWILIOSMSFUNCTION: This is the project name defined in sfdx-project.json in your vs-code.
	private static final String SF_TWILIO_IMPORT_FUNCTION = 'SFTWILIOSMSFUNCTION.sftwiliosms'; 
     
    public static void sendSMS( String toNumber, String smsBody ){
        Map<String, String> request = new Map<String, String>{ 'toNumber' => toNumber, 'smsBody' => smsBody};
        functions.Function function = functions.Function.get( SF_TWILIO_IMPORT_FUNCTION );
        functions.FunctionInvocation invocation = function.invoke(
            JSON.serialize( request ), 
            new SFTwilioFunctionCallback()
        );
    }
}