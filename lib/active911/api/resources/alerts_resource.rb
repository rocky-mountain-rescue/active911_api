# frozen_string_literal: true

module Active911
  module API
    class AlertsResource < Resource
      def show alert_id:
        result = get_request "alerts/#{alert_id}"
        # API unfortunately returns HTML instead of JSON encoding
        # even though the content-type is set to application/json
        # so we have to parse the HTML and extract the JSON
        begin
          json_body = JSON.parse result.body
        rescue JSON::ParserError
          raise Error,
                "Non JSON response received from Active911 (alerts/#{alert_id}) API: URL: #{result.env.url}, body: #{result.body}"
        end
        Alert.new json_body
      end

      #
      # alert_days - How many days of alerts to show. Default 10. Max 30.
      # alert_minutes - How many minutes of alerts to show. Will supersede alert_days if set. Optional.
      def index alert_days: nil, alert_minutes: nil
        alert_params = {}

        if alert_days
          fail Error, "alert_days must be between 1 and 30" if (alert_days < 1) || (alert_days > 30)

          alert_params[:alert_days] = alert_days
        end

        if alert_minutes
          max_alert_minutes = 30 * 24 * 60
          if (alert_minutes < 1) || (alert_minutes > max_alert_minutes)
            fail Error, "alert_minutes must be between 1 and #{max_alert_minutes}"
          end

          alert_params[:alert_minutes] = alert_minutes
        end
        result = get_request "alerts", params: alert_params

        # API unfortunately returns HTML instead of JSON encoding
        # even though the content-type is set to application/json
        # so we have to parse the HTML and extract the JSON
        begin
          json_body = JSON.parse result.body
        rescue JSON::ParserError
          raise Error,
                "Non JSON response received from Active911 (alerts) API: URL: #{result.env.url}, body: #{result.body}"
        end
        Alerts.new json_body
      end
    end
  end
end
