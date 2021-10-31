# Bazel workspace
workspace(
    # How this workspace would be referenced with absolute labels from another workspace
    name = "aws_lambda_experiment",
    # Map the @npm bazel workspace to the node_modules directory.
    # This lets Bazel use the same node_modules as other local tooling.
    managed_directories = {"@npm": ["node_modules"]},
)

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
http_archive(
    name = "build_bazel_rules_nodejs",
    sha256 = "3aa6296f453ddc784e1377e0811a59e1e6807da364f44b27856e34f5042043fe",
    urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/4.4.2/rules_nodejs-4.4.2.tar.gz"],
)

# The yarn_install rule runs yarn anytime the package.json or yarn.lock file changes.
# It also extracts and installs any Bazel rules distributed in an npm package.
load("@build_bazel_rules_nodejs//:index.bzl", "yarn_install")
yarn_install(
    name = "npm",
    package_json = "//:package.json",
    yarn_lock = "//:yarn.lock",
    frozen_lockfile = False,
)

load("@build_bazel_rules_nodejs//toolchains/esbuild:esbuild_repositories.bzl", "esbuild_repositories")
esbuild_repositories(npm_repository = "npm")  # Note, npm is the default value for npm_repository
