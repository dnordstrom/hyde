module Hyde
  module PathHelper
    def use_path(path)
      @parts = { site: 0, dir: 1, file: 2 }
      @path = path.split("/").select {|e| e != "" }
    end

    def path_part(part)
      @path[part].nil? ? false : @path[part]
    end

    def method_missing(method, *args)
      if method =~ /current_(.*)/
        parts = { site: 0, dir: 1, file: 2 }
        return path_part( @parts[$1.to_sym] ) if @parts.has_key?($1.to_sym)
      end

      super
    end
  end
end
