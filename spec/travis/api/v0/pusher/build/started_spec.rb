require 'spec_helper'

describe Travis::Api::V0::Pusher::Build::Started do
  include Travis::Testing::Stubs, Support::Formats

  let(:repo)  { stub_repo(last_build_state: :started, last_build_duration: nil, last_build_finished_at: nil) }
  let(:job)   { stub_test(state: :started, finished_at: nil, finished?: false) }
  let(:build) { stub_build(repository: repo, state: :started, finished_at: nil, matrix: [job], finished?: false) }
  let(:data)  { Travis::Api::V0::Pusher::Build::Started.new(build).data }

  it 'build' do
    data['build'].except('matrix').should == {
      'id' => build.id,
      'repository_id' => build.repository_id,
      'number' => 2,
      'config' => { 'rvm' => ['1.8.7', '1.9.2'], 'gemfile' => ['test/Gemfile.rails-2.3.x', 'test/Gemfile.rails-3.0.x'] },
      'state' => 'started',
      'result' => nil,
      'started_at' => json_format_time(Time.now.utc - 1.minute),
      'finished_at' => nil,
      'duration' => nil,
      'commit' => '62aae5f70ceee39123ef',
      'commit_id' => 1,
      'branch' => 'master',
      'job_ids' => [1],
      'message' => 'the commit message',
      'author_name' => 'Sven Fuchs',
      'author_email' => 'svenfuchs@artweb-design.de',
      'committer_name' => 'Sven Fuchs',
      'committer_email' => 'svenfuchs@artweb-design.de',
      'committed_at' => json_format_time(Time.now.utc - 1.hour),
      'compare_url' => 'https://github.com/svenfuchs/minimal/compare/master...develop',
      'event_type' => 'push',
      'pull_request' => false,
      'pull_request_title' => nil,
      'pull_request_number' => nil
    }
  end

  it 'repository' do
    data['repository'].should == {
      'id' => build.repository_id,
      'slug' => 'svenfuchs/minimal',
      'private' => false,
      'description' => 'the repo description',
      'last_build_id' => 1,
      'last_build_number' => 2,
      'last_build_started_at' => json_format_time(Time.now.utc - 1.minute),
      'last_build_finished_at' => nil,
      'last_build_duration' => nil,
      'last_build_state' => 'started',
      'last_build_result' => nil,
      'last_build_language' => nil
    }
  end
end
