module RailsPerformance
  class EngineAssets
    module Helper
      mattr_accessor :engine_assets

      def engine_asset_url(source, type)
        fingerprint_value = engine_assets.fingerprint(source, type)
        normalized_type = case type.to_s
        when "javascript" then "js"
        when "stylesheet" then "css"
        else type.to_s
        end
        engine_asset_path("#{source}.#{normalized_type}", v: fingerprint_value)
      end

      def engine_stylesheet_link_tag(source, **options)
        tag.link(
          rel: "stylesheet",
          href: engine_asset_url(source, "css"),
          **options
        )
      end

      def engine_javascript_include_tag(source, **options)
        tag.script(
          src: engine_asset_url(source, "js"),
          **options
        )
      end

      def engine_javascript_importmap_tags(entry_point = "application", imports = {})
        assets_root = engine_assets.engine.root.join("app/#{engine_assets.assets_subdir}/javascripts")
        engine_imports = engine_assets.javascript_files.each_with_object({}) do |path, hash|
          relative_path = path.relative_path_from(assets_root).to_s
          key = "#{engine_assets.engine.engine_name}/#{relative_path.sub(/\.js\z/, "")}"
          hash[key] = engine_asset_url(relative_path.sub(/\.js\z/, ""), "js")
        end
        [
          tag.script(type: "importmap") do
            JSON.pretty_generate({"imports" => imports.merge(engine_imports)}).html_safe
          end,
          tag.script(<<~JS.html_safe, type: "module")
            import "#{engine_assets.engine.engine_name}/#{entry_point}"
          JS
        ].join("\n").html_safe
      end
    end
  end
end
