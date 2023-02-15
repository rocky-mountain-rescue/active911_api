# frozen_string_literal: true

require "zeitwerk"

Zeitwerk::Loader.for_gem.then do |loader|
  loader.inflector.inflect "api" => "API"
  loader.setup
end

# Main namespace.
module Active911
  # API namespace.
  module API
    autoload :Client, "active911/api/client"
    autoload :Error, "active911/api/error"
    autoload :Model, "active911/api/model"
    autoload :Resource, "active911/api/resource"

    autoload :Agency, "active911/api/models/agency"
    autoload :AgencyResource, "active911/api/resources/agency_resource"

    autoload :Device, "active911/api/models/device"
    autoload :DeviceResource, "active911/api/resources/device_resource"

    autoload :Location, "active911/api/models/location"
    autoload :Locations, "active911/api/models/locations"
    autoload :LocationsResource, "active911/api/resources/locations_resource"

    autoload :Alert, "active911/api/models/alert"
    autoload :Alerts, "active911/api/models/Alerts"
    autoload :AlertsResource, "active911/api/resources/alerts_resource"
  end
end
