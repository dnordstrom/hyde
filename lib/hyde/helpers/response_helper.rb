module Hyde
  module ResponseHelper
    # Generates Rack response array with specified body.
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

    # Generates a Rack response array with a 302 redirect header.
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
