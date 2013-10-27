require 'spec_helper'

describe Travis::Api::V0::Pusher::Job::Started do
  include Travis::Testing::Stubs, Support::Formats

  let(:test) { stub_test(state: :started, finished_at: nil, finished?: false) }
  let(:data) { Travis::Api::V0::Pusher::Job::Started.new(test).data }

  before :each do
    Travis.config.sponsors.workers = {
      'ruby3.worker.travis-ci.org' => {
        'name' => 'Railslove',
        'url' => 'http://railslove.de'
      }
    }
  end

  it 'data' do
    data.should == {
      'id' => 1,
      'build_id' => 1,
      'repository_id' => 1,
      'repository_slug' => 'svenfuchs/minimal',
      'repository_private' => false,
      'number' => '2.1',
      'state' => 'started',
      'result' => nil,
      'started_at' => json_format_time(Time.now.utc - 1.minute),
      'finished_at' => nil,
      'worker' => 'ruby3.worker.travis-ci.org:travis-ruby-4',
      'sponsor' => { 'name' => 'Railslove', 'url' => 'http://railslove.de' }
    }
  end
end

