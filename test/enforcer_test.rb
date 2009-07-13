require 'test_helper'

class EnforcerTest < Test::Unit::TestCase
  context "with an enforcer" do
    setup do
      stub(GitHubApi).add_collaborator(anything, anything, anything, anything)
      @username = "user"
      @api_key = "api key"
      @enforcer = Enforcer.new(@username, @api_key)
    end

    should "add a collaborator to the project" do
      @enforcer.project 'foo' do
        collaborators 'chaines'
      end

      assert_received(GitHubApi) do |subject|
        subject.add_collaborator(@username, @api_key, 'foo', 'chaines')
      end
    end

    should "add collaborators to the project" do
      @enforcer.project 'foo' do
        collaborators 'chaines', 'qrush'
      end

      assert_received(GitHubApi) do |subject|
        subject.add_collaborator(@username, @api_key, 'foo', 'chaines')
        subject.add_collaborator(@username, @api_key, 'foo', 'qrush')
      end
    end
  end

  context "setting up enforcer dsl" do
    setup do
      @enforcer = "enforcer"
      stub(@enforcer).project(anything)

      @username = "thoughtbot"
      @api_key  = "api key"
      mock(Enforcer).new(@username, @api_key) { @enforcer }
    end
    should "be there and take a string and block" do
      Enforcer(@username, @api_key) { project("corey") {} }
      assert_received(@enforcer) { |subject| subject.project("corey") }
    end
  end
end
