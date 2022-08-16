package("frozen")

    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/serge-sans-paille/frozen")
    set_description("A header-only, constexpr alternative to gperf for C++14 users")
    set_license("Apache-2.0")

    set_urls("https://github.com/arthapz/frozen.git")

    add_versions("1.1.1-modules", "ec07d71e1d01b3a5778490b78cd717c9588af664")

    on_install(function (package)
        os.cp("include/frozen", package:installdir("include"))
    end)