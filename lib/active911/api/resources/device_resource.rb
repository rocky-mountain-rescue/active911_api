# frozen_string_literal: true

module Active911::API
  class DeviceResource < Resource
    def show(device_id:)
      result = get_request("devices/#{device_id}")
      # API unfortunately returns HTML instead of JSON encoding
      # even though the content-type is set to application/json
      # so we have to parse the HTML and extract the JSON
      begin
        json_body = JSON.parse(result.body)
      rescue JSON::ParserError
        warning = <<~END
          Non JSON response received from Active911 (/devices/#{device_id}) API: URL: #{result.env.url}, body: #{result.body}
        END
        raise(
          Error,
          warning
        )
      end

      Device.new(json_body)
    end
  end
end
