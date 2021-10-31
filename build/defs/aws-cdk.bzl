#
# Provides a `cdk` wrapper script that configures:
#    - :cdk-synth       => runs the `cdk synth` command on the given sources
#    - :cdk-bootstrap   => runs the `cdk bootstrap` command on the given sources
#    - :cdk-deploy      => runs the `cdk deploy` command on the given sources
#    - :cdk-destroy     => runs the `cdk destroy` command on the given sources
#

load("@build_bazel_rules_nodejs//:index.bzl", _copy_to_bin = "copy_to_bin", _npm_package_bin = "npm_package_bin")
load("@npm//aws-cdk:index.bzl", _cdk = "cdk")

def cdk(
        srcs,
        name = "cdk",
        resources = [],
        deps = [],
):
    native.exports_files(["cdk.json"])

    _copy_to_bin(
        name = name + "-config",
        srcs = [":cdk.json"],
    )

    _copy_to_bin(
        name = name + "-resources",
        srcs = resources,
    )

    _cdk(
        name = name + "-synth",
        args = ["synth"],
        outs = ["cdk.out"],
        data = srcs + [":" + name + "-config", ":" + name + "-resources"] + deps,
        tags = ["manual"],
        chdir = "$(RULEDIR)"
    )

    _cdk(
        name = name + "-bootstrap",
        args = ["bootstrap"],
        data = [":" + name + "-config"] + srcs + deps,
        tags = ["manual"],
        chdir = native.package_name()
    )

    _cdk(
        name = name + "-deploy",
        args = ["deploy"],
        data = [":" + name + "-config"] + srcs + deps,
        tags = ["manual"],
        chdir = native.package_name()
    )

    _cdk(
        name = name + "-destroy",
        args = ["destroy"],
        data = [":" + name + "-config"] + srcs + deps,
        tags = ["manual"],
        chdir = native.package_name()
    )
