module Hyde
  module ResponseHelper
    # Generates a Rack response array with the provided page
    # body.
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
      # Append notice to URL if provided.
      notice = "?#{notice.to_s}" unless notice === ""

      [
        # HTTP status code.
        302,
        
        # Content type and redirect location.
        { "Content-Type" => "text", "Location" => "#{path + notice}" },

        # Response body, not important in this case.
        [ "302 Redirect" ]
      ]
    end
  end
end
