package("glap")
    set_homepage("http://glew.sourceforge.net/")
    set_description("A cross-platform open-source C/C++ extension loading library.")
    set_license("MIT")

    -- add_urls("https://github.com/glcraft/glap.git")
    -- add_versions("2.0.0", "d336c8b7ae23fbf059480197078c9f0303ef5b14")
    -- add_versions("2.0.1", "4b80020be6e29e508d805f475a06b9bedbe7b97a")
    -- add_versions("2.1", "c44f019c0f7e283540f2fe2465398542a5db4780")
    
    add_configs("use_tl_expected", {description = "Use tl::expected instead of std::expected", default = true, type = "boolean"})
    add_configs("use_fmt", {description = "Use fmt library instead of std format library", default = true, type = "boolean"})

    on_load(function (package)
        package:set("sourcedir",os.getenv("PROJECTS") .. "/glap")
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
            configs["use_" .. dep]  = package:config("use_" .. dep) ~= nil
        end
        if package:config("shared") then
            configs.kind = "shared"
        end
        configs.target = "glap"
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        local language = "cxx20"

        if not has_config("use_tl_expected") then
            language = "cxx23"
        end

        assert(package:check_cxxsnippets({test = [[
            using command_t = glap::model::Command<glap::Names<"command">>;
            using program_t = glap::model::Program<"myprogram", glap::model::DefaultCommand::None, command_t>;
            void test() {
                using namespace std::literals;
                auto result = glap::parser<program_t>(std::array{"pyprogram"sv});
            }
        ]]}, {configs = {languages = language}, includes = {"glap/glap.h", "array", "string_view"}}))
    end)
