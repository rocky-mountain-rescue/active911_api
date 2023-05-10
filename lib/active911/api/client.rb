# frozen_string_literal: true

require "faraday"
require "faraday/middleware"

module Active911::API
  # Client is the main entry point for making requests to the Active911 API.
  class Client
    BASE_URL = ENV.fetch("ACTIVE911_BASE_URL", "https://access.active911.com/interface/open_api/api/")

    attr_reader :adapter, :api_key, :api_key_expiration, :api_refresh_key

    def initialize(api_refresh_key:, adapter: Faraday.default_adapter, stubs: nil)
      @api_key = nil
      @api_key_expiration = nil
      @api_refresh_key = api_refresh_key
      @adapter = adapter
      @stubs = stubs
    end

    def connection
      @connection ||= Faraday.new do |connection|
        connection.adapter(@adapter, @stubs)
        connection.url_prefix = BASE_URL
        connection.request(:json)
        connection.response(:json, content_type: /\bjson$/)
      end
    end

    def agency
      AgencyResource.new(self)
    end

    def device
      DeviceResource.new(self)
    end

    def alerts
      AlertsResource.new(self)
    end

    def alert
      AlertsResource.new(self)
    end

    def locations
      LocationsResource.new(self)
    end

    def location
      LocationsResource.new(self)
    end

    def resource
      ResourceResource.new(self)
    end

    def inspect
      "#<#{self.class.name} api_refresh_key=#{api_refresh_key.inspect}>"
    end

    def api_key_from_refesh_key
      @api_key = connection.post("token", {refresh_token: api_refresh_key})
    end

    def access_token
      if access_token_needs_refreshing?
        refresh_access_token
      end
    end

    private

    def refresh_access_token
      conn = Faraday.new("https://console.active911.com/interface/dev/api_access.php") do |faraday|
        faraday.adapter(@adapter, @stubs)
        faraday.request(:url_encoded)
      end

      response = conn.post("", refresh_token: api_refresh_key)
      unless response.status == 200
        raise Error, "Invalid response from Active911 API: #{response.body}"
      end

      begin
        body_parsed = JSON.parse(response.body)
        @api_key = body_parsed["access_token"]
        @api_key_expiration = body_parsed["expiration"]
        body_parsed
      rescue JSON::ParserError
        raise Error, "Invalid response from Active911 API: #{response.body}"
      end
    end

    def access_token_needs_refreshing?
      not_initialized?(@api_key) or
        not_initialized?(@api_key_expiration) or
        (@api_key_expiration < Time.now.to_i)
    end

    def not_initialized?(var)
      !var
    end
  end
end
