module Travis
  class Config < Hashr
    class Files
      def load
        @load_files ||= filenames.inject({}) do |conf, filename|
          data = load_file(filename)[Travis.env] || {}
          conf.deep_merge(data)
        end
      end

      private

        def load_file(filename)
          YAML.load_file(filename) if File.file?(filename) rescue {}
        end

        def filenames
          @filenames ||= Dir['config/{travis.yml,travis/*.yml}'].sort
        end
    end
  end
end
