package("pugixml", function()
    set_kind("library")
    set_homepage("https://github.com/Arthapz/pugixml")
    set_license("MIT")

    set_urls("https://github.com/Arthapz/pugixml.git")

    add_configs("moduleonly", { default = true })

    on_load(function(package)
        if package:config("moduleonly") then
            package:set("kind", "library", { moduleonly = true })
            package:add("defines", "PUGIXML_HEADER_ONLY")
        end
    end)
    on_install(function(package)
        local configs = {
            kind = package:config("shared") and "shared" or "static",
            moduleonly = package:config("moduleonly"),
        }
        io.writefile(
            "xmake.lua",
            format([[
              option("moduleonly", {default = true})
              target("pugixml")
                  if get_config("moduleonly") then
                      set_kind("moduleonly")
                  else
                      set_kind("$(kind)")
                  end
                  set_languages("c++23")
                  add_headerfiles("src/(**.hpp)")
                  add_includedirs("src")
                  add_files("src/*.cppm", {public = true})
                  if is_kind("shared") and not get_config("moduleonly") then
                      add_cxxflags([==[cl::/DPUGIXML_API=__declspec(dllexport)]==])
                      add_cxxflags('-DPUGIXML_API=__attribute__((visibility("default")))', { tools = { "gcc", "clang" } })
                  end
                  if not get_config("moduleonly") then
                      add_files("src/**.cpp")
                  end
          ]])
        )
        if package:config("moduleonly") then os.cp("src/pugixml.cpp", package:installdir("include")) end
        import("package.tools.xmake").install(package, configs)
    end)
end)
