require "spec_helper"

describe Travis::Api::V2::Pusher::Metadata::Updated do
  include Travis::Testing::Stubs, Support::Formats

  let(:data) { described_class.new(metadata).data }

  it "metadata" do
    data["metadata"].should == {
      "id" => metadata.id,
      "job_id" => metadata.job_id,
      "source_name" => metadata.source_name,
      "description" => metadata.description,
      "url" => metadata.url,
    }
  end
end