# frozen_string_literal: true

require "spec_helper"

RSpec.describe Active911::API::Client do
  it "is a class" do
    expect(described_class).to(be_a(Class))
  end

  it "loads api_refresh_key" do
    expect(described_class.new(api_refresh_key: "bar").api_refresh_key).to(eql("bar"))
  end

  it "obtains an api_key from api_refresh" do
    stub_request(:post, "https://console.active911.com/interface/dev/api_access.php")
      .with(
        body: {"refresh_token" => "bar"}
      )
      .to_return(status: 200, body: "{\"access_token\":\"baz\",\"expiration\":123}", headers: {})

    client = described_class.new(api_refresh_key: "bar")
    client.get_access_token
    expect(client.api_key).to(eql("baz"))
    expect(client.api_key_expiration).to(be(123))
  end
end
