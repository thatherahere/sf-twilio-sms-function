/**
 * Describe Sftwiliosms here.
 *
 * The exported method is the entry point for your code when the function is invoked. 
 *
 * Following parameters are pre-configured and provided to your function on execution: 
 * @param event: represents the data associated with the occurrence of an event, and  
 *                 supporting metadata about the source of that occurrence.
 * @param context: represents the connection to Functions and your Salesforce org.
 * @param logger: logging handler used to capture application logs and trace specifically
 *                 to a given execution of a function.
 */
 
 import 'dotenv/config';
 import { TwilioService } from './twilioService.js';

[
  'TWILIO_ACCOUNT_SID',
  'TWILIO_AUTH_TOKEN',
  'FROM_NUMBER'
].forEach((varName) => {
  if (!process.env[varName]) {
      console.error(`Missing ${varName} environment variable`);
      process.exit(-1);
  }
});

const { TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, FROM_NUMBER } = process.env;

// Polyfill for Error cause
const OriginalError = global.Error;
class Error extends OriginalError {
    constructor(msg, options) {
        super(msg);
        if (options?.cause) {
            this.cause = options.cause;
        }
    }

    toString() {
        let value = this.message;
        if (this.cause) {
            value += `\nCaused by: ${this.cause}`;
        }
        return value;
    }
}

export default async function (event, context, logger) {
    // Download the helper library from https://www.twilio.com/docs/node/install
    // Find your Account SID and Auth Token at twilio.com/console
    // and set the environment variables. See http://twil.io/secure
    const client = TwilioService.init( TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN );
    return await sendSMS( event, logger, client );
}

async function sendSMS( event, logger, client ){
    let response = {};
    await client.messages .create({
        body: event.data.smsBody,
        from: FROM_NUMBER,
        to: event.data.toNumber
    }).then(message =>{   
      response = message;
    }).catch(err=>{
        logger.error("Failed to send SMS: "+JSON.stringify( err ));
        const newError = new Error("Failed to send SMS:", {
            cause: err
        });
        throw newError; 
    });
    return response;
}
