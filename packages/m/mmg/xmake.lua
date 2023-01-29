package("mmg")
    set_homepage("https://gitlab.com/Arthapz/stormkit")

    set_sourcedir("/home/gly/Projets/glap/make_my_glap")
    on_install(function(package)
        local configs = {
            kind = package:config("shared") and "shared" or "static",
            mode = package:is_debug() and "debug" or "release",
        }

        import("package.tools.xmake").install(package, configs)
    end)