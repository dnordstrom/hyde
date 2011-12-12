module Hyde
  module PathHelper
    def use_path(path)
      # Specify indexes of path fragments, e.g. site
      # identifier is in first part of URL ( /:site/... )
      @parts = { site: 0, dir: 1, file: 2, notice: 3 }

      # Turn full path into array of path fragments, and
      # use Array#shift to remove empty first element.
      @path = path.split("/")
      @path.shift
    end

    # Return path fragment at specified index, if available,
    # otherwise returns false.
    def path_part(part)
      (@path.nil? || @path[part].nil?) ? false : @path[part]
    end
    
    # Defines ghost methods current_(site|dir|file).
    def method_missing(method, *args)
      if method =~ /current_(.*)/
        return path_part( @parts[$1.to_sym] ) if @parts.has_key?($1.to_sym)
      end

      super
    end
  end
end
