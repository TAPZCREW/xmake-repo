package("pugixml", function()
	set_kind("library", { moduleonly = true })
	set_homepage("https://github.com/Arthapz/pugixml")
	set_license("MIT")

	set_urls("https://github.com/Arthapz/pugixml.git")

	on_install(function(package)
    io.writefile(
      "xmake.lua",
      format([[
              target("pugixml")
                  set_kind("moduleonly")
                  set_languages("c++23")
                  add_headerfiles("src/(**.hpp)")
                  add_includedirs("src")
                  add_files("src/*.cppm", {public = true})
          ]])
    )
    os.cp("src/pugixml.cpp", package:installdir("include"))
		import("package.tools.xmake").install(package, configs)
	end)
end)
