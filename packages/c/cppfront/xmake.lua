package("cppfront")
    set_homepage("https://github.com/hsutter/cppfront")
    set_description("Herb Sutter's experimental C++ Syntax 2 -> Syntax 1 compiler")
    set_license("CC-BY-NC-ND-4.0")

    add_urls("https://github.com/hsutter/cppfront.git")

    add_versions("2022.09.17", "8140ab920a38e9cc66d1862c9b823a98a9f25e3b")

    on_install(function(package)
        io.writefile("xmake.lua", [[
            target("cppfront")
                set_languages("cxxlatest", "clatest")
                set_kind("binary")
                add_files("source/*.cpp")
                add_headerfiles("source/*.h")
        ]])
        import("package.tools.xmake").install(package, {})
        package:addenv("PATH", "bin")
    end)

    on_test(function(package)
        os.vrun("cppfront --help")
    end)