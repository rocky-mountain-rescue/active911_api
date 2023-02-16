require "spec_helper"

RSpec.describe Active911::API::Model do
  it "is a class" do
    expect(described_class).to be_a(Class)
  end

  it "creates object from hash" do
    expect(Active911::API::Model.new(foo: "bar").foo).to eql "bar"
  end

  it "creates object from nested hash" do
    expect(Active911::API::Model.new(foo: {bar: {baz: "foobar"}}).foo.bar.baz).to eql "foobar"
  end

  it "creates object from nested hash and returns correct value" do
    expect(Active911::API::Model.new(foo: {bar: 1}).foo.bar).to eql 1
  end

  it "creates object with arrays" do
    object = Active911::API::Model.new(foo: [{bar: :baz}])
    expect(object.foo.first.class).to be OpenStruct
    expect(object.foo.first.bar).to eql :baz
  end
end
