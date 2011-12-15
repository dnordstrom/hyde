module Hyde
  module RequestHelper
    # Sets Hyde environment variables unless they have already
    # been defined somewhere else.
    def setup_environment(env)
      return false unless @env.nil?

      @env = env
      @env["hyde.request"] = Rack::Request.new(env) if @env["hyde.request"].nil?
      @env["hyde.users"] = Hyde::DSL.load.users if @env["hyde.users"].nil?
      @env["hyde.configs"] = Hyde::DSL.load.configs if @env["hyde.configs"].nil?

      # Set path used by Hyde::PathHelper.
      use_path(env["PATH_INFO"])

      true
    end

    # Shortcut to Rack::Request#params.
    def params
      @env["hyde.request"].params
    end
  end
end
