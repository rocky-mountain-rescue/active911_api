# frozen_string_literal: true

module Active911::API::Resources
  # AlertsResource is a representation of the Alerts API endpoint
  class AlertsResource < Active911::API::Resource
    def show(alert_id:)
      result = get_request("alerts/#{alert_id}")
      # API unfortunately returns HTML instead of JSON encoding
      # even though the content-type is set to application/json
      # so we have to parse the HTML and extract the JSON
      body = result.body
      begin
        json_body = JSON.parse(body)
      rescue JSON::ParserError
        warning = <<~END
          Non JSON response received from Active911 (alerts/#{alert_id}) API: URL: #{result.env.url}, body: #{body}
        END
        raise(
          Error,
          warning
        )
      end

      Active911::API::Models::Alert.new(json_body)
    end

    #
    # alert_days - How many days of alerts to show. Default 10. Max 30.
    # alert_minutes - How many minutes of alerts to show. Will supersede alert_days if set. Optional.
    def index(alert_days: nil, alert_minutes: nil)
      alert_params = {}

      if alert_days
        if (alert_days < 1) || (alert_days > 30)
          raise Error, "alert_days must be between 1 and 30"
        end

        alert_params[:alert_days] = alert_days
      end

      if alert_minutes
        max_alert_minutes = 30 * 24 * 60
        if (alert_minutes < 1) || (alert_minutes > max_alert_minutes)
          raise Error, "alert_minutes must be between 1 and #{max_alert_minutes}"
        end

        alert_params[:alert_minutes] = alert_minutes
      end

      result = get_request("alerts", params: alert_params)

      # API unfortunately returns HTML instead of JSON encoding
      # even though the content-type is set to application/json
      # so we have to parse the HTML and extract the JSON
      body = result.body
      begin
        json_body = JSON.parse(body)
      rescue JSON::ParserError
        error_message = <<~END
          Non JSON response received from Active911 (alerts) API: URL: #{result.env.url}, body: #{body}
        END
        raise(
          Error,
          error_message
        )
      end

      Active911::API::Models::Alerts.new(json_body)
    end
  end
end
