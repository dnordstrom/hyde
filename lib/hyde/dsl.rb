module Hyde
  class DSL
    attr_accessor :configs
    attr_accessor :users

    # Reads a config file and evaluates it in the context of a DSL
    # object which is then returned. The DSL object will contain
    # user details and configuration blocks.
    def self.execute(file)
      dsl = new
      dsl.instance_eval(file.read)
      dsl
    end

    # Loads config files and returns object containing users and
    # conofiguration blocks.
    #
    # Loads all Ruby files in the "hyde" directory within the
    # directory from which the "hyde" command was run. Each file
    # will be passed to the <code>Hyde::DSL.execute()</code>.
    # After all files have been loaded, an instance of
    # <code>Hyde::DSL</code> containing users and configuration
    # blocks will be returned.
    def self.load
      # If already loaded, return instance of Hyde::DSL.
      return @dsl unless @dsl.nil?
      
      @dsl = new

      users = {}
      configs = {}
      config_blocks = {}
      
      Dir.glob("hyde/*.rb").each do |config|
        dsl = Hyde::DSL.execute( File.new(config) )

        config_blocks.merge!(dsl.configs) unless dsl.configs.nil?
        users.merge!(dsl.users) unless dsl.users.nil?
      end

      config_blocks.each do |site, block|
        configs[site] = Hyde::Configuration.new(site, &block)
      end

      @dsl.configs = configs
      @dsl.users = users
      @dsl
    end
    
    private

    # DSL method. Stores site name (if specified), along with
    # a corresponding configuration block.
    def configure(site = :default, &block)
      @configs ||= {}
      @configs[site.to_s] = block
    end
    
    # DSL method. Stores username and password to be used for
    # authenticating access (to all sites.)
    def user(username, password)
      @users ||= {}
      @users[username.to_sym] = { username: username, password: password }
    end
  end
end
