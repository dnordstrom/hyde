module Hyde
  module MiddlewareHelper
    # Adds a middleware class to the stack.
    # 
    # To be used at application initialization to inform the
    # application of available middleware. Takes a middleware
    # class (which must have a <code>call</code> instance method)
    # and a <code>Regexp</code> object (which will be matched
    # against the requested path) as arguments.
    #
    # E.g., the following will call
    # <code>StaticManager#call</code> when request path begins
    # with "/gui".
    #
    # <code>use StaticManager, /^\/gui/</code>
    def use(manager, condition)
      (@middleware ||= []) << { manager: manager, condition: condition }
    end

    # Calls middleware matching current request. Should always be
    # used with <code>middleware_responds?</code>, which checks
    # if a middleware matches the current request and sets the
    # environment variable. E.g.:
    #
    # <code>return middleware if middleware_responds?</code>
    #
    # Calls middleware if no argument is given, otherwise sets
    # matching middleware for current request.
    def middleware(ware = nil)
      @env["hyde.middleware"].nil? ? false : @env["hyde.middleware"].call(@env)
    end

    # Checks if any middleware regular expression matches the
    # requested path. If a match is found, an instance of the
    # class is stored in <code>@env["hyde.middleware"]</code>.
    def middleware_responds?
      @middleware.each do |ware|
        unless ware[:condition].match(@env["PATH_INFO"]).nil?
          @env["hyde.middleware"] = ware[:manager].new
print "\n\nFound middleware\n\n"
          return true
        end
      end

      false
    end
  end
end
