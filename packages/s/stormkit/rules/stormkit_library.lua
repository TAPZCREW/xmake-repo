rule("library", function()
    add_deps("@flags")

    on_config(function(target)
        import("core.base.hashset")

        local stormkit_components = target:values("stormkit.components") or {}
        local stormkit_components_set = hashset.from(stormkit_components)

        if not target:kind() then target:set("kind", "$(kind)") end
        target:set("languages", "cxxlatest", "clatest")

        -- core --
        target:add("packages", "frozen", "unordered_dense", "tl_function_ref")

        if stormkit_components_set:has("image") then target:add("packages", "libktx", "libpng", "libjpeg-turbo") end
        if stormkit_components_set:has("wsi") then
            if target:is_plat("linux") then
                target:add(
                    "packages",
                    "libxcb",
                    "xcb-util-keysyms",
                    "xcb-util",
                    "xcb-util-image",
                    "xcb-util-wm",
                    "xcb-util-errors",
                    "wayland",
                    "wayland-protocols",
                    "libxkbcommon"
                )
            end
        end
        if stormkit_components_set:has("gpu") then
            target:add("packages", "volk", "vulkan-headers", "vulkan-memory-allocator")
        end

        target:add("packages", "stormkit", { components = table.join("core", "main", stormkit_components) })
    end)
end)
