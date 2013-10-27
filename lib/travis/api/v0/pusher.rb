module Travis
  module Api
    module V0
      module Pusher
        autoload :Build,  'travis/api/v0/pusher/build'
        autoload :Job,    'travis/api/v0/pusher/job'
      end
    end
  end
end
