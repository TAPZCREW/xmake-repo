package("magic_enum", function()
	set_kind("library", { headeronly = true })
	set_homepage("https://github.com/Neargye/magic_enum")
	set_description(
		"Static reflection for enums (to string, from string, iteration) for modern C++, work with any enum type without any macro or boilerplate code"
	)
	set_license("MIT")

	add_urls("https://github.com/Arthapz/magic_enum.git")

	add_versions("20250429", "0084a0c92deb438a0c6ce9b56d67902140009d0a")

	add_configs("modules", { description = "Build with C++20 modules support.", default = false, type = "boolean" })

	-- after v0.9.6 include files need to be prepended with magic_enum directory
	add_includedirs("include", "include/magic_enum")

	add_deps("cmake")

	on_install(function(package)
		local version = package:version()
		if version and version:lt("0.9.6") or not package:config("modules") then
			local configs = {
				"-DMAGIC_ENUM_OPT_BUILD_EXAMPLES=OFF",
				"-DMAGIC_ENUM_OPT_BUILD_TESTS=OFF",
				"-DMAGIC_ENUM_OPT_INSTALL=ON",
			}
			table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
			import("package.tools.cmake").install(package, configs)
		else
			io.writefile(
				"xmake.lua",
				[[ 
                target("magic_enum")
                    set_kind("moduleonly")
                    set_languages("c++20")
                    add_headerfiles("include/(magic_enum/**.hpp)")
                    add_includedirs("include")
                    add_files("module/**.cppm", {public = true})
            ]]
			)
			import("package.tools.xmake").install(package)
		end
	end)

	on_test(function(package)
		assert(package:check_cxxsnippets({
			test = [[
            enum class Color { RED = 2, BLUE = 4, GREEN = 8 };
            void test() {
                Color color = Color::RED;
                auto color_name = magic_enum::enum_name(color);
            }
        ]],
		}, { configs = { languages = "c++17" }, includes = "magic_enum.hpp" }))
	end)
end)
