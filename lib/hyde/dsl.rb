module Hyde
  class DSL
    attr_reader :configs
    attr_reader :users

    # Loads a config file, evaluates it in the context of a DSL
    # object and returns a Hash of configuration blocks.
    def self.load(file)
      dsl = new
      dsl.instance_eval(file.read)

      { users: dsl.users, configs: dsl.configs }
    end
    
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
