module RailsPerformance
  module Gems

    class RakeExt
      def self.init
        ::Rake::Task.class_eval do
          def invoke_with_rails_performance(*args)
            begin
              now    = Time.current
              status = 'success'
              invoke_without_new_rails_performance(*args)
            rescue Exception => ex
              status = 'error'
              raise(ex)
            ensure
              if !RailsPerformance.skipable_rake_tasks.include?(self.name)
                task_info = RailsPerformance::Gems::RakeExt.find_task_name(*args)
                task_info = [self.name] if task_info.empty?
                RailsPerformance::Models::RakeRecord.new(
                  task: task_info,
                  datetime: now.strftime(RailsPerformance::FORMAT),
                  datetimei: now.to_i,
                  duration: (Time.current - now) * 1000,
                  status: status,
                ).save
              end
            end
          end

          alias_method :invoke_without_new_rails_performance, :invoke
          alias_method :invoke, :invoke_with_rails_performance

          def invoke(*args)
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
