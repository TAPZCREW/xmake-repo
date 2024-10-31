package("stormkit", function()
	set_homepage("https://gitlab.com/Arthapz/stormkit")

	set_urls("https://github.com/TapzCrew/stormkit.git")

	add_components("core", { default = true, readyonly = true })
	add_components("main", { default = true, readyonly = true })
	add_components("log", { default = false })
	add_components("wsi", { default = false })
	add_components("entities", { default = false })
	add_components("image", { default = false })
	add_components("gpu", { default = false })
	add_components("engine", { default = false })

	add_configs("core", { description = "Enable core module", default = true, type = "boolean", readyonly = true })
	add_configs("assertion", { description = "Enable assertions", default = true, type = "boolean" })

	add_configs("main", { description = "Build main module", default = true, type = "boolean", readyonly = true })
	add_configs("log", { description = "Build log module", default = true, type = "boolean" })
	add_configs("wsi", { description = "Build wsi module", default = true, type = "boolean" })
	add_configs("entities", { description = "Build entities module", default = true, type = "boolean" })
	add_configs("image", { description = "Build image module", default = true, type = "boolean" })
	add_configs("gpu", { description = "Build gpu module", default = true, type = "boolean" })
	add_configs("engine", { description = "Build engine module", default = false, type = "boolean" })

	add_configs("examples", { description = "Build examples", default = false, type = "boolean" })

	local components = {
		core = { external_deps = { "glm", "frozen", "unordered_dense", "magic_enum", "tl_function_ref" } },
		main = { deps = "core" },
		log = { deps = "core" },
		wsi = { deps = "core" },
		entities = { deps = "core" },
		image = { deps = "core", external_deps = { "gli", "libpng", "libjpeg" } },
		gpu = {
			deps = { "core", "log", "wsi", "image" },
			external_deps = {
				"vulkan-headers >= v1.3.297",
				"vulkan-memory-allocator >= 3.1.0",
				"vulkan-memory-allocator-hpp",
			},
		},
		engine = { deps = { "core", "log", "wsi", "entities", "image", "gpu" } },
	}

	for name, _component in pairs(components) do
		on_component(name, function(package, component)
			local suffix = package:is_debug() and "-d" or ""

			component:add("link", "stormkit-" .. name .. suffix)

			if _component.deps then
				component:add("deps", table.unwrap(_component.deps))
			end
			if _component.external_deps then
				component:add("deps", table.unwrap(_component.external_deps))
			end
		end)
	end

	on_load(function(package)
		if package:config("assertions") then
			package:add("defines", "STORMKIT_ASSERT=1")
		else
			package:add("defines", "STORMKIT_ASSERT=0")
		end

		if not package:config("shared") then
			package:add("defines", "STORMKIT_STATIC")
		end
	end)

	on_install(function(package)
		local configs = {
			kind = package:config("shared") and "shared" or "static",
			mode = package:is_debug() and "debug" or "release",

			main = package:config("main"),
			log = package:config("log"),
			wsi = package:config("wsi"),
			entities = package:config("entities"),
			image = package:config("image"),
			gpu = package:config("gpu"),
			engine = package:config("engine"),

			examples = package:config("examples"),
		}

		import("package.tools.xmake").install(package, configs)
	end)
end)

