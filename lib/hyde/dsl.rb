module Hyde
  class DSL
    # Loads a config file, evaluates it in the context of a DSL
    # object and returns a Hash of configuration blocks.
    def self.load(file)
      dsl = new
      dsl.instance_eval(file.read)
      dsl.configs
    end
    
    # DSL method; saves site name (if specified), along with
    # a corresponding configuration block.
    def configure(site = :default, &block)
      @configs ||= {}
      @configs[site.to_s] = block
    end

    def configs
      @configs
    end
  end
end
