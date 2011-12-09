module Hyde
  class Application
    include PathHelper

    def initialize
      @configs = []
      config_blocks = {}

      # Load configuration files.
      Dir.glob("hyde/*.rb").each do |config|
        config_blocks += Hyde::DSL.load config
      end

      # Create configuration objects from loaded blocks.
      config_blocks.each do |site, block|
        @configs << Hyde::Configuration.new(site, block)
      end
    end

    def call(env)
      print env.inspect
      [
        # HTTP status code.
        200,

        # Content type header.
        { "Content-Type" => "text/html" },

        # Response body.
        # TODO: Load ERB template.
        [ "Hello World!" ]
      ]
    end
  end
end
