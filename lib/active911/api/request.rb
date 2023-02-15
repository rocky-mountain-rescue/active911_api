module Active911
  module API
    module Request
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def get_request(path, params = {})
          request(:get, path, params)
        end

        def post_request(path, params = {})
          request(:post, path, params)
        end

        def put_request(path, params = {})
          request(:put, path, params)
        end

        def delete_request(path, params = {})
          request(:delete, path, params)
        end

        def request(method, path, params = {})
          response = Active911::API::Connection.request(method, path, params)
          response.body
        end
      end
    end
  end
end
