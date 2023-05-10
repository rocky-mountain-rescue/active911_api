# frozen_string_literal: true

module Active911::API::Resources
  # AgencyResource is a representation of the Agency API endpoint
  class AgencyResource < Active911::API::Resource
    def show
      result = get_request("")
      # API unfortunately returns HTML instead of JSON encoding
      # even though the content-type is set to application/json
      # so we have to parse the HTML and extract the JSON
      begin
        json_body = JSON.parse(result.body)
      rescue JSON::ParserError
        error_message = <<~END
          Non JSON response received from Active911 (/) API: URL: #{result.env.url}, body: #{result.body}
        END
        raise(
          Error,
          error_message
        )
      end

      Active911::API::Models::Agency.new(json_body)
    end
  end
end
