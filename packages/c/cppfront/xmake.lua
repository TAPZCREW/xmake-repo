package("cppfront")
    set_homepage("https://github.com/hsutter/cppfront")
    set_description("Herb Sutter's experimental C++ Syntax 2 -> Syntax 1 compiler")
    set_license("CC-BY-NC-ND-4.0")

    add_urls("https://github.com/hsutter/cppfront.git")

    add_versions("2022.09.17", "8140ab920a38e9cc66d1862c9b823a98a9f25e3b")
    add_versions("2022.09.23", "5b100f62aa18b4af6306aa24385c2369d75e0c36")

    on_install(function(package)
        io.writefile("xmake.lua", [[
            target("cppfront")
                set_languages("cxxlatest", "clatest")
                set_kind("binary")
                add_files("source/*.cpp")
                add_headerfiles("source/*.h")

            target("cppfront_runtime")
                set_languages("cxxlatest", "clatest")
                set_kind("headeronly")
                add_headerfiles("include/*.h")
                add_includedirs("include", {public = true})
        ]])
        import("package.tools.xmake").install(package, {})
        package:addenv("PATH", "bin")
    end)

    on_test(function(package)
        os.vrun("cppfront --help")
    end)