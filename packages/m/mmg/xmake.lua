package("mmg")
    set_homepage("https://gitlab.com/Arthapz/stormkit")

    on_load(function(package)
        package:set("sourcedir",os.getenv("PROJECTS") .. "/glap/make_my_glap")
    end)
    on_install(function(package)
        local configs = {
            kind = package:config("shared") and "shared" or "static",
            mode = package:is_debug() and "debug" or "release",
        }

        import("package.tools.xmake").install(package, configs)
    end)