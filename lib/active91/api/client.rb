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
      attr_reader :api_refresh_key, :adapter

      def initialize api_refresh_key, adapter: Faraday.default_adapter
        @api_refresh_key = api_refresh_key
        @adapter = adapter
      end

      def connection
        @connection ||= Faraday.new do |conn|
          conn.adapter adapter
          conn.url_prefix BASE_URL
          conn.request :json
          conn.response :json, content_type: /\bjson$/
        end
      end

      def inspect
        "#<#{self.class.name} api_refresh_key=#{api_refresh_key.inspect}>"
      end
    end
  end
end
