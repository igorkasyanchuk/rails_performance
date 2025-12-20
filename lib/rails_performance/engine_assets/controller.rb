module RailsPerformance
  class EngineAssets
    class Controller < ActionController::Metal
      include ActionController::DataStreaming
      include ActionController::ConditionalGet
      include ActionController::Head
      include ActionController::Caching

      def show
        file_path = safe_file_path

        if file_path && File.exist?(file_path)
          send_file file_path,
            type: content_type,
            disposition: "inline"

          fresh_when(etag: File.mtime(file_path), public: true)
          expires_in 1.year, public: true
        else
          head :not_found
        end
      end

      private

      cattr_accessor :engine_assets

      def safe_file_path
        requested = params[:file].gsub("..", "")
        format = params[:format] || request.format.symbol.to_s
        engine_assets.asset_path(requested, format)
      end

      def content_type
        format = params[:format] || request.format.symbol.to_s
        engine_assets.content_type(format)
      end
    end
  end
end
