require 'spec_helper'

describe Travis::Api::V0::Pusher::Job::Log do
  include Travis::Testing::Stubs

  let(:data) { Travis::Api::V0::Pusher::Job::Log.new(test, :_log => 'some chars', :number => 1, :final => false).data }

  it 'data' do
    data.should == {
      'id' => test.id,
      'build_id' => test.source_id,
      'repository_id' => test.repository_id,
      'repository_private' => false,
      '_log' => 'some chars',
      'number' => 1,
      'final' => false
    }
  end
end

