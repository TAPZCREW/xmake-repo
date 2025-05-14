package("ftxui")
    set_homepage("https://github.com/ArthurSonzogni/FTXUI")
    set_description(":computer: C++ Functional Terminal User Interface. :heart:")
    set_license("MIT")

    add_urls("https://github.com/mikomikotaishi/FTXUI/archive/refs/tags/$(version).tar.gz",
             "https://github.com/mikomikotaishi/FTXUI.git")

    add_deps("cmake")

    add_configs("modules", { default = false, type = "boolean" })
    add_configs("microsoft_fallback_terminal", { default = true, description = "On windows, assume the \
terminal used will be one of Microsoft and use a set of reasonnable fallback \
to counteract its implementations problems.", type = "boolean" })

    if is_plat("windows") then
        add_configs("shared", {description = "Build shared library.", default = false, type = "boolean", readonly = true})
    elseif is_plat("linux", "bsd") then
        add_syslinks("pthread")
    end

    add_components("screen", "dom", "component")

    on_load(function(package)
        if package:config("modules") then
            assert(package:gitref() or (package:version() and package:version():gt("1.0")), "modules support is not compatible with ftxui <= 1.0")
        end
    end)

    on_component("screen", function(_, component)
        component:add("links","ftxui-screen")
    end)

    on_component("dom", function(_, component)
        component:add("links", "ftxui-dom")
        component:add("deps", "screen")
    end)

    on_component("component", function(_, component)
        component:add("links", "ftxui-component")
        component:add("deps", "dom")
    end)

    on_install("linux", "windows", "macosx", "bsd", "mingw", "cross", function (package)
        if package:config("modules") then
            os.cp(path.join(package:scriptdir(), "port", "xmake.lua"), ".")
            import("package.tools.xmake").install(package, {modules = package:config("modules"), microsoft_fallback_terminal = package:config("microsoft_fallback_terminal")})
        else
            local configs = {"-DFTXUI_BUILD_DOCS=OFF", "-DFTXUI_BUILD_EXAMPLES=OFF"}
            table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
            table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
            table.insert(configs, "-DFTXUI_MICROSOFT_TERMINAL_FALLBACK=" .. (package:config("microsoft_fallback_terminal") and "ON" or "OFF"))
            import("package.tools.cmake").install(package, configs)
        end
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <memory>
            #include <string>

            #include "ftxui/component/captured_mouse.hpp"
            #include "ftxui/component/component.hpp"
            #include "ftxui/component/component_base.hpp"
            #include "ftxui/component/screen_interactive.hpp"
            #include "ftxui/dom/elements.hpp"

            using namespace ftxui;

            void test() {
                int value = 50;
                auto buttons = Container::Horizontal({
                  Button("Decrease", [&] { value--; }),
                  Button("Increase", [&] { value++; }),
                });
                auto component = Renderer(buttons, [&] {
                return vbox({
                           text("value = " + std::to_string(value)),
                           separator(),
                           gauge(value * 0.01f),
                           separator(),
                           buttons->Render(),
                       }) |
                       border;
                });
                auto screen = ScreenInteractive::FitComponent();
                screen.Loop(component);
            }
        ]]}, {configs = {languages = "c++17"}}))
    end)
