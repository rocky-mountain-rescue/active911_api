module Active911
  module API
    class AgencyResource < Resource
      def get
        result = get_request("")
        # API unfortunately returns HTML instead of JSON encoding
        # even though the content-type is set to application/json
        # so we have to parse the HTML and extract the JSON
        begin
        json_body = JSON.parse(result.body)
        rescue JSON::ParserError
          raise Error, "Non JSON response received from Active911 (/) API: URL: #{result.env.url}, body: #{result.body}"
        end
        Agency.new(json_body)
      end
    end
  end
end
