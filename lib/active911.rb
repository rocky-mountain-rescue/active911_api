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
  end
end
