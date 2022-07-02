import twilio from 'twilio';

export class TwilioService {
    /**
     * Initializes the twilio client
     * @param {string} accountSid
     * @param {string} authToken
     */
    static init(accountSid, authToken) {
        return new twilio(accountSid, authToken);
    }
}