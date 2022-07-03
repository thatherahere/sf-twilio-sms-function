# Send SMS via Twilio using Salesforce Function

## About

This project is an integration between a Salesforce Org, Salesforce Functions and Twilio.

The goal of the integration is to Send SMS from Salesforce to Contact's phone number using twilio.

## Installation

### Prerequisites

#### Salesforce Resources

1. [Sign up for a Salesforce Functions trial org](https://functions.salesforce.com/signups/).
1. [Enable Dev Hub](https://help.salesforce.com/s/articleView?id=sf.sfdx_setup_enable_devhub.htm&type=5) in your org.
1. [Install the Salesforce CLI](https://developer.salesforce.com/tools/sfdxcli).
1. [Authorize](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_auth.htm) your Dev Hub in the Salesforce CLI.
1. [Get Started | Salesforce Functions](https://developer.salesforce.com/docs/platform/functions/guide/index.html)

#### Twilio Resources

1. [Sign up for your free Twilio trial](https://www.twilio.com/try-twilio).
1. Once you finish signup, you should see your [Console Dashboard](https://www.twilio.com/console). This is your home for finding your Twilio credentials. Get your Account SID and Auth Token from this page. You will need those values for the Integration.
1. [Verify your personal phone number](https://www.twilio.com/console/phone-numbers): When you signed up for your trial account, you verified your personal phone number. You can see your list of [verified phone numbers](https://www.twilio.com/console/phone-numbers/verified) on the Verified Caller IDs page. Here you must verify any non-Twilio phone numbers you wish to send SMS messages or MMS messages, or place phone calls to while in trial mode.
1. [Get your first Twilio phone number](https://www.twilio.com/console/phone-numbers/incoming): After signing up for your trial account, navigate to the Phone Numbers page in your console. Click Buy a Number to purchase your first Twilio number.
1. [The Twilio Node Helper Library](https://www.twilio.com/docs/node/install)

### Deploy and configure the Salesforce Function

You execute the function by either [deploying to a compute environement](#deploy-to-compute-environment) or [run locally](#run-locally).

<!--Make sure to refer to the relevant section and check the [environment variables reference](#environment-variables-reference) section for the appropriate configuration.-->

#### Deploy to compute environment

Follow these steps to deploy your function to a compute environment:

1. Log in to Salesforce Functions (you may have to repeat this command later as this will eventually time out)

   ```sh
   sf login functions
   ```

1. Create a compute environment:

   ```sh
   sf env create compute -o sf-twilio-function -a stenv
   ```

1. Deploy the Salesforce Function:

   ```sh
   cd functions/sftwiliosms
   sf deploy functions -o sf-twilio-function
   ```

1. Configure the Salesforce Function with the following command (see environment variables reference):

   ```sh
   sf env var set TWILIO_ACCOUNT_SID=XXXXXXXXXX -e stenv
   sf env var set TWILIO_AUTH_TOKEN=XXXXXXXXXX -e stenv
   sf env var set FROM_NUMBER=XXXXXXXXXX -e stenv
   ```

#### Run locally

Follow these steps to test your function locally:

1. Create a `.env` file in the `functions/sftwiliosms` directory. Use the following template and make sure to replace values accordingly (see environment variables reference):

   ```properties
   TWILIO_ACCOUNT_SID=XXXXXXXXXX
   TWILIO_AUTH_TOKEN=XXXXXXXXXX
   FROM_NUMBER=XXXXXXXXXX
   ```

1. To test a running function, send it a JSON payload. Pass the payload inline or create a payload.json file in your function directory with a verified number and SMS body as:

   ```json
   {
     "toNumber": "[VERIFIED_NUMBER]",
     "smsBody": "This SMS was sent via Salesforce Function."
   }
   ```

1. Run these commands to start the function locally:

   ```sh
   cd functions/sftwiliosms
   sf run function start
   ```

1. Navigate to your project root directory and invoke the function:
   ```sh
   sf run function -l http://localhost:8080 -p '@functions/sftwiliosms/payload.json'
   ```

#### Environment variables reference

| Variable Name        | Description                        |
| -------------------- | ---------------------------------- |
| `TWILIO_ACCOUNT_SID` | Your twilio account's Account SID. |
| `TWILIO_AUTH_TOKEN`  | Your twilio account's Auth Token . |
| `FROM_NUMBER`        | Your Twilio phone number           |

## Troubleshooting

While creating the compute environment if you see below error, Check your sfdx-project.json at the root level. The name of the project must not have -. Please change it to underscore and it should work.

```
Creating compute environment for org ID 00DXXXXXXXXXXXXXXX... failed
Error: Request failed with status code 422
```

Monitor Salesforce Function's logs by running:

```sh
sf env log tail -e stenv
```

Monitor Salesforce logs by running:

```sh
sfdx force:apex:log:tail -c
```
