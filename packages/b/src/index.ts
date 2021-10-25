//
// This is a test.
//

import {APIGatewayProxyEvent, APIGatewayProxyResult} from 'aws-lambda';


import HelloWorld from '@anomaly-xii/a'

export const lambdaHandler = (event: APIGatewayProxyEvent): APIGatewayProxyResult => {
    return {
        statusCode: 200,
        body: new HelloWorld().get_hello()
    };
}