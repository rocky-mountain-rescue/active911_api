# frozen_string_literal: true

# FixtureWrapper provides a request which can be stubbed within a fixture.
module FixtureWrapper
  def stub_get(path, fixture:, status: 200, headers: {"Content-Type" => "application/json"})
    stub_request(path, response: stub_response(fixture:, status:, headers:))
  end

  def stub_post(path, fixture:, status: 200, headers: {"Content-Type" => "application/json"})
    stub_request(path, response: stub_response(fixture:, status:, headers:), method: :post)
  end

  def stub_put(path, fixture:, status: 200, headers: {"Content-Type" => "application/json"})
    stub_request(path, response: stub_response(fixture:, status:, headers:), method: :put)
  end

  def stub_patch(path, fixture:, status: 200, headers: {"Content-Type" => "application/json"})
    stub_request(path, response: stub_response(fixture:, status:, headers:), method: :patch)
  end

  def stub_delete(path, fixture:, status: 200, headers: {"Content-Type" => "application/json"})
    stub_request(path, response: stub_response(fixture:, status:, headers:), method: :delete)
  end

  def stub_response(fixture:, status: 200, headers: {"Content-Type" => "application/json"})
    [status, headers, File.read("test/fixtures/#{fixture}.json")]
  end

  def stub_request(path, response:, method: :get, body: {})
    Faraday::Adapter::Test::Stubs.new do |stub|
      arguments = [method, "/v2/#{path}"]
      arguments << body.to_json if [:post, :put, :patch].include?(method)
      stub.send(*arguments) { |_env| response }
    end
  end

  def stub_auth_request(response:, method: :get, body: {})
    Faraday::Adapter::Test::Stubs.new do |stub|
      arguments = [method, "/v2/#{path}"]
      arguments << body.to_json if [:post, :put, :patch].include?(method)
      stub.send(*arguments) { |_env| response }
    end
  end
end
