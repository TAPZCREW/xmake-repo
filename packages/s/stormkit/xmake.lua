package("stormkit", function()
    set_homepage("https://gitlab.com/Arthapz/stormkit")

    set_urls("https://github.com/Arthapz/stormkit.git")
    set_kind("library")

    set_policy("package.strict_compatibility", true)

    add_components("stormkit", { default = true, readyonly = true })
    add_components("core", { default = true, readyonly = true })
    add_components("main", { default = true, readyonly = true })
    add_components("log", { default = false })
    add_components("wsi", { default = false })
    add_components("entities", { default = false })
    add_components("image", { default = false })
    add_components("gpu", { default = false })
    add_components("lua", { default = false })

    add_configs("core", { description = "Enable core module", default = true, type = "boolean", readyonly = true })
    add_configs("assertion", { description = "Enable assertions", default = true, type = "boolean" })

    add_configs("log", { description = "Build log module", default = true, type = "boolean" })
    add_configs("wsi", { description = "Build wsi module", default = true, type = "boolean" })
    add_configs("entities", { description = "Build entities module", default = true, type = "boolean" })
    add_configs("image", { description = "Build image module", default = true, type = "boolean" })
    add_configs("gpu", { description = "Build gpu module", default = true, type = "boolean" })
    add_configs("lua", { description = "Build lua module", default = true, type = "boolean" })

    add_configs("examples", { description = "Build examples", default = false, type = "boolean" })

    add_configs("lto", { description = "Enable lto", default = false, type = "boolean" })

    add_versions("20251102", "db479e8c916dbec739279cd7fab5db1b7b8acb41")
    add_versions("20251105", "85f6d4997bed98607ffc644c0cb278e4cb4ce8db")
    add_versions("20251106", "617c7f5c6f69d1822c97dc8442e5eb0032437eda")
    add_versions("20251107", "76d1a6e28d5328e3c8b1b12be5379986e840709b")
    add_versions("20251115", "15a641ba541188f3621de33ad94f9e44fd95e071")
    add_versions("20260206", "a1559694da2401281e7a5a100d9fad9a2f0ad3e0")
    add_versions("20260208", "9a5180192045abab69e745d2a697191357387d63")

    add_versions("dev", "6e9055633cd8c35a4ddff587c2b6c144e38899d5")

    add_bindirs("bin")
    add_includedirs("include")
    add_linkdirs("lib")

    on_component("stormkit", function(package, component)
        print("AAAAAAAAAAAAAAA", package:components())
        component:add("links", "stormkit")

        component:add("deps", "core")
        component:add("deps", "main")
        for name, _ in pairs(package:components()) do
            if name ~= "stormkit" and name ~= "main" and name ~= "core" and package:config(name) then
                component:add("deps", name)
            end
        end
    end)

    on_component("core", function(package, component)
        local suffix = (not package:config("shared") and "-static" or "")
            .. (package:config("debug") and "-debug" or "")
        component:add("links", "core" .. suffix)

        component:add("defines", "ANKERL_UNORDERED_DENSE_STD_MODULE=1", "FROZEN_STD_MODULE=1")
        package:add("deps", "frozen", {
            system = false,
            configs = {
                modules = true,
                std_import = true,
                cpp = "latest",
            },
        })
        package:add("deps", "unordered_dense", {
            system = false,
            configs = {
                modules = true,
                std_import = true,
            },
        })
        package:add("deps", "tl_function_ref", {
            system = false,
            configs = {
                modules = true,
                std_import = true,
            },
        })
    end)

    on_component("main", function(package, component)
        local suffix = (not package:config("shared") and "-static" or "")
            .. (package:config("debug") and "-debug" or "")
        component:add("links", "main" .. suffix)

        component:add("deps", "core")
    end)

    on_component("log", function(package, component)
        if package:config("log") then
            local suffix = (not package:config("shared") and "-static" or "")
                .. (package:config("debug") and "-debug" or "")
            component:add("links", "log" .. suffix)

            component:add("deps", "core")
        end
    end)

    on_component("entities", function(package, component)
        if package:config("entities") then
            local suffix = (not package:config("shared") and "-static" or "")
                .. (package:config("debug") and "-debug" or "")
            component:add("links", "entities" .. suffix)

            component:add("deps", "core")
        end
    end)

    on_component("lua", function(package, component)
        local is_libcpp = package:is_plat("linux") and package:has_runtime("c++_shared", "c++_static")
        if package:config("lua") then
            local suffix = (not package:config("shared") and "-static" or "")
                .. (package:config("debug") and "-debug" or "")
            component:add("links", "lua" .. suffix)

            component:add("deps", "core")
            component:add("defines", "STORMKIT_LUA_BINDING")

            package:add("deps", "luau", {
                system = false,
                version = "upstream",
                configs = {
                    shared = false,
                    extern_c = true,
                    build_cli = false,
                    cxxflags = is_libcpp and { "-stdlib=libc++" } or nil,
                    shflags = is_libcpp and { "-stdlib=libc++" } or nil,
                    arflags = is_libcpp and { "-stdlib=libc++" } or nil,
                },
            })
            package:add("deps", "sol2_luau", {
                system = false,
                version = "develop",
            })
        end
    end)

    on_component("image", function(package, component)
        if package:config("image") then
            local suffix = (not package:config("shared") and "-static" or "")
                .. (package:config("debug") and "-debug" or "")

            component:add("links", "image" .. suffix)

            component:add("deps", "core")

            package:add("deps", "libktx", "libpng")
            package:add("deps", "libjpeg-turbo", is_plat("windows") and {
                system = false,
                configs = {
                    runtimes = "MD",
                    shared = true,
                },
            } or {})
        end
    end)

    on_component("gpu", function(package, component)
        if package:config("gpu") then
            local suffix = (not package:config("shared") and "-static" or "")
                .. (package:config("debug") and "-debug" or "")
            component:add("links", "gpu" .. suffix)

            component:add("deps", "core", "log", "wsi", "image")
            component:add("defines", "STORMKIT_GPU_VULKAN")

            package:add("deps", "volk", { version = "1.4.335" })
            package:add("deps", "vulkan-headers", {
                version = "1.4.335",
                system = false,
                configs = {
                    modules = false,
                },
            })
            package:add("deps", "vulkan-memory-allocator", {
                version = "v3.3.0",
                system = false,
            })
        end
    end)

    on_component("wsi", function(package, component)
        if package:config("wsi") then
            local suffix = (not package:config("shared") and "-static" or "")
                .. (package:config("debug") and "-debug" or "")
            component:add("links", "wsi" .. suffix)

            component:add("deps", "core")

            if package:is_plat("linux") then
                package:add(
                    "deps",
                    "libxcb",
                    "xcb-util-keysyms",
                    "xcb-util",
                    "xcb-util-image",
                    "xcb-util-wm",
                    "xcb-util-errors",
                    "wayland",
                    "wayland-protocols"
                )
                package:add("deps", "libxkbcommon", {
                    system = false,
                    configs = {
                        wayland = true,
                        x11 = true,
                    },
                })
            elseif package:is_plat("windows") then
                component:add("syslinks", "User32", "Shell32", "Gdi32", "Shcore", "Gdiplus")
            elseif package:is_plat("macosx") then
            end
        end
    end)

    on_load(function(package)
        if not package:config("shared") then package:add("defines", "STORMKIT_STATIC") end
    end)

    on_install(function(package)
        local configs = {
            kind = package:config("shared") and "shared" or "static",
            mode = package:is_debug() and "debug" or "release",

            log = package:config("log"),
            wsi = package:config("wsi"),
            entities = package:config("entities"),
            image = package:config("image"),
            gpu = package:config("gpu"),
            lua = package:config("lua"),

            examples = package:config("examples"),

            lto = package:config("lto"),
        }

        import("package.tools.xmake").install(package, configs)
    end)
end)
