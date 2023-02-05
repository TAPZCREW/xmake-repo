package("mmg")
    set_homepage("https://github.com/glcraft/make-my-glap")

    add_deps("glap")

    on_load(function(package)
        local mmg_local_source = path.absolute("../../../../make-my-glap", os.scriptdir())  -- for [glap constellation](https://gitlab.com/glcraft/glap-constellation)
        if os.isdir(mmg_local_source) and false then
            package:set("sourcedir", mmg_local_source)
        else
            package:add("urls", "https://github.com/glcraft/make-my-glap.git")
            package:add("versions", "2023-02-05", "e2a737c855f325c86e827033b6ca18f0612681d2")
            package:add("versions", "latest", "e2a737c855f325c86e827033b6ca18f0612681d2")
        end
    end)
    on_install(function(package)
        local configs = {
            kind = package:config("shared") and "shared" or "static",
            mode = package:is_debug() and "debug" or "release",
        }

        import("package.tools.xmake").install(package, configs)
    end)