# frozen_string_literal: true

module Active911::API::Resources
  # LocationsResource is a representation of the Locations API endpoint
  class LocationsResource < Active911::API::Resource
    def show(location_id:)
      result = get_request("locations/#{location_id}")
      # API unfortunately returns HTML instead of JSON encoding
      # even though the content-type is set to application/json
      # so we have to parse the HTML and extract the JSON
      body = result.body
      begin
        json_body = JSON.parse(body)
      rescue JSON::ParserError
        error_message = <<~END
          Non JSON response received from Active911 (locations/#{location_id}) API: URL: #{result.env.url}, body: #{body}
        END
        raise(
          Error,
          error_message
        )
      end

      Active911::API::Models::Locations.new(json_body)
    end

    def index
      result = get_request("locations")
      # API unfortunately returns HTML instead of JSON encoding
      # even though the content-type is set to application/json
      # so we have to parse the HTML and extract the JSON
      body = result.body
      begin
        json_body = JSON.parse(body)
      rescue JSON::ParserError
        error_message = <<~END
          Non JSON response received from Active911 (locations) API: URL: #{result.env.url}, body: #{body}
        END
        raise(
          Error,
          error_message
        )
      end

      Active911::API::Models::Locations.new(json_body)
    end
  end
end
