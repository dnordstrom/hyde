module Hyde
  class StaticManager
    def call(env)
      @dir = Rack::Directory.new(
        File.join(
          File.expand_path( File.dirname(__FILE__) ),
          "gui"
        )
      )
      @dir.call(env)
    end
  end
end
