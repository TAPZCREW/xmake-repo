package("stormkit")
    set_homepage("https://gitlab.com/Arthapz/stormkit")

    set_urls("https://github.com/TapzCrew/stormkit.git")
    add_versions("01-11-2023", "modulify")

    add_components("core", {default = true})

    add_configs("use_modules", {description = "Build with C++23 module support", default = false, type = "boolean"})
    add_configs("enable_assert", {description = "Enable assertions", default = true, type = "boolean"})

    local components = {
        log = {},
        image = { deps = {"gli", "libpng", "libjpeg"} },
        entities = {},
    }

    for name, _component in pairs(components) do
        add_configs("enable_" .. name, { description = "Enable " .. name .. " module", default = false, type = "boolean"})

        on_component(name, function(package, component)
            local suffix = package:is_debug() and "-d" or ""

            component:add("link", "stormkit-" .. name .. suffix)

            component:add("deps", "core")
            if _component.deps then
                component:add("deps", table.unwrap(_component.deps))
            end
        end)
    end

    on_load(function(package)
        if package:config("enable_assert") then
            package:add("defines", "STORMKIT_ASSERT=1")
        else
            package:add("defines", "STORMKIT_ASSERT=0")
        end

        if not package:config("shared") then
            package:add("defines", "STORMKIT_STATIC")
        end

        if not package:config("use_modules") then
            package:add("defines", "STORMKIT_NO_MODULES")
        end
    end)

    on_install(function(package)
        local configs = {
            kind = package:config("shared") and "shared" or "static",
            mode = package:is_debug() and "debug" or "release",
            use_modules = package:config("use_modules") or false,
            use_cpp23_msvc_import = package:config("use_modules"),
            enable_applications = false,
            enable_entities = package:config("enable_entities"),
            enable_tests = false,
            unity_build = false,
            enable_wsi_wayland = false,
            enable_log = package:config("enable_log"),
            enable_wsi_x11 = false,
            enable_engine = false,
            enable_examples = false,
            enable_image = package:config("enable_image"),
            enable_wsi = false,
            enable_gpu = false,
            enable_pch = true
        }

        import("package.tools.xmake").install(package, configs)
    end)