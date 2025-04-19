package("unordered_dense")
    set_base("unordered_dense")

    set_urls("https://github.com/Arthapz/unordered_dense.git")

    add_configs("modules", {description = "Build with C++23 std modules support.", default = false, type = "boolean"})
    add_configs("std_import", {description = "Build with C++23 std modules support.", default = false, type = "boolean"})
    add_configs("cpp", {description = "Build with C++23 std modules support.", default = "20", type = "string"})

    add_versions("20250419", "82f820af48f5f4e9c5c37c754af4e13e8f8f98cd")

    on_load(function(package)
        local cpp = package:config("cpp")
        assert(cpp == "20" or cpp == "23" or cpp == "26" or cpp == "latest")
    end)
    
    on_install(function (package)
        if not package:config("modules") then
            import("package.tools.cmake").install(package)
            os.cp("include", package:installdir())
        else
            os.cp("src/ankerl.unordered_dense.cpp", "src/ankerl.unordered_dense.cppm")
            io.writefile("xmake.lua", [[
                option("std_import", {default = true, defines = "ANKERL_UNORDERED_DENSE_USE_STD_IMPORT"})
                option("cpp", {default = "20"})
                target("unordered_dense")
                    set_kind("moduleonly")
                    set_languages("c++" .. (get_config("cpp") or "20"))
                    add_headerfiles("include/(**.h)")
                    add_includedirs("include")
                    add_files("src/**.cppm", {public = true})
                    add_options("std_import", "cpp")
            ]])
            local configs = {cpp = package:config("cpp"), std_import = package:config("std_import")}
            import("package.tools.xmake").install(package, configs)
        end
    end)
