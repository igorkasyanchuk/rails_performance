module RailsPerformance
  module Gems
    class DelayedJobExt

      class Plugin < ::Delayed::Plugin
        callbacks do |lifecycle|
          lifecycle.around(:invoke_job) do |job, *args, &block|
            begin
              now = Time.current
              block.call(job, *args)
              status = 'success'
            rescue Exception => error
              status = 'error'
              raise error
            ensure
              meta_data = RailsPerformance::Gems::DelayedJobExt::Plugin.meta(job.payload_object)
              record    = RailsPerformance::Models::DelayedJobRecord.new(
                jid: job.id,
                duration: (Time.current - now) * 1000,
                datetime: now.strftime(RailsPerformance::FORMAT),
                datetimei: now.to_i,
                source_type: meta_data[0],
                class_name: meta_data[1],
                method_name: meta_data[2],
                status: status
              )
              record.save
            end
          end
        end

        # [source_type, class_name, method_name, duration]
        def self.meta(payload_object)
          if payload_object.is_a?(::Delayed::PerformableMethod)
            if payload_object.object.is_a?(Module)
              [:class_method, payload_object.object.name, payload_object.method_name.to_s]
            else
              [:instance_method, payload_object.object.class.name, payload_object.method_name.to_s]
            end
          else
            [:instance_method, payload_object.class.name, "perform"]
          end
        rescue
          [:unknown, :unknown, :unknown]
        end
      end

      def self.init
        ::Delayed::Worker.plugins += [::RailsPerformance::Gems::DelayedJobExt::Plugin]
      end

    end
  end
end
