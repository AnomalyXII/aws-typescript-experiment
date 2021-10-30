import * as cdk from '@aws-cdk/core';
import * as AwsLambdaExperiment from '../lib/aws-lambda-experiment-stack';
import '@aws-cdk/assert/jest';


test('should create a lambda', () => {
    const app: cdk.App = new cdk.App();

    const stack: AwsLambdaExperiment.AwsLambdaExperimentStack = new AwsLambdaExperiment.AwsLambdaExperimentStack(app, 'MyTestStack');

    expect(stack)
        .toHaveResource("AWS::Lambda::Function", {
            "Handler": "hello.handler",
            "Runtime": "nodejs14.x"
        });
});

test('should create an APIGateway endpoint', () => {
    const app: cdk.App = new cdk.App();

    const stack: AwsLambdaExperiment.AwsLambdaExperimentStack = new AwsLambdaExperiment.AwsLambdaExperimentStack(app, 'MyTestStack');

    expect(stack)
        .toHaveResource("AWS::ApiGateway::RestApi", {
            "Name": "HelloEndpoint"
        });
});
