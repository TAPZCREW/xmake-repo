package("vulkan-memory-allocator-hpp_", function()
    set_kind("library", { moduleonly = true })
    set_homepage("https://gpuopen-librariesandsdks.github.io/VulkanMemoryAllocator/html/")
    set_description("C++ bindings for VulkanMemoryAllocator.")
    set_license("CC0")

    add_urls(
        "https://github.com/Arthapz/VulkanMemoryAllocator-Hpp/archive/refs/tags/$(version).tar.gz",
        "https://github.com/Arthapz/VulkanMemoryAllocator-Hpp.git"
    )

    add_configs("modules", { description = "Build with C++20 modules support.", default = false, type = "boolean" })
    add_configs(
        "use_vulkanheaders",
        { description = "Use vulkan-headers package instead of vulkan-hpp.", default = false, type = "boolean" }
    )

    add_deps("vulkan-memory-allocator >=3.1.0")

    on_install("windows|x86", "windows|x64", "linux", "macosx", "mingw", "android", "iphoneos", function(package)
        if not package:config("modules") then
            os.cp("include", package:installdir())
        else
            io.writefile(
                "xmake.lua",
                format([[
                add_requires("vulkan-memory-allocator >=3.1.0", "vulkan-headers")
                target("vulkan-memory-allocator-hpp")
                    set_kind("moduleonly")
                    set_languages("c++20")
                    add_headerfiles("include/(**.hpp)")
                    add_includedirs("include")
                    add_files("src/*.cppm", {public = true})
                    add_packages("vulkan-memory-allocator")
            ]])
            )
            local configs = {}
            import("package.tools.xmake").install(package, configs)
        end
    end)

    on_test(
        function(package)
            assert(package:check_cxxsnippets({
                test = [[
            void test() {
                int version = VMA_VULKAN_VERSION;
            }
        ]],
            }, { includes = "vk_mem_alloc.hpp", configs = { languages = "c++14" } }))
        end
    )
end)
