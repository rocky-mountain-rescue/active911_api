# frozen_string_literal: true

module Active911::API::Resources
  class ResourceResource < Active911::API::Resource
    def show(resource_id:)
      result = get_request("resources/#{resource_id}")
      # API unfortunately returns HTML instead of JSON encoding
      # even though the content-type is set to application/json
      # so we have to parse the HTML and extract the JSON
      begin
        json_body = JSON.parse(result.body)
      rescue JSON::ParserError
        error_message = <<~END
          Non JSON response received from Active911 (resources/#{resource_id}) API: URL: #{result.env.url}, body: #{result.body}
        END
        raise(
          Error,
          error_message
        )
      end

      Active911::API::Models::Resource.new(json_body)
    end
  end
end
