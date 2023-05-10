# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Active911::API::Resources::AgencyResource) do
  include_context("with required environmental variables")
  include_context("with Active911::API::Client api_key request stub")

  it "is a class" do
    expect(described_class).to(be_a(Class))
  end

  describe "#show" do
    it "returns an Active911::API::Agency" do
      client = Active911::API::Client.new(api_refresh_key: ENV.fetch("ACTIVE911_API_REFRESH_KEY"))
      resource = described_class.new(client)

      stub_request(:get, "https://access.active911.com/interface/open_api/api/")
        .to_return(status: 200, body: File.read("spec/fixtures/agency/show.json"), headers: {})

      expect(resource.show).to(be_a(Active911::API::Models::Agency))
      expect(resource.show.message.agency.name).to(eql("Rescue Group"))
    end
  end
end
