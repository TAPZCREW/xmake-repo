package("pugixml", function()
    set_kind("library", { moduleonly = true })
    set_homepage("https://github.com/Arthapz/pugixml")
    set_license("MIT")

    set_urls("https://github.com/Arthapz/pugixml.git")

    add_configs("moduleonly", { default = true })

    on_load(function(package)
        if package:config("moduleonly") then package:add("defines", "PUGIXML_HEADER_ONLY") end
    end)

    on_install(function(package)
        local kind = "$(kind)"
        if package:config("moduleonly") then kind = "moduleonly" end
        io.writefile(
            "xmake.lua",
            format(
                [[
              target("pugixml")
                  set_kind("%s")
                  set_languages("c++23")
                  add_headerfiles("src/(**.hpp)")
                  add_includedirs("src")
                  add_files("src/*.cppm", {public = true})
          ]],
                kind
            )
        )
        os.cp("src/pugixml.cpp", package:installdir("include"))
        import("package.tools.xmake").install(package, configs)
    end)
end)
