package("mdspan", function()
    set_kind("library", { headeronly = true })

    set_homepage("https://github.com/kokkos/mdspan")
    set_description("Reference implementation of mdspan targeting C++23")
    set_license("Apache-2.0")

    add_urls(
        "https://github.com/kokkos/mdspan/archive/refs/tags/$(version).tar.gz",
        "https://github.com/kokkos/mdspan.git"
    )
    add_versions("5.3.0", "ba71517536c646b9160c10e7d83e6aad5663e3289a1f619deb6a3760f252ffae")

    on_install(function(package) os.cp("include/*", package:installdir("include")) end)

    on_test(function(package)
        local test = [[
            #include <cstddef>
            void test() {
                double data[6] = {0, 1, 2, 3, 4, 5};
                std::experimental::mdspan<double, std::experimental::extents<std::size_t, 2, 3>> a(data);
            }
        ]]
        if package:version():lt("0.4.0") then
            -- extents has no index_type template parameter before 0.4.0
            test = [[
                void test() {
                    double data[6] = {0, 1, 2, 3, 4, 5};
                    std::experimental::mdspan<double, std::experimental::extents<2, 3>> a(data);
                }
            ]]
        end
        assert(
            package:check_cxxsnippets(
                { test = test },
                { configs = { languages = "c++17" }, includes = "experimental/mdspan" }
            )
        )
    end)
end)
