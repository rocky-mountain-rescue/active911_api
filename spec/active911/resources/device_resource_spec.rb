require "spec_helper"

RSpec.describe Active911::API::DeviceResource do
  include_context "sets required env"
  include_context "stubs Active911::API::Client api_key request"

  it "is a class" do
    expect(described_class).to be_a(Class)
  end

  describe "#show" do
    it "returns an Active911::API::Alert" do
      client   = Active911::API::Client.new(api_refresh_key: ENV.fetch("ACTIVE911_API_REFRESH_KEY"))
      resource = Active911::API::DeviceResource.new(client)

      stub_request(:get, "https://access.active911.com/interface/open_api/api/devices/1").
        to_return(status: 200, body: File.read("spec/fixtures/device/show.json"), headers: {})

      expect(resource.show(device_id: 1)).to be_a(Active911::API::Device)
      expect(resource.show(device_id: 1).message.device.id).to eql 1
    end
  end
end
