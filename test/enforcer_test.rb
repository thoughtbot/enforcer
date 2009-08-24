require 'test_helper'

class EnforcerTest < Test::Unit::TestCase
  context "with an enforcer" do
    setup do
      @existing_collaborators = []
      @repo = "repo"
      @project = "project"
      @account = "user"
      @api_key = "api key"

      stub(@repo).add(anything)
      stub(@repo).list { @existing_collaborators }
      mock(Repository).new(@account, @api_key, @project) { @repo }

      @enforcer = Enforcer.new(@account, @api_key)
    end

    should "totally skip adding/removing collaborators if the existing collaborators can't be found" do
      @existing_collaborators = nil

      assert_nothing_raised do
        @enforcer.project @project, 'chaines'
      end

      assert_received(@repo) do |subject|
        subject.add('chaines').never
      end
    end

    should "add a collaborator to the project" do
      @enforcer.project @project, 'chaines'

      assert_received(@repo) do |subject|
        subject.add('chaines')
      end
    end

    should "add collaborators to the project" do
      @enforcer.project @project, 'chaines', 'qrush'

      assert_received(@repo) do |subject|
        subject.add('chaines')
        subject.add('qrush')
      end
    end

    context "with an existing user" do
      setup do
        @existing_user = "ralph"
        stub(@repo).remove(anything)
        @existing_collaborators << "ralph"
      end

      should "not add existing user to the project" do
        @enforcer.project @project, 'ralph'

        assert_received(@repo) do |subject|
          subject.add('ralph').never
        end
      end

      should "remove existing user from the project if not in collaborators" do
        @enforcer.project @project, 'qrush'

        assert_received(@repo) do |subject|
          subject.add('qrush')
          subject.remove(@existing_user)
        end
      end
    end
  end

  context "setting up enforcer dsl" do
    setup do
      @enforcer = "enforcer"
      stub(@enforcer).project(anything, anything)

      @account = "thoughtbot"
      @api_key  = "api key"
      mock(Enforcer).new(@account, @api_key) { @enforcer }
    end

    should "be there and take a string and block" do
      Enforcer(@account, @api_key) { project("shoulda", "corey") {} }
      assert_received(@enforcer) { |subject| subject.project("shoulda", "corey") }
    end
  end
end
