module Hyde
  module Manager
    class StaticManager
      def call(env)
        Rack::Directory.new(
          File.join(
            File.expand_path( File.dirname(__FILE__) ), "..", "templates"
          )
        ).call(env)
      end
    end
  end
end
