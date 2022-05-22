package("stormkit")

    set_homepage("https://gitlab.com/Arthapz/stormkit")

    set_urls("https://gitlab.com/Arthapz/stormkit.git")
    add_versions("latest", "main")

    add_configs("enable_wsi", {description = "Enable WSI support", default = true, type = "boolean"})
    add_configs("unity_build", {description = "Enable Unity build", default = true, type = "boolean"})

    if is_plat("linux") then
        add_configs("enable_wsi_x11", {description = "Enable X11 WSI support", default = true, type = "boolean"})
        add_configs("enable_wsi_wayland", {description = "Enable Wayland WSI support", default = true, type = "boolean"})
    end

    on_install(function(package)
    
        local configs = {}
        configs.kind = package:config("shared") and "shared" or "static"
        configs.enable_wsi = package:config("enable_wsi")
        configs.unity_build = package:config("unity_build")

        if is_plat("linux") then
            configs.enable_wsi_x11 = package:config("enable_wsi_x11")
            configs.enable_wsi_wayland = package:config("enable_wsi_wayland")
        end

        import("package.tools.xmake").install(package, configs)

    end)