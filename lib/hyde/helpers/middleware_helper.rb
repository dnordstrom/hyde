module Hyde
  module MiddlewareHelper
    def use(manager, condition)
      (@middleware ||= []) << { manager: manager, condition: condition }
    end

    def middleware(ware = nil)
      ware.nil? ? @current_middleware.call(@env) : @current_middleware = ware
    end

    def middleware_responds?
      @middleware.each do |ware|
        middleware(ware[:manager].new) if @env["PATH_INFO"] =~ ware[:condition]
      end
    end
  end
end
