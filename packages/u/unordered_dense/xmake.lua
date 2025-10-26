package("unordered_dense", function()
    set_base("unordered_dense")

    set_urls("https://github.com/Arthapz/unordered_dense.git")

    add_configs("modules", { description = "Build with C++23 std modules support.", default = false, type = "boolean" })

    add_versions("20250419", "b45d4094c202f012385fd43b066df6df258c0700")
    add_versions("20251021", "b37bf4b303d6bb4a4b236726b819680d05636323")
    add_versions("20251026", "f70d6986b06b853a1aaef9545c85e1b27231f75a")

    on_install(function(package)
        if not package:config("modules") then
            import("package.tools.cmake").install(package)
            os.cp("include", package:installdir())
        else
            os.cp("src/ankerl.unordered_dense.cpp", "src/ankerl.unordered_dense.cppm")
            io.writefile(
                "xmake.lua",
                [[
                target("unordered_dense")
                    set_kind("moduleonly")
                    set_languages("c++20")
                    add_headerfiles("include/(**.h)")
                    add_includedirs("include")
                    add_files("src/**.cppm", {public = true})
            ]]
            )
            import("package.tools.xmake").install(package)
        end
    end)
end)
