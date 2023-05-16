# frozen_string_literal: true

module Active911::API
  # Namespace for Resource Utils
  module ResourceUtils
    def self.error_meta_info(body)
      body["meta"].to_s
    end
  end

  # Resource class uses the Faraday connection encapsulated by connection
  # to talk to the Active911 API. Individual Resource API endpoints classes
  # inherit from this class.
  class Resource
    include ResourceUtils

    attr_reader :client

    def initialize(client)
      client.access_token
      @client = client
    end

    def get_request(url, params: {}, headers: {})
      handle_response(client.connection.get(url, params, default_headers.merge(headers)))
    end

    def post_request(url, body:, headers: {})
      handle_response(client.connection.post(url, body, default_headers.merge(headers)))
    end

    def put_request(url, body:, headers: {})
      handle_response(client.connection.put(url, body, default_headers.merge(headers)))
    end

    def patch_request(url, body: {}, headers: {})
      handle_response(client.connection.patch(url, body, default_headers.merge(headers)))
    end

    def delete(url, params: {}, headers: {})
      handle_response(client.connection.delete(url, params, default_headers.merge(headers)))
    end

    def default_headers
      {
        Authorization: "Bearer #{client.api_key}"
      }
    end

    def handle_response(response)
      case response.status
      when 400
        raise Error, response.body
      when 401
        raise Error, response.body
      when 403
        raise Error, response.body
      when 404
        raise Error, response.body
      when 429
        raise Error, response.body
      when 500
        raise Error, response.body
      end

      response
    end
  end
end
