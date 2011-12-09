module Hyde
  class Application
    def initialize
      @configs = []

      # Load configuration files.
      Dir.glob("hyde/*.rb").each do |config|
        Hyde::DSL.load config
      end

      # Create configuration objects from loaded blocks.
      hyde_configs.each do |site, block|
        @configs << Hyde::Configuration.new(site, block)
      end
    end

    def call(env)
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
