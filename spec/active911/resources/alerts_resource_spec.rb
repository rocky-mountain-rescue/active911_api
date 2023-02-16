# frozen_string_literal: true

require "spec_helper"

RSpec.describe Active911::API::AlertsResource do
  include_context "with required environmental variables"
  include_context "with Active911::API::Client api_key request stub"

  it "is a class" do
    expect(described_class).to be_a(Class)
  end

  describe "#show" do
    it "returns an Active911::API::Alert" do
      client   = Active911::API::Client.new api_refresh_key: ENV.fetch("ACTIVE911_API_REFRESH_KEY")
      resource = described_class.new client

      stub_request(:get, "https://access.active911.com/interface/open_api/api/alerts/1")
        .to_return(status: 200, body: File.read("spec/fixtures/alerts/show.json"), headers: {})

      expect(resource.show(alert_id: 1)).to be_a(Active911::API::Alert)
      expect(resource.show(alert_id: 1).message.alert.id).to be 1
    end
  end

  describe "#index" do
    it "returns an Active911::API::Alert" do
      client   = Active911::API::Client.new api_refresh_key: ENV.fetch("ACTIVE911_API_REFRESH_KEY")
      resource = described_class.new client

      stub_request(:get, "https://access.active911.com/interface/open_api/api/alerts")
        .to_return(status: 200, body: File.read("spec/fixtures/alerts/index.json"), headers: {})

      expect(resource.index.message.alerts[0].id).to be 1
    end
  end
end
