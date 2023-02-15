# frozen_string_literal: true

require "faraday"
require "faraday/middleware"

# Active 911 namespace
module Active911
  # API namespace
  module API
    # Client class
    class Client
      BASE_URL = ENV.fetch "ACTIVE911_BASE_URL", "https://access.active911.com/interface/open_api/api/"
      attr_reader :adapter, :api_key, :api_key_expiration, :api_refresh_key

      def initialize(api_refresh_key:, adapter: Faraday.default_adapter)
        @api_refresh_key = api_refresh_key
        @adapter         = adapter
      end

      def connection
        @connection ||= Faraday.new do |connection|
          connection.adapter adapter
          connection.url_prefix = BASE_URL
          connection.request :json
          connection.response :json, content_type: /\bjson$/
        end
      end

      def agency
        AgencyResource.new self
      end

      def device
        DeviceResource.new self
      end

      def alerts; end

      def deviceAlerts; end

      def locations
        LocationsResource.new self
      end

      def location
        LocationsResource.new self
      end

      def resource
        ResourceResource.new self
      end

      def inspect
        "#<#{self.class.name} api_refresh_key=#{api_refresh_key.inspect}>"
      end

      def get_api_key_from_refesh_key
        @api_key = connection.post("token", {refresh_token: api_refresh_key})
      end

      def get_access_token
        if @api_key.nil? or
          @api_key_expiration.nil? or
          @api_key_expiration < Time.now.to_i
          refresh_access_token
        end
      end

      private

      def refresh_access_token
        conn   = Faraday.new("https://console.active911.com/interface/dev/api_access.php") do |f|
          f.adapter Faraday.default_adapter
          f.request :url_encoded
        end
        response = conn.post("", refresh_token: api_refresh_key)
        if response.status == 200
          begin
            body_parsed         = JSON.parse(response.body)
            @api_key            = body_parsed["access_token"]
            @api_key_expiration = body_parsed["expiration"]
          rescue JSON::ParserError
            raise Error, "Invalid response from Active911 API: #{response.body}"
          end
        else
          raise Error, "Invalid response from Active911 API: #{response.body}"
        end
      end
    end
  end
end
