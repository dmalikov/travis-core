module Travis
  module Api
    module V0
      module Pusher
        class Job
          class Canceled < Job
            include V1::Helpers::Legacy

            def data
              {
                'id' => job.id,
                'build_id' => job.source_id,
                'repository_id' => job.repository_id,
                'repository_slug' => job.repository.slug,
                'repository_private' => repository.private,
                'number' => job.number,
                'queue' => job.queue,
                'state' => job.state.to_s,
                'result' => legacy_job_result(job),
                'log_id' => job.log_id,
                'allow_failure' => job.allow_failure
              }
            end
          end
        end
      end
    end
  end
end
