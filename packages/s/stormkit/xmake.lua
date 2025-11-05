package("stormkit", function()
    set_homepage("https://gitlab.com/Arthapz/stormkit")

    set_urls("https://github.com/TapzCrew/stormkit.git")
    set_kind("library")

    add_components("core", { default = true, readyonly = true })
    add_components("main", { default = true, readyonly = true })
    add_components("log", { default = false })
    add_components("wsi", { default = false })
    add_components("entities", { default = false })
    add_components("image", { default = false })
    add_components("gpu", { default = false })

    add_configs("core", { description = "Enable core module", default = true, type = "boolean", readyonly = true })
    add_configs("assertion", { description = "Enable assertions", default = true, type = "boolean" })

    add_configs("main", { description = "Build main module", default = true, type = "boolean", readyonly = true })
    add_configs("log", { description = "Build log module", default = true, type = "boolean" })
    add_configs("wsi", { description = "Build wsi module", default = true, type = "boolean" })
    add_configs("entities", { description = "Build entities module", default = true, type = "boolean" })
    add_configs("image", { description = "Build image module", default = true, type = "boolean" })
    add_configs("gpu", { description = "Build gpu module", default = true, type = "boolean" })

    add_configs("examples", { description = "Build examples", default = false, type = "boolean" })

    add_versions("20251102", "db479e8c916dbec739279cd7fab5db1b7b8acb41")
    add_versions("20251105", "85f6d4997bed98607ffc644c0cb278e4cb4ce8db")
    add_versions("20251106", "617c7f5c6f69d1822c97dc8442e5eb0032437eda")

    local components = {
        core = {
            package_deps = { "frozen", "unordered_dense", "tl_function_ref" },
            defines = { "ANKERL_UNORDERED_DENSE_STD_MODULE=1", "FROZEN_STD_MODULE=1" },
        },
        main = { deps = "core" },
        log = { deps = "core" },
        wsi = { deps = "core" },
        entities = { deps = "core" },
        image = { deps = "core", package_deps = { "libktx", "libpng", "libjpeg" } },
        gpu = {
            deps = {
                "core",
                "log",
                "wsi",
                "image",
            },
            package_deps = {
                "volk",
                "vulkan-headers v1.4.309",
                "vulkan-memory-allocator 3.2.1",
            },
            defines = {
                "STORMKIT_GPU_VULKAN",
            },
        },
    }

    for name, _component in pairs(components) do
        on_component(name, function(package, component)
            local suffix = package:is_debug() and "-d" or ""

            component:add("links", "stormkit-" .. name .. suffix)

            if _component.defines then component:add("defines", table.unwrap(_component.defines)) end
            if _component.deps then component:add("deps", table.unwrap(_component.deps)) end
            if _component.links and not package:config("shared") then
                component:add("links", table.unwrap(_component.links))
            end
        end)
    end

    on_load(function(package)
        if not package:config("shared") then package:add("defines", "STORMKIT_STATIC") end
        for name, _component in pairs(components) do
            if package:config(name) and _component.package_deps then
                package:add("deps", table.unwrap(_component.package_deps), { modules = true })
            end
        end
    end)

    on_install(function(package)
        local configs = {
            kind = package:config("shared") and "shared" or "static",
            mode = package:is_debug() and "debug" or "release",

            main = package:config("main"),
            log = package:config("log"),
            wsi = package:config("wsi"),
            entities = package:config("entities"),
            image = package:config("image"),
            gpu = package:config("gpu"),

            examples = package:config("examples"),
        }

        import("package.tools.xmake").install(package, configs)
    end)
end)
