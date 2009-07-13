require 'test_helper'

class GitHubApiTest < Test::Unit::TestCase
  context "with github api credentials" do
    setup do
      @account = "thoughtbot"
      @api_key = "deadbeef"
      @repo    = "repo"
      @user    = "coreyhaines" + rand(10).to_s
    end

    should "set base uri" do
      assert_equal "http://github.com/api/v2/json", GitHubApi.base_uri
    end

    context "listing collaborators" do
      setup do
        @collaborators = ["qrush", "coreyhaines"]
        stub(GitHubApi).get("/repos/show/#{@account}/#{@repo}/collaborators") { { 'collaborators' => @collaborators } }
      end

      should "return just the usernames" do
        assert_equal @collaborators, GitHubApi.list_collaborators(@account, @repo)
      end
    end

    context "adding a collaborator" do
      setup do
        @collaborators = ["qrush", @user]
        stub(GitHubApi).post(anything, anything) { {'collaborators' => @collaborators }}
        @collaborators = GitHubApi.add_collaborator(@account, @api_key, @repo, @user)
      end

      should "hit the github api" do
        assert_received(GitHubApi) do |subject|
          subject.post("/repos/collaborators/#{@repo}/add/#{@user}", :body => {
            :login => @account,
            :token => @api_key})
        end
      end

      should "return the new collaborators" do
        assert_equal ["qrush", @user], @collaborators
      end
    end
  end
  context "removing a collaborator" do
    setup do
      @collaborators = ["qrush"]
      stub(GitHubApi).post(anything, anything) { {'collaborators' => @collaborators }}
      @collaborators = GitHubApi.remove_collaborator(@account, @api_key, @repo, @user)
    end

    should "hit the github api" do
      assert_received(GitHubApi) do |subject|
        subject.post("/repos/collaborators/#{@repo}/remove/#{@user}", :body => {
          :login => @account,
          :token => @api_key})
      end
    end

    should "return the new collaborators" do
      assert_equal ["qrush"], @collaborators
    end
  end
end
