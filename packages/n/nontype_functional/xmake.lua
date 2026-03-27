package("nontype_functional", function()
    set_kind("library", { moduleonly = true })
    set_homepage("https://github.com/zhihaoy/nontype_functional")
    set_description("Complete implementation of std::function, std::function_ref, and std::move_only_function ")
    set_license("BSD-2.0")

    add_urls(
        -- "https://github.com/zhihaoy/nontype_functional/archive/refs/tags/$(version).tar.gz",
        "https://github.com/arthapz/nontype_functional.git"
    )

    add_version("20260327", "85ba1c9591c0fd7625128363e058d919ef0b6745")
    -- add_versions("v1.0.2", "0fa53530d813b97c6f87615d4c2e3f0ded1a95e337f797059a4b201e96bf5a4f")

    on_install(function(package)
        local configs = { modules = true }
        import("package.tools.xmake").install(package, configs)
    end)
end)
