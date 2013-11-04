module Travis
  class Config
    class Heroku
      def load
        { database: parse_database_url(database_url) || {} }
      end

      private

        def database_url
          ENV.values_at('DATABASE_URL', 'SHARED_DATABASE_URL').first
        end

        def parse_database_url(url)
          if url.to_s =~ %r((.+?)://(.+):(.+)@([^:]+):?(.*)/(.+))
            database = $~.to_a.last
            adapter, username, password, host, port = $~.to_a[1..-2]
            adapter = 'postgresql' if adapter == 'postgres'
            compact adapter: adapter, username: username, password: password, host: host, port: port, database: database
          end
        end

        def compact(hash)
          hash.keys.each { |key| hash.delete(key) if hash[key].blank? }
          hash
        end
    end
  end
end
