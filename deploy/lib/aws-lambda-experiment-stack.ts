import * as cdk from '@aws-cdk/core';
import * as lambda from '@aws-cdk/aws-lambda';
import * as apigw from '@aws-cdk/aws-apigateway';

export class AwsLambdaExperimentStack extends cdk.Stack {
    constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
        super(scope, id, props);

        const hello = new lambda.Function(this, 'HelloHandler', {
            runtime: lambda.Runtime.NODEJS_14_X,
            code: lambda.Code.fromAsset('./node_modules/@anomaly-xii/b'),
            handler: 'hello.handler'
        });

        new apigw.LambdaRestApi(this, 'HelloEndpoint', {
            handler: hello
        });
    }
}
