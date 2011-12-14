module Hyde
  module ResponseHelper
    # Generate Rack response array.
    def respond_with(body)
      [
        # HTTP status code.
        200,

        # Content type header.
        { "Content-Type" => "text/html" },

        # Response body.
        [ body ]
      ]
    end

    def redirect_to(path, notice = "")
      notice = "/#{notice.to_s}" unless notice === ""

      [
        302,
        { "Content-Type" => "text", "Location" => "#{path + notice}" },
        [ "302 Redirect" ]
      ]
    end
  end
end
