# frozen_string_literal: true

module Active911::API
  class LocationsResource < Resource
    def show(location_id:)
      result = get_request("locations/#{location_id}")
      # API unfortunately returns HTML instead of JSON encoding
      # even though the content-type is set to application/json
      # so we have to parse the HTML and extract the JSON
      begin
        json_body = JSON.parse(result.body)
      rescue JSON::ParserError
        warning = <<~END
          Non JSON response received from Active911 (locations/#{location_id}) API: URL: #{result.env.url}, body: #{result.body}
        END
        raise(
          Error,
          warning
        )
      end

      Location.new(json_body)
    end

    def index
      result = get_request("locations")
      # API unfortunately returns HTML instead of JSON encoding
      # even though the content-type is set to application/json
      # so we have to parse the HTML and extract the JSON
      begin
        json_body = JSON.parse(result.body)
      rescue JSON::ParserError
        raise(
          Error,
          "Non JSON response received from Active911 (locations) API: URL: #{result.env.url}, body: #{result.body}"
        )
      end

      Locations.new(json_body)
    end
  end
end
