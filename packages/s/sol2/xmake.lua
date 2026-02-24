package("sol2", function()
    set_kind("library", { headeronly = true })
    set_homepage("https://github.com/ThePhD/sol2")
    set_description("A C++ library binding to Lua.")
    set_urls("https://github.com/NougatBitz/sol2.git", { branch = "develop" })

    -- add_patches(
    --     ">=3.3.0",
    --     path.join(os.scriptdir(), "patches", "3.3.0", "optional.patch"),
    --     "8440f25e5dedc29229c3def85aa6f24e0eb165d4c390fd0e1312452a569a01a6"
    -- )

    add_deps("cmake")
    add_deps("luau", {
        system = false,
        version = "upstream",
        configs = {
            shared = false,
            extern_c = true,
            build_cli = false,
        },
    })

    on_install("!wasm", function(package)
        local configs = {
            "-DSOL2_BUILD_LUA=OFF",
            "-DSOL2_TESTS=OFF",
            "-DSOL2_TESTS_SINGLE=OFF",
            "-DSOL2_TESTS_INTEROP_EXAMPLES=OFF",
            "-DSOL2_TESTS_DYNAMIC_LOADING_EXAMPLES=OFF",
        }
        import("package.tools.cmake").install(package, configs)
    end)
end)
