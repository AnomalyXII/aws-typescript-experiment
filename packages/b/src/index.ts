//
// This is a test.
//

import {APIGatewayProxyEvent, APIGatewayProxyResult} from 'aws-lambda';


import HelloWorld from '@anomaly-xii/a'

export const handler = async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
    const helloWorld = new HelloWorld();

    return {
        statusCode: 200,
        body: `Greetings: ${helloWorld.get_hello()}`
    };
}
