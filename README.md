# AWS Lambda / Typescript Monorepo Example

This project is designed as an example of how to use Bazel to build a Typescript monorepo.
Specifically, this project is designed to demonstrate how these tools can be used to deploy an AWS lambda function.

## Key points

1. The project uses the [Bazel Node.js rules](https://bazelbuild.github.io/rules_nodejs/), wrapped in a macro:
   1. `//:build/defs/typescript.bzl` provides the `ts_project` macro to automatically configure build and test actions;
   2. In order to deploy the code as an AWS Lambda function, an `esbuild` target can bundle dependencies into one file;
   3. A test target is automatically configured using `jest`.

2. The [AWS CDK](https://aws.amazon.com/cdk/) is used for deployment of the AWS Lambda function:
   1. `//:build/defs/cdk.bzl` provides the `cdk` macro to configure `synth`, `bootstrap`, `deploy` and `destroy` actions;
   2. The `:cdk-synth` is a _build_ action, and so is [tagged](https://docs.bazel.build/versions/main/be/common-definitions.html#common-attributes) as  `'manual'`
   3. The `:cdk-bootstrap`, `:cdk-deploy` and `:cdk-destroy` are _run_ actions;
   4. The actual deployment to AWS relies on credentials being set elsewhere (e.g `~/aws/credentials`).
   
3. Thanks to Bazel, the project is _almost_ entirely self contained:
   1. In theory, the `yarn` cache could be bundled alongside the project to remove remote `npm` fetches...
   2. ...however, as Bazel itself is installed via `yarn` (via `@bazel/bazelisk`) it does require an external `yarn`.

## Todo

1. It would be quite nice to move `jest.config.js` under `build/`, but this seems to mess things up;
2. Generating a `package.json` automatically might be good (but might also mess things up?)
3. The `esbuild` action is currently named `src` to get the output directory named `src`... this is gross :/
4. Bazel does not seem to play nicely with `yarn >= v2`... maybe I could fix that?

## Weirdnesses

1. Sometimes IDEA seems to recognise the imported sub-modules, and other times it doesn't?
   1. This seems to be more of a problem on Windows... maybe it's a byproduct of the way symlinks are used?
   2. Adding the sub-modules as `yarn` workspaces seems to help _sometimes_ but it's pretty hit-or-miss.