require 'faraday'
require 'hashr'
require 'yaml'

require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/string/inflections'
require 'core_ext/hash/deep_symbolize_keys'
require 'core_ext/kernel/run_periodically'

module Travis
  class Config < Hashr
    autoload :Docker, 'travis/config/docker'
    autoload :Env,    'travis/config/env'
    autoload :Files,  'travis/config/files'
    autoload :Heroku, 'travis/config/heroku'

    class << self
      def load(loaders)
        data = loaders.inject({}) do |data, loader|
          loader = const_get(loader.to_s.camelize).new
          data.deep_merge(loader.load.deep_symbolize_keys)
        end
        new(data)
      end
    end

    HOSTS = {
      :production  => 'travis-ci.org',
      :staging     => 'staging.travis-ci.org',
      :development => 'localhost:3000'
    }

    include Logging

    define  :host          => 'travis-ci.org',
            :tokens        => { :internal => 'token' },
            :auth          => { target_origin: nil },
            :assets        => { :host => HOSTS[Travis.env.to_sym] },
            :amqp          => { :username => 'guest', :password => 'guest', :host => 'localhost', :prefetch => 1 },
            :database      => { :adapter => 'postgresql', :database => "travis_#{Travis.env}", :encoding => 'unicode', :min_messages => 'warning' },
            :s3            => { :access_key_id => '', :secret_access_key => '' },
            :pusher        => { :app_id => 'app-id', :key => 'key', :secret => 'secret' },
            :redis         => { :url => 'redis://localhost:6379' },
            :sidekiq       => { :namespace => 'sidekiq', :pool_size => 1 },
            :smtp          => {},
            :email         => {},
            :github        => { :api_url => 'https://api.github.com', :token => 'travisbot-token' },
            :sentry        => {},

            :async         => {},
            :notifications => [], # TODO rename to event.handlers
            :metrics       => { :reporter => 'logger' },
            :logger        => { :thread_id => true },
            :ssl           => {},

            :repository_filter => { :include => [/^rails\/rails/], :exclude => [/\/rails$/] },
            :queues        => [],
            :default_queue => 'builds.linux',
            :jobs          => { :retry => { :after => 60 * 60 * 2, :max_attempts => 1, :interval => 60 * 5 } },
            :queue         => { :limit => { :default => 5, :by_owner => {} }, :interval => 3 },

            :logs          => { :shards => 1, :intervals => { :vacuum => 10, :regular => 180, :force => 3 * 60 * 60 } },

            :roles         => {},
            :archive       => {},
            :encryption    => (Travis.env == 'development' ? { key: 'secret'*10 } : {}),
            :sync          => { :organizations => { :repositories_limit => 1000 } },
            :states_cache  => { :memcached_servers => 'localhost:11211' },

            :workers       => { :ttl => 60, :prune => { :interval => 5 } },
            :sponsors      => { :platinum => [], :gold => [], :workers => {} },
            :shorten_host  => 'trvs.io'

    default :_access => [:key]

    def update_periodically
      Travis.info "[deprecated] Travis.config.update_periodically doesn't do anything anymore"
    end
  end
end
