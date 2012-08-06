require 'spec_helper'

describe User do
  subject { User.new }

  describe "#api" do
    it "returns an instance of api with the user_token" do
      subject.stub(oauth_token: "abc")
      Taskrabbit::Api.should_receive(:new).with("abc")
      subject.send(:api)
    end
  end

  describe "#remote_tasks" do
    it "returns an instance of Taskrabbit::Task" do
      api_instance = stub
      api_instance.should_receive(:tasks).and_return(Taskrabbit::Task.new)
      subject.stub(api: api_instance)
      subject.send(:remote_tasks).should == Taskrabbit::Task.new
    end
  end
end
