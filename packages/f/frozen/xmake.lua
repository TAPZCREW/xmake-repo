package("frozen", function()
    set_kind("library", { moduleonly = true })
    set_homepage("https://github.com/Arthapz/frozen")
    set_description("A header-only, constexpr alternative to gperf for C++14 users")
    set_license("Apache-2.0")

    set_urls("https://github.com/Arthapz/frozen.git")

    add_configs("modules", { default = false, type = "boolean" })

    add_versions("20251102", "7b7ea282746ec6d9a23d27d42c1c7d27419f52c2")

    on_install(function(package)
        local configs = {
            modules = package:config("modules"),
        }
        import("package.tools.xmake").install(package, configs)
    end)
end)
