module RailsPerformance
  module Gems

    class Rake
      def self.init
        ::Rake::Task.class_eval do
          def invoke_with_rails_performance(*args)
            begin
              now    = Time.now
              status = 'success'
              invoke_without_new_rails_performance(*args)
            rescue Exception => ex
              status = 'error'
              raise(ex)
            ensure
              RailsPerformance::Models::RakeRecord.new(
                task: RailsPerformance::Gems::Rake.find_task_name(*args),
                datetime: now.strftime(RailsPerformance::FORMAT),
                datetimei: now.to_i,
                duration: Time.now - now,
                status: status,
              ).save
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
