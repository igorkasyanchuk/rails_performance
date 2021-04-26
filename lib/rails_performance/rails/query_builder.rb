module RailsPerformance
  module Rails
    class QueryBuilder

      def QueryBuilder.compose_from(params)
        result = {}

        result[:controller] = params[:controller_eq]
        result[:action]     = params[:action_eq]
        result[:format]     = params[:format_eq]
        result[:status]     = params[:status_eq]

        result.delete_if {|k, v| v.nil?}

        { q: result }
      end

    end
  end
end