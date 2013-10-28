require 'spec_helper'

describe Travis::Api::V2::Http::Repository do
  include Travis::Testing::Stubs
  include Support::Formats

  let(:data) { Travis::Api::V2::Http::Repository.new(repository).data }

  it 'repository' do
    data['repo'].should == {
      'id' => repository.id,
      'slug' => 'svenfuchs/minimal',
      'description' => 'the repo description',
      'last_build_id' => 1,
      'last_build_number' => 2,
      'last_build_started_at' => json_format_time(Time.now.utc - 1.minute),
      'last_build_finished_at' => json_format_time(Time.now.utc),
      'last_build_state' => 'passed',
      'last_build_language' => nil,
      'last_build_duration' => 60,
      'github_language' => 'ruby'
    }
  end
end

describe 'Travis::Api::V2::Http::Repository using Travis::Services::FindRepo' do
  include Support::ActiveRecord

  let!(:record) { Factory(:repository) }
  let(:repo)    { Travis.run_service(:find_repo, :id => record.id) }
  let(:data)    { Travis::Api::V2::Http::Repository.new(repo).data }

  it 'queries' do
    lambda { data }.should issue_queries(1)
  end
end
