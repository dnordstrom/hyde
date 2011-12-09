module Kernel
  def configure(site = :default, &block)
    @hyde_configs ||= {}
    @hyde_configs[site.to_s] = block
  end

  def hyde_configs
    @hyde_configs
  end
end
