module Hyde
  module PathHelper
    # Sets up path to be used by helper (ghost) methods. Path
    # must have leading slash for helpers to work properly.
    #
    # Example:
    #
    #   use_path("/my_site/_posts")
    #    => ["my_site", "_posts"]
    #   current_site
    #    => "my_site"
    #   current_dir
    #    => "_posts"
    #   current_file
    #    => false
    def use_path(path)
      # Specify indexes of path fragments, e.g. site
      # identifier is in first part of URL ( /:site/... )
      @parts = { site: 0, dir: 1, file: 2 }

      # Turn full path into array of path fragments, and
      # use Array#shift to remove empty first element.
      @path = path.split("/")
      @path.shift
    end

    # Return path fragment at specified index, if available,
    # otherwise returns false. Used by ghost methods.
    def path_part(part)
      (@path.nil? || @path[part].nil?) ? false : @path[part]
    end
    
    # Defines ghost methods current_(site|dir|file) based
    # on path provided by <code>Hyde::PathHelper::use_path</code>
    # and parts defined in <code>@parts</code> instance variable.
    def method_missing(method, *args)
      if method =~ /current_(.*)/
        return path_part( @parts[$1.to_sym] ) if @parts.has_key?($1.to_sym)
      end

      super
    end
  end
end
