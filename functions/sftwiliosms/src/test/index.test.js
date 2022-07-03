import { expect } from 'chai';
import createSandbox from 'sinon/lib/sinon/create-sandbox.js';

import execute from '../index.js'

/**
 * Sftwiliosms unit tests.
 */

describe('Unit Tests', () => {

    let sandbox;
    let mockContext;
    let mockLogger;

    beforeEach(() => {
        mockContext = {
            org: {
                dataApi: { query: () => {} }
            },
            logger: { info: () => {} }
        };

        mockLogger = mockContext.logger;
        sandbox = createSandbox();

        sandbox.stub(mockContext.org.dataApi, "query");
        sandbox.stub(mockLogger, "info");

        
    });

    afterEach(() => {
        sandbox.restore();
    });

    it('Invoke Sftwiliosms', async () => {
        const results = await execute({ data: {
            "toNumber" : "+910000000000",
            "smsBody" : "This sms was sent from twili using Salesforce Function."
        } }, mockContext, mockLogger);
    });
});
