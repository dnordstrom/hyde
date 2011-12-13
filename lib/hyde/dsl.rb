module Hyde
  class DSL
    attr_reader :configs
    attr_reader :users

    # Loads a config file, evaluates it in the context of a DSL
    # object and returns a Hash of configuration blocks.
    def self.execute(file)
      @dsl = new
      @dsl.instance_eval(file.read)
      @dsl #{ users: dsl.users, configs: dsl.configs }
    end

    def self.load
      # If already loaded, return instance of Hyde::DSL.
      return @dsl unless @dsl.nil?

      users = {}
      configs = {}
      config_blocks = {}
      
      Dir.glob("hyde/*.rb").each do |config|
        dsl = Hyde::DSL.execute( File.new(config) )

        config_blocks.merge!(dsl.configs)
        users.merge!(dsl.configs)
      end

      config_blocks.each do |site, block|
        configs[site] = Hyde::Configuration.new(site, &block)
      end

      @dsl.instance_eval { @configs = configs }
    end
    
    private

    # DSL method; saves site name (if specified), along with
    # a corresponding configuration block.
    def configure(site = :default, &block)
      @configs ||= {}
      @configs[site.to_s] = block
    end
    
    def user(username, password)
      @users ||= {}
      @users[username.to_sym] = { username: username, password: password }
    end
  end
end
