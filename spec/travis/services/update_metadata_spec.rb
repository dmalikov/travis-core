require "spec_helper"

describe Travis::Services::UpdateMetadata do
  include Support::ActiveRecord

  let(:metadata_provider) { Factory(:metadata_provider) }
  let(:job) { Factory(:test) }
  let(:service) { described_class.new(params) }

  attr_reader :params

  it "creates the metadata if it doesn't exist already" do
    @params = {
      username: metadata_provider.api_username,
      key: metadata_provider.api_key,
      job_id: job.id,
      description: "Foo bar baz",
      image_url: "https://example.com/image.png",
      image_alt: "An image",
    }

    metadata = service.run
    metadata.description.should eq(params[:description])
    metadata.image_url.should eq(params[:image_url])
    metadata.image_alt.should eq(params[:image_alt])
  end

  it "updates an existing metadata if one exists" do
    @params = {
      username: metadata_provider.api_username,
      key: metadata_provider.api_key,
      job_id: job.id,
      description: "Foo bar baz",
    }

    metadata = Factory(:metadata, metadata_provider: metadata_provider, job: job)
    service.run.id.should eq(metadata.id)
  end

  it "returns nil when given invalid provider credentials" do
    @params = {
      username: "some-invalid-provider",
      key: "some-invalid-key",
      job_id: job.id,
      description: "Foo bar baz",
    }

    service.run.should be_nil
  end
end