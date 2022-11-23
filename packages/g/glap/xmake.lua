package("glap_")
    set_homepage("http://glew.sourceforge.net/")
    set_description("A cross-platform open-source C/C++ extension loading library.")

    set_urls("https://github.com/glcraft/glap/archive/refs/tags/v$(version).zip")
    add_versions("2.0.0", "833c04fb4f2f722751f9122220c8c6e58cf739de3aa9a42734f9d3a54a9d7cde")
    add_configs("use_tl_expected", {description = "Use tl::expected instead of std::expected", default = true, type = "boolean"})
    add_configs("use_fmt", {description = "Use fmt library instead of std format library", default = true, type = "boolean"})

    on_load(function (package)
        for _, dep in ipairs({"tl_expected", "fmt"}) do
            if package:config("use_" .. dep) then 
                package:add("deps", dep)
                package:add("defines", "GLAP_USE_" .. dep:upper())
            end
        end
    end)

    on_install(function (package)
        local configs = {}
        for _, dep in ipairs({"tl_expected", "fmt"}) do
            -- if package:config("use_" .. dep) then
                configs["use_" .. dep] = true
            -- end
        end
        if package:config("shared") then
            configs.kind = "shared"
        end
        configs.target = "glap"
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            using command_t = glap::model::Command<glap::Names<"command">>;
            using program_t = glap::model::Program<"myprogram", glap::model::DefaultCommand::None, command_t>;
            void test() {
                using namespace std::literals;
                auto result = glap::parser<program_t>(std::array{"pyprogram"sv});
            }
        ]]}, {configs = {languages = "c++20"}, includes = {"glap/glap.h", "array", "string_view"}}))
    end)