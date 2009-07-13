require 'test_helper'

class EnforcerTest < Test::Unit::TestCase
  context "with an enforcer" do
    setup do
      stub(GitHubApi).add_collaborator(anything, anything, anything)
      @username = "user"
      @enforcer = Enforcer.new(@username)
    end

    should "add collaborators to the project" do
      @enforcer.project 'foo' do
        collaborators 'chaines'
      end

      assert_received(GitHubApi) do |subject|
        subject.add_collaborator(@username, 'foo', 'chaines')
      end
    end
  end

  context "setting up enforcer dsl" do
    setup do
      @enforcer = "enforcer"
      stub(@enforcer).project(anything)

      @username = "thoughtbot"
      mock(Enforcer).new(@username) { @enforcer }
    end
    should "be there and take a string and block" do
      Enforcer("thoughtbot") { project("corey") {} }
      assert_received(@enforcer) { |subject| subject.project("corey") }
    end
  end
end
