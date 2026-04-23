package("nontype_functional", function()
    set_kind("library", { moduleonly = true })
    set_homepage("https://github.com/zhihaoy/nontype_functional")
    set_description("Complete implementation of std::function, std::function_ref, and std::move_only_function ")
    set_license("BSD-2.0")

    add_urls(
        -- "https://github.com/zhihaoy/nontype_functional/archive/refs/tags/$(version).tar.gz",
        "https://github.com/arthapz/nontype_functional.git"
    )

    add_versions("20260327", "9ba0b2727c2969391fb1ffba878a072b928d86ec")
    -- add_versions("v1.0.2", "0fa53530d813b97c6f87615d4c2e3f0ded1a95e337f797059a4b201e96bf5a4f")
    add_defines("NONTYPE_FUNCTIONAL_MODULE")

    on_install(function(package)
        local configs = { modules = true }
        import("package.tools.xmake").install(package, configs)
    end)
end)
