# frozen_string_literal: true

RSpec.shared_context "with Active911::API::Client api_key request stub" do
  around do |example|
    stub_request(:post, "https://console.active911.com/interface/dev/api_access.php")
      .with(
        body: {"refresh_token" => "1234567890"}
      ).to_return(
        status: 200,
        body: '{"access_token":"baz","expiration":123}',
        headers: {}
      )
    example.run
  end
end
