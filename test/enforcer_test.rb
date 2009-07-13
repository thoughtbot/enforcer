require 'test_helper'

class EnforcerTest < Test::Unit::TestCase
  context "with an enforcer" do
    setup do
      stub(GitHubApi).add_collaborator(anything, anything)
      @enforcer = Enforcer.new
    end

    should "adds the collaborators to the project" do
      @enforcer.project 'foo' do
        collaborators 'chaines'
      end

      assert_received(GitHubApi) do |subject|
        subject.add_collaborator('foo', 'chaines')
      end
    end
  end
end
