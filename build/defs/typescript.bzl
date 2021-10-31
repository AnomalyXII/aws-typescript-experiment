#
# Provides a `ts_project` wrapper script that configures:
#    - :config          => exports the `tsconfig.json` file
#    - :compile         => compiles all the typescript sources
#    - :main            => creates a (hopefully!) npm-compatible library of `:compile`
#    - :esbuild         => (optionally) creates an `esbuild` bundle of the sources
#    - :npm             => (optionally) runs `npm pack` on the target
#    - :compile-tests   => (optionally, if test sources are specified) compiles all the typescript test sources
#    - :tests           => (optionally, if test sources are specified) exports the compile test sources
#    - :jest            => (optionally, if test sources are specified) runs the tests via `jest`
#

load("@build_bazel_rules_nodejs//:index.bzl", _js_library = "js_library", _pkg_npm = "pkg_npm")
load("@npm//@bazel/typescript:index.bzl", _ts_project = "ts_project")
load("@npm//@bazel/esbuild:index.bzl", _esbuild = "esbuild")
load("@npm//jest-cli:index.bzl", _jest_test = "jest_test")

def ts_project(
        name = None,
        org = None,
        srcs = ["src/*.ts"],
        tests = ["test/*.ts"],
        deps = [],
        test_deps = [],
        fat = False,
        package_json = "package.json",
        jest_config = "//:jest.config.js",
):
    main_srcs = native.glob(srcs)
    test_srcs = native.glob(tests)

    # Export the package.json file
    native.exports_files([package_json])

    _ts_project(
        name = "compile",
        srcs = main_srcs,
        deps = deps,
        out_dir = None if not fat else 'thin',
        declaration = True,
        declaration_map = True,
        tsconfig = {
            "extends": "tsconfig.json"
        },
        extends = "//:tsconfig.json",
    )

    if name != None:
        # Todo: validate that the org doesn't contain a `/`?
        package_name = ("@" + org + "/" if org != None else "") + name

        lib_target = ":compile"
        if fat:
            _esbuild(
                name = "src", # TODO: naming this src is gross, but apparently you can't rename the output dir?? :<
                entry_points = [":compile"],
                deps = deps,
                format = "cjs",
                platform = "node",
                minify = True,
            )
            lib_target = ":src"

        _js_library(
            name = "main",
            package_name = package_name,
            srcs = [":package.json"],
            deps = [lib_target],
        )

        _pkg_npm(
            name = "npm",
            deps = [":main"],
            srcs = [":package.json"],
            package_name = package_name,
            substitutions = {"0.0.0-WORKSPACE": "1.0.0"},
        )

    if len(test_srcs) > 0:
        test_libraries = [ "@npm//@types/jest", "@npm//jest", "@npm//ts-jest" ]

        _ts_project(
            name = "compile-tests",
            srcs = main_srcs + test_srcs,
            deps = test_libraries + deps + test_deps,
            out_dir = 'tests',
            testonly = True,
            tsconfig = {
                "compilerOptions": {
                    "target": "ES2018",
                    "module": "commonjs",
                    "lib": [
                      "es2018"
                    ],
                },
                "include": main_srcs + test_srcs
            },
        )

        native.filegroup(
            name = "tests",
            srcs = [":compile-tests"],
            testonly = True,
        )

        _jest_test(
            name = "jest",
            data = [jest_config] + [":tests"] + deps + test_libraries,
            args = ["--config", "$(location %s)" % jest_config, "--runTestsByPath", "$(locations :tests)"],
            testonly = True,
        )
