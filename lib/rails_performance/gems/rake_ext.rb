module RailsPerformance
  module Gems
    class RakeExt
      def self.init
        ::Rake::Task.class_eval do
          next if method_defined?(:invoke_with_rails_performance)

          def invoke_with_rails_performance(*args)
            now = RailsPerformance::Utils.time
            status = "success"
            invoke_without_new_rails_performance(*args)
          rescue Exception => ex # rubocop:disable Lint/RescueException
            status = "error"
            raise(ex)
          ensure
            if !RailsPerformance.skipable_rake_tasks.include?(name)
              task_info = RailsPerformance::Gems::RakeExt.find_task_name(*args)
              task_info = [name] if task_info.empty?
              RailsPerformance::Models::RakeRecord.new(
                task: task_info,
                datetime: now.strftime(RailsPerformance::FORMAT),
                datetimei: now.to_i,
                duration: (RailsPerformance::Utils.time - now) * 1000,
                status: status
              ).save
            end
          end

          alias_method :invoke_without_new_rails_performance, :invoke
          alias_method :invoke, :invoke_with_rails_performance

          def invoke(*args) # rubocop:disable Lint/DuplicateMethods
            invoke_with_rails_performance(*args)
          end
        end
      end

      def self.find_task_name(*args)
        (ARGV + args).compact
      end
    end
  end
end
