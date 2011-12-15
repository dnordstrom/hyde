module Hyde
  class DSL
    attr_accessor :configs
    attr_accessor :users

    # Loads a config file, evaluates it in the context of a DSL
    # object and returns a Hash of configuration blocks.
    def self.execute(file)
      dsl = new
      dsl.instance_eval(file.read)
      dsl
    end

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
