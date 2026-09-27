package("beman_optional", function()
    set_kind("library", { headeronly = true })
    set_homepage("https://github.com/bemanproject/optional")
    set_description("std::optional extensions adopted for C++26")
    set_license("Apache-2.0")

    add_urls("https://github.com/bemanproject/optional.git")

    on_install(
        function(package)
            import("package.tools.cmake").install(
                package,
                { BEMAN_OPTIONAL_BUILD_EXAMPLES = false, BEMAN_OPTIONAL_BUILD_TESTS = false }
            )
        end
    )

    on_test(
        function(package)
            assert(package:check_cxxsnippets({
                test = [[
            #include <beman/optional/optional.hpp>

            void test() {
                beman::optional::optional<int> empty_opt{};
            }
        ]],
            }, { configs = { languages = "cxx20" } }))
        end
    )
end)
