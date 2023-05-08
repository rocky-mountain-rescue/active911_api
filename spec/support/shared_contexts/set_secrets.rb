# frozen_string_literal: true

RSpec.shared_context("with required environmental variables") do
  around do |example|
    ENV["ACTIVE911_API_REFRESH_KEY"] = "1234567890"
    ENV["ACTIVE911_API_URL"] = "https://access.active911.com/interface/open_api/api/"
    example.run
  end
end
