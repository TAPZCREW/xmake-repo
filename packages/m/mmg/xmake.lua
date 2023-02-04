package("mmg")
    set_homepage("https://gitlab.com/Arthapz/stormkit")

    add_deps("glap")

    on_load(function(package)
        package:set("sourcedir", path.absolute("../../../../make-my-glap", os.scriptdir()))
    end)
    on_install(function(package)
        local configs = {
            kind = package:config("shared") and "shared" or "static",
            mode = package:is_debug() and "debug" or "release",
        }

        import("package.tools.xmake").install(package, configs)
    end)