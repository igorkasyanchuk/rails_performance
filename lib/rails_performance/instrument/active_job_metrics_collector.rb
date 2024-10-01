module RailsPerformance
  module Instrument
    class ActiveJobMetricsCollector
      # Example
      #   {:job=>
      #   #<MyJob:0x00000001092c70e0
      #    @_halted_callback_hook_called=nil,
      #    @_scheduled_at_time=2024-10-01 09:59:35.929293 UTC,
      #    @arguments=[],
      #    @enqueued_at=2024-10-01 09:59:35.931923 UTC,
      #    @exception_executions={},
      #    @executions=1,
      #    @job_id="8549e8ec-42d5-46fc-941f-74c00e27ac11",
      #    @locale="en",
      #    @priority=nil,
      #    @provider_job_id=nil,
      #    @queue_name="default",
      #    @scheduled_at=2024-10-01 09:59:35.929293 UTC,
      #    @serialized_arguments=nil,
      #    @timezone="Kyiv">,
      #  :adapter=>#<ActiveJob::QueueAdapters::SolidQueueAdapter:0x00000001092c81e8>,
      #  :db_runtime=>0.0,
      #  :aborted=>nil}

      def call(event_name, started, finished, event_id, payload)
        return if RailsPerformance.skip

        # TODO do we need this new?
        event = ActiveSupport::Notifications::Event.new(event_name, started, finished, event_id, payload)
        now = Time.now

        job = payload[:job]

        record = RailsPerformance::Models::ActiveJobRecord.new(
          queue: job.queue_name,
          enqueued_ati: job.enqueued_at.to_i,
          datetimei: job.scheduled_at.to_i,
          jid: job.job_id,
          start_timei: now.to_i,
          datetime: now.strftime(RailsPerformance::FORMAT),
          worker: job.class.name,
          db_runtime: payload[:db_runtime],
          aborted: payload[:aborted]
        )

        puts record

        binding.pry

        record.save
      end
    end
  end
end
